# 🚀 HƯỚNG DẪN KỊCH BẢN THUYẾT TRÌNH DEMO 5 PHÚT (DEMO GUIDE)

- **Đề tài:** Hệ thống nhúng TinyML tự động phát hiện dị thường và phục hồi chuỗi thời gian độ ẩm đất trên ESP32-S3
- **Tác giả:** Nguyễn Phi Hùng
- **Đơn vị:** Khoa Công nghệ Thông tin – Trường Đại học An Giang
- **Mục tiêu:** Trình diễn tính khả thi của giải pháp *Software-defined Reliability* trong 5 phút trước Giảng viên Hướng dẫn / Hội đồng.

---

## ⏱️ PHÂN BỔ THỜI GIAN KỊCH BẢN (5-MINUTE TIMELINE)

```text
[00:00 - 00:45] 1. Mở đầu & Đặt vấn đề (Executive Summary)
↓
[00:45 - 01:45] 2. Luận chứng Kinh tế BOM & Hardware (Trang 3)
↓
[01:45 - 03:15] 3. Trực quan hóa A/B & Selective Imputation (Trang 1)
↓
[03:15 - 04:15] 4. Ma trận Đối chuẩn Khoa học T18/T19 (Trang 4)
↓
[04:15 - 05:00] 5. Kết luận & Hướng phát triển (Chốt ấn tượng)
```

---

## 🎬 CHI TIẾT TỪNG BƯỚC THAO TÁC TRÊN GIAO DIỆN

### Bước 1: Trang chủ (`app.py`) — Mở đầu & Đặt vấn đề (00:00 – 00:45)
- **Hành động:** Mở trình duyệt tại `http://localhost:8501`. Chỉ tay vào **3 Thẻ KPI Hero**.
- **Lời thoại:** 
  > "Kính thưa Thầy/Cô, trong nông nghiệp thông minh tại ĐBSCL, cảm biến độ ẩm đất giá rẻ rất dễ bị hỏng hóc hoặc trôi dốc (Drift) gây tưới sai. Đề tài của em đề xuất giải pháp **Software-defined Reliability** nhúng mô hình TinyML INT8 trực tiếp trên ESP32-S3: Đạt **F1-Score 0.912**, độ trễ suy luận chỉ **18.4 ms** và giảm sai số MAE tới **80.9%**."

---

### Bước 2: Trang Luận chứng Kinh tế (`pages/3_Hardware_Economics.py`) (00:45 – 01:45)
- **Hành động:** Chuyển sang Trang 3. Chỉ vào Thẻ Metric So sánh & Biểu đồ Radar.
- **Lời thoại:** 
  > "Thay vì đầu tư **1 cảm biến công nghiệp đắt tiền (~980.000 VNĐ)** vẫn có nguy cơ hỏng đơn điểm (SPOF) làm sập hệ thống, đề tài sử dụng **cụm 3 cảm biến điện dung MKE-S13 giá rẻ** kết hợp ESP32-S3. Tổng chi phí phần cứng trọn bộ chỉ **~345.000 VNĐ** (tiết kiệm **64.8%**), đạt khả năng chịu lỗi đa kênh **3/3** và chi phí thay thế rủi ro khi hỏng chỉ **25.000 VNĐ**."

---

### Bước 3: Trang Workspace A/B (`pages/1_Interactive_Fault_Visualizer.py`) (01:45 – 03:15)
- **Hành động:** 
  1. Chuyển sang Trang 1. Nhấp nút `Tiếp theo ⏭️` chọn **Cửa sổ #108 (Spike)** hoặc **#122 (Drift)**.
  2. Chỉ vào đường đứt nét đỏ (Lỗi) và đường xanh dương (Đã bù).
  3. Chỉ vào **Thẻ Relay Bơm** và **Đồng hồ $C_t$**.
- **Lời thoại:** 
  > "Khi tiêm lỗi trôi dốc Drift hoặc xung gai Spike trên Kênh S1, thuật toán Autoencoder bóc tách sai số $MSE_1$ vượt ngưỡng $\tau = 0.0075$. Cơ chế **Selective Spatial Imputation** lập tức cô lập S1 và lấy trung vị của 2 kênh S2, S3 lành lặn bù vào, giúp khôi phục dạng sóng chính xác. Nếu cả 2 kênh cùng suy biến, Điểm tin cậy $C_t$ giảm dưới 0.50, hệ thống kích hoạt **Khóa ngắt Relay an toàn** chống ngập úng."

---

### Bước 4: Trang Đối chuẩn Khoa học (`pages/4_Benchmark_Comparison.py`) (03:15 – 04:15)
- **Hành động:** Chuyển sang Trang 4. Mở **Tab 1 (Ma trận T18)** rồi chuyển **Tab 2 (Ma trận T19)**.
- **Lời thoại:** 
  > "Trên ma trận đối chuẩn 48 kịch bản kiểm thử, phương pháp đề xuất vượt trội so với các bộ lọc cổ điển: F1 đạt **0.912** (so với 0.742 của 3-Sigma), tỷ lệ bỏ sót lỗi MDR giảm xuống **11.0%**. Đặc biệt ở Tab 2, mức suy giảm sai số MAE sau phục hồi đạt **80.9%**, vượt xa chỉ tiêu $\ge 40\%$ đề ra trong đề cương."

---

### Bước 5: Chẩn đoán Kỹ thuật & Kết luận (04:15 – 05:00)
- **Hành động:** Chuyển sang Trang 5 (`5_System_Diagnostic.py`), bấm nút **`🚀 Chạy Stress Test Ngay`**.
- **Lời thoại:** 
  > "Hệ thống đã trải qua stress-test liên tục trên 126 cửa sổ dữ liệu với tốc độ xử lý trung bình dưới **50 ms**, đảm bảo khả năng vận hành thời gian thực. Em xin chân thành cảm ơn Thầy/Cô và sẵn sàng nhận câu hỏi góp ý!"

---

## 🛠️ PHƯƠNG ÁN DỰ PHÒNG SỰ CỐ (TROUBLESHOOTING CHECKLIST)

| Sự cố phát sinh | Nguyên nhân | Thao tác xử lý nhanh trong 5 giây |
| :--- | :--- | :--- |
| **Trình duyệt báo không kết nối** | Streamlit chưa khởi động xong | Chạy lại lệnh `./scripts/run_dashboard.sh` trên Terminal |
| **Giao diện hiển thị chậm** | Bộ nhớ đệm cache bị đè | Nhấp nút **`🔄 Làm mới Cache`** ở thanh Sidebar bên trái |
| **Mất file CSV đối chuẩn** | File bị xóa tạm | Script `run_dashboard.sh` tự động sinh lại file ngay khi bật |
