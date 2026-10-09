"""
Trang 3: dashboard/pages/3_Hardware_Economics.py
Nhiệm vụ: Trình bày luận chứng kinh tế và tối ưu hóa chi phí phần cứng (Task T1.3.3)
theo nguyên lý 'Software-defined Reliability' (Định nghĩa độ tin cậy bằng phần mềm).
Bao gồm:
- 4 Thẻ KPI So sánh Chi phí & Năng lực Dung lỗi
- Biểu đồ Radar Đối chuẩn Đa chiều 5 Tiêu chí
- Mô phỏng Chi phí Sở hữu Dài hạn TCO (24 tháng & Rủi ro SPOF)
- Bảng Bóc tách Danh mục Linh kiện BOM chi tiết & Nút Xuất Báo cáo CSV
"""

import sys
import os
import streamlit as st
import pandas as pd
import plotly.graph_objects as go
from lucide import lucide_icon

# Đảm bảo đường dẫn import
CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
DASHBOARD_DIR = os.path.abspath(os.path.join(CURRENT_DIR, ".."))
PROJECT_ROOT = os.path.abspath(os.path.join(DASHBOARD_DIR, ".."))
for p in [PROJECT_ROOT, DASHBOARD_DIR]:
    if p not in sys.path:
        sys.path.insert(0, p)

from components.sidebar import render_sidebar
from src.pipeline.hardware_economics_loader import HardwareEconomicsLoader

# Cấu hình trang chuẩn khoa học
st.set_page_config(
    page_title="Luận chứng Kinh tế & Phần cứng | Ag-IoT",
    page_icon=":material/payments:",
    layout="wide",
    initial_sidebar_state="expanded"
)

# Hiển thị sidebar thống nhất
render_sidebar()

# -----------------------------------------------------------------------------
# 1. TIÊU ĐỀ TRANG & PHÁT BIỂU LUẬN CHỨNG (EXECUTIVE HEADER)
# -----------------------------------------------------------------------------
st.caption("LUẬN CHỨNG KINH TẾ & PHÂN TÍCH TỐI ƯU HÓA PHẦN CỨNG THỰC NGHIỆM")
st.title("Luận chứng kinh tế & phần cứng trạm quan trắc", icon=":material/payments:")
st.markdown(
    "Chứng minh tính khả thi kinh tế của giải pháp **Software-defined Reliability**: "
    "Thay vì đầu tư một cảm biến công nghiệp đắt tiền ($850.000 - 1.200.000\\text{ VNĐ}$) vẫn tiềm ẩn rủi ro "
    "điểm hỏng đơn lẻ (*Single Point of Failure*), việc ứng dụng cụm 3 cảm biến điện dung giá rẻ kết hợp "
    "vi điều khiển ESP32-S3 và mô hình TinyML INT8 giúp **tiết kiệm $>64\\%$ chi phí** "
    "mà vẫn đạt độ dung lỗi tuyệt đối."
)

st.space("small")

# -----------------------------------------------------------------------------
# 2. KHỐI THẺ KPI SO SÁNH CHI PHÍ & DUNG LỖI (COST & RESILIENCE KPI CARDS)
# -----------------------------------------------------------------------------
cost_data = HardwareEconomicsLoader.calculate_cost_comparison()

kpi_col1, kpi_col2, kpi_col3, kpi_col4 = st.columns(4)

with kpi_col1:
    st.metric(
        label="Cụm TinyML Đề xuất (Trọn bộ)",
        value=f"{cost_data['proposed_total_vnd']:,} VNĐ",
        delta="Bao gồm ESP32-S3 + 3 cảm biến",
        delta_color="normal",
        border=True
    )

with kpi_col2:
    st.metric(
        label="Cảm biến Công nghiệp Cơ bản",
        value=f"{cost_data['industrial_sensor_avg_vnd']:,} VNĐ",
        delta="FDR/TDR 1 đầu dò đơn lẻ",
        delta_color="off",
        border=True
    )

with kpi_col3:
    st.metric(
        label="Tỷ lệ Tiết kiệm Phần cứng",
        value=f"-{cost_data['savings_pct']}%",
        delta=f"Tiết kiệm {cost_data['savings_vnd']:,} VNĐ",
        delta_color="normal",
        border=True
    )

with kpi_col4:
    st.metric(
        label="Chỉ số Dung lỗi Phần cứng",
        value="3/3 (Active Redundancy)",
        delta="Công nghiệp: 1/3 (SPOF)",
        delta_color="normal",
        border=True
    )

st.space("small")

# -----------------------------------------------------------------------------
# 3. PHÂN TÍCH ĐA CHIỀU: BIỂU ĐỒ RADAR & MÔ PHỎNG TCO 24 THÁNG
# -----------------------------------------------------------------------------
col_radar, col_tco = st.columns([1.1, 1.2])

with col_radar:
    with st.container(border=True):
        st.subheader("Biểu đồ Radar so sánh đa chiều 5 tiêu chí", icon=":material/workspaces:")
        st.caption("Đối chuẩn thang điểm định lượng (1 - 10) giữa 2 trường phái giải pháp phần cứng:")

        radar_payload = HardwareEconomicsLoader.get_radar_chart_data()
        cats = radar_payload["categories"]

        fig_radar = go.Figure()

        # Đường đánh giá Cảm biến công nghiệp
        fig_radar.add_trace(go.Scatterpolar(
            r=radar_payload["industrial_scores"] + [radar_payload["industrial_scores"][0]],
            theta=cats + [cats[0]],
            fill='toself',
            name='Cảm biến Công nghiệp Đơn lẻ (FDR/TDR)',
            line=dict(color='#64748B', width=2, dash='dash'),
            fillcolor='rgba(100, 116, 139, 0.15)'
        ))

        # Đường đánh giá Cụm TinyML Đề xuất
        fig_radar.add_trace(go.Scatterpolar(
            r=radar_payload["proposed_scores"] + [radar_payload["proposed_scores"][0]],
            theta=cats + [cats[0]],
            fill='toself',
            name='Cụm Ag-IoT TinyML Đề xuất',
            line=dict(color='#10B981', width=3),
            fillcolor='rgba(16, 185, 129, 0.25)'
        ))

        fig_radar.update_layout(
            polar=dict(
                radialaxis=dict(
                    visible=True,
                    range=[0, 10],
                    tickfont=dict(size=10, color='#6B7280'),
                    gridcolor='#E5E7EB'
                ),
                angularaxis=dict(
                    tickfont=dict(size=11, weight='bold', color='#1F2937'),
                    gridcolor='#E5E7EB'
                )
            ),
            showlegend=True,
            legend=dict(
                orientation="h",
                yanchor="bottom",
                y=-0.22,
                xanchor="center",
                x=0.5,
                font=dict(size=11)
            ),
            height=390,
            margin=dict(l=35, r=35, t=25, b=60),
            template="plotly_white"
        )
        st.plotly_chart(fig_radar, width="stretch")

with col_tco:
    with st.container(border=True):
        st.subheader("Phân tích chi phí sở hữu dài hạn (TCO 24 Tháng)", icon=":material/trending_up:")
        st.caption("Mô phỏng rủi ro hư hại do ăn mòn điện hóa/sét lan truyền sau 18 tháng vận hành thực địa:")

        df_tco = HardwareEconomicsLoader.get_tco_simulation_data()

        fig_tco = go.Figure()

        # Cột chi phí Cảm biến Công nghiệp
        fig_tco.add_trace(go.Bar(
            name="Cảm biến Công nghiệp",
            x=df_tco["Milestone"],
            y=df_tco["Cảm biến Công nghiệp (VNĐ)"],
            marker_color="#94A3B8",
            text=[f"{val:,.0f} đ" for val in df_tco["Cảm biến Công nghiệp (VNĐ)"]],
            textposition="outside"
        ))

        # Cột chi phí Cụm TinyML Đề xuất
        fig_tco.add_trace(go.Bar(
            name="Cụm TinyML Đề xuất",
            x=df_tco["Milestone"],
            y=df_tco["Giải pháp TinyML Đề xuất (VNĐ)"],
            marker_color="#10B981",
            text=[f"{val:,.0f} đ" for val in df_tco["Giải pháp TinyML Đề xuất (VNĐ)"]],
            textposition="outside"
        ))

        fig_tco.update_layout(
            barmode="group",
            height=390,
            margin=dict(l=30, r=20, t=25, b=60),
            yaxis=dict(
                title="Tổng chi phí luỹ kế (VNĐ)",
                gridcolor="#F3F4F6",
                range=[0, 2400000]
            ),
            xaxis=dict(tickfont=dict(size=10)),
            legend=dict(
                orientation="h",
                yanchor="bottom",
                y=-0.22,
                xanchor="center",
                x=0.5,
                font=dict(size=11)
            ),
            template="plotly_white"
        )
        st.plotly_chart(fig_tco, width="stretch")

st.space("small")

# -----------------------------------------------------------------------------
# 4. BẢNG BÓC TÁCH LINH KIỆN BOM CHI TIẾT & TẢI BÁO CÁO CSV
# -----------------------------------------------------------------------------
with st.container(border=True):
    bom_header_left, bom_header_right = st.columns([3, 1])
    with bom_header_left:
        st.subheader("Bảng bóc tách danh mục linh kiện BOM thực tế (Bill of Materials)", icon=":material/table_chart:")
        st.caption("Cấu hình thiết bị trạm Ag-IoT TinyML nghiệm thu đề tài với tổng giá thành tối ưu:")
    
    df_bom = HardwareEconomicsLoader.load_bom_data()

    with bom_header_right:
        csv_bytes = df_bom.to_csv(index=False).encode('utf-8')
        st.download_button(
            label="Xuất dữ liệu BOM (CSV)",
            data=csv_bytes,
            file_name="hardware_bom_metrics.csv",
            mime="text/csv",
            icon=":material/download:",
            width="stretch"
        )

    # Hiển thị bảng cấu hình linh kiện Streamlit với formatting tiền tệ
    st.dataframe(
        df_bom,
        column_config={
            "item_id": st.column_config.TextColumn("Mã linh kiện", width="small"),
            "component_name": st.column_config.TextColumn("Tên chi tiết linh kiện / module", width="large"),
            "category": st.column_config.TextColumn("Phân nhóm chức năng", width="medium"),
            "unit_price_vnd": st.column_config.NumberColumn("Đơn giá (VNĐ)", format="%,d đ"),
            "quantity": st.column_config.NumberColumn("Số lượng", format="%d"),
            "total_price_vnd": st.column_config.NumberColumn("Thành tiền (VNĐ)", format="%,d đ"),
            "technical_role": st.column_config.TextColumn("Vai trò kỹ thuật trong hệ thống", width="large"),
        },
        hide_index=True,
        width="stretch"
    )

st.space("small")

# -----------------------------------------------------------------------------
# 5. TỔNG HỢP LUẬN CHỨNG KHOA HỌC & ĐÓNG GÓP THỰC TIỄN
# -----------------------------------------------------------------------------
col_arg1, col_arg2 = st.columns(2)

with col_arg1:
    with st.container(border=True):
        st.subheader("Lợi thế kinh tế & Chi phí rủi ro đơn điểm (SPOF)", icon=":material/verified_user:")
        st.markdown(f"""
        1. **Tiết kiệm ban đầu vượt trội:**  
           Chi phí đầu tư trọn bộ cụm TinyML là **{cost_data['proposed_total_vnd']:,} VNĐ**, giúp tiết kiệm **{cost_data['savings_pct']}%** ngân sách (khoảng **{cost_data['savings_vnd']:,} VNĐ**) so với việc trang bị 1 cảm biến công nghiệp đơn chiếc ({cost_data['industrial_sensor_avg_vnd']:,} VNĐ).
        
        2. **Rủi ro thay thế linh kiện cực thấp:**  
           Khi cảm biến chôn dưới đất bị ăn mòn sau 18 - 24 tháng, việc thay thế 1 cảm biến lẻ MKE-S13 chỉ tốn **{cost_data['single_sensor_replace_cost_vnd']:,} VNĐ** (chỉ chiếm **{cost_data['single_sensor_replace_pct']}%** giá thành cảm biến công nghiệp).
        
        3. **Không ngắt quãng dữ liệu quan trắc:**  
           Hệ thống vẫn liên tục duy trì dữ liệu sạch nhờ thuật toán *Selective Spatial Imputation* trên 2 kênh còn lại trong suốt thời gian chờ kỹ thuật viên thay thế cảm biến hỏng.
        """)
        st.badge("Khả thi thương mại hóa cao", icon=":material/check:", color="green")

with col_arg2:
    with st.container(border=True):
        st.subheader("Định nghĩa độ tin cậy bằng phần mềm (Software-defined Reliability)", icon=":material/memory:")
        st.markdown("""
        1. **Chuyển dịch gánh nặng từ phần cứng sang thuật toán:**  
           Cảm biến giá rẻ có độ nhiễu và độ trôi cao hơn cảm biến công nghiệp đắt tiền. Thay vì mua phần cứng đắt đỏ, mô hình Dense Autoencoder INT8 và hàng rào Heuristic bù đắp hoàn toàn nhược điểm này trực tiếp tại biên vi điều khiển.
        
        2. **Bảo vệ tài sản vượt trội:**  
           Cơ chế khóa an toàn *Fail-safe* tự động ngắt relay bơm khi độ tin cậy $C_t < 0.50$, ngăn chặn triệt để nguy cơ cháy bơm hoặc ngập úng gốc cây trồng trị giá hàng triệu đồng.
        
        3. **Sẵn sàng triển khai lưới quan trắc mật độ cao:**  
           Với cùng một mức kinh phí 10.000.000 VNĐ, người làm nông nghiệp chỉ lắp được 10 điểm đo công nghiệp (không có dự phòng), nhưng có thể triển khai gần **30 trạm TinyML Ag-IoT**, thu thập bản đồ độ ẩm không gian toàn diện hơn gấp 3 lần.
        """)
        st.badge("Đạt chuẩn tiêu chí Sprint 1.3", icon=":material/verified:", color="green")

# Chân trang học thuật
st.space("small")
with st.container(horizontal=True, horizontal_alignment="distribute"):
    st.caption("Khóa luận tốt nghiệp: TinyML Soil Anomaly Pipeline trên ESP32-S3")
    st.caption("Module: 3_Hardware_Economics.py • Luận chứng kinh tế & Tối ưu BOM")
