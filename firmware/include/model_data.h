#ifndef MODEL_DATA_H_
#define MODEL_DATA_H_

#include <cstdint>

// Độ dài của mảng nhị phân mô hình INT8
extern const unsigned int g_model_len;

// Con trỏ trỏ đến mảng byte mô hình được căn chỉnh bộ nhớ 16-byte trong Flash
extern const unsigned char g_model[];

#endif  // MODEL_DATA_H_
