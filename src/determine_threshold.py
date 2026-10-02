import os
import json
import numpy as np
import matplotlib.pyplot as plt
import tensorflow as tf
from tensorflow.keras.models import load_model

# 1. Định nghĩa đường dẫn file
DATA_DIR = os.path.join("data", "processed")
MODELS_DIR = "models"
REPORTS_DIR = "reports"
os.makedirs(MODELS_DIR, exist_ok=True)
os.makedirs(REPORTS_DIR, exist_ok=True)

VAL_DATA_PATH = os.path.join(DATA_DIR, "val.npy")
MODEL_PATH = os.path.join(MODELS_DIR, "autoencoder_float32.keras")
CONFIG_OUT_PATH = os.path.join(MODELS_DIR, "threshold_config.json")
IMG_THRESHOLD_PATH = os.path.join(REPORTS_DIR, "threshold_and_confidence.png")

# 2. Nạp mô hình và tập dữ liệu Validation
print(f"[*] Bước 1: Nạp mô hình từ '{MODEL_PATH}'...")
model = load_model(MODEL_PATH)

print(f"[*] Bước 2: Nạp tập dữ liệu Validation từ '{VAL_DATA_PATH}'...")
X_val = np.load(VAL_DATA_PATH)  # Shape: (N_val, 32, 1)
n_val = len(X_val)
print(f"    -> Đã nạp {n_val} cửa sổ validation sạch.")

# 3. Tính toán sai số tái tạo trên tập Validation sạch
print(f"[*] Bước 3: Thực hiện suy luận tái tạo trên tập Validation...")
X_val_rec = model.predict(X_val, verbose=0)

# Tính MSE cho từng cửa sổ trượt (trục thời gian 32 điểm)
val_mse_per_window = np.mean(np.square(X_val - X_val_rec), axis=(1, 2))

mu_val = float(np.mean(val_mse_per_window))
sigma_val = float(np.std(val_mse_per_window))
min_val_mse = float(np.min(val_mse_per_window))
max_val_mse = float(np.max(val_mse_per_window))

print(f"    -> Mean MSE (mu_val)     : {mu_val:.6f}")
print(f"    -> Std MSE  (sigma_val)  : {sigma_val:.6f}")
print(f"    -> Min MSE               : {min_val_mse:.6f}")
print(f"    -> Max MSE               : {max_val_mse:.6f}")

# 4. Xác định ngưỡng cắt bất thường tau theo quy tắc 3-Sigma
K_SIGMA = 3.0
tau = float(mu_val + K_SIGMA * sigma_val)
theta_base = mu_val

# Tính tỷ lệ báo động giả (False Alarm Rate - FAR) trên tập sạch
false_alarms = np.sum(val_mse_per_window > tau)
far_pct = float((false_alarms / n_val) * 100.0)

print("\n" + "="*60)
print(f"[+] Ngưỡng nền theta_base : {theta_base:.6f}")
print(f"[+] Ngưỡng cắt tau (3-sigma): {tau:.6f}")
print(f"[+] Số cảnh báo giả        : {false_alarms} / {n_val} cửa sổ")
print(f"[+] Tỷ lệ báo động giả (FAR): {far_pct:.2f}%")

MAX_ALLOWED_FAR = 2.0  # Tiêu chí nghiệm thu < 2%
if far_pct < MAX_ALLOWED_FAR:
    print(f"[SUCCESS] FAR ({far_pct:.2f}%) < {MAX_ALLOWED_FAR}% -> ĐẠT TIÊU CHÍ NGHIỆM THU!")
else:
    print(f"[!] Cảnh báo: FAR vượt mức {MAX_ALLOWED_FAR}%. Cần xem xét điều chỉnh hệ số k_sigma.")
print("="*60)

# 5. Lưu file cấu hình ngưỡng để chuẩn bị chuyển giao cho MCU ESP32-S3
config = {
    "model_name": "Dense_Autoencoder_Float32",
    "window_size": 32,
    "statistical_metrics": {
        "mu_val": mu_val,
        "sigma_val": sigma_val,
        "min_mse": min_val_mse,
        "max_mse": max_val_mse
    },
    "detection_threshold": {
        "k_sigma": K_SIGMA,
        "tau": tau,
        "theta_base": theta_base,
        "false_alarm_rate_pct": far_pct
    },
    "confidence_parameters": {
        "gamma": 1.0,
        "valid_threshold": 0.85,
        "suspicious_threshold": 0.50,
        "fail_safe_cutoff": 0.30,
        "physical_min_vwc": 0.0,
        "physical_max_vwc": 0.60
    }
}

with open(CONFIG_OUT_PATH, "w") as f:
    json.dump(config, f, indent=4)
print(f"[+] Đã lưu cấu hình ngưỡng ra file: {CONFIG_OUT_PATH}")

# 6. Kiểm định hàm tính điểm độ tin cậy C_t
def calculate_confidence(mse, physical_valid=True):
    if not physical_valid:
        return 0.0
    if mse <= theta_base:
        return 1.0
    # Công thức suy giảm hàm mũ
    exponent = -1.0 * ((mse - theta_base) / (tau - theta_base))
    return float(np.exp(exponent))

# 7. Vẽ biểu đồ nghiệm thu (Phân phối sai số & Đường cong suy giảm độ tin cậy)
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5))

# (a) Phân phối MSE trên tập Validation và vị trí ngưỡng tau
ax1.plot(val_mse_per_window, color="#2b5c8f", lw=1.3, marker='o', markersize=3, label="MSE Validation sạch")
ax1.axhline(y=tau, color="red", linestyle="--", lw=1.5, label=f"Ngưỡng tau ({tau:.6f})")
ax1.axhline(y=theta_base, color="green", linestyle=":", lw=1.3, label=f"Nền theta_base ({theta_base:.6f})")
ax1.set_title("(a) Phân Phối Sai Số Tái Tạo & Ngưỡng tau", fontsize=11, fontweight="bold")
ax1.set_xlabel("Chỉ số cửa sổ trượt trên D_val")
ax1.set_ylabel("Sai số tái tạo (MSE)")
ax1.legend(loc="upper right", fontsize=9)
ax1.grid(True, linestyle="--", alpha=0.5)

# (b) Đường cong hàm độ tin cậy C_t theo mức tăng của MSE
test_mse_range = np.linspace(0, tau * 3.5, 300)
conf_curve = [calculate_confidence(m) for m in test_mse_range]

ax2.plot(test_mse_range, conf_curve, color="#7570b3", lw=2.0, label="Chỉ số tin cậy C_t")
ax2.axvline(x=tau, color="red", linestyle="--", lw=1.3, label="Ngưỡng tau (Bắt đầu Faulty)")
ax2.axhline(y=0.85, color="green", linestyle=":", alpha=0.7, label="Mức Valid (>= 0.85)")
ax2.axhline(y=0.50, color="orange", linestyle=":", alpha=0.7, label="Mức Suspicious (0.50)")
ax2.axhline(y=0.30, color="crimson", linestyle=":", alpha=0.7, label="Ngắt an toàn (< 0.30)")

ax2.set_title("(b) Hàm Định Lượng Độ Tin Cậy C_t Theo MSE", fontsize=11, fontweight="bold")
ax2.set_xlabel("Sai số tái tạo (MSE)")
ax2.set_ylabel("Chỉ số tin cậy C_t ∈ [0, 1]")
ax2.set_ylim(-0.05, 1.05)
ax2.legend(loc="upper right", fontsize=9)
ax2.grid(True, linestyle="--", alpha=0.5)

plt.suptitle("Xác Lập Ngưỡng Bất Thường (tau) & Hàm Điểm Tin Cậy (C_t) - Task T08", fontsize=13)
plt.tight_layout()
plt.savefig(IMG_THRESHOLD_PATH, dpi=200)
print(f"[+] Đã xuất ảnh kiểm định: {IMG_THRESHOLD_PATH}")