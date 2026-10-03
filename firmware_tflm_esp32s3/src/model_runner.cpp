#include "model_runner.h"
#include "model_data.h"

#include <Arduino.h>
#include "tensorflow/lite/micro/all_ops_resolver.h"
#include "tensorflow/lite/micro/micro_error_reporter.h"
#include "tensorflow/lite/micro/micro_interpreter.h"
#include "tensorflow/lite/schema/schema_generated.h"

namespace
{
    tflite::ErrorReporter *error_reporter = nullptr;
    tflite::MicroErrorReporter micro_error_reporter;
    const tflite::Model *model = nullptr;
    tflite::MicroInterpreter *interpreter = nullptr;
    tflite::AllOpsResolver resolver;

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
    model = tflite::GetModel(g_model);

    if (model->version() != TFLITE_SCHEMA_VERSION)
    {
        Serial.printf("[!] Model schema version khong khop!\n");
        return false;
    }

    static tflite::MicroInterpreter static_interpreter(
        model, resolver, tensor_arena, kTensorArenaSize, error_reporter);
    interpreter = &static_interpreter;

    TfLiteStatus allocate_status = interpreter->AllocateTensors();
    if (allocate_status != kTfLiteOk)
    {
        Serial.printf("[!] AllocateTensors that bai! Code: %d\n", allocate_status);
        return false;
    }

    initialized_ = true;
    Serial.printf("[+] ModelRunner khoi tao thanh cong! Arena used: %zu bytes\n",
                  interpreter->arena_used_bytes());
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