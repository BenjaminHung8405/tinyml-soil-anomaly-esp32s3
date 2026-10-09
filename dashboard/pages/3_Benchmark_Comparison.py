"""
Trang 3: dashboard/pages/3_Benchmark_Comparison.py
Nhiệm vụ: Trình bày bảng đối chuẩn khoa học so sánh phương pháp đề xuất với
các phương pháp đường cơ sở (Ngưỡng tĩnh, Hampel, Moving 3-Sigma).
"""

import sys
import os
import streamlit as st
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go

# Đảm bảo đường dẫn import
CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
DASHBOARD_DIR = os.path.abspath(os.path.join(CURRENT_DIR, ".."))
PROJECT_ROOT = os.path.abspath(os.path.join(DASHBOARD_DIR, ".."))
for p in [PROJECT_ROOT, DASHBOARD_DIR]:
    if p not in sys.path:
        sys.path.insert(0, p)

from components.sidebar import render_sidebar
from components.data_loader import (
    load_benchmark_metrics,
    load_detection_metrics,
    load_imputation_metrics,
    load_hardware_benchmarks
)

st.set_page_config(
    page_title="Bảng đối chuẩn toàn diện & Đánh giá học thuật | Ag-IoT",
    page_icon=":material/analytics:",
    layout="wide",
    initial_sidebar_state="expanded"
)

# Hiển thị sidebar dùng chung
render_sidebar()

# Tiêu đề trang
st.caption("KẾT QUẢ THỰC NGHIỆM & ĐỐI CHUẨN ĐỊNH LƯỢNG HỌC THUẬT")
st.title("Bảng đối chuẩn toàn diện các phương pháp", icon=":material/balance:")
st.markdown(
    "So sánh định lượng độc lập giữa **Hybrid TinyML Pipeline (INT8)** với các phương pháp đường cơ sở "
    "(Ngưỡng tĩnh, Bộ lọc Hampel, Moving 3-Sigma) về độ chính xác phát hiện lỗi, mức độ phục hồi chuỗi và tài nguyên nhúng."
)

st.space("small")

# Nạp dữ liệu metrics
df_metrics = load_benchmark_metrics()
df_detection = load_detection_metrics()
df_imputation = load_imputation_metrics()
df_hardware = load_hardware_benchmarks()

# -----------------------------------------------------------------------------
# BẢNG MA TRẬN ĐỐI CHUẨN TỔNG HỢP
# -----------------------------------------------------------------------------
with st.container(border=True):
    st.subheader("Bảng ma trận đánh giá hiệu năng tổng hợp", icon=":material/table_chart:")
    st.caption("Dữ liệu đối chuẩn độc lập chạy trên tập kiểm thử 126 cửa sổ mẫu phân tách 4 kịch bản lỗi:")

    st.dataframe(
        df_metrics,
        column_config={
            "Phương pháp": st.column_config.TextColumn("Phương pháp đánh giá", width="large"),
            "F1-Score": st.column_config.ProgressColumn("F1-Score", min_value=0.0, max_value=1.0, format="%.3f"),
            "Precision": st.column_config.NumberColumn("Precision", format="%.3f"),
            "Recall": st.column_config.NumberColumn("Recall", format="%.3f"),
            "FAR (%)": st.column_config.NumberColumn("Tỷ lệ báo giả FAR", format="%.1f%%"),
            "MDR (%)": st.column_config.NumberColumn("Tỷ lệ sót lỗi MDR", format="%.1f%%"),
            "MAE Giảm (%)": st.column_config.ProgressColumn("Mức giảm MAE", min_value=0.0, max_value=100.0, format="%.1f%%"),
            "Độ trễ Trên Chip": st.column_config.TextColumn("Độ trễ (ESP32-S3)"),
            "SRAM Arena": st.column_config.TextColumn("SRAM Arena"),
        },
        hide_index=True,
        width="stretch"
    )

st.space("small")

# -----------------------------------------------------------------------------
# BIỂU ĐỒ SO SÁNH TRỰC QUAN (F1 VÀ MAE GIẢM)
# -----------------------------------------------------------------------------
chart_col1, chart_col2 = st.columns(2)

with chart_col1:
    with st.container(border=True):
        st.subheader("So sánh F1-Score phát hiện dị thường", icon=":material/radar:")
        st.caption("Giải pháp đề xuất đạt F1 = 0.912, vượt trội hoàn toàn so với Moving 3-Sigma (0.742)")

        # Bar chart Plotly
        fig_f1 = px.bar(
            df_metrics,
            x="Phương pháp",
            y="F1-Score",
            color="Phương pháp",
            text="F1-Score",
            color_discrete_sequence=["#94A3B8", "#F59E0B", "#3B82F6", "#10B981"]
        )
        fig_f1.update_traces(texttemplate="%{text:.3f}", textposition="outside")
        fig_f1.update_layout(
            yaxis_range=[0, 1.1],
            showlegend=False,
            height=360,
            margin=dict(l=20, r=20, t=20, b=20),
            template="plotly_white",
            xaxis_title="",
            yaxis_title="F1-Score (0.0 – 1.0)"
        )
        st.plotly_chart(fig_f1, width="stretch")

with chart_col2:
    with st.container(border=True):
        st.subheader("Tỷ lệ suy giảm sai số MAE (%) sau phục hồi", icon=":material/trending_down:")
        st.caption("Chỉ tiêu nghiệm thu đề tài: Giảm MAE ≥ 40% (Thực tế đạt 80.9% – Vượt 102% chỉ tiêu)")

        fig_mae = px.bar(
            df_metrics,
            x="Phương pháp",
            y="MAE Giảm (%)",
            color="Phương pháp",
            text="MAE Giảm (%)",
            color_discrete_sequence=["#94A3B8", "#F59E0B", "#3B82F6", "#10B981"]
        )
        fig_mae.update_traces(texttemplate="%{text:.1f}%", textposition="outside")
        fig_mae.update_layout(
            yaxis_range=[0, 100],
            showlegend=False,
            height=360,
            margin=dict(l=20, r=20, t=20, b=20),
            template="plotly_white",
            xaxis_title="",
            yaxis_title="Tỷ lệ giảm MAE (%)"
        )
        st.plotly_chart(fig_mae, width="stretch")

# -----------------------------------------------------------------------------
# BIỂU ĐỒ RADAR NHIỀU CHIỀU & BẢNG ĐỐI CHUẨN TỪNG DẠNG LỖI
# -----------------------------------------------------------------------------
radar_col1, radar_col2 = st.columns([1, 1])

with radar_col1:
    with st.container(border=True):
        st.subheader("Biểu đồ Radar cân bằng đa chỉ số", icon=":material/workspaces:")
        st.caption("Đánh giá toàn diện: F1, Precision, Recall, Độ tin cậy (100 - FAR), Độ nhạy (100 - MDR)")

        categories = ["F1-Score", "Precision", "Recall", "Độ tin cậy (1-FAR)", "Độ nhạy (1-MDR)"]

        fig_radar = go.Figure()

        # baseline 3: 3-Sigma
        fig_radar.add_trace(go.Scatterpolar(
            r=[0.742, 0.765, 0.720, 1.0 - 0.065, 1.0 - 0.280],
            theta=categories,
            fill='toself',
            name='Moving 3-Sigma',
            line=dict(color='#3B82F6', dash='dash')
        ))

        # Đề xuất
        fig_radar.add_trace(go.Scatterpolar(
            r=[0.912, 0.935, 0.890, 1.0 - 0.028, 1.0 - 0.110],
            theta=categories,
            fill='toself',
            name='Hybrid TinyML (INT8)',
            line=dict(color='#10B981', width=2)
        ))

        fig_radar.update_layout(
            polar=dict(radialaxis=dict(visible=True, range=[0, 1])),
            showlegend=True,
            legend=dict(orientation="h", yanchor="bottom", y=1.05, xanchor="right", x=1),
            height=380,
            margin=dict(l=30, r=30, t=30, b=30),
            template="plotly_white"
        )
        st.plotly_chart(fig_radar, width="stretch")

with radar_col2:
    with st.container(border=True):
        st.subheader("Phân tích đóng góp học thuật & Điểm mấu chốt", icon=":material/lightbulb:")
        st.markdown("""
        1. **Khắc phục triệt để điểm mù lỗi Trôi dốc (Drift):**  
           Các bộ lọc thống kê như Hampel và Moving 3-Sigma phụ thuộc vào độ lệch chuẩn phương sai tức thời nên hoàn toàn **bỏ sót lỗi trôi chậm** ($MDR > 28\%$). Mạng Autoencoder học tương quan không - thời gian giữa 3 kênh nên phát hiện trôi dốc với Recall $89.0\\%$.

        2. **Bảo toàn hình thái chuỗi bằng Selective Spatial Imputation:**  
           Thay vì ghi đè toàn bộ cửa sổ 3 kênh làm méo dạng sóng như các giải pháp nội suy truyền thống, hệ thống chỉ can thiệp kênh lỗi bằng trung bình 2 cảm biến lành, giảm sai số $MAE$ tới $80.9\\%$.

        3. **Khả thi tuyệt đối trên vi điều khiển ESP32-S3:**  
           - Độ trễ trên chip: $0.192\\text{ ms}$ (ngưỡng cho phép $< 50\\text{ ms}$)  
           - Bộ nhớ SRAM Arena: $1.94\\text{ KB}$ (ngưỡng cho phép $< 32\\text{ KB}$)  
           - Bộ đệm vòng tĩnh: Hoàn toàn không cấp phát động (`zero heap-fragmentation`).
        """)
        st.badge("Đạt chỉ tiêu đề tài xuất sắc", icon=":material/verified:", color="green")

# Chân trang
st.space("small")
with st.container(horizontal=True, horizontal_alignment="distribute"):
    st.caption("Khóa luận tốt nghiệp: TinyML Soil Anomaly Pipeline trên ESP32-S3")
    st.caption("Module: 3_Benchmark_Comparison.py • Đối chuẩn định lượng & Radar")
