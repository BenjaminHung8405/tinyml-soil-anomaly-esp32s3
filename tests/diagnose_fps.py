import os
import numpy as np
import tensorflow as tf

DATA_DIR = os.path.join("data", "processed")
X_test = np.load(os.path.join(DATA_DIR, "test_fault_injected.npy"))
labels = np.load(os.path.join(DATA_DIR, "test_fault_labels.npy")).astype(int)
MODEL_PATH = os.path.join("models", "model_int8.tflite")

interpreter = tf.lite.Interpreter(model_path=MODEL_PATH)
interpreter.allocate_tensors()
in_det = interpreter.get_input_details()[0]
out_det = interpreter.get_output_details()[0]
in_scale, in_zero = in_det['quantization']
out_scale, out_zero = out_det['quantization']

clean_indices = np.where(labels == 0)[0]
print(f"[*] Kiểm tra 108 cửa sổ Clean để truy vết 9 False Positives:")

fps_phys = []
fps_3sig = []
fps_slope = []
fps_mse = []

for idx in clean_indices:
    w = X_test[idx].flatten()
    mean_val = np.mean(w)
    std_val = np.std(w)
    delta_slope = w[-1] - w[0]

    # Kiểm tra từng cờ
    c_phys = np.any(np.isnan(w)) or np.any(w < 0.0) or np.any(w > 1.0)
    c_3sig = std_val > 1e-4 and np.any(np.abs(w - mean_val) > 2.5 * std_val)
    c_slope = abs(delta_slope) > 0.10

    sample_int8 = np.round(w / in_scale + in_zero).astype(np.int8).reshape(in_det['shape'])
    interpreter.set_tensor(in_det['index'], sample_int8)
    interpreter.invoke()
    out_int8 = interpreter.get_tensor(out_det['index'])
    rec = ((out_int8.astype(np.float32) - out_zero) * out_scale).flatten()
    win_mse = np.mean((w - rec) ** 2)
    c_mse = win_mse > 0.025

    if c_phys: fps_phys.append(idx)
    if c_3sig: fps_3sig.append(idx)
    if c_slope: fps_slope.append(idx)
    if c_mse: fps_mse.append(idx)

print(f"    - Lỗi do c_phys   (NaN / <0 / >1) : {len(fps_phys)} mẫu")
print(f"    - Lỗi do c_3sig   (2.5 * std)     : {len(fps_3sig)} mẫu")
print(f"    - Lỗi do c_slope  (delta > 0.10)  : {len(fps_slope)} mẫu (Indices: {fps_slope})")
print(f"    - Lỗi do c_mse    (win_mse > 0.025): {len(fps_mse)} mẫu (Indices: {fps_mse})")