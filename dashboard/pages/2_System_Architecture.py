"""
Trang 2: dashboard/pages/2_System_Architecture.py
Nhiệm vụ: Trình bày chi tiết POC, Pipeline lai 7 tầng, bố trí hình học cảm biến,
động học mao dẫn đất và phân tích bài toán kinh tế phần cứng (BOM).
"""

import sys
import os
import streamlit as st
import pandas as pd

# Đảm bảo đường dẫn import
CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
DASHBOARD_DIR = os.path.abspath(os.path.join(CURRENT_DIR, ".."))
PROJECT_ROOT = os.path.abspath(os.path.join(DASHBOARD_DIR, ".."))
for p in [PROJECT_ROOT, DASHBOARD_DIR]:
    if p not in sys.path:
        sys.path.insert(0, p)

from components.sidebar import render_sidebar
from components.data_loader import load_hardware_bom, load_hardware_benchmarks

st.set_page_config(
    page_title="Kiến trúc hệ thống & Kinh tế phần cứng | Ag-IoT",
    page_icon=":material/architecture:",
    layout="wide",
    initial_sidebar_state="expanded"
)

# Hiển thị sidebar dùng chung
render_sidebar()

# Tiêu đề trang
st.caption("KIẾN TRÚC TỔNG THỂ & THIẾT KẾ PHẦN CỨNG / TASK T1.1.4")
st.title("Kiến trúc hệ thống & bài toán kinh tế phần cứng", icon=":material/account_tree:")
st.markdown(
    "Thuyết minh giải pháp độ tin cậy bằng phần mềm (**Software-Defined Reliability**) "
    "kết hợp cụm cảm biến giá rẻ và mạng nơ-ron TinyML INT8 chạy thời gian thực trên ESP32-S3."
)

st.space("small")

# 3 Tab nội dung kiến trúc
tab_pipeline, tab_sensors, tab_bom = st.tabs([
    "Pipeline lai 7 tầng đa biến",
    "Bố trí cảm biến & động học đất",
    "Phân tích kinh tế BOM & đối chuẩn"
])

# -----------------------------------------------------------------------------
# TAB 1: PIPELINE LAI 7 TẦNG
# -----------------------------------------------------------------------------
with tab_pipeline:
    with st.container(border=True):
        st.subheader("Sơ đồ luồng xử lý 7 tầng tại biên (7-Tier Hybrid Edge Pipeline)", icon=":material/schema:")
        st.caption(
            "Kết hợp hàng rào Heuristic siêu nhanh (Fast-path) và mô hình học sâu Autoencoder (Deep-path) "
            "nhằm tối ưu hóa năng lượng và độ trễ."
        )

        # Mermaid Diagram trực quan
        st.markdown("""
```mermaid
flowchart TD
    T1["Tầng 1: Đọc ADC & Hiệu chuẩn phi tuyến 3 điểm<br/>(64x oversampling, VWC in [0.0, 1.0])"] --> T2["Tầng 2: Bộ đệm vòng đa kênh RingBuffer<br/>(Static SRAM 32 samples x 3 channels)"]
    T2 --> T3{"Tầng 3: Hàng rào Heuristic & Đồng thuận<br/>(Physical bounds & 2.5 sigma fast-path)"}
    T3 -- "Vi phạm biên thô" --> T6["Tầng 6: Phục hồi thích ứng & Fail-safe"]
    T3 -- "Vượt qua kiểm tra" --> T4["Tầng 4: Multivariate TinyML INT8<br/>(Dense AE: 96-48-16-48-96, tách MSE_k)"]
    T4 --> T5["Tầng 5: Ước lượng Điểm tin cậy C_t<br/>(Smooth exponential decay: C_t in [0.0, 1.0])"]
    T5 --> T6
    T6 --> T7["Tầng 7: Đóng gói EdgeSensorPacket<br/>(Đồng thuận VWC, Ghi SD & Truyền thông LoRa/WiFi)"]
```
""")

    col_t1, col_t2 = st.columns(2)
    with col_t1:
        with st.container(border=True):
            st.markdown("#### Chi tiết các tầng 1 – 3 (Tầng tiền xử lý)")
            st.markdown("""
            - **Tầng 1 (Đọc ADC & Hiệu chuẩn):**  
              Lấy mẫu $64\\times$ oversampling trên ESP32-S3 ADC (12-bit), bù đường cong suy giảm điện áp phi tuyến 3 điểm để chuyển đổi giá trị thô thành Độ ẩm thể tích đất $VWC \\in [0.0, 1.0]$.
            - **Tầng 2 (Bộ đệm vòng đa kênh - Static Ring Buffer):**  
              Quản lý mảng tĩnh kích thước $32 \\times 3$ trong SRAM nội bộ. Bộ đệm dạng trượt ($stride=16$, $window=32$), hoàn toàn không dùng cấp phát động (`malloc/free`) để tránh phân mảnh bộ nhớ vi điều khiển.
            - **Tầng 3 (Hàng rào Heuristic & Đồng thuận không gian):**  
              Kiểm tra biên vật lý ($VWC < 0.0$ hoặc $VWC > 0.65$), Fast-path $2.5\\sigma$, và tính trung vị không gian $\\text{median}(S_1, S_2, S_3)$. Bắt tức thì các lỗi spike hoặc đứt cáp mà không cần đánh thức NPU/TFLite.
            """)

    with col_t2:
        with st.container(border=True):
            st.markdown("#### Chi tiết các tầng 4 – 7 (Tầng TinyML & Phục hồi)")
            st.markdown("""
            - **Tầng 4 (Multivariate TinyML INT8 Inference):**  
              Kiến trúc Autoencoder nén đối xứng ($96 \\to 48 \\to 16 \\to 48 \\to 96$). TFLite Micro giải nén và bóc tách sai số tái tạo độc lập trên từng kênh:
              $$MSE_k = \\frac{1}{W}\\sum_{t=1}^W (x_{t,k} - \\hat{x}_{t,k})^2$$
            - **Tầng 5 (Ước lượng Điểm tin cậy $C_t$):**  
              Điểm tin cậy $C_t \\in [0.0, 1.0]$ suy giảm mũ mượt:
              $$C_t = \\exp\\left(-\\alpha \\left(\\frac{\\max(MSE_k)}{\\tau}\\right)^2 - \\beta\\right)$$
            - **Tầng 6 (Phục hồi thích ứng & Khóa an toàn Fail-safe):**  
              *Selective Spatial Imputation*: Kênh lỗi được thay thế bằng trung bình của 2 cảm biến lành. Khi $C_t < 0.50$, khóa relay ngắt bơm khẩn cấp để ngăn ngập úng.
            - **Tầng 7 (Đóng gói gói tin biên EdgeSensorPacket):**  
              Xuất cấu trúc nhị phân đóng gói lưu thẻ nhớ MicroSD qua giao tiếp SPI và gửi cảnh báo.
            """)

# -----------------------------------------------------------------------------
# TAB 2: BỐ TRÍ CẢM BIẾN & ĐỘNG HỌC ĐẤT
# -----------------------------------------------------------------------------
with tab_sensors:
    geom_col1, geom_col2 = st.columns([3, 2])

    with geom_col1:
        with st.container(border=True):
            st.subheader("Bố trí hình học dưỡng cắm tam giác triệt tiêu trễ mao dẫn", icon=":material/hub:")
            st.markdown("""
            Để loại trừ hiện tượng trễ khuếch tán mao dẫn bất đối xứng làm sai lệch tương quan chuỗi thời gian, hệ thống thiết kế dưỡng cắm cơ học chuẩn xác:
            - **Bố trí đối xứng tâm:** 03 cảm biến điện dung MKE-S13 được cắm cách đều vòi tưới nhỏ giọt đúng bán kính $r = 5\\text{ cm}$, góc lệch $120^\\circ$ tạo thành tam giác đều.
            - **Độ sâu cắm cảm biến:** 5 – 7 cm (vùng rễ hoạt động mạnh nhất của cây trồng mục tiêu).
            - **Động học mao dẫn đất:** Nước tưới khuếch tán dạng nón ướt (*wetting front*), mất khoảng $12 - 18\\text{ phút}$ để ngấm ngang từ tâm tưới ra bán kính $5\\text{ cm}$. Nhờ khoảng cách đối xứng nghiêm ngặt, cả 3 cảm biến luôn nhận được xung ẩm gần như đồng pha.
            - **Chu kỳ nghỉ bảo toàn:** Thuật toán áp dụng chu kỳ nghỉ sau tưới $\\ge 20\\text{ phút}$ trước khi đánh giá lại để chờ gradient độ ẩm trong đất ổn định.
            """)

            st.markdown("""
```mermaid
graph TD
    subgraph "Dưỡng cắm tam giác đều r = 5 cm"
        Center(("Vòi tưới nhỏ giọt<br/>(Tâm đối xứng)"))
        S1["Cảm biến S1<br/>(0 độ, r=5cm)"]
        S2["Cảm biến S2<br/>(120 độ, r=5cm)"]
        S3["Cảm biến S3<br/>(240 độ, r=5cm)"]
        Center ---|r = 5 cm| S1
        Center ---|r = 5 cm| S2
        Center ---|r = 5 cm| S3
        S1 -.-|d = 8.66 cm| S2
        S2 -.-|d = 8.66 cm| S3
        S3 -.-|d = 8.66 cm| S1
    end
```
""")

    with geom_col2:
        with st.container(border=True):
            st.subheader("Mốc kiểm chứng Ground Truth", icon=":material/verified:")
            st.markdown("""
            Quá trình thu thập dữ liệu kiểm thử được kiểm soát bằng cân điện tử mini đối chứng độ sụt giảm khối lượng chậu đất:
            """)
            st.table({
                "Chỉ tiêu đối chuẩn": "Độ biến thiên khối lượng Δm (gam)",
                "Cảm biến tham chiếu": "Cân điện tử phân giải 0.1g",
                "Độ sâu cảm biến": "5 – 7 cm",
                "Đất thực nghiệm": "Đất thịt pha phù sa sông Hậu",
                "Tần suất đo mốc": "Mỗi 60 phút / mốc đối chứng",
                "Nhiệt độ môi trường": "28°C – 34°C"
            })

            st.caption("Kiểm định định kỳ bảo đảm độ ẩm đất tính toán bám sát độ ẩm trọng lượng thực tế.")

# -----------------------------------------------------------------------------
# TAB 3: BÀI TOÁN KINH TẾ (BOM) & ĐỐI CHUẨN PHẦN CỨNG
# -----------------------------------------------------------------------------
with tab_bom:
    bom_col1, bom_col2 = st.columns([3, 2])

    with bom_col1:
        with st.container(border=True):
            st.subheader("Danh mục linh kiện thực tế (Bill of Materials - BOM)", icon=":material/receipt_long:")
            st.caption("Bảng kê chi tiết cấu hình phần cứng trạm quan trắc kiểm thử tại phòng thí nghiệm.")

            bom_df = load_hardware_bom()
            st.dataframe(
                bom_df,
                column_config={
                    "Hạng mục linh kiện": st.column_config.TextColumn("Linh kiện thiết bị", width="large"),
                    "Đơn giá (VNĐ)": st.column_config.NumberColumn("Đơn giá", format="%,d đ"),
                    "Số lượng": st.column_config.NumberColumn("Số lượng", format="%d"),
                    "Thành tiền (VNĐ)": st.column_config.NumberColumn("Thành tiền", format="%,d đ"),
                },
                hide_index=True,
                width="stretch"
            )

            total_cost = int(bom_df["Thành tiền (VNĐ)"].sum())
            st.metric(
                label="Tổng chi phí phần cứng trạm POC đề xuất",
                value=f"{total_cost:,.0f} VNĐ",
                delta="~ 18 USD (Tối ưu cho ứng dụng nông nghiệp thông minh)",
                delta_color="off",
                border=True
            )

    with bom_col2:
        with st.container(border=True):
            st.subheader("Hiệu quả kinh tế & Độ sẵn sàng", icon=":material/savings:")
            st.markdown("""
            **So sánh giữa 2 trường phái giải pháp:**

            | Tiêu chí | Cảm biến công nghiệp đắt tiền (FDR/TDR) | Giải pháp đề xuất (3× MKE-S13 + TinyML) |
            | :--- | :--- | :--- |
            | **Chi phí thiết bị** | 850.000 – 1.200.000 VNĐ / chiếc | ~ 465.000 VNĐ (trọn bộ 3 cảm biến + MCU) |
            | **Mức tiết kiệm** | Cơ sở (100%) | **Tiết kiệm > 60%** |
            | **Điểm hỏng đơn lẻ** | Có (Single Point of Failure) | **Không (Có 2 kênh dự phòng)** |
            | **Khả năng tự hồi phục** | Không (Hỏng là mất dữ liệu) | **Tự bù kênh hỏng tức thời (Imputation)** |
            | **Tính an toàn bơm tưới** | Phụ thuộc cảm biến đơn | **Fail-safe tự ngắt khi $C_t < 0.5$** |
            """)

            st.badge("Phù hợp triển khai diện rộng", icon=":material/check_circle:", color="green")

# Chân trang
st.space("small")
with st.container(horizontal=True, horizontal_alignment="distribute"):
    st.caption("Khóa luận tốt nghiệp: TinyML Soil Anomaly Pipeline trên ESP32-S3")
    st.caption("Module: 1_System_Architecture.py • Sơ đồ khối & Kinh tế phần cứng")
