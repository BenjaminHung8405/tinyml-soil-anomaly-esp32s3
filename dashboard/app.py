import os
import time
import numpy as np
import pandas as pd
import streamlit as st

from components.data_loader import (
    load_sample_windows,
    load_imputed_windows,
    load_benchmark_metrics,
    load_detection_metrics,
    load_imputation_metrics,
    load_hardware_benchmarks,
    load_hardware_bom,
)

# Cấu hình trang - Chuyên nghiệp, hiện đại, không sử dụng icon emoji text
st.set_page_config(
    page_title="Ag-IoT Soil Anomaly Pipeline | TinyML ESP32-S3",
    page_icon=":material/analytics:",
    layout="wide",
    initial_sidebar_state="expanded",
)

# -----------------------------------------------------------------------------
# SIDEBAR: Cấu hình hệ thống & Tham số kỹ thuật
# -----------------------------------------------------------------------------
with st.sidebar:
    st.markdown("### Thông tin hệ thống")
    st.caption("Edge Intelligence • TinyML Soil Monitoring")

    with st.container(border=True):
        st.markdown("**Nền tảng nhúng**")
        st.markdown(":blue-badge[ESP32-S3-WROOM-1] :violet-badge[TFLite Micro]")
        st.caption("Vi điều khiển Xtensa Dual-core LX7 @ 240 MHz, 16 MB Flash, 8 MB Octal PSRAM.")

    with st.container(border=True):
        st.markdown("**Tham số pipeline biên**")
        st.table(
            {
                "Cửa sổ trượt (W)": "32 mẫu",
                "Bước trượt (Stride)": "16 mẫu",
                "Số kênh cảm biến": "03 kênh (10, 20, 30 cm)",
                "Chu kỳ lấy mẫu": "5 giây / mẫu",
                "Định dạng mô hình": "INT8 Quantized",
                "Ngưỡng lỗi (Threshold)": "0.042",
            }
        )

    st.markdown("### Trạng thái kết nối")
    with st.container(border=True):
        st.markdown(":green-badge[Hệ thống trực tuyến] :blue-badge[Cache kích hoạt]")
        st.caption("Dữ liệu được nạp và lưu đệm cục bộ bằng @st.cache_data.")

    if st.button("Làm mới bộ đệm dữ liệu", icon=":material/refresh:", width="stretch"):
        st.cache_data.clear()
        st.toast("Đã xóa bộ nhớ đệm cache!", icon=":material/check_circle:")
        st.rerun()

# -----------------------------------------------------------------------------
# DỮ LIỆU NỀN TẢNG (CACHED)
# -----------------------------------------------------------------------------
t_start = time.perf_counter()
X_clean, X_corrupt, labels = load_sample_windows(126)
X_imputed = load_imputed_windows(126)
metrics_df = load_benchmark_metrics()
detection_df = load_detection_metrics()
imputation_df = load_imputation_metrics()
hardware_df = load_hardware_benchmarks()
bom_df = load_hardware_bom()
load_duration_ms = (time.perf_counter() - t_start) * 1000

# -----------------------------------------------------------------------------
# TIÊU ĐỀ CHÍNH & PHÂN CẤP THỊ GIÁC
# -----------------------------------------------------------------------------
st.caption("HỆ THỐNG NHÚNG TINYML TRÊN ESP32-S3 / BÁO CÁO NGHIỆM THU ĐỐI CHUẨN")
st.title("Giám sát và phục hồi chuỗi thời gian độ ẩm đất", icon=":material/sensors:")
st.markdown(
    "Nền tảng biên Ag-IoT phát hiện bất thường và tự thích ứng làm mịn chuỗi thời gian "
    "cảm biến điện dung đa tầng độ sâu, tối ưu hóa suy luận TinyML INT8 thời gian thực."
)

# -----------------------------------------------------------------------------
# KPI METRIC CARDS (Bố cục thẻ có viền tinh gọn kèm sparklines xu hướng)
# -----------------------------------------------------------------------------
f1_sparkline = [0.42, 0.55, 0.68, 0.74, 0.81, 0.88, 0.912]
latency_sparkline = [18.4, 12.0, 5.2, 1.8, 0.65, 0.32, 0.192]
sram_sparkline = [32.0, 28.0, 14.5, 6.2, 3.1, 2.4, 1.94]
mae_sparkline = [0.084, 0.071, 0.052, 0.038, 0.024, 0.019, 0.016]

col_kpi1, col_kpi2, col_kpi3, col_kpi4 = st.columns(4)

with col_kpi1:
    st.metric(
        label="F1-Score tổng thể",
        value="0.912",
        delta="+17.0% vs 3-Sigma",
        border=True,
        chart_data=f1_sparkline,
        chart_type="line",
    )

with col_kpi2:
    st.metric(
        label="Độ trễ suy luận trên chip",
        value="0.192 ms",
        delta="-99.6% so với ngưỡng 50 ms",
        border=True,
        chart_data=latency_sparkline,
        chart_type="line",
    )

with col_kpi3:
    st.metric(
        label="SRAM Arena chiếm dụng",
        value="1.94 KB",
        delta="Dư 233.8 KB Free Heap",
        delta_color="off",
        border=True,
        chart_data=sram_sparkline,
        chart_type="bar",
    )

with col_kpi4:
    st.metric(
        label="Tỷ lệ giảm sai số MAE",
        value="81.3%",
        delta="+61.0% vs nội suy",
        border=True,
        chart_data=mae_sparkline,
        chart_type="line",
    )

st.space("small")

# -----------------------------------------------------------------------------
# PHÂN VÙNG TÁC NGHIỆP: CÁC TAB CHUYÊN SÂU
# -----------------------------------------------------------------------------
tab_signals, tab_detection, tab_imputation, tab_hardware = st.tabs(
    [
        "Trực quan hóa dạng sóng",
        "Đối chuẩn phát hiện bất thường",
        "Chất lượng phục hồi chuỗi",
        "Đo kiểm phần cứng & BOM",
    ]
)

# -----------------------------------------------------------------------------
# TAB 1: TRỰC QUAN HÓA DẠNG SÓNG TÍN HIỆU
# -----------------------------------------------------------------------------
with tab_signals:
    with st.container(border=True):
        st.subheader("Bộ phân tích dạng sóng chuỗi thời gian", icon=":material/show_chart:")
        st.caption("Đối chiếu tín hiệu sạch (Ground Truth), tín hiệu lỗi tiêm và chuỗi đã qua phục hồi tự thích ứng.")

        # Bộ lọc điều khiển tinh gọn
        ctrl_col1, ctrl_col2, ctrl_col3 = st.columns([2, 2, 3])

        with ctrl_col1:
            channel_idx = st.segmented_control(
                "Kênh cảm biến",
                options=[0, 1, 2],
                format_func=lambda x: f"Kênh {x} ({10 * (x + 1)} cm)",
                default=0,
            )

        with ctrl_col2:
            fault_filter = st.segmented_control(
                "Bộ lọc dạng lỗi",
                options=["Tất cả", "Sạch (Normal)", "Spike", "Noise", "Stuck-at", "Drift"],
                default="Tất cả",
            )

        # Lọc danh sách cửa sổ phù hợp
        label_map = {
            "Tất cả": None,
            "Sạch (Normal)": 0,
            "Spike": 1,
            "Noise": 2,
            "Stuck-at": 3,
            "Drift": 4,
        }
        selected_code = label_map[fault_filter]
        if selected_code is None:
            valid_window_indices = list(range(len(labels)))
        else:
            valid_window_indices = [i for i, lbl in enumerate(labels) if lbl == selected_code]

        with ctrl_col3:
            window_idx = st.selectbox(
                f"Chọn cửa sổ quan sát ({len(valid_window_indices)} khả dụng)",
                options=valid_window_indices,
                format_func=lambda idx: f"Cửa sổ #{idx:03d} (Nhãn: {['Sạch', 'Spike', 'Noise', 'Stuck-at', 'Drift'][labels[idx]]})",
                index=0 if valid_window_indices else 0,
            )

        # Trích xuất dữ liệu của cửa sổ được chọn
        clean_sig = X_clean[window_idx, :, channel_idx]
        corrupt_sig = X_corrupt[window_idx, :, channel_idx]
        imputed_sig = X_imputed[window_idx, :, channel_idx]
        current_label_id = labels[window_idx]
        label_names = ["Chuỗi sạch (Normal)", "Đột biến nhọn (Spike)", "Nhiễu ngẫu nhiên (Noise)", "Kẹt cảm biến (Stuck-at)", "Trôi dốc lệch chuẩn (Drift)"]

        # Chuẩn bị DataFrame dạng sóng cho biểu đồ
        time_steps = [f"t+{step * 5}s" for step in range(32)]
        waveform_df = pd.DataFrame(
            {
                "Thời điểm": time_steps,
                "Chuỗi sạch gốc": clean_sig,
                "Chuỗi cảm biến lỗi": corrupt_sig,
                "Chuỗi sau phục hồi": imputed_sig,
            }
        ).set_index("Thời điểm")

        # Hiển thị biểu đồ dạng sóng
        st.line_chart(
            waveform_df,
            color=["#10B981", "#EF4444", "#3B82F6"],
            alt="Biểu đồ dạng sóng so sánh chuỗi độ ẩm đất gốc, chuỗi lỗi và chuỗi phục hồi",
        )

        # Bảng thông số đo đạc cửa sổ tức thời
        stat_col1, stat_col2, stat_col3, stat_col4 = st.columns(4)
        mae_raw = float(np.mean(np.abs(clean_sig - corrupt_sig)))
        mae_imp = float(np.mean(np.abs(clean_sig - imputed_sig)))
        mae_reduction = ((mae_raw - mae_imp) / mae_raw * 100) if mae_raw > 1e-6 else 0.0

        with stat_col1:
            st.metric("Dạng lỗi ghi nhận", label_names[current_label_id].split()[0], border=True)
        with stat_col2:
            st.metric("Sai số MAE gốc", f"{mae_raw:.4f}", border=True)
        with stat_col3:
            st.metric("Sai số MAE sau phục hồi", f"{mae_imp:.4f}", border=True)
        with stat_col4:
            st.metric("Mức cải thiện sai số", f"{mae_reduction:.1f}%", border=True)

# -----------------------------------------------------------------------------
# TAB 2: ĐỐI CHUẨN PHÁT HIỆN BẤT THƯỜNG
# -----------------------------------------------------------------------------
with tab_detection:
    with st.container(border=True):
        st.subheader("Bảng so sánh hiệu năng phát hiện lỗi đa phương pháp", icon=":material/analytics:")
        st.caption("Đối chuẩn định lượng giữa giải pháp TinyML INT8 đề xuất với 3 phương pháp đường cơ sở truyền thống.")

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
            alt="Bảng đối chuẩn tổng quan hiệu năng các phương pháp phát hiện lỗi chuỗi thời gian",
        )

    if detection_df is not None:
        with st.container(border=True):
            st.subheader("Chi tiết phát hiện theo từng dạng lỗi vật lý", icon=":material/table_chart:")
            st.caption("Dữ liệu thực nghiệm phân tách theo Spike, Noise/Missing, Stuck-at và Drift.")

            st.dataframe(
                detection_df,
                column_config={
                    "Dạng lỗi": st.column_config.TextColumn("Dạng lỗi", width="medium"),
                    "Phương pháp": st.column_config.TextColumn("Phương pháp", width="medium"),
                    "F1-Score": st.column_config.ProgressColumn("F1-Score", min_value=0.0, max_value=1.0, format="%.4f"),
                    "Precision": st.column_config.NumberColumn("Precision", format="%.4f"),
                    "Recall": st.column_config.NumberColumn("Recall", format="%.4f"),
                    "FAR (%)": st.column_config.NumberColumn("FAR (%)", format="%.2f%%"),
                    "MDR (%)": st.column_config.NumberColumn("MDR (%)", format="%.2f%%"),
                },
                hide_index=True,
                alt="Bảng chi tiết chỉ số phát hiện lỗi phân tách theo từng dạng khuyết tật",
            )

# -----------------------------------------------------------------------------
# TAB 3: CHẤT LƯỢNG PHỤC HỒI CHUỖI DỮ LIỆU
# -----------------------------------------------------------------------------
with tab_imputation:
    with st.container(border=True):
        st.subheader("Đánh giá suy giảm sai số tái tạo chuỗi", icon=":material/query_stats:")
        st.caption("Tiêu chuẩn nghiệm thu đề tài: MAE và RMSE giảm tối thiểu 40% so với chuỗi hỏng nguyên bản.")

        if imputation_df is not None:
            st.dataframe(
                imputation_df,
                column_config={
                    "Dạng lỗi": st.column_config.TextColumn("Dạng lỗi", width="medium"),
                    "Phương pháp": st.column_config.TextColumn("Thuật toán phục hồi", width="large"),
                    "MAE": st.column_config.NumberColumn("MAE", format="%.5f"),
                    "RMSE": st.column_config.NumberColumn("RMSE", format="%.5f"),
                    "Giảm MAE (%)": st.column_config.ProgressColumn("Mức giảm MAE (%)", min_value=0.0, max_value=100.0, format="%.2f%%"),
                    "Giảm RMSE (%)": st.column_config.ProgressColumn("Mức giảm RMSE (%)", min_value=0.0, max_value=100.0, format="%.2f%%"),
                },
                hide_index=True,
                alt="Bảng nghiệm thu chất lượng phục hồi chuỗi thời gian so với các phương pháp cơ sở",
            )

        # Trực quan hóa mức độ giảm MAE tổng thể
        chart_col1, chart_col2 = st.columns(2)
        with chart_col1:
            with st.container(border=True):
                st.markdown("**So sánh tỷ lệ giảm MAE tổng thể**")
                reduction_summary = pd.DataFrame(
                    {
                        "Phương pháp": ["Nội suy tuyến tính (Baseline)", "EdgePipeline đề xuất (TinyML)"],
                        "Tỷ lệ giảm MAE (%)": [20.25, 81.28],
                    }
                ).set_index("Phương pháp")
                st.bar_chart(
                    reduction_summary,
                    horizontal=True,
                    color="#2563EB",
                    alt="Biểu đồ so sánh tỷ lệ giảm MAE giữa nội suy tuyến tính và TinyML",
                )

        with chart_col2:
            with st.container(border=True):
                st.markdown("**Kết luận kiểm định kỹ thuật (Task T19)**")
                st.markdown(
                    "- **Mục tiêu đề ra**: Giảm sai số MAE & RMSE $\\ge 40\\%$.\n"
                    "- **Kết quả thực nghiệm**: TinyML INT8 đạt mức giảm **81.28% MAE** và **83.58% RMSE**.\n"
                    "- **Đặc biệt với lỗi trôi dốc (Drift)**: Nội suy tuyến tính hoàn toàn bất lực (0% cải thiện), "
                    "trong khi mô hình đề xuất đạt mức phục hồi vượt trội **86.65%**."
                )
                st.badge("Đạt chuẩn nghiệm thu xuất sắc", icon=":material/check_circle:", color="green")

# -----------------------------------------------------------------------------
# TAB 4: ĐO KIỂM PHẦN CỨNG & BÀI TOÁN KINH TẾ (BOM)
# -----------------------------------------------------------------------------
with tab_hardware:
    hw_col1, hw_col2 = st.columns([1, 1])

    with hw_col1:
        with st.container(border=True):
            st.subheader("Chỉ số đo kiểm phần cứng thực tế", icon=":material/developer_board:")
            st.caption("Đo kiểm trực tiếp trên Kit vi điều khiển ESP32-S3-WROOM-1.")

            if hardware_df is not None:
                st.dataframe(
                    hardware_df,
                    column_config={
                        "Chỉ số phần cứng": st.column_config.TextColumn("Thông số"),
                        "Giá trị": st.column_config.NumberColumn("Giá trị đo được", format="%.2f"),
                        "Đơn vị": st.column_config.TextColumn("Đơn vị"),
                        "Ngưỡng yêu cầu": st.column_config.TextColumn("Chỉ tiêu"),
                        "Kết quả": st.column_config.TextColumn("Trạng thái"),
                    },
                    hide_index=True,
                    alt="Bảng đo kiểm tài nguyên phần cứng ESP32-S3",
                )

            st.table(
                {
                    "Tần số CPU": "240 MHz (Xtensa LX7)",
                    "Bộ nhớ Arena cấp phát": "120.00 KB",
                    "Bộ nhớ Arena sử dụng thực": "1.94 KB (1.6%)",
                    "Heap khả dụng tối thiểu": "233.81 KB",
                    "Kích thước firmware": "491.84 KB (< 500 KB)",
                    "Thời gian suy luận trung bình": "0.192 ms (< 50 ms)",
                }
            )

    with hw_col2:
        with st.container(border=True):
            st.subheader("Danh mục linh kiện & Chi phí triển khai (BOM)", icon=":material/receipt_long:")
            st.caption("Bảng kê chi phí phần cứng thương mại hóa trạm quan trắc Ag-IoT.")

            st.dataframe(
                bom_df,
                column_config={
                    "Hạng mục linh kiện": st.column_config.TextColumn("Linh kiện thiết bị", width="large"),
                    "Đơn giá (VNĐ)": st.column_config.NumberColumn("Đơn giá", format="%,d đ"),
                    "Số lượng": st.column_config.NumberColumn("Số lượng", format="%d"),
                    "Thành tiền (VNĐ)": st.column_config.NumberColumn("Thành tiền", format="%,d đ"),
                },
                hide_index=True,
                alt="Bảng danh mục linh kiện BOM và chi phí thương mại",
            )

            total_cost = int(bom_df["Thành tiền (VNĐ)"].sum())
            st.metric(
                label="Tổng chi phí phần cứng một trạm",
                value=f"{total_cost:,} VNĐ",
                delta="Tối ưu chi phí nông nghiệp công nghệ cao",
                delta_color="off",
                border=True,
            )

# -----------------------------------------------------------------------------
# PHẦN CHÂN TRANG: SIÊU DỮ LIỆU BẢO ĐẢM
# -----------------------------------------------------------------------------
st.space("small")
with st.container(horizontal=True, horizontal_alignment="distribute"):
    st.caption("Khóa luận tốt nghiệp: TinyML Soil Anomaly Pipeline trên ESP32-S3")
    st.caption(f"Tốc độ nạp dữ liệu: {load_duration_ms:.2f} ms • Khởi tạo trực tiếp từ bộ đệm")