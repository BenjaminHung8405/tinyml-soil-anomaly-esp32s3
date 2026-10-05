#include <Arduino.h>
#include "esp_timer.h"
#include "esp_heap_caps.h"
#include "model_runner.h"

namespace
{
    constexpr int BENCHMARK_ITERATIONS = 100;
}

void runBenchmark()
{
    Serial.println("\n[ESP32-S3] DANG THUC THI BENCHMARK...");

    ModelRunner &runner = ModelRunner::getInstance();
    if (!runner.init())
    {
        Serial.println("[!] Khoi tao ModelRunner that bai!");
        return;
    }

    size_t arena_used = runner.getArenaUsedBytes();
    size_t arena_total = runner.getArenaTotalBytes();

    TfLiteTensor *input = runner.getInputTensor();
    if (!input)
    {
        Serial.println("[!] Khong the lay input tensor!");
        return;
    }

    int8_t *in_data = input->data.int8;
    for (int i = 0; i < 32; ++i)
    {
        in_data[i] = (int8_t)(i * 4 - 64);
    }

    // Warm-up 5 chu kỳ
    for (int i = 0; i < 5; ++i)
    {
        runner.invoke();
    }

    // Đo độ trễ suy luận qua esp_timer_get_time()
    int64_t total_latency_us = 0;
    int64_t min_latency_us = 1000000;
    int64_t max_latency_us = 0;

    for (int i = 0; i < BENCHMARK_ITERATIONS; ++i)
    {
        int64_t t_start = esp_timer_get_time();
        TfLiteStatus status = runner.invoke();
        int64_t t_end = esp_timer_get_time();

        if (status != kTfLiteOk)
            return;

        int64_t lat = t_end - t_start;
        total_latency_us += lat;
        if (lat < min_latency_us)
            min_latency_us = lat;
        if (lat > max_latency_us)
            max_latency_us = lat;
        delay(1);
    }

    float avg_latency_us = (float)total_latency_us / BENCHMARK_ITERATIONS;
    float avg_latency_ms = avg_latency_us / 1000.0f;
    size_t min_free_heap = esp_get_minimum_free_heap_size();

    // Xuất khối dữ liệu CSV
    Serial.println("\n[CSV_EXPORT_BEGIN]");
    Serial.println("metric,value,unit,threshold,status");
    Serial.printf("inference_latency_mean,%.3f,ms,< 50.0,%s\n",
                  avg_latency_ms, (avg_latency_ms < 50.0f) ? "PASSED" : "FAILED");
    Serial.printf("inference_latency_max,%.3f,ms,< 50.0,%s\n",
                  max_latency_us / 1000.0f, (max_latency_us / 1000.0f < 50.0f) ? "PASSED" : "FAILED");
    Serial.printf("sram_arena_allocated,%.2f,KB,< 150.0,%s\n",
                  arena_total / 1024.0f, (arena_total / 1024.0f < 150.0f) ? "PASSED" : "FAILED");
    Serial.printf("sram_arena_used,%.2f,KB,-,INFO\n", arena_used / 1024.0f);
    Serial.printf("min_free_heap,%.2f,KB,-,INFO\n", min_free_heap / 1024.0f);
    Serial.println("[CSV_EXPORT_END]");
}

void setup()
{
    Serial.begin(115200);
    delay(1000);
    Serial.println("\n[ESP32-S3] SYSTEM READY. Gui ky tu 'B' de chay Benchmark.");
}

void loop()
{
    if (Serial.available() > 0)
    {
        char c = (char)Serial.read();
        if (c == 'B' || c == 'b' || c == '\n')
        {
            runBenchmark();
        }
    }
}