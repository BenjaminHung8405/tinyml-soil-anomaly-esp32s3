import os
import json
import numpy as np
import tensorflow as tf

# 1. Định nghĩa đường dẫn
MODELS_DIR = "models"
os.makedirs(MODELS_DIR, exist_ok=True)

MODEL_FLOAT32_PATH = os.path.join(MODELS_DIR, "autoencoder_float32.keras")
MODEL_INT8_PATH = os.path.join(MODELS_DIR, "model_int8.tflite")
REP_DATA_PATH = os.path.join("data", "processed", "representative_dataset.npy")
METADATA_PATH = os.path.join(MODELS_DIR, "quantization_metadata.json")

print(f"[*] Bước 1: Nạp mô hình Float32 gốc từ: {MODEL_FLOAT32_PATH}")
model_float32 = tf.keras.models.load_model(MODEL_FLOAT32_PATH)

# 2. Xây dựng Representative Dataset Generator function (từ Task T09)
print(f"[*] Bước 2: Nạp tập dữ liệu đại diện từ: {REP_DATA_PATH}")
rep_data = np.load(REP_DATA_PATH)  # Shape: (300, 32, 1)

def representative_data_gen():
    """
    Generator cung cấp từng mẫu dữ liệu đại diện chuẩn float32 cho TFLite Converter
    để tính toán Scale factor (S) và Zero-point (Z).
    """
    for i in range(len(rep_data)):
        sample = np.expand_dims(rep_data[i], axis=0).astype(np.float32)
        yield [sample]

# 3. Cấu hình TFLite Converter cho Full INT8 PTQ
print(f"[*] Bước 3: Cấu hình TensorFlow Lite Converter (Full INT8 PTQ)...")
converter = tf.lite.TFLiteConverter.from_keras_model(model_float32)

converter.optimizations = [tf.lite.Optimize.DEFAULT]
converter.representative_dataset = representative_data_gen

# Ép buộc toàn bộ op, input và output chuyển sang INT8 hoàn toàn
converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS_INT8]
converter.inference_input_type = tf.int8
converter.inference_output_type = tf.int8

# 4. Thực hiện chuyển đổi
print(f"[*] Bước 4: Đang tiến hành lượng tử hóa mô hình sang INT8...")
tflite_model_int8 = converter.convert()

# 5. Lưu tệp mô hình nhị phân nén .tflite
with open(MODEL_INT8_PATH, "wb") as f:
    f.write(tflite_model_int8)

# 6. Đo đạc đối chuẩn kích thước file
float32_size_bytes = os.path.getsize(MODEL_FLOAT32_PATH)
int8_size_bytes = os.path.getsize(MODEL_INT8_PATH)

int8_size_kb = int8_size_bytes / 1024.0
float32_size_kb = float32_size_bytes / 1024.0
reduction_pct = (1.0 - (int8_size_bytes / float32_size_bytes)) * 100.0

print("\n" + "="*65)
print(f"[+] Kích thước mô hình Float32 gốc : {float32_size_kb:.2f} KB")
print(f"[+] Kích thước mô hình INT8 .tflite : {int8_size_kb:.2f} KB")
print(f"[+] Tỷ lệ nén giảm dung lượng       : {reduction_pct:.2f}%")

# Kiểm tra tiêu chí nghiệm thu Task T10 (< 10 KB)
MAX_ALLOWED_KB = 10.0
if int8_size_kb < MAX_ALLOWED_KB:
    print(f"[SUCCESS] Kích thước tflite ({int8_size_kb:.2f} KB) < {MAX_ALLOWED_KB} KB -> ĐẠT TIÊU CHÍ NGHIỆM THU!")
else:
    print(f"[!] Cảnh báo: Kích thước vượt ngưỡng {MAX_ALLOWED_KB} KB.")
print("="*65)

# 7. Lưu metadata lượng tử hóa
quant_meta = {
    "model_name": "Dense_Autoencoder_INT8",
    "target_hardware": "ESP32-S3",
    "float32_size_bytes": int(float32_size_bytes),
    "int8_size_bytes": int(int8_size_bytes),
    "int8_size_kb": float(int8_size_kb),
    "size_reduction_percentage": float(reduction_pct),
    "quantization_type": "Full Integer Quantization (PTQ INT8)",
    "input_type": "int8",
    "output_type": "int8"
}

with open(METADATA_PATH, "w") as f:
    json.dump(quant_meta, f, indent=4)

print(f"[+] Đã lưu tệp mô hình INT8 tại : {MODEL_INT8_PATH}")
print(f"[+] Đã lưu metadata lượng tử hóa tại: {METADATA_PATH}")