import os
import subprocess

# 1. Định nghĩa đường dẫn file
MODELS_DIR = "models"
SRC_EMBEDDED_DIR = os.path.join("firmware", "include") # hoặc src/ nếu chưa tạo thư mục firmware
os.makedirs(SRC_EMBEDDED_DIR, exist_ok=True)

TFLITE_MODEL_PATH = os.path.join(MODELS_DIR, "model_int8.tflite")
CC_OUT_PATH = os.path.join(SRC_EMBEDDED_DIR, "model_data.cc")
H_OUT_PATH = os.path.join(SRC_EMBEDDED_DIR, "model_data.h")

print(f"[*] Bước 1: Kiểm tra tệp mô hình nhị phân: {TFLITE_MODEL_PATH}")
if not os.path.exists(TFLITE_MODEL_PATH):
    raise FileNotFoundError(f"Không tìm thấy file {TFLITE_MODEL_PATH}! Hãy kiểm tra lại Task T10.")

# 2. Đọc dữ liệu nhị phân từ file .tflite
with open(TFLITE_MODEL_PATH, "rb") as f:
    model_bytes = f.read()

model_len = len(model_bytes)
print(f"    -> Đã nạp {model_len} bytes từ mô hình nhị phân.")

# 3. Tạo file header: model_data.h
print(f"[*] Bước 2: Tạo tệp header {H_OUT_PATH}...")
header_content = f"""#ifndef MODEL_DATA_H_
#define MODEL_DATA_H_

#include <cstdint>

// Độ dài của mảng nhị phân mô hình INT8
extern const unsigned int g_model_len;

// Con trỏ trỏ đến mảng byte mô hình được căn chỉnh bộ nhớ 16-byte trong Flash
extern const unsigned char g_model[];

#endif  // MODEL_DATA_H_
"""

with open(H_OUT_PATH, "w", encoding="utf-8") as f:
    f.write(header_content)
print(f"[+] Đã tạo thành công: {H_OUT_PATH}")

# 4. Định dạng và ghi file source: model_data.cc
print(f"[*] Bước 3: Tạo tệp mã nguồn {CC_OUT_PATH}...")
hex_lines = []
for i in range(0, model_len, 12):
    chunk = model_bytes[i:i+12]
    hex_line = ", ".join(f"0x{b:02x}" for b in chunk)
    hex_lines.append(f"  {hex_line}")

hex_array_body = ",\n".join(hex_lines)

source_content = f"""#include "model_data.h"

// Kích thước tệp mô hình nhị phân
const unsigned int g_model_len = {model_len};

// Mảng byte nhị phân được đặt vào bộ nhớ Flash và căn chỉnh 16-byte cho ESP32-S3
alignas(16) const unsigned char g_model[] = {{
{hex_array_body}
}};
"""

with open(CC_OUT_PATH, "w", encoding="utf-8") as f:
    f.write(source_content)
print(f"[+] Đã tạo thành công: {CC_OUT_PATH}")

# 5. Đối chuẩn kích thước file xuất ra
cc_size_kb = os.path.getsize(CC_OUT_PATH) / 1024.0
print("\n" + "="*60)
print(f"[+] Kích thước mảng dữ liệu (bytes) : {model_len} bytes")
print(f"[+] Kích thước tệp mã nguồn C++    : {cc_size_kb:.2f} KB")
print(f"[+] Tên biến mảng byte             : g_model[]")
print(f"[+] Tên biến độ dài mảng           : g_model_len")
print("[SUCCESS] Xuất mảng byte C++ hoàn tất! Sẵn sàng biên dịch.")
print("="*60)