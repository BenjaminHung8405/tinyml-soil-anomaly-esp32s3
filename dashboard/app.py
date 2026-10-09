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

# 5 Thẻ chuyên đề tương ứng 5 trang nghiên cứu
row1_col1, row1_col2 = st.columns(2)

with row1_col1:
    with st.container(border=True):
        st.markdown("#### 1. Không gian So sánh A/B Tín hiệu")
        st.write("Trực tiếp kiểm thử 18 kịch bản tiêm lỗi, theo dõi bóc tách sai số từng kênh và phục hồi Selective Imputation.")
        st.page_link("pages/1_Interactive_Fault_Visualizer.py", label="Mở Không gian So sánh A/B →", icon=":material/science:")

    with st.container(border=True):
        st.markdown("#### 3. Luận chứng Kinh tế & Phần cứng")
        st.write("Phân tích chi phí BOM cụm TinyML (~345k VNĐ), so sánh TCO 24 tháng và mức tiết kiệm >64% so với cảm biến công nghiệp.")
        st.page_link("pages/3_Hardware_Economics.py", label="Xem Luận chứng Kinh tế →", icon=":material/payments:")

with row1_col2:
    with st.container(border=True):
        st.markdown("#### 2. Kiến trúc Hệ thống & Phần cứng")
        st.write("Tìm hiểu Pipeline 7 tầng tại biên, bố trí cụm 3 cảm biến đối xứng bán kính 5 cm và động học mao dẫn đất.")
        st.page_link("pages/2_System_Architecture.py", label="Khám phá Kiến trúc →", icon=":material/account_tree:")

    with st.container(border=True):
        st.markdown("#### 4. Bảng Đối chuẩn Khoa học")
        st.write("So sánh định lượng toàn diện giữa TinyML INT8 với Ngưỡng tĩnh, Hampel và Moving 3-Sigma trên 126 cửa sổ.")
        st.page_link("pages/4_Benchmark_Comparison.py", label="Xem Bảng Đối chuẩn Toàn diện →", icon=":material/bar_chart:")

with st.container(border=True):
    st.markdown("#### 5. Chẩn đoán Kỹ thuật & Tải Dữ liệu")
    st.write("Môi trường đo kiểm thời gian thực phục vụ nghiệm thu: Độ trễ suy luận tức thời, Stress Test 126 cửa sổ và kiểm soát cấp phát bộ nhớ SRAM.")
    st.page_link("pages/5_System_Diagnostic.py", label="Chạy Kiểm định Hệ thống →", icon=":material/bolt:")

st.markdown("---")
st.caption("Khuyến nghị trình chiếu: Sử dụng **Trang 1 (Không gian So sánh A/B)** để demo trực tiếp khả năng phát hiện lỗi trước Hội đồng, và **Trang 3 (Kinh tế & Phần cứng)** để bảo vệ tính khả thi ứng dụng.")