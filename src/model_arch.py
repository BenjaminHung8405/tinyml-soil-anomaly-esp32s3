import os
import json
import tensorflow as tf
from tensorflow.keras import layers, models

def build_dense_autoencoder(input_dim=32, latent_dim=4):
    """
    Xây dựng kiến trúc Dense Autoencoder siêu nhẹ cho TinyML trên ESP32-S3.
    Cấu trúc: Input(32) -> Dense(16, ReLU) -> Dense(8, ReLU) -> Latent(4)
              -> Dense(8, ReLU) -> Dense(16, ReLU) -> Output(32, Linear).
    """
    inputs = layers.Input(shape=(input_dim, 1), name="input_layer")
    x = layers.Flatten(name="flatten")(inputs)
    
    # --- ENCODER ---
    x = layers.Dense(16, activation="relu", name="enc_dense_1")(x)
    x = layers.Dense(8, activation="relu", name="enc_dense_2")(x)
    latent = layers.Dense(latent_dim, activation="linear", name="latent_space")(x)
    
    # --- DECODER ---
    x = layers.Dense(8, activation="relu", name="dec_dense_1")(latent)
    x = layers.Dense(16, activation="relu", name="dec_dense_2")(x)
    outputs = layers.Dense(input_dim, activation="linear", name="reconstruction")(x)
    outputs = layers.Reshape((input_dim, 1), name="output_layer")(outputs)
    
    autoencoder = models.Model(inputs=inputs, outputs=outputs, name="TinyML_Soil_Autoencoder")
    return autoencoder

if __name__ == "__main__":
    print("[*] Khởi tạo kiến trúc Dense Autoencoder siêu nhẹ...")
    model = build_dense_autoencoder(input_dim=32, latent_dim=4)
    
    # In bảng cấu trúc chi tiết
    model.summary()
    
    total_params = model.count_params()
    print(f"\n[+] Tổng số tham số học (Trainable Parameters): {total_params}")
    
    # Kiểm tra ràng buộc kỹ thuật của Task T05
    MAX_ALLOWED_PARAMS = 1500
    if total_params < MAX_ALLOWED_PARAMS:
        print(f"[SUCCESS] Số lượng tham số ({total_params}) thỏa mãn tiêu chí (< {MAX_ALLOWED_PARAMS}).")
    else:
        print(f"[!] Cảnh báo: Số lượng tham số vượt ngưỡng {MAX_ALLOWED_PARAMS}!")
        
    # Lưu metadata kiến trúc mô hình ra thư mục models/
    os.makedirs("models", exist_ok=True)
    meta_path = os.path.join("models", "model_architecture_summary.json")
    
    layer_info = []
    for layer in model.layers:
        out_shape = getattr(layer, "output_shape", getattr(layer, "shape", None))
        layer_info.append({
            "name": layer.name,
            "type": layer.__class__.__name__,
            "output_shape": str(out_shape)
        })

    arch_info = {
        "model_name": model.name,
        "input_shape": [32, 1],
        "output_shape": [32, 1],
        "latent_dimension": 4,
        "total_parameters": int(total_params),
        "target_mcu": "ESP32-S3",
        "estimated_weight_size_float32_bytes": int(total_params * 4),
        "estimated_weight_size_int8_bytes": int(total_params * 1),
        "layers": layer_info
    }
    
    with open(meta_path, "w") as f:
        json.dump(arch_info, f, indent=4)
        
    print(f"[+] Đã lưu thông tin cấu trúc kiến trúc tại: {meta_path}")