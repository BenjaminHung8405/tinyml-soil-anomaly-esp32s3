# Edge AI TinyML Anomaly Detection & Data Imputation on ESP32-S3

Hệ thống phát hiện bất thường, đánh giá độ tin cậy và phục hồi dữ liệu cảm biến độ ẩm đất thời gian thực bằng TinyML (Autoencoder INT8 PTQ) trực tiếp tại biên trên vi điều khiển **ESP32-S3-WROOM-1-N16R8**.

---

## 📌 Giới thiệu đề tài

- **Tên đề tài:** Nghiên cứu và triển khai hệ thống phát hiện bất thường, đánh giá độ tin cậy và phục hồi dữ liệu cảm biến độ ẩm đất bằng TinyML tại biên trên ESP32-S3.
- **Lĩnh vực:** Công nghệ thông tin / Kỹ thuật phần mềm nhúng (Embedded AI / TinyML).
- **Mục tiêu:**
  1. Phát hiện 04 dạng lỗi kỹ thuật mềm phổ biến của cảm biến (*Spike, Noise/Missing, Stuck-at, Drift*).
  2. Phân định chính xác biến động tự nhiên (tưới nước, mưa, bốc thoát hơi) với lỗi phần cứng thông qua mô hình lai (Hybrid Rule–TinyML).
  3. Định lượng chỉ số tin cậy dữ liệu $C_t \in [0, 1]$ từ sai số tái tạo ($MSE$).
  4. Tự động phục hồi chuỗi dữ liệu suy biến hoặc kích hoạt cờ ngắt an toàn (*Safety Invalid Flag*) phục vụ tưới tiêu vòng kín.
  5. Vận hành độc lập 100% tại biên (Edge-native, offline-first), tối ưu hóa bộ nhớ SRAM nội bộ (< 150 KB) và thời gian suy luận (< 50 ms/chu kỳ).

---

## 🏗️ Kiến trúc Pipeline lai (Hybrid Pipeline)

```text
[ Cảm biến ADC ] 
       │
       ▼
[ Ring Buffer đa tầng (W_S: 15m, W_M: 32 mẫu, W_L: 24h) ]
       │
       ├──► Tầng 1: Quy tắc vật lý (Biophysical Rules) & Bộ lọc Hampel (Chặn Spike)
       │
       └──► Tầng 2: TinyML Autoencoder INT8 (Suy luận hình thái chuỗi thời gian)
                   │
                   ▼
       [ Tính chỉ số độ tin cậy C_t ∈ [0, 1] ]
                   │
       ┌───────────┼───────────┐
       ▼           ▼           ▼
   Valid      Suspicious     Faulty
 (C_t ≥ 0.8) (0.3 ≤ C_t < 0.8) (C_t < 0.3)
   Giữ x_t    Nội suy / Tái tạo  Bật cờ ngắt an toàn (Invalid Flag)