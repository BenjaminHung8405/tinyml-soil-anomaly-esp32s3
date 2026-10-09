"""
Trang chủ: dashboard/app.py
Nhiệm vụ: Executive Summary tinh gọn theo nguyên tắc 3 Giây - 3 Phút - 30 Phút.
"""

import sys
import os
import streamlit as st

# Đảm bảo đường dẫn import
CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.abspath(os.path.join(CURRENT_DIR, ".."))
for p in [PROJECT_ROOT, CURRENT_DIR]:
    if p not in sys.path:
        sys.path.insert(0, p)

from components.sidebar import render_sidebar

st.set_page_config(
    page_title="Ag-IoT Soil Anomaly Dashboard",
    page_icon=":material/eco:",
    layout="wide",
    initial_sidebar_state="expanded"
)

render_sidebar()

# Hero Section
st.title("Ag-IoT Soil Anomaly Detection & Adaptive Imputation", icon=":material/eco:")
st.markdown(
    "**Giám sát độ ẩm đất thời gian thực với độ tin cậy định nghĩa bằng phần mềm "
    "(Software-defined Reliability) trên vi điều khiển ESP32-S3.**"
)
st.markdown("---")

# 3 Chỉ số Hero Cốt lõi (Bỏ các thông số debug thứ yếu)
col1, col2, col3 = st.columns(3)
col1.metric("F1-Score Phát hiện Dị thường", "0.912", "+17.0% so với 3-Sigma")
col2.metric("Thời gian Suy luận Trên Chip", "18.4 ms", "ESP32-S3 (Real-time)")
col3.metric("Mức giảm Sai số MAE", "80.9%", "Mục tiêu đề cương: ≥ 40%")

st.markdown("---")
st.subheader("Khám phá Các Chuyên đề Nghiên cứu", icon=":material/explore:")

# 4 Thẻ chuyên đề tinh gọn dạng 2x2
col_a, col_b = st.columns(2)

with col_a:
    with st.container(border=True):
        st.markdown("#### 1. Không gian So sánh A/B Tín hiệu")
        st.write("Trực tiếp kiểm thử 18 kịch bản tiêm lỗi, theo dõi bóc tách sai số từng kênh và phục hồi Selective Imputation.")
        st.page_link("pages/1_Interactive_Fault_Visualizer.py", label="Mở Không gian So sánh A/B →", icon=":material/science:")

    with st.container(border=True):
        st.markdown("#### 3. Bảng Đối chuẩn Khoa học")
        st.write("So sánh định lượng toàn diện giữa phương pháp đề xuất với Ngưỡng tĩnh, Hampel và Moving 3-Sigma.")
        st.page_link("pages/3_Benchmark_Comparison.py", label="Xem Bảng Đối chuẩn Toàn diện →", icon=":material/bar_chart:")

with col_b:
    with st.container(border=True):
        st.markdown("#### 2. Kiến trúc Hệ thống & Phần cứng")
        st.write("Tìm hiểu Pipeline 7 tầng, bố trí cụm 3 cảm biến đối xứng bán kính 5 cm và bài toán tối ưu chi phí BOM.")
        st.page_link("pages/2_System_Architecture.py", label="Khám phá Kiến trúc →", icon=":material/architecture:")

    with st.container(border=True):
        st.markdown("#### 4. Chẩn đoán Kỹ thuật & Tải dữ liệu")
        st.write("Đo kiểm hiệu năng nạp dữ liệu tức thì, stress-test 126 cửa sổ và kiểm tra độ ổn định thời gian thực.")
        st.page_link("pages/4_System_Diagnostic.py", label="Chạy Kiểm định Hệ thống →", icon=":material/bolt:")

st.markdown("---")
st.caption("Khuyến nghị trình chiếu: Sử dụng **Trang 1 (Không gian So sánh A/B)** để demo trực tiếp khả năng phát hiện lỗi trước Hội đồng.")