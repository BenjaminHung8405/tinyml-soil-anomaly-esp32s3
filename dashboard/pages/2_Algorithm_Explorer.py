"""
Trang 2: dashboard/pages/2_Algorithm_Explorer.py
Nhiệm vụ: Giao diện trực quan hóa tương tác tối ưu thị giác, biểu đồ Triplet làm trung tâm.
"""

import sys
import os
import streamlit as st

# Đảm bảo đường dẫn import
CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
DASHBOARD_DIR = os.path.abspath(os.path.join(CURRENT_DIR, ".."))
PROJECT_ROOT = os.path.abspath(os.path.join(DASHBOARD_DIR, ".."))
for p in [PROJECT_ROOT, DASHBOARD_DIR]:
    if p not in sys.path:
        sys.path.insert(0, p)

from components.sidebar import render_sidebar
from components.data_loader import load_sample_windows_with_metadata
from components.plot_helpers import (
    plot_triplet_signals,
    plot_confidence_gauge,
    plot_channel_mse_bar,
)
from src.pipeline.edge_pipeline import EdgePipeline
from src.pipeline.tflite_engine import TFLiteInferenceEngine

st.set_page_config(
    page_title="Khám phá Thuật toán - Ag-IoT",
    page_icon="🔬",
    layout="wide",
    initial_sidebar_state="expanded",
)
render_sidebar()

# Nạp dữ liệu
X_clean, X_corrupt, df_meta = load_sample_windows_with_metadata()

st.title("🔬 Khám phá Thuật toán & Trực quan hóa A/B")
st.markdown("---")

# 1. TOP BAR: Bộ điều khiển kịch bản ngang gọn gàng
col_filter, col_select, col_ch = st.columns([1, 2, 1])

with col_filter:
    filter_mode = st.radio(
        "Lọc kịch bản:",
        ["Chỉ Tiêm Lỗi (18)", "Tất cả (126)", "Chỉ Sạch (108)"],
        horizontal=True,
    )

# Lọc danh sách tương ứng
if filter_mode == "Chỉ Tiêm Lỗi (18)":
    active_df = df_meta[df_meta["status"] == "Tiêm Lỗi (Faulty)"]
elif filter_mode == "Chỉ Sạch (108)":
    active_df = df_meta[df_meta["status"] == "Sạch (Normal)"]
else:
    active_df = df_meta

with col_select:
    def format_scenario(idx):
        matches = df_meta.loc[df_meta["window_idx"] == idx]
        if matches.empty:
            return f"#{idx:03d}"
        row = matches.iloc[0]
        if row["fault_type"] == "None":
            return f"#{idx:03d} | Chuỗi sạch tự nhiên"
        return f"#{idx:03d} | [{row['fault_type']}] {row['target_channel']} ({row['severity']})"

    options_list = active_df["window_idx"].tolist()
    selected_idx = st.selectbox(
        "Chọn Cửa sổ Kiểm thử (W=32):",
        options_list,
        format_func=format_scenario,
    )

# Tự động chọn kênh cảm biến tương ứng nếu kịch bản tiêm lỗi chỉ định kênh
target_ch_default = 0
if selected_idx is not None:
    matched = df_meta.loc[df_meta["window_idx"] == selected_idx]
    if not matched.empty:
        ch_str = str(matched.iloc[0]["target_channel"])
        if "S1" in ch_str:
            target_ch_default = 0
        elif "S2" in ch_str:
            target_ch_default = 1
        elif "S3" in ch_str:
            target_ch_default = 2

with col_ch:
    target_ch = st.selectbox(
        "Cảm biến khảo sát:",
        [0, 1, 2],
        index=target_ch_default,
        format_func=lambda x: f"Cảm biến S{x+1}",
    )

# Khởi tạo Pipeline (cache instance)
@st.cache_resource
def get_pipeline():
    return EdgePipeline(tflite_engine=TFLiteInferenceEngine())

pipeline = get_pipeline()

if selected_idx is not None:
    scenario_row = df_meta.loc[df_meta["window_idx"] == selected_idx].iloc[0]
    res = pipeline.evaluate_window(X_corrupt[selected_idx])

    # 2. HERO VISUAL: Biểu đồ Triplet chiếm vị trí trung tâm
    st.markdown(f"##### 📈 Đối chiếu Tín hiệu Thực nghiệm: `{scenario_row['description']}`")

    imputed_win_ch = X_corrupt[selected_idx, :, target_ch].copy()
    if res.faulty_mask[target_ch]:
        imputed_win_ch[-1] = res.imputed_current[target_ch]

    fig_triplet = plot_triplet_signals(
        clean_series=X_clean[selected_idx, :, target_ch],
        corrupt_series=X_corrupt[selected_idx, :, target_ch],
        imputed_series=imputed_win_ch,
        channel_name=f"S{target_ch+1}",
        height=360,
    )
    st.plotly_chart(fig_triplet, width="stretch")

    # 3. SPLIT SECTION: 2 Cột Chẩn đoán & Bóc tách Sai số
    col_diag, col_breakdown = st.columns([1, 1.4])

    with col_diag:
        st.markdown("##### 🧭 Đánh giá Độ tin cậy & Chấp hành")
        st.plotly_chart(
            plot_confidence_gauge(res.confidence_score_ct, res.status_label),
            width="stretch",
        )

        # Trạng thái Relay rõ ràng
        if res.is_safe_for_actuation:
            st.success(f"**Trạng thái Relay:** CHO PHÉP TƯỚI (Consensus: {res.consensus_vwc * 100:.1f}%)")
        else:
            st.error(f"**Trạng thái Relay:** KHÓA NGẮT AN TOÀN (Fail-safe Lockout)")

    with col_breakdown:
        st.markdown("##### 🔍 Bóc tách Sai số Tái tạo Cục bộ")
        st.plotly_chart(
            plot_channel_mse_bar(res.mse_channels, threshold_tau=0.0075),
            width="stretch",
        )

    # 4. PROGRESSIVE DISCLOSURE: Đưa công thức toán vào Expander
    with st.expander("📐 Cơ sở Toán học của Thuật toán Selective Imputation", expanded=False):
        st.markdown("""
        * **Bóc tách sai số cục bộ:** 
          $$MSE_k = \\frac{1}{32} \\sum_{i=1}^{32} \\left(x_{i, k} - \\hat{x}_{i, k}\\right)^2$$
        * **Điểm tin cậy $C_t$:** 
          $$C_t = \\exp\\left( - \\left[ \\alpha \\left(\\frac{\\max_k MSE_k}{\\tau}\\right)^2 + \\beta \\cdot I_{\\text{spatial}} \\right] \\right)$$
        * **Phục hồi không gian chọn lọc:** Chỉ thay thế kênh vi phạm bằng giá trị trung bình/trung vị của 2 cảm biến lành lặn, triệt tiêu việc ghi đè toàn bộ cửa sổ gây méo sóng.
        """)
