#include "edge_pipeline.h"
#include "model_runner.h"
#include <cmath>
#include <cstring>
#include <Arduino.h>

EdgePipeline &EdgePipeline::getInstance()
{
    static EdgePipeline instance;
    return instance;
}

void EdgePipeline::init(float detection_threshold_tau)
{
    tau_ = detection_threshold_tau;
    initialized_ = true;
}

bool EdgePipeline::checkPlausibility(const float *samples, bool *point_mask)
{
    bool has_violation = false;

    for (int i = 0; i < WINDOW_SIZE; ++i)
    {
        float val = samples[i];
        point_mask[i] = true; // Mặc định là hợp lệ

        // Kiểm tra NaN, Inf hoặc vượt ngưỡng biên vật lý [0.0, 1.0]
        if (std::isnan(val) || std::isinf(val) || val < VWC_MIN_PHYSICAL || val > VWC_MAX_PHYSICAL)
        {
            point_mask[i] = false;
            has_violation = true;
            continue;
        }

        // Kiểm tra biến động gradient đột biến (Spike) so với mẫu trước
        if (i > 0 && point_mask[i - 1])
        {
            if (std::abs(val - samples[i - 1]) > MAX_SPIKE_DIFF)
            {
                point_mask[i] = false;
                has_violation = true;
            }
        }
    }
    return has_violation;
}

void EdgePipeline::imputeMissingValues(float *samples, const bool *point_mask, const float *reconstructed)
{
    for (int i = 0; i < WINDOW_SIZE; ++i)
    {
        if (!point_mask[i])
        {
            // Thay thế mẫu hỏng bằng giá trị tái tạo từ Autoencoder
            // Nếu không có, dùng nội suy lân cận
            if (reconstructed != nullptr)
            {
                samples[i] = reconstructed[i];
            }
            else
            {
                float prev_val = (i > 0) ? samples[i - 1] : 0.5f;
                samples[i] = prev_val;
            }
        }
    }
}

EdgePipelineResult EdgePipeline::processWindow(uint16_t window_idx, const float *raw_samples)
{
    EdgePipelineResult res;
    res.window_index = window_idx;
    res.rule_violation = false;
    res.anomaly_detected = false;
    res.pump_lockout = false;
    res.reconstruction_mse = 0.0f;
    res.confidence_score = 1.0f;
    res.inference_latency_us = 0;

    // Sao chép mẫu thô vào mảng xử lý
    memcpy(res.clean_or_imputed, raw_samples, WINDOW_SIZE * sizeof(float));

    // ==========================================
    // TẦNG 1: KIỂM TRA BIÊN VẬT LÝ (RULE-BASED)
    // ==========================================
    bool point_valid_mask[WINDOW_SIZE];
    res.rule_violation = checkPlausibility(raw_samples, point_valid_mask);

    // ==========================================
    // TẦNG 2: CHUẨN BỊ VÀ SUY LUẬN TINYML INT8
    // ==========================================
    ModelRunner &runner = ModelRunner::getInstance();
    TfLiteTensor *input = runner.getInputTensor();
    TfLiteTensor *output = runner.getOutputTensor();

    float reconstructed[WINDOW_SIZE];
    for (int i = 0; i < WINDOW_SIZE; ++i)
    {
        reconstructed[i] = res.clean_or_imputed[i];
    }

    if (input != nullptr && output != nullptr)
    {
        float in_scale = input->params.scale;
        int32_t in_zero_point = input->params.zero_point;
        int8_t *in_data = input->data.int8;

        // Ánh xạ lượng tử hóa từ float32 sang int8
        for (int i = 0; i < WINDOW_SIZE; ++i)
        {
            float clamped_val = std::max(0.0f, std::min(1.0f, res.clean_or_imputed[i]));
            int32_t q = (int32_t)std::round(clamped_val / in_scale) + in_zero_point;
            if (q < -128)
                q = -128;
            if (q > 127)
                q = 127;
            in_data[i] = (int8_t)q;
        }

        // Đo đạc thời gian suy luận phần cứng
        uint32_t t_start = micros();
        TfLiteStatus status = runner.invoke();
        uint32_t t_end = micros();
        res.inference_latency_us = (t_end - t_start);

        if (status == kTfLiteOk)
        {
            float out_scale = output->params.scale;
            int32_t out_zero_point = output->params.zero_point;
            int8_t *out_data = output->data.int8;

            // Giải lượng tử hóa và tính sai số Reconstruction MSE
            float sum_sq_error = 0.0f;
            for (int i = 0; i < WINDOW_SIZE; ++i)
            {
                float rec_val = ((float)out_data[i] - (float)out_zero_point) * out_scale;
                reconstructed[i] = rec_val;

                float diff = res.clean_or_imputed[i] - rec_val;
                sum_sq_error += (diff * diff);
            }
            res.reconstruction_mse = sum_sq_error / (float)WINDOW_SIZE;
        }
        else
        {
            Serial.println("[!] Invoke failed!");
        }
    }
    else
    {
        Serial.println("[!] Input or Output tensor is NULL!");
    }

    // ==========================================
    // TẦNG 3: TÍNH ĐIỂM ĐỘ TIN CẬY C_t & NGƯỠNG TAU
    // ==========================================
    if (res.rule_violation)
    {
        // Nếu vi phạm biên vật lý, điểm tin cậy bị phạt trực tiếp
        res.confidence_score = 0.0f;
        res.anomaly_detected = true;
    }
    else
    {
        // Đánh giá dựa trên sai số MSE của Autoencoder
        if (res.reconstruction_mse > tau_)
        {
            res.anomaly_detected = true;
            res.confidence_score = std::max(0.0f, 1.0f - (res.reconstruction_mse / tau_));
        }
        else
        {
            res.confidence_score = std::min(1.0f, 1.0f - (res.reconstruction_mse / (2.0f * tau_)));
        }
    }

    // Bật cờ khóa an toàn bơm nếu phát hiện bất thường hoặc Ct < 0.5
    if (res.anomaly_detected || res.confidence_score < 0.5f)
    {
        res.pump_lockout = true;
    }

    // ==========================================
    // TẦNG 4: PHỤC HỒI DỮ LIỆU THÍCH ỨNG
    // ==========================================
    if (res.rule_violation)
    {
        imputeMissingValues(res.clean_or_imputed, point_valid_mask, reconstructed);
    }

    return res;
}