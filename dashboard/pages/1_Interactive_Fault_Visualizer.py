"""
Trang 1: dashboard/pages/1_Interactive_Fault_Visualizer.py
Mục tiêu: Main Workspace so sánh A/B tín hiệu tương tác, hỗ trợ Zoom/Pan mượt mà 60fps (Task T1.2.3).
"""

import sys
import os
import streamlit as st
import numpy as np

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
    plot_multichannel_spatial_grid,
    plot_confidence_gauge,
    plot_channel_mse_bar,
)
from src.pipeline.edge_pipeline import EdgePipeline
from src.pipeline.tflite_engine import TFLiteInferenceEngine

st.set_page_config(
    page_title="Không gian So sánh A/B Tín hiệu | Ag-IoT",
    page_icon="🔬",
    layout="wide",
    initial_sidebar_state="expanded",
)

render_sidebar()

# Khởi tạo trạng thái phiên làm việc (Session State) cho chỉ số cửa sổ
if "current_window_idx" not in st.session_state:
    st.session_state.current_window_idx = 108  # Mặc định kịch bản tiêm lỗi đầu tiên

# Nạp dữ liệu (Cached)
X_clean, X_corrupt, df_meta = load_sample_windows_with_metadata()

# Khởi tạo Pipeline (Cache Resource tránh reload model trên mỗi rerun)
@st.cache_resource
def get_pipeline():
    return EdgePipeline(tflite_engine=TFLiteInferenceEngine())

pipeline = get_pipeline()

# Tiêu đề trang
st.title("🔬 Không gian Làm việc So sánh A/B Tín hiệu Thực nghiệm")
st.caption("Khảo sát tương tác độ trễ, sai số phục hồi và trạng thái an toàn trên 126 cửa sổ mẫu (Sliding Window W=32).")
st.markdown("---")

# -------------------------------------------------------------
# 1. THANH ĐIỀU KHIỂN & BƯỚC TRƯỢT THỜI GIAN (TOP CONTROL BAR)
# -------------------------------------------------------------
col_step1, col_step2, col_step3, col_view, col_channel = st.columns([1, 1, 3.5, 2.2, 1.3])

with col_step1:
    if st.button("⏮️ Trước", width="stretch", help="Lùi về cửa sổ kiểm thử trước"):
        st.session_state.current_window_idx = max(0, st.session_state.current_window_idx - 1)
        st.rerun()

with col_step2:
    if st.button("Tiếp ⏭️", width="stretch", help="Tiến tới cửa sổ kiểm thử tiếp theo"):
        st.session_state.current_window_idx = min(len(df_meta) - 1, st.session_state.current_window_idx + 1)
        st.rerun()

with col_step3:
    win_list = df_meta["window_idx"].tolist()

    def format_win(idx):
        matches = df_meta.loc[df_meta["window_idx"] == idx]
        if matches.empty:
            return f"Cửa sổ #{idx:03d}"
        row = matches.iloc[0]
        if row["fault_type"] == "None":
            return f"Cửa sổ #{idx:03d} (Sạch) • {row['description']}"
        return f"Cửa sổ #{idx:03d} • [{row['fault_type'].upper()}] {row['target_channel']} ({row['severity']})"

    current_val = st.session_state.current_window_idx
    if current_val not in win_list:
        current_val = win_list[0]
        st.session_state.current_window_idx = current_val

    selected_idx = st.selectbox(
        "Chọn trực tiếp cửa sổ kiểm thử:",
        win_list,
        index=win_list.index(current_val),
        format_func=format_win,
        label_visibility="collapsed",
    )
    if selected_idx != st.session_state.current_window_idx:
        st.session_state.current_window_idx = selected_idx
        st.rerun()

with col_view:
    view_mode = st.radio(
        "Chế độ hiển thị:",
        ["1 Kênh Chuyên sâu", "Cụm 3 Kênh Đồng bộ"],
        horizontal=True,
        label_visibility="collapsed",
    )

# Tự động gợi ý kênh cảm biến dựa trên metadata của kịch bản hiện tại
current_idx = st.session_state.current_window_idx
scenario_row = df_meta.loc[df_meta["window_idx"] == current_idx].iloc[0]

default_channel = 0
ch_desc = str(scenario_row["target_channel"])
if "S2" in ch_desc:
    default_channel = 1
elif "S3" in ch_desc:
    default_channel = 2

with col_channel:
    target_ch = st.selectbox(
        "Kênh khảo sát:",
        [0, 1, 2],
        index=default_channel,
        format_func=lambda x: f"Kênh S{x+1}",
        label_visibility="collapsed",
    )

# Chạy suy luận qua EdgePipeline
res = pipeline.evaluate_window(X_corrupt[current_idx])

# -------------------------------------------------------------
# 2. KHỐI THẺ ĐO LƯỜNG DELTA SAI SỐ & TÌNH TRẠNG CHẤP HÀNH
# -------------------------------------------------------------
gt_last = float(X_clean[current_idx, -1, target_ch])
raw_last = float(X_corrupt[current_idx, -1, target_ch])
imp_last = float(res.imputed_current[target_ch])

mae_corrupt = abs(raw_last - gt_last)
mae_imputed = abs(imp_last - gt_last)
mae_reduction = ((mae_corrupt - mae_imputed) / mae_corrupt * 100) if mae_corrupt > 1e-4 else 0.0

col_kpi1, col_kpi2, col_kpi3, col_kpi4 = st.columns(4)

with col_kpi1:
    col_kpi1.metric(
        "Độ tin cậy Ct",
        f"{res.confidence_score_ct:.4f}",
        res.status_label,
        delta_color="normal" if res.status_label == "VALID" else ("off" if res.status_label == "SUSPICIOUS" else "inverse"),
        border=True,
    )

with col_kpi2:
    col_kpi2.metric(
        "Sai số Lỗi Thô (Raw MAE)",
        f"{mae_corrupt:.4f}",
        f"Kênh S{target_ch+1}",
        delta_color="off",
        border=True,
    )

with col_kpi3:
    col_kpi3.metric(
        "Sai số Sau Phục Hồi (MAE)",
        f"{mae_imputed:.4f}",
        f"-{mae_reduction:.1f}% (Cải thiện)" if mae_reduction > 0 else "Giữ nguyên",
        delta_color="normal" if mae_reduction > 0 else "off",
        border=True,
    )

with col_kpi4:
    if res.is_safe_for_actuation:
        col_kpi4.metric(
            "Chấp hành Relay Bơm",
            "CHO PHÉP TƯỚI",
            f"Consensus VWC: {res.consensus_vwc*100:.1f}%",
            delta_color="normal",
            border=True,
        )
    else:
        col_kpi4.metric(
            "Chấp hành Relay Bơm",
            "KHÓA AN TOÀN",
            "Fail-safe Lockout",
            delta_color="inverse",
            border=True,
        )

st.space("small")

# -------------------------------------------------------------
# 3. VÙNG KHÔNG GIAN ĐỒ THỊ CHÍNH (INTERACTIVE WORKSPACE)
# -------------------------------------------------------------
# Cấu hình thanh công cụ Plotly tối ưu cho thao tác Zoom/Pan mượt mà 60 FPS
plotly_config = {
    "scrollZoom": True,
    "displayModeBar": True,
    "displaylogo": False,
    "modeBarButtonsToAdd": ["drawline", "drawopenpath", "eraseshape"],
    "toImageButtonOptions": {
        "format": "png",
        "filename": f"ab_comparison_window_{current_idx:03d}",
        "height": 500,
        "width": 900,
        "scale": 2,
    },
}

with st.container(border=True):
    if view_mode == "1 Kênh Chuyên sâu":
        st.subheader(
            f"So sánh Tín hiệu Chi tiết trên Cảm biến S{target_ch+1} (W=32 Mẫu)",
            icon=":material/stacked_line_chart:",
        )
        st.caption(
            f"Kịch bản cửa sổ #{current_idx:03d}: `{scenario_row['description']}` • "
            f"Trạng thái kênh: :{'red' if res.faulty_mask[target_ch] else 'green'}-badge[{'BỊ LỖI (Đã bù)' if res.faulty_mask[target_ch] else 'CHUẨN (Bình thường)'}]"
        )

        imputed_full_series = X_corrupt[current_idx, :, target_ch].copy()
        if res.faulty_mask[target_ch]:
            imputed_full_series[-1] = res.imputed_current[target_ch]

        fig_main = plot_triplet_signals(
            clean_series=X_clean[current_idx, :, target_ch],
            corrupt_series=X_corrupt[current_idx, :, target_ch],
            imputed_series=imputed_full_series,
            channel_name=f"S{target_ch+1}",
            height=380,
            show_uncertainty_band=True,
        )
        st.plotly_chart(fig_main, width="stretch", config=plotly_config)

    else:
        st.subheader(
            "Đối chuẩn Không gian Cụm 3 Cảm biến Đồng bộ (S1 – S2 – S3)",
            icon=":material/hub:",
        )
        st.caption("Trực quan hóa sự phân tách không gian và năng lực bù lỗi độc lập từng kênh:")

        fig_grid = plot_multichannel_spatial_grid(
            X_clean_win=X_clean[current_idx],
            X_corrupt_win=X_corrupt[current_idx],
            imputed_current=res.imputed_current,
            faulty_mask=res.faulty_mask,
            spatial_eps=0.05,
            height=480,
        )
        st.plotly_chart(fig_grid, width="stretch", config=plotly_config)

st.space("small")

# -------------------------------------------------------------
# 4. KHỐI CHẨN ĐOÁN DƯỚI: ĐỒNG HỒ ĐỘ TIN CẬY & BÓC TÁCH MSE KÊNH
# -------------------------------------------------------------
col_gauge_b, col_bar_b = st.columns([1, 1.4])

with col_gauge_b:
    with st.container(border=True):
        st.caption("ĐỒNG HỒ ĐIỂM TIN CẬY HỆ THỐNG (Ct)")
        st.plotly_chart(
            plot_confidence_gauge(res.confidence_score_ct, res.status_label, height=240),
            width="stretch",
            config={"displayModeBar": False},
        )

with col_bar_b:
    with st.container(border=True):
        st.caption("BÓC TÁCH SAI SỐ TÁI TẠO TỪNG KÊNH (MSE_k vs Ngưỡng tau)")
        st.plotly_chart(
            plot_channel_mse_bar(res.mse_channels, threshold_tau=0.0075, height=240),
            width="stretch",
            config={"displayModeBar": False},
        )

# -------------------------------------------------------------
# 5. TIẾT LỘ TIỆM TIẾN: KỊCH BẢN & GÓI TIN BIÊN EDGE PACKET
# -------------------------------------------------------------
with st.expander("📝 Chi tiết Kịch bản Thực nghiệm & Gói tin Biên (Edge Packet)", expanded=False):
    col_t1, col_t2 = st.columns(2)
    with col_t1:
        st.markdown(f"**Thông tin Kịch bản #{current_idx:03d}:**")
        st.json({
            "window_index": int(current_idx),
            "status": scenario_row["status"],
            "fault_type": scenario_row["fault_type"],
            "severity": scenario_row["severity"],
            "target_channel": scenario_row["target_channel"],
            "description": scenario_row["description"],
        })
    with col_t2:
        st.markdown("**Gói tin Trạng thái Xuất ra Biên (`EdgeSensorPacket`):**")
        st.json({
            "timestamp": int(res.timestamp),
            "raw_sensors": [round(float(x), 4) for x in res.raw_current],
            "imputed_sensors": [round(float(x), 4) for x in res.imputed_current],
            "consensus_vwc": round(float(res.consensus_vwc), 4),
            "confidence_ct": round(float(res.confidence_score_ct), 4),
            "faulty_mask": [bool(m) for m in res.faulty_mask],
            "relay_safe": bool(res.is_safe_for_actuation),
            "status": res.status_label,
        })
