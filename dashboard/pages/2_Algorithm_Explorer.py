"""
Trang 2: dashboard/pages/2_Algorithm_Explorer.py
Nhiệm vụ: Trực quan hóa tương tác 126 cửa sổ kiểm thử, kiểm tra tiêm lỗi,
bóc tách sai số tái tạo kênh MSE_k, đánh giá độ tin cậy C_t và phục hồi Selective Imputation.
"""

import sys
import os
import streamlit as st
import numpy as np
import pandas as pd
import plotly.graph_objects as go

# Đảm bảo đường dẫn import
CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
DASHBOARD_DIR = os.path.abspath(os.path.join(CURRENT_DIR, ".."))
PROJECT_ROOT = os.path.abspath(os.path.join(DASHBOARD_DIR, ".."))
for p in [PROJECT_ROOT, DASHBOARD_DIR]:
    if p not in sys.path:
        sys.path.insert(0, p)

from components.sidebar import render_sidebar
from components.data_loader import load_sample_windows
from components.plot_helpers import (
    plot_triplet_signals,
    plot_confidence_gauge,
    plot_channel_mse_bar,
    plot_spatial_consistency,
)
from src.pipeline.edge_pipeline import EdgePipeline
from src.pipeline.tflite_engine import TFLiteInferenceEngine

st.set_page_config(
    page_title="Khám phá thuật toán A/B & Selective Imputation | Ag-IoT",
    page_icon=":material/biotech:",
    layout="wide",
    initial_sidebar_state="expanded"
)

# Hiển thị sidebar dùng chung
render_sidebar()

# Tiêu đề trang
st.caption("TRỰC QUAN HÓA THUẬT TOÁN & ĐÁNH GIÁ A/B / TASK T1.2.1")
st.title("Khám phá thuật toán & phục hồi chuỗi thích ứng", icon=":material/tune:")
st.markdown(
    "Môi trường kiểm thử tương tác trên **126 cửa sổ mẫu**, cho phép tiêm lỗi, "
    "quan sát mạng Autoencoder INT8 bóc tách sai số từng kênh, đánh giá điểm tin cậy $C_t$ và cơ chế tự bù dữ liệu."
)

st.space("small")

# 1. Nạp dữ liệu cửa sổ (126 x 32 x 3)
X_clean, X_corrupt, labels = load_sample_windows(126)
label_names = {
    0: "Bình thường (Clean)",
    1: "Lỗi đột biến nhọn (Spike)",
    2: "Lỗi nhiễu / mất tín hiệu (Noise)",
    3: "Lỗi kẹt cảm biến (Stuck-at)",
    4: "Lỗi trôi dốc (Drift)"
}

# Khởi tạo Pipeline biên (cache instance)
@st.cache_resource
def get_pipeline():
    engine = TFLiteInferenceEngine()
    return EdgePipeline(tflite_engine=engine)

pipeline = get_pipeline()

# -----------------------------------------------------------------------------
# THANH ĐIỀU KHIỂN TƯƠNG TÁC
# -----------------------------------------------------------------------------
with st.container(border=True):
    st.subheader("Bộ điều khiển kịch bản kiểm thử", icon=":material/tune:")
    ctrl1, ctrl2, ctrl3 = st.columns([2, 2, 3])

    with ctrl1:
        fault_type_filter = st.segmented_control(
            "Phân loại kịch bản",
            options=["Tất cả", "Bình thường (Clean)", "Spike", "Noise", "Stuck-at", "Drift"],
            default="Tất cả"
        )

    # Lọc danh sách index cửa sổ
    type_code_map = {
        "Tất cả": None,
        "Bình thường (Clean)": 0,
        "Spike": 1,
        "Noise": 2,
        "Stuck-at": 3,
        "Drift": 4
    }
    target_code = type_code_map[fault_type_filter]
    if target_code is None:
        candidate_indices = list(range(len(labels)))
    else:
        candidate_indices = [i for i, lbl in enumerate(labels) if lbl == target_code]

    with ctrl2:
        default_idx = candidate_indices[0] if candidate_indices else 0
        window_idx = st.slider(
            "Cửa sổ kiểm thử (Window Index):",
            min_value=0,
            max_value=len(X_clean) - 1,
            value=35 if 35 in candidate_indices else default_idx,
            help="Kéo để chọn cửa sổ thời gian trượt (32 bước đo liên tiếp)"
        )

    with ctrl3:
        target_ch = st.segmented_control(
            "Kênh cảm biến quan sát",
            options=[0, 1, 2],
            format_func=lambda x: f"Cảm biến S{x+1} (Kênh {x})",
            default=0
        )

# Suy luận qua EdgePipeline
current_label = int(labels[window_idx])
res = pipeline.evaluate_window(X_corrupt[window_idx])

# -----------------------------------------------------------------------------
# BẢNG CHỈ SỐ SUY LUẬN TỨC THỜI (KPI CARDS)
# -----------------------------------------------------------------------------
col_kpi1, col_kpi2, col_kpi3, col_kpi4 = st.columns(4)

with col_kpi1:
    ct_delta = "Hệ thống tin cậy" if res.confidence_score_ct >= 0.85 else ("Nghi ngờ" if res.confidence_score_ct >= 0.50 else "Không an toàn")
    st.metric(
        label="Điểm tin cậy Ct",
        value=f"{res.confidence_score_ct:.3f}",
        delta=ct_delta,
        delta_color="normal" if res.confidence_score_ct >= 0.85 else ("off" if res.confidence_score_ct >= 0.50 else "inverse"),
        border=True
    )

with col_kpi2:
    faulty_count = sum(res.faulty_mask)
    st.metric(
        label="Trạng thái phân tách lỗi",
        value=f"{faulty_count}/3 kênh lỗi",
        delta=f"Mask: {res.faulty_mask}",
        delta_color="off",
        border=True
    )

with col_kpi3:
    st.metric(
        label="Khóa an toàn Relay (Fail-safe)",
        value="CHO PHÉP TƯỚI" if res.is_safe_for_actuation else "KHÓA KHẨN CẤP",
        delta="Bơm sẵn sàng" if res.is_safe_for_actuation else "Ngắt bơm (Ct < 0.5)",
        delta_color="normal" if res.is_safe_for_actuation else "inverse",
        border=True
    )

with col_kpi4:
    st.metric(
        label="Độ ẩm đồng thuận (Consensus VWC)",
        value=f"{res.consensus_vwc * 100:.1f}%",
        delta="Sau khi áp dụng Selective Imputation",
        delta_color="off",
        border=True
    )

st.space("small")

# -----------------------------------------------------------------------------
# HÀNG ĐỒ THỊ CHUYÊN SÂU: GAUGE CHART & CHANNEL MSE BAR
# -----------------------------------------------------------------------------
col_gauge, col_bar = st.columns([1, 1.4])

with col_gauge:
    with st.container(border=True):
        st.caption("ĐỒNG HỒ ĐIỂM TIN CẬY HỆ THỐNG")
        st.plotly_chart(
            plot_confidence_gauge(
                ct_score=res.confidence_score_ct,
                status_label=res.status_label,
                height=260
            ),
            width="stretch"
        )

with col_bar:
    with st.container(border=True):
        st.caption("BÓC TÁCH SAI SỐ TÁI TẠO TỪNG KÊNH SO VỚI NGƯỠNG")
        st.plotly_chart(
            plot_channel_mse_bar(
                mse_channels=res.mse_channels,
                threshold_tau=0.0075,
                height=260
            ),
            width="stretch"
        )

st.space("small")

# -----------------------------------------------------------------------------
# BIỂU ĐỒ SO SÁNH DẠNG SÓNG PLOTLY (3 ĐƯỜNG TÍN HIỆU TRIPLET)
# -----------------------------------------------------------------------------
with st.container(border=True):
    st.subheader(
        f"Trực quan hóa chuỗi thời gian kênh S{target_ch+1}: Ground Truth vs Corrupted vs Imputed",
        icon=":material/stacked_line_chart:"
    )
    st.caption(
        f"Kịch bản cửa sổ #{window_idx:03d}: :blue-badge[{label_names.get(current_label, 'Custom')}] • "
        f"Trạng thái kênh S{target_ch+1}: :{'red' if res.faulty_mask[target_ch] else 'green'}-badge[{'BỊ LỖI (Faulty)' if res.faulty_mask[target_ch] else 'LÀNH LẶN (Normal)'}]"
    )

    clean_trace = X_clean[window_idx, :, target_ch]
    corrupt_trace = X_corrupt[window_idx, :, target_ch]

    # Dựng chuỗi sau phục hồi
    imputed_trace = corrupt_trace.copy()
    if res.faulty_mask[target_ch]:
        imputed_trace[-1] = res.imputed_current[target_ch]

    fig_triplet = plot_triplet_signals(
        clean_series=clean_trace,
        corrupt_series=corrupt_trace,
        imputed_series=imputed_trace,
        channel_name=f"S{target_ch+1}",
        height=400,
        show_uncertainty_band=True
    )
    st.plotly_chart(fig_triplet, width="stretch")

    # Đánh giá mức độ cải thiện sai số MAE
    mae_raw_val = float(np.mean(np.abs(clean_trace - corrupt_trace)))
    mae_imp_val = float(np.mean(np.abs(clean_trace - imputed_trace)))
    mae_improve = ((mae_raw_val - mae_imp_val) / mae_raw_val * 100) if mae_raw_val > 1e-6 else 0.0

    st.caption(
        f"Đánh giá sai số chuỗi đo: MAE trước phục hồi: **{mae_raw_val:.4f}** • "
        f"Sau phục hồi: **{mae_imp_val:.4f}** • "
        f"Mức độ triệt tiêu sai số: :{'green' if mae_improve > 0 else 'blue'}-badge[{mae_improve:.1f}%]"
    )

st.space("small")

# -----------------------------------------------------------------------------
# TÍNH NHẤT QUÁN KHÔNG GIAN & NGUYÊN LÝ THUẬT TOÁN
# -----------------------------------------------------------------------------
col_spatial, col_calc = st.columns([1.2, 1])

with col_spatial:
    with st.container(border=True):
        st.subheader("Kiểm tra nhất quán không gian cụm 3 cảm biến", icon=":material/hub:")
        st.caption("Đối chiếu 3 kênh cảm biến đồng thời trên cùng cửa sổ 32 mẫu:")
        fig_spatial = plot_spatial_consistency(
            sensor_readings=X_corrupt[window_idx],
            tolerance_delta=0.05,
            height=280
        )
        st.plotly_chart(fig_spatial, width="stretch")

with col_calc:
    with st.container(border=True):
        st.subheader("Nguyên lý Selective Spatial Imputation", icon=":material/calculate:")
        st.markdown("""
        **1. Trường hợp 0 cảm biến lỗi:**  
        $$\\hat{x}_{t} = x_{t} \\quad (\\text{Bảo toàn nguyên vẹn chuỗi đo ban đầu})$$

        **2. Trường hợp 1 cảm biến lỗi (VD: S1 lỗi, S2 và S3 lành):**  
        $$\\hat{x}_{t, S1} = \\frac{x_{t, S2} + x_{t, S3}}{2}$$  
        *Chỉ bù đúng kênh lỗi, bảo toàn dạng sóng các kênh lành lặn.*

        **3. Trường hợp $\\ge 2$ cảm biến cùng hỏng:**  
        $$\\hat{x}_{t} = \\text{median}(S_1, S_2, S_3) \\quad \\& \\quad \\text{Khóa Relay ngắt bơm Fail-safe}$$
        """)

# Chân trang
st.space("small")
with st.container(horizontal=True, horizontal_alignment="distribute"):
    st.caption("Khóa luận tốt nghiệp: TinyML Soil Anomaly Pipeline trên ESP32-S3")
    st.caption("Module: 2_Algorithm_Explorer.py • Kiểm thử A/B & Selective Imputation")
