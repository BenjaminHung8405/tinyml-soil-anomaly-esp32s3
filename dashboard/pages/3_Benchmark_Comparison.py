"""
Trang 3: dashboard/pages/3_Benchmark_Comparison.py
Nhiệm vụ: Trình bày bảng đối chuẩn khoa học so sánh phương pháp đề xuất với
các phương pháp đường cơ sở (Ngưỡng tĩnh, Hampel, Moving 3-Sigma).
Bao gồm:
- Tab 1: Đối chuẩn chất lượng phát hiện dị thường (Phát hiện lỗi & Ma trận nhầm lẫn)
- Tab 2: Đối chuẩn chất lượng phục hồi tín hiệu (Selective Spatial Imputation vs Baselines)
- Tab 3: Tổng hợp đa chiều & Đóng góp học thuật (Radar & Phân tích chuyên sâu)
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
from src.pipeline.benchmark_t18_loader import BenchmarkT18Loader
from src.pipeline.benchmark_t19_loader import BenchmarkT19Loader

st.set_page_config(
    page_title="Đối chuẩn Định lượng & Đánh giá Học thuật | Ag-IoT",
    page_icon=":material/analytics:",
    layout="wide",
    initial_sidebar_state="expanded"
)

# Hiển thị sidebar dùng chung
render_sidebar()

# Tiêu đề trang chuẩn học thuật (không chứa từ khóa task/sprint)
st.caption("KẾT QUẢ THỰC NGHIỆM & ĐỐI CHUẨN ĐỊNH LƯỢNG HỌC THUẬT")
st.title("Bảng đối chuẩn toàn diện các phương pháp", icon=":material/balance:")
st.markdown(
    "So sánh định lượng độc lập giữa **Hybrid TinyML Pipeline (INT8)** với các phương pháp đường cơ sở "
    "(Ngưỡng tĩnh, Bộ lọc Hampel, Moving 3-Sigma) về độ chính xác phát hiện dị thường, năng lực phục hồi dữ liệu và tài nguyên nhúng."
)

st.space("small")

# 3 Tabs cấu trúc theo chuẩn báo cáo khoa học
tab_detection, tab_imputation, tab_academic = st.tabs([
    "Chất lượng phát hiện dị thường",
    "Chất lượng phục hồi tín hiệu",
    "Tổng hợp đa chiều & Đóng góp học thuật"
])

# =============================================================================
# TAB 1: ĐỐI CHUẨN CHẤT LƯỢNG PHÁT HIỆN DỊ THƯỜNG
# =============================================================================
with tab_detection:
    # 1. Bộ lọc Kịch bản Đối chuẩn (Scenario Filter Bar)
    with st.container(border=True):
        f_col1, f_col2, f_col3 = st.columns([1.2, 1.2, 1.6])
        with f_col1:
            fault_options = ["Tất cả", "Spike", "Noise", "Stuck-at", "Drift"]
            selected_fault = st.selectbox(
                "Dạng lỗi khảo sát:",
                options=fault_options,
                index=0,
                key="t18_fault_filter"
            )
        with f_col2:
            sev_options = ["Tất cả", "Nhẹ (Mild)", "Vừa (Moderate)", "Nặng (Severe)"]
            selected_sev = st.selectbox(
                "Mức độ nghiêm trọng:",
                options=sev_options,
                index=0,
                key="t18_sev_filter"
            )
        with f_col3:
            st.caption("Ghi chú kịch bản:")
            st.markdown(
                "Đo kiểm trên **126 cửa sổ mẫu / kịch bản** (18 cửa sổ dương tính, 108 cửa sổ âm tính đối chứng) "
                "đáp ứng đầy đủ 4 dạng hư hỏng cảm biến độ ẩm đất."
            )

    # Nạp dữ liệu T18 đã lọc
    df_t18_filtered = BenchmarkT18Loader.load_t18_data(
        fault_filter=selected_fault,
        severity_filter=selected_sev
    )
    t18_cards = BenchmarkT18Loader.get_kpi_cards_payload(df_t18_filtered)

    # 2. Khối 4 Thẻ KPI Tóm tắt Đối chuẩn
    st.space("small")
    if t18_cards:
        card_cols = st.columns(len(t18_cards))
        for idx, card in enumerate(t18_cards):
            with card_cols[idx]:
                with st.container(border=True):
                    # Header với Lucide SVG icon
                    st.markdown(
                        f"""
                        <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 6px;">
                            <span style="font-weight: 600; font-size: 0.95rem; color: #1E293B;">{card['short_name']}</span>
                            <span>{card['icon_svg']}</span>
                        </div>
                        """,
                        unsafe_allow_html=True
                    )
                    st.metric(
                        label="F1-Score",
                        value=f"{card['f1_score']:.3f}",
                        delta=card['delta_str'],
                        delta_color="normal" if not card['is_proposed'] else "off"
                    )
                    st.caption(f"FAR: **{card['far_pct']:.1f}%** | MDR: **{card['mdr_pct']:.1f}%**")
                    if card['badge_text']:
                        st.badge(card['badge_text'], color=card['badge_color'])

    # 3. Khu vực Trực quan hóa Song song (Dual Visualization Columns)
    st.space("small")
    chart_col1, chart_col2 = st.columns([1.1, 0.9])

    summary_t18 = BenchmarkT18Loader.get_summary_by_method(df_t18_filtered)

    with chart_col1:
        with st.container(border=True):
            st.subheader("So sánh F1-Score, Precision & Recall", icon=":material/bar_chart:")
            st.caption("Chỉ số cân bằng giữa độ chính xác và độ nhạy phát hiện dị thường:")

            if not summary_t18.empty:
                # Chuẩn bị bảng unpivot để vẽ Grouped Bar
                df_plot = summary_t18.melt(
                    id_vars=["method_name"],
                    value_vars=["f1_score", "precision", "recall"],
                    var_name="Chỉ số",
                    value_name="Giá trị"
                )
                metric_name_map = {
                    "f1_score": "F1-Score",
                    "precision": "Precision",
                    "recall": "Recall"
                }
                df_plot["Chỉ số"] = df_plot["Chỉ số"].map(metric_name_map)

                fig_t18_bar = px.bar(
                    df_plot,
                    x="method_name",
                    y="Giá trị",
                    color="Chỉ số",
                    barmode="group",
                    color_discrete_sequence=["#10B981", "#3B82F6", "#F59E0B"]
                )
                fig_t18_bar.add_hline(
                    y=0.880,
                    line_dash="dash",
                    line_color="#EF4444",
                    annotation_text="Ngưỡng đề tài F1 ≥ 0.880",
                    annotation_position="bottom right"
                )
                fig_t18_bar.update_layout(
                    yaxis_range=[0, 1.05],
                    height=350,
                    margin=dict(l=20, r=20, t=30, b=20),
                    template="plotly_white",
                    xaxis_title="",
                    yaxis_title="Điểm số (0.0 - 1.0)",
                    legend=dict(orientation="h", yanchor="bottom", y=1.02, xanchor="right", x=1)
                )
                st.plotly_chart(fig_t18_bar, width="stretch")

    with chart_col2:
        with st.container(border=True):
            st.subheader("Tỷ lệ Báo giả (FAR) vs Bỏ sót (MDR)", icon=":material/balance:")
            st.caption("Mô hình lý tưởng nằm ở góc dưới bên trái (FAR và MDR cùng tiệm cận 0%):")

            if not summary_t18.empty:
                fig_scatter = px.scatter(
                    summary_t18,
                    x="far_pct",
                    y="mdr_pct",
                    color="method_name",
                    size=[22 if "Proposed" in m else 16 for m in summary_t18["method_name"]],
                    text="method_name",
                    color_discrete_map={
                        "Proposed: Hybrid TinyML INT8": "#10B981",
                        "Baseline 3: Moving 3-Sigma": "#3B82F6",
                        "Baseline 2: Bộ lọc Hampel": "#F59E0B",
                        "Baseline 1: Ngưỡng tĩnh": "#94A3B8"
                    }
                )
                fig_scatter.update_traces(textposition="top center")
                fig_scatter.update_layout(
                    xaxis_range=[-1, max(25, summary_t18["far_pct"].max() + 5)],
                    yaxis_range=[-2, max(60, summary_t18["mdr_pct"].max() + 8)],
                    height=350,
                    margin=dict(l=20, r=20, t=30, b=20),
                    template="plotly_white",
                    showlegend=False,
                    xaxis_title="Tỷ lệ Báo động Giả - FAR (%)",
                    yaxis_title="Tỷ lệ Bỏ sót Lỗi - MDR (%)"
                )
                st.plotly_chart(fig_scatter, width="stretch")

    # 4. Bảng Ma trận Nhầm lẫn Chi tiết (Confusion Matrix & Data Table)
    st.space("small")
    with st.container(border=True):
        st.subheader("Bảng chi tiết ma trận nhầm lẫn & Thống kê kịch bản", icon=":material/table_chart:")
        st.caption("Số liệu chi tiết phân rã số lượng mẫu TP, FP, TN, FN của từng kịch bản kiểm thử:")

        st.dataframe(
            df_t18_filtered,
            column_config={
                "method_name": st.column_config.TextColumn("Phương pháp đánh giá", width="medium"),
                "fault_category": st.column_config.TextColumn("Dạng lỗi"),
                "severity_level": st.column_config.TextColumn("Cấp độ"),
                "tp": st.column_config.NumberColumn("TP (Đúng lỗi)", format="%d"),
                "fp": st.column_config.NumberColumn("FP (Báo giả)", format="%d"),
                "tn": st.column_config.NumberColumn("TN (Đúng sạch)", format="%d"),
                "fn": st.column_config.NumberColumn("FN (Sót lỗi)", format="%d"),
                "f1_score": st.column_config.ProgressColumn("F1-Score", min_value=0.0, max_value=1.0, format="%.3f"),
                "far_pct": st.column_config.NumberColumn("FAR (%)", format="%.2f%%"),
                "mdr_pct": st.column_config.NumberColumn("MDR (%)", format="%.2f%%"),
            },
            hide_index=True,
            width="stretch"
        )

        # Điểm nhấn học thuật phân tích lỗi Drift theo Brief
        st.space("small")
        st.info(
            "💡 **Điểm nhấn phân tích học thuật (Drift Anomaly Sensitivity):**  \n"
            "Cả 3 phương pháp cơ sở (*Ngưỡng tĩnh, Hampel Filter, Moving 3-Sigma*) đều **thất bại nặng nề trước lỗi Trôi cảm biến (Drift)** "
            "với tỷ lệ bỏ sót lỗi **MDR > 50%** (thậm chí > 67% ở mức độ nhẹ/vừa) do phụ thuộc vào độ lệch chuẩn phương sai tức thời cục bộ. "
            "Ngược lại, **Proposed TinyML INT8** khai thác tương quan không - thời gian giữa 3 cảm biến đối xứng, "
            "duy trì tỷ lệ bỏ sót cực thấp **MDR < 11%** (F1 = 0.912, FAR < 3%), bảo đảm cảnh báo sớm suy thoái phần cứng trước khi dẫn đến quyết định tưới sai lầm.",
            icon=":material/lightbulb:"
        )

# =============================================================================
# TAB 2: ĐỐI CHUẨN CHẤT LƯỢNG PHỤC HỒI TÍN HIỆU
# =============================================================================
with tab_imputation:
    # 1. Bộ điều khiển Phân tích Phục hồi (Imputation Scenario Control Bar)
    with st.container(border=True):
        imp_col1, imp_col2, imp_col3 = st.columns([1.2, 1.2, 1.6])
        with imp_col1:
            selected_imp_fault = st.selectbox(
                "Dạng lỗi khảo sát:",
                options=["Tất cả", "Spike", "Noise", "Stuck-at", "Drift"],
                index=0,
                key="t19_fault_filter"
            )
        with imp_col2:
            selected_metric_type = st.radio(
                "Chỉ số trực quan hóa:",
                options=["MAE (Sai số tuyệt đối)", "RMSE (Căn bậc hai bình phương)", "% Cắt giảm sai số"],
                index=0,
                horizontal=True,
                key="t19_metric_type"
            )
        with imp_col3:
            st.caption("Cơ chế phục hồi cốt lõi:")
            st.markdown(
                "Áp dụng **Selective Spatial Imputation**: Chỉ tái tạo kênh hỏng dựa trên quan hệ không gian "
                "2 cảm biến lành, bảo toàn 100% hình thái sóng không bị méo như nội suy đơn biến."
            )

    # Nạp dữ liệu T19 đã lọc
    df_t19_filtered = BenchmarkT19Loader.load_t19_data(fault_filter=selected_imp_fault)
    t19_cards = BenchmarkT19Loader.get_kpi_cards_payload(df_t19_filtered)

    # 2. Khối 4 Thẻ KPI Tóm tắt Suy giảm Sai số
    st.space("small")
    if t19_cards:
        imp_card_cols = st.columns(len(t19_cards))
        for idx, card in enumerate(t19_cards):
            with imp_card_cols[idx]:
                with st.container(border=True):
                    st.markdown(
                        f"""
                        <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 6px;">
                            <span style="font-weight: 600; font-size: 0.95rem; color: #1E293B;">{card['short_name']}</span>
                            <span>{card['icon_svg']}</span>
                        </div>
                        """,
                        unsafe_allow_html=True
                    )
                    st.metric(
                        label="Giảm Sai số MAE",
                        value=f"{card['mae_reduction_pct']:.1f}%",
                        delta=f"MAE: {card['mae_imputed']:.4f} VWC",
                        delta_color="normal" if card['is_proposed'] else "off"
                    )
                    st.caption(f"Sai số gốc: **{card['mae_raw']:.4f}** | Nhất quán: **{card['spatial_consistency_score']:.2f}**")
                    if card['badge_text']:
                        st.badge(card['badge_text'], color=card['badge_color'])

    # 3. Khu vực Trực quan hóa Song song
    st.space("small")
    imp_chart_col1, imp_chart_col2 = st.columns([1.1, 0.9])
    summary_t19 = BenchmarkT19Loader.get_summary_by_method(df_t19_filtered)

    with imp_chart_col1:
        with st.container(border=True):
            st.subheader("Sai số trước vs sau khi phục hồi", icon=":material/compare_arrows:")
            st.caption("So sánh sai số tín hiệu thô (Corrupted Raw) so với tín hiệu sau khi phục hồi (Imputed):")

            if not summary_t19.empty:
                if "RMSE" in selected_metric_type:
                    val_raw_col, val_imp_col = "rmse_raw", "rmse_imputed"
                    y_label = "Sai số RMSE (VWC)"
                else:
                    val_raw_col, val_imp_col = "mae_raw", "mae_imputed"
                    y_label = "Sai số MAE (VWC)"

                df_err_plot = summary_t19.melt(
                    id_vars=["method_name"],
                    value_vars=[val_raw_col, val_imp_col],
                    var_name="Trạng thái",
                    value_name="Sai số"
                )
                df_err_plot["Trạng thái"] = df_err_plot["Trạng thái"].map({
                    val_raw_col: "Tín hiệu lỗi thô (Raw)",
                    val_imp_col: "Sau phục hồi (Imputed)"
                })

                fig_imp_bar = px.bar(
                    df_err_plot,
                    x="method_name",
                    y="Sai số",
                    color="Trạng thái",
                    barmode="group",
                    color_discrete_sequence=["#94A3B8", "#10B981"]
                )
                fig_imp_bar.update_layout(
                    height=350,
                    margin=dict(l=20, r=20, t=30, b=20),
                    template="plotly_white",
                    xaxis_title="",
                    yaxis_title=y_label,
                    legend=dict(orientation="h", yanchor="bottom", y=1.02, xanchor="right", x=1)
                )
                st.plotly_chart(fig_imp_bar, width="stretch")

    with imp_chart_col2:
        with st.container(border=True):
            st.subheader("Tỷ lệ cắt giảm sai số (%)", icon=":material/trending_down:")
            st.caption("Mức giảm sai số tuyệt đối so với chỉ tiêu đề cương khóa luận (≥ 40%):")

            if not summary_t19.empty:
                metric_col = "rmse_reduction_pct" if "RMSE" in selected_metric_type else "mae_reduction_pct"

                fig_reduc = px.bar(
                    summary_t19,
                    x="method_name",
                    y=metric_col,
                    color="method_name",
                    text=metric_col,
                    color_discrete_map={
                        "Proposed: Hybrid TinyML INT8": "#10B981",
                        "Baseline 3: Moving 3-Sigma": "#3B82F6",
                        "Baseline 2: Bộ lọc Hampel": "#F59E0B",
                        "Baseline 1: Ngưỡng tĩnh": "#94A3B8"
                    }
                )
                fig_reduc.update_traces(texttemplate="%{text:.1f}%", textposition="outside")
                fig_reduc.add_hline(
                    y=40.0,
                    line_dash="dash",
                    line_color="#EF4444",
                    annotation_text="Chỉ tiêu đề tài ≥ 40.0%",
                    annotation_position="bottom right"
                )
                fig_reduc.update_layout(
                    yaxis_range=[0, 105],
                    height=350,
                    margin=dict(l=20, r=20, t=30, b=20),
                    template="plotly_white",
                    showlegend=False,
                    xaxis_title="",
                    yaxis_title="Mức giảm sai số (%)"
                )
                st.plotly_chart(fig_reduc, width="stretch")

    # 4. Bảng Chi tiết Ma trận Phục hồi
    st.space("small")
    with st.container(border=True):
        st.subheader("Bảng chi tiết ma trận phục hồi tín hiệu", icon=":material/table_rows:")
        st.caption("Đầy đủ 48 kịch bản đối chuẩn sai số MAE, RMSE và điểm nhất quán không gian:")

        st.dataframe(
            df_t19_filtered,
            column_config={
                "method_name": st.column_config.TextColumn("Phương pháp đánh giá", width="medium"),
                "fault_category": st.column_config.TextColumn("Dạng lỗi"),
                "severity_level": st.column_config.TextColumn("Cấp độ"),
                "mae_raw": st.column_config.NumberColumn("MAE Thô", format="%.4f"),
                "mae_imputed": st.column_config.NumberColumn("MAE Phục hồi", format="%.4f"),
                "mae_reduction_pct": st.column_config.ProgressColumn("Giảm MAE (%)", min_value=0.0, max_value=100.0, format="%.1f%%"),
                "rmse_raw": st.column_config.NumberColumn("RMSE Thô", format="%.4f"),
                "rmse_imputed": st.column_config.NumberColumn("RMSE Phục hồi", format="%.4f"),
                "spatial_consistency_score": st.column_config.ProgressColumn("Nhất quán không gian", min_value=0.0, max_value=1.0, format="%.3f"),
            },
            hide_index=True,
            width="stretch"
        )

# =============================================================================
# TAB 3: TỔNG HỢP ĐA CHIỀU & ĐÓNG GÓP HỌC THUẬT
# =============================================================================
with tab_academic:
    df_metrics = load_benchmark_metrics()

    # Bảng ma trận tổng hợp
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

    # Radar đa chiều & Luận cứ đóng góp học thuật
    radar_col1, radar_col2 = st.columns([1, 1])

    with radar_col1:
        with st.container(border=True):
            st.subheader("Biểu đồ Radar cân bằng đa chỉ số", icon=":material/workspaces:")
            st.caption("Đánh giá toàn diện: F1, Precision, Recall, Độ tin cậy (100 - FAR), Độ nhạy (100 - MDR)")

            categories = ["F1-Score", "Precision", "Recall", "Độ tin cậy (1-FAR)", "Độ nhạy (1-MDR)"]

            fig_radar = go.Figure()
            # Moving 3-Sigma
            fig_radar.add_trace(go.Scatterpolar(
                r=[0.742, 0.765, 0.720, 1.0 - 0.065, 1.0 - 0.280],
                theta=categories,
                fill='toself',
                name='Moving 3-Sigma',
                line=dict(color='#3B82F6', dash='dash')
            ))
            # Proposed TinyML
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

# Chân trang học thuật
st.space("small")
with st.container(horizontal=True, horizontal_alignment="distribute"):
    st.caption("Khóa luận tốt nghiệp: TinyML Soil Anomaly Pipeline trên ESP32-S3")
    st.caption("Trang đối chuẩn định lượng: Ma trận phát hiện dị thường & Phục hồi chuỗi")
