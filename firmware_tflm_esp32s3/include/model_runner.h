#ifndef MODEL_RUNNER_H_
#define MODEL_RUNNER_H_

#include <cstdint>
#include <cstddef>
#include "tensorflow/lite/c/common.h"

// Giới hạn kích thước Tensor Arena: 120 KB (đáp ứng tiêu chuẩn < 136 KB)
constexpr size_t kTensorArenaSize = 120 * 1024;

class ModelRunner
{
public:
    static ModelRunner &getInstance();

    // Khởi tạo TFLM runtime, OpResolver và cấp phát Tensor Arena
    bool init();

    // Lấy thông tin tài nguyên sử dụng
    size_t getArenaUsedBytes() const;
    size_t getArenaTotalBytes() const { return kTensorArenaSize; }

    // Con trỏ truy xuất Tensor
    TfLiteTensor *getInputTensor();
    TfLiteTensor *getOutputTensor();

    // Thực thi suy luận 1 chu kỳ
    TfLiteStatus invoke();

private:
    ModelRunner() = default;
    ~ModelRunner() = default;
    ModelRunner(const ModelRunner &) = delete;
    ModelRunner &operator=(const ModelRunner &) = delete;

    bool initialized_ = false;
};

#endif // MODEL_RUNNER_H_