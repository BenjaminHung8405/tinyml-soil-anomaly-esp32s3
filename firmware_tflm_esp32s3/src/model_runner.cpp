#include "model_runner.h"
#include "model_data.h"

#include <Arduino.h>
#include "tensorflow/lite/micro/micro_mutable_op_resolver.h"
#include "tensorflow/lite/micro/micro_error_reporter.h"
#include "tensorflow/lite/micro/micro_interpreter.h"
#include "tensorflow/lite/schema/schema_generated.h"

namespace
{
    // 1. Đối tượng báo lỗi TFLM
    tflite::ErrorReporter *error_reporter = nullptr;
    tflite::MicroErrorReporter micro_error_reporter;

    // 2. Con trỏ mô hình và Interpreter
    const tflite::Model *model = nullptr;
    tflite::MicroInterpreter *interpreter = nullptr;

    // 3. Khai báo chỉ đúng 5 toán tử mà mô hình Dense Autoencoder INT8 cần dùng
    tflite::MicroMutableOpResolver<5> micro_op_resolver;

    // 4. Cấp phát tĩnh Tensor Arena trong SRAM nội bộ (căn chỉnh 16-byte cho Xtensa LX7)
    alignas(16) static uint8_t tensor_arena[kTensorArenaSize];
}

ModelRunner &ModelRunner::getInstance()
{
    static ModelRunner instance;
    return instance;
}

bool ModelRunner::init()
{
    if (initialized_)
    {
        return true;
    }

    error_reporter = &micro_error_reporter;

    // Nạp mô hình từ mảng byte trong Flash ROM
    model = tflite::GetModel(g_model);
    if (model->version() != TFLITE_SCHEMA_VERSION)
    {
        Serial.printf("[!] Model schema version (%ld) khong khop TFLM schema (%d)!\n",
                      model->version(), TFLITE_SCHEMA_VERSION);
        return false;
    }

    // Đăng ký tối thiểu các toán tử cần thiết cho Autoencoder
    micro_op_resolver.AddFullyConnected();
    micro_op_resolver.AddRelu();
    micro_op_resolver.AddReshape();
    micro_op_resolver.AddQuantize();
    micro_op_resolver.AddDequantize();

    // Khởi tạo MicroInterpreter với mảng tĩnh tensor_arena
    static tflite::MicroInterpreter static_interpreter(
        model, micro_op_resolver, tensor_arena, kTensorArenaSize, error_reporter);
    interpreter = &static_interpreter;

    // Cấp phát bộ nhớ cho các tensor kích hoạt trung gian
    TfLiteStatus allocate_status = interpreter->AllocateTensors();
    if (allocate_status != kTfLiteOk)
    {
        Serial.println("[!] Loi: Khong the AllocateTensors tren Tensor Arena!");
        return false;
    }

    initialized_ = true;
    return true;
}

size_t ModelRunner::getArenaUsedBytes() const
{
    if (!initialized_ || !interpreter)
        return 0;
    return interpreter->arena_used_bytes();
}

TfLiteTensor *ModelRunner::getInputTensor()
{
    if (!initialized_ || !interpreter)
        return nullptr;
    return interpreter->input(0);
}

TfLiteTensor *ModelRunner::getOutputTensor()
{
    if (!initialized_ || !interpreter)
        return nullptr;
    return interpreter->output(0);
}

TfLiteStatus ModelRunner::invoke()
{
    if (!initialized_ || !interpreter)
        return kTfLiteError;
    return interpreter->Invoke();
}