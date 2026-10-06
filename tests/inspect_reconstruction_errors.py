import os
import json
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

CODE_TO_NAME = {0: "Clean", 1: "Spike", 2: "Noise", 3: "Stuck", 4: "Drift"}

fault_indices = np.where(labels > 0)[0]
print(f"[*] Phân tích sai số tái tạo của 18 cửa sổ lỗi:")
print(f"{'Index':<7} | {'Type':<8} | {'Window MSE':<12} | {'Max Point SqErr':<16} | {'Max Gradient':<12}")
print("-" * 65)

for idx in fault_indices:
    w = X_test[idx].flatten()
    diffs = np.abs(np.diff(w))
    max_grad = np.max(diffs) if len(diffs) > 0 else 0.0

    sample_int8 = np.round(w / in_scale + in_zero).astype(np.int8).reshape(in_det['shape'])
    interpreter.set_tensor(in_det['index'], sample_int8)
    interpreter.invoke()
    out_int8 = interpreter.get_tensor(out_det['index'])
    rec = ((out_int8.astype(np.float32) - out_zero) * out_scale).flatten()

    pt_sq = (w - rec) ** 2
    win_mse = np.mean(pt_sq)
    max_pt = np.max(pt_sq)

    print(f"#{idx:03d}   | {CODE_TO_NAME[labels[idx]]:<8} | {win_mse:.6f}     | {max_pt:.6f}         | {max_grad:.6f}")

# Đo dải sai số của 108 cửa sổ Clean để tìm trần an toàn
clean_indices = np.where(labels == 0)[0]
clean_mses = []
clean_max_pts = []
for idx in clean_indices:
    w = X_test[idx].flatten()
    sample_int8 = np.round(w / in_scale + in_zero).astype(np.int8).reshape(in_det['shape'])
    interpreter.set_tensor(in_det['index'], sample_int8)
    interpreter.invoke()
    out_int8 = interpreter.get_tensor(out_det['index'])
    rec = ((out_int8.astype(np.float32) - out_zero) * out_scale).flatten()
    pt_sq = (w - rec) ** 2
    clean_mses.append(np.mean(pt_sq))
    clean_max_pts.append(np.max(pt_sq))

print("-" * 65)
print(f"[*] Trần sai số của 108 cửa sổ Clean:")
print(f"    Clean Mean MSE: {np.mean(clean_mses):.6f} | Clean Max MSE: {np.max(clean_mses):.6f} | Clean 95th MSE: {np.percentile(clean_mses, 95):.6f}")
print(f"    Clean Mean Peak: {np.mean(clean_max_pts):.6f} | Clean Max Peak: {np.max(clean_max_pts):.6f} | Clean 95th Peak: {np.percentile(clean_max_pts, 95):.6f}")