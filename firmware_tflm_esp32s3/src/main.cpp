#include <Arduino.h>
#include "model_data.h"

// TFLM Core Headers
#include "tensorflow/lite/micro/all_ops_resolver.h"
#include "tensorflow/lite/micro/micro_error_reporter.h"
#include "tensorflow/lite/micro/micro_interpreter.h"
#include "tensorflow/lite/schema/schema_generated.h"
// Đã loại bỏ dòng #include "tensorflow/lite/version.h"

namespace
{
    // 1. Đối tượng báo lỗi TFLM
    tflite::ErrorReporter *error_reporter = nullptr;
    tflite::MicroErrorReporter micro_error_reporter;

    // 2. Con trỏ mô hình và trình thông dịch
    const tflite::Model *model = nullptr;
    tflite::MicroInterpreter *interpreter = nullptr;

    // 3. Khai báo các toán tử mạng cần thiết (AllOpsResolver)
    tflite::AllOpsResolver resolver;

    // 4. Cấp phát vùng nhớ Tensor Arena tĩnh trong SRAM (120 KB)
    constexpr int kTensorArenaSize = 120 * 1024;
    alignas(16) uint8_t tensor_arena[kTensorArenaSize];

    // Con trỏ Tensor vào / ra
    TfLiteTensor *input_tensor = nullptr;
    TfLiteTensor *output_tensor = nullptr;
}

void setup()
{
    Serial.begin(115200);
    delay(2000); // Chờ USB Serial CDC sẵn sàng

    Serial.println("\n==================================================");
    Serial.println("[ESP32-S3] KHOI TAO RUNTIME TFLM - TASK T13");
    Serial.println("==================================================");

    error_reporter = &micro_error_reporter;

    // 1. Nạp mô hình nhị phân từ Flash ROM
    Serial.printf("[*] Nhan dang mang model nhan vao: %u bytes\n", g_model_len);
    model = tflite::GetModel(g_model);
    if (model->version() != TFLITE_SCHEMA_VERSION)
    {
        Serial.printf("[!] Loi: Model schema version (%ld) khong khop TFLM schema (%d)!\n",
                      model->version(), TFLITE_SCHEMA_VERSION);
        return;
    }
    Serial.println("[+] Model Schema hop le!");

    // 2. Khoi tao MicroInterpreter
    static tflite::MicroInterpreter static_interpreter(
        model, resolver, tensor_arena, kTensorArenaSize, error_reporter);
    interpreter = &static_interpreter;

    // 3. Cap phat Tensor Arena
    TfLiteStatus allocate_status = interpreter->AllocateTensors();
    if (allocate_status != kTfLiteOk)
    {
        Serial.println("[!] Loi: Khong the AllocateTensors tren Tensor Arena!");
        return;
    }
    Serial.println("[+] AllocateTensors thanh cong!");

    // 4. Kiem tra kich thuoc Tensor vao/ra
    input_tensor = interpreter->input(0);
    output_tensor = interpreter->output(0);

    Serial.println("\n[*] Thong so Tensor Dau vao (Input):");
    Serial.printf("    - Dtype: %d (8 = INT8)\n", input_tensor->type);
    Serial.printf("    - Dimensions: [%d, %d, %d]\n",
                  input_tensor->dims->data[0],
                  input_tensor->dims->data[1],
                  input_tensor->dims->data[2]);
    Serial.printf("    - Scale: %f, Zero-point: %d\n",
                  input_tensor->params.scale,
                  input_tensor->params.zero_point);

    Serial.println("\n[*] Thong so Tensor Dau ra (Output):");
    Serial.printf("    - Dtype: %d (8 = INT8)\n", output_tensor->type);
    Serial.printf("    - Dimensions: [%d, %d, %d]\n",
                  output_tensor->dims->data[0],
                  output_tensor->dims->data[1],
                  output_tensor->dims->data[2]);
    Serial.printf("    - Scale: %f, Zero-point: %d\n",
                  output_tensor->params.scale,
                  output_tensor->params.zero_point);

    Serial.printf("\n[+] Dung luong Tensor Arena da dung: %zu bytes / %d bytes\n",
                  interpreter->arena_used_bytes(), kTensorArenaSize);
    Serial.println("==================================================");
    Serial.println("[SUCCESS] Khoi tao Skeleton Firmware TFLM Hoan Tat!");
    Serial.println("==================================================");
}

void loop()
{
    delay(5000);
}