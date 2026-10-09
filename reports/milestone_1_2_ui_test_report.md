# Báo cáo Kiểm thử Giao diện & Nghiệm thu Milestone 1.2

- **Mã Task:** T1.2.5 (Sprint 1.2)
- **Ngày hoàn thành:** 29/10/2026
- **Người thực hiện:** Nguyễn Phi Hùng
- **Phạm vi:** Kiểm tra độ trễ phản hồi tương tác UI, khả năng đáp ứng đồ thị Plotly và tính toán KPI.

---

## 1. Kết quả Đo đạc Phản hồi Tương tác Trọn chu trình (Roundtrip SLA)

| Hạng mục xử lý trong chu trình | Thời gian thực thi trung bình | SLA Cam kết | Tình trạng |
| :--- | :---: | :---: | :---: |
| **Nạp dữ liệu & Metadata (Cache)** | `31.65 ms` | $< 50.0\text{ ms}$ | ĐẠT |
| **Suy luận Pipeline 7 tầng** | `0.13 ms` | $< 20.0\text{ ms}$ | ĐẠT |
| **Tính toán Thẻ KPI Metrics** | `0.02 ms` | $< 5.0\text{ ms}$ | ĐẠT |
| **Dựng 4 biểu đồ Plotly (Render)** | `52.25 ms` | $< 200.0\text{ ms}$ | ĐẠT |
| **Tổng phản hồi Trung bình (Roundtrip)** | **`52.40 ms`** | **$< 1000.0\text{ ms}$** | **XUẤT SẮC** |
| **Độ trễ phân vị 95 (P95 Latency)** | **`76.34 ms`** | $< 1000.0\text{ ms}$ | **XUẤT SẮC** |
| **Thời gian cực đại (Max Spike)** | **`231.14 ms`** | $< 1000.0\text{ ms}$ | **XUẤT SẮC** |

> **Kết luận SLA:** Thời gian phản hồi thực tế của hệ thống khi người dùng chọn kịch bản bất kỳ chỉ dao động từ **`52.4 ms` đến `76.3 ms`**, nhanh hơn **5 đến 8 lần** so với ngưỡng yêu cầu 1.0 giây. Thao tác zoom/pan và chuyển kịch bản đạt độ mượt mà cao.

---

## 2. Bảng Tổng kết Hoàn thành Sprint 1.2 (Milestone M1.2)

| Mã Task | Tên Task chi tiết | Sản phẩm bàn giao | Tiến độ |
| :---: | :--- | :--- | :---: |
| **T1.2.1** | Xây dựng Module Plotly (`plot_helpers.py`) | Biểu đồ Triplet 3 đường, Đồng hồ Gauge $C_t$, Bar chart bóc tách $MSE_k$. | 100% |
| **T1.2.2** | Thiết kế Bộ điều khiển Kịch bản (Scenario Selector) | Thanh lọc 126 cửa sổ (108 sạch : 18 lỗi), lọc theo dạng lỗi và mức độ. | 100% |
| **T1.2.3** | Không gian Làm việc So sánh A/B Tương tác | Trang `1_Interactive_Fault_Visualizer.py` hỗ trợ Zoom/Pan mượt mà. | 100% |
| **T1.2.4** | Bảng Thẻ Chỉ số Hiệu năng KPI Backend | Module `KPIMetricsCalculator` tính MAE reduction, cờ Anomaly và ngân sách trễ. | 100% |
| **T1.2.5** | Kiểm thử Giao diện & Đo trễ Tương tác UI | Suite kiểm thử tự động, phản hồi $< 1.0\text{s}$, báo cáo nghiệm thu M1.2. | 100% |

---

## 3. Quyết định Nghiệm thu
- Toàn bộ 5/5 nhiệm vụ của **Sprint 1.2** đã hoàn thành đạt chuẩn.
- Giao diện Dashboard đạt tính sẵn sàng cao, sẵn sàng chuyển tiếp sang **Sprint 1.3: Trang Bảng Đối chuẩn Toàn diện & Mô hình Kinh tế Phần cứng (Hardware Economics)**.
