#include <Arduino.h>
#include "model_runner.h"

void setup()
{
    Serial.begin(115200);
    delay(2000); // Chờ USB Serial CDC sẵn sàng

    Serial.println("\n==================================================");
    Serial.println("[ESP32-S3] KIEM DINH TENSOR ARENA & SRAM - TASK T14");
    Serial.println("==================================================");

    ModelRunner &runner = ModelRunner::getInstance();

    if (!runner.init())
    {
        Serial.println("[FAILED] Khong the khoi tao ModelRunner!");
        return;
    }

    Serial.println("[+] ModelRunner khoi tao thanh cong voi MicroMutableOpResolver!");

    // Đo đạc mức chiếm dụng SRAM
    size_t arena_used = runner.getArenaUsedBytes();
    size_t arena_total = runner.getArenaTotalBytes();
    float used_kb = arena_used / 1024.0f;
    float total_kb = arena_total / 1024.0f;

    Serial.printf("[*] Tensor Arena Tong Cong : %zu bytes (%.2f KB)\n", arena_total, total_kb);
    Serial.printf("[*] Tensor Arena Da Chiem   : %zu bytes (%.2f KB)\n", arena_used, used_kb);
    Serial.printf("[*] Ty Le Su Dung Arena     : %.2f%%\n", (float)arena_used / arena_total * 100.0f);

    // Kiểm tra thông số Tensor
    TfLiteTensor *input = runner.getInputTensor();
    TfLiteTensor *output = runner.getOutputTensor();

    if (input && output)
    {
        Serial.println("\n[*] Thong tin Tensor:");
        Serial.printf("    - Input  Shape: [%d, %d, %d], Type: %d (INT8)\n",
                      input->dims->data[0], input->dims->data[1], input->dims->data[2], input->type);
        Serial.printf("    - Output Shape: [%d, %d, %d], Type: %d (INT8)\n",
                      output->dims->data[0], output->dims->data[1], output->dims->data[2], output->type);
    }

    // Đánh giá tiêu chuẩn nghiệm thu (< 136 KB)
    Serial.println("\n==================================================");
    if (arena_total <= 136 * 1024)
    {
        Serial.printf("[SUCCESS] Tensor Arena (%.2f KB) < 136.0 KB -> DAT NGHIEP THU T14!\n", total_kb);
    }
    else
    {
        Serial.println("[!] Canh bao: Kich thuoc Tensor Arena vuot qua 136 KB!");
    }
    Serial.println("==================================================");
}

void loop()
{
    delay(5000);
}