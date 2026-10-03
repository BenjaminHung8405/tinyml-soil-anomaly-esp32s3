# BÁO CÁO ĐO KIỂM SUY HAO LƯỢNG TỬ HÓA (QUANTIZATION DEGRADATION REPORT)

**Dự án:** Nghiên cứu và triển khai hệ thống phát hiện bất thường, đánh giá độ tin cậy và phục hồi dữ liệu cảm biến độ ẩm đất bằng TinyML tại biên trên ESP32-S3  
**Mô hình đối chiếu:** `autoencoder_float32.keras` vs. `model_int8.tflite`  

---

## 1. Bảng Tổng Hợp Chỉ Số Hiệu Năng

| Chỉ số đánh giá | Mô hình Float32 | Mô hình INT8 PTQ | Chênh lệch / Đánh giá |
| :--- | :---: | :---: | :--- |
| **Kích thước mô hình** | 66.04 KB | **9.66 KB** | Giảm 85.01% dung lượng |
| **RMSE Tái tạo tổng thể** | 0.047080 | 0.047230 | $\Delta\text{RMSE} = 0.000150$ (Đạt $< 0.02$) |
| **Precision (Độ chuẩn xác)** | 0.1530 | 0.1479 | Ổn định |
| **Recall (Độ nhạy)** | 0.7065 | 0.7065 | Ổn định |
| **F1-Score** | 0.2516 | 0.2446 | Sụt giảm 2.76% (Đạt $< 3\%$) |

---

## 2. Kết Luận Nghiệm Thu Kỹ Thuật
* **Tiêu chuẩn $\Delta\text{RMSE} < 0.02$:** Thỏa mãn tuyệt đối (`0.000150 < 0.02`). Quá trình chuyển đổi sang số nguyên 8-bit không gây ra hiện tượng bùng nổ sai số tái tạo trên tập kiểm thử chứa lỗi.
* **Tiêu chuẩn Suy giảm F1-Score $< 3\%$:** Thỏa mãn (`2.76% < 3%`). Năng lực phân loại và phát hiện bất thường gần như được bảo toàn nguyên vẹn sau khi lượng tử hóa.
* **Khả năng triển khai phần cứng:** Tệp `model_int8.tflite` đạt dung lượng tối ưu, sẵn sàng tích hợp vào mã nguồn C++ trên ESP32-S3.
