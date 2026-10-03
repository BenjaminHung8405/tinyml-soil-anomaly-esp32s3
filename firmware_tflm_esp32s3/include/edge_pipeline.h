#ifndef EDGE_PIPELINE_H_
#define EDGE_PIPELINE_H_

#include <cstdint>
#include <cstddef>
#include <stdbool.h>

#define WINDOW_SIZE 32
#define VWC_MIN_PHYSICAL 0.0f
#define VWC_MAX_PHYSICAL 1.0f
#define MAX_SPIKE_DIFF 0.35f // Biến động tối đa cho phép giữa 2 mẫu liên tiếp

// Cấu trúc lưu trữ kết quả phân tích tại biên
struct EdgePipelineResult
{
    uint16_t window_index;
    bool rule_violation;                 // Lỗi biên vật lý
    bool anomaly_detected;               // Cờ phát hiện bất thường tổng hợp
    bool pump_lockout;                   // Cờ khóa rơ-le bơm an toàn
    float reconstruction_mse;            // Sai số MSE từ Autoencoder
    float confidence_score;              // Điểm tin cậy C_t [0.0, 1.0]
    uint32_t inference_latency_us;       // Thời gian suy luận (micro giây)
    float clean_or_imputed[WINDOW_SIZE]; // Dữ liệu sau khi làm sạch / phục hồi
};

class EdgePipeline
{
public:
    static EdgePipeline &getInstance();

    // Khởi tạo pipeline và nạp ngưỡng tau từ Task T08
    void init(float detection_threshold_tau);

    // Xử lý toàn bộ chu trình khép kín cho 1 cửa sổ 32 mẫu
    EdgePipelineResult processWindow(uint16_t window_idx, const float *raw_samples);

private:
    EdgePipeline() = default;
    float tau_ = 0.005f; // Ngưỡng mặc định nếu chưa cấu hình
    bool initialized_ = false;

    // Các hàm phụ trợ
    bool checkPlausibility(const float *samples, bool *point_mask);
    void imputeMissingValues(float *samples, const bool *point_mask, const float *reconstructed);
};

#endif // EDGE_PIPELINE_H_