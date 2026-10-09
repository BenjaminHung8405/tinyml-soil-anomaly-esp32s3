"""
Trang chủ: dashboard/app.py
Nhiệm vụ: Cung cấp bức tranh toàn cảnh Executive Summary, bảng chỉ số tóm tắt,
các thẻ điều hướng sang 3 chuyên đề chuyên sâu và bảng đối chuẩn nhanh.
"""

import sys
import os
import time
import streamlit as st
import pandas as pd

# Đảm bảo đường dẫn import
CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.abspath(os.path.join(CURRENT_DIR, ".."))
for p in [PROJECT_ROOT, CURRENT_DIR]:
    if p not in sys.path:
        sys.path.insert(0, p)

from components.sidebar import render_sidebar
from components.data_loader import (
    load_sample_windows,
    load_benchmark_metrics,
    load_hardware_benchmarks,
)

# Cấu hình trang chung
st.set_page_config(
    page_title="Ag-IoT Soil Anomaly Pipeline | TinyML ESP32-S3",
    page_icon=":material/analytics:",
    layout="wide",
    initial_sidebar_state="expanded"
)

# Hiển thị Sidebar chung
render_sidebar()

# -----------------------------------------------------------------------------
# TIÊU ĐỀ CHÍNH & PHÂN CẤP THỊ GIÁC (EXECUTIVE SUMMARY)
# -----------------------------------------------------------------------------
st.caption("TRẠM QUAN TRẮC ĐỘ ẨM ĐẤT AG-IOT / HỆ THỐNG NHÚNG TINYML TRÊN ESP32-S3")
st.title("Phát hiện bất thường và phục hồi chuỗi thời gian độ ẩm đất", icon=":material/sensors:")
st.markdown(
    "Hệ thống nhúng TinyML tự động phát hiện dị thường và phục hồi chuỗi thời gian "
    "độ ẩm đất bằng giải pháp **Software-defined reliability** đa tầng trên vi điều khiển ESP32-S3."
)

st.space("small")

# -----------------------------------------------------------------------------
# DỮ LIỆU NỀN TẢNG (CACHED)
# -----------------------------------------------------------------------------
t_start = time.perf_counter()
X_clean, X_corrupt, labels = load_sample_windows(126)
metrics_df = load_benchmark_metrics()
hardware_df = load_hardware_benchmarks()
load_time_ms = (time.perf_counter() - t_start) * 1000

# -----------------------------------------------------------------------------
# 4 METRIC CARDS TÓM LƯỢC (KPI SUMMARY)
# -----------------------------------------------------------------------------
f1_sparkline = [0.42, 0.55, 0.68, 0.74, 0.81, 0.88, 0.912]
latency_sparkline = [18.4, 12.0, 5.2, 1.8, 0.65, 0.32, 0.192]
sram_sparkline = [32.0, 28.0, 14.5, 6.2, 3.1, 2.4, 1.94]
mae_sparkline = [0.084, 0.071, 0.052, 0.038, 0.024, 0.019, 0.016]

col1, col2, col3, col4 = st.columns(4)

with col1:
    st.metric(
        label="F1-Score mô hình đề xuất",
        value="0.912",
        delta="+17.0% vs Moving 3-Sigma",
        border=True,
        chart_data=f1_sparkline,
        chart_type="line",
    )

with col2:
    st.metric(
        label="Độ trễ suy luận trên chip",
        value="0.192 ms",
        delta=f"Cache: {load_time_ms:.1f} ms (< 500ms)",
        delta_color="normal",
        border=True,
        chart_data=latency_sparkline,
        chart_type="line",
    )

with col3:
    st.metric(
        label="SRAM Arena chiếm dụng",
        value="1.94 KB",
        delta="Dư 233.8 KB Free Heap",
        delta_color="off",
        border=True,
        chart_data=sram_sparkline,
        chart_type="bar",
    )

with col4:
    st.metric(
        label="Tỷ lệ giảm sai số MAE",
        value="80.9%",
        delta="Chỉ tiêu đề cương: ≥ 40%",
        delta_color="normal",
        border=True,
        chart_data=mae_sparkline,
        chart_type="line",
    )

st.space("small")

# -----------------------------------------------------------------------------
# ĐỊNH HƯỚNG CÁC CHUYÊN ĐỀ NGHIÊN CỨU (NAVIGATION HUBS)
# -----------------------------------------------------------------------------
st.subheader("Định hướng các chuyên đề nghiên cứu trong hệ thống", icon=":material/explore:")

col_nav1, col_nav2, col_nav3 = st.columns(3)

with col_nav1:
    with st.container(border=True):
        st.markdown("#### 1. Kiến trúc hệ thống & BOM")
        st.caption("Kiến trúc nhúng & Thiết kế phần cứng")
        st.markdown(
            "Khám phá **Pipeline lai 7 tầng**, mô hình phân rã nhiệm vụ trên FreeRTOS, "
            "bố trí dưỡng cắm tam giác đều $r=5\\text{ cm}$ và bài toán tối ưu chi phí BOM."
        )
        st.page_link(
            "pages/1_System_Architecture.py",
            label="Khám phá kiến trúc hệ thống",
            icon=":material/architecture:",
            width="stretch"
        )

with col_nav2:
    with st.container(border=True):
        st.markdown("#### 2. Trực quan hóa A/B & Selective Imputation")
        st.caption("Môi trường thực nghiệm tương tác")
        st.markdown(
            "Trải nghiệm tiêm lỗi trên **126 cửa sổ mẫu**, theo dõi bóc tách $MSE_k$ từng kênh, "
            "điểm tin cậy $C_t$ và cơ chế phục hồi không gian **Selective Imputation**."
        )
        st.page_link(
            "pages/2_Algorithm_Explorer.py",
            label="Mở bộ kiểm thử A/B tương tác",
            icon=":material/tune:",
            width="stretch"
        )

with col_nav3:
    with st.container(border=True):
        st.markdown("#### 3. Bảng đối chuẩn toàn diện")
        st.caption("Định lượng học thuật & Đóng góp khoa học")
        st.markdown(
            "So sánh định lượng toàn diện giữa phương pháp đề xuất với **Ngưỡng tĩnh**, "
            "**Bộ lọc Hampel** và **Moving 3-Sigma** về F1, FAR, MDR, Latency và Radar đa chiều."
        )
        st.page_link(
            "pages/3_Benchmark_Comparison.py",
            label="Xem bảng đối chuẩn chi tiết",
            icon=":material/analytics:",
            width="stretch"
        )

st.space("small")

# -----------------------------------------------------------------------------
# BẢNG TÓM TẮT NHANH HIỆU NĂNG ĐỐI CHUẨN (PREVIEW DATAFRAME)
# -----------------------------------------------------------------------------
with st.container(border=True):
    st.subheader("Tóm tắt nhanh hiệu năng đối chuẩn (Benchmark Preview)", icon=":material/table_chart:")
    st.caption("Ma trận tóm tắt kết quả nghiệm thu so sánh 4 giải pháp trên 126 cửa sổ kiểm thử:")

    st.dataframe(
        metrics_df,
        column_config={
            "Phương pháp": st.column_config.TextColumn("Phương pháp đánh giá", width="large"),
            "F1-Score": st.column_config.ProgressColumn("F1-Score", min_value=0.0, max_value=1.0, format="%.3f"),
            "Precision": st.column_config.NumberColumn("Precision", format="%.3f"),
            "Recall": st.column_config.NumberColumn("Recall", format="%.3f"),
            "FAR (%)": st.column_config.NumberColumn("FAR (%)", format="%.1f%%"),
            "MDR (%)": st.column_config.NumberColumn("MDR (%)", format="%.1f%%"),
            "MAE Giảm (%)": st.column_config.ProgressColumn("Giảm MAE (%)", min_value=0.0, max_value=100.0, format="%.1f%%"),
            "Độ trễ Trên Chip": st.column_config.TextColumn("Độ trễ (ESP32-S3)"),
            "SRAM Arena": st.column_config.TextColumn("Bộ nhớ SRAM"),
        },
        hide_index=True,
        width="stretch",
    )

# Chân trang
st.space("small")
with st.container(horizontal=True, horizontal_alignment="distribute"):
    st.caption("Khóa luận tốt nghiệp: TinyML Soil Anomaly Pipeline trên ESP32-S3")
    st.caption(f"Tốc độ nạp dữ liệu: {load_time_ms:.2f} ms • Khởi tạo từ bộ đệm cache")