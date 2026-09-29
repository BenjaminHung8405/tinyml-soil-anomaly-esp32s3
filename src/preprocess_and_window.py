import os
import json
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.preprocessing import MinMaxScaler

# 1. Định nghĩa đường dẫn file
INPUT_CSV_PATH = os.path.join("data", "raw", "raw_dataset.csv")
OUTPUT_NPY_PATH = os.path.join("data", "processed", "processed_windows.npy")
SCALER_CONFIG_PATH = os.path.join("data", "processed", "scaler_params.json")
IMG_INSPECTION_PATH = os.path.join("data", "processed", "window_inspection.png")

# Đảm bảo thư mục lưu trữ đã tồn tại
os.makedirs(os.path.dirname(OUTPUT_NPY_PATH), exist_ok=True)

print(f"[*] Bước 1: Đọc dữ liệu thô từ: {INPUT_CSV_PATH}")
df = pd.read_csv(INPUT_CSV_PATH)
print(f"    -> Đã nạp {len(df)} dòng dữ liệu.")

# 2. Sàng lọc giá trị bất thường vật lý thô (Plausibility Check)
print("[*] Bước 2: Kiểm tra biên vật lý thổ nhưỡng...")
PHYSICAL_MIN_VWC = 0.0    # 0%
PHYSICAL_MAX_VWC = 60.0   # Đất bão hòa tối đa 60%

# Cắt chặn (clip) các giá trị ngoài biên vật lý nếu có
raw_vwc = df["vwc"].values
clipped_vwc = np.clip(raw_vwc, PHYSICAL_MIN_VWC, PHYSICAL_MAX_VWC)

# 3. Chuẩn hóa Min-Max Scaling về đoạn [0.0, 1.0]
print("[*] Bước 3: Áp dụng Min-Max Scaling...")
scaler = MinMaxScaler(feature_range=(0.0, 1.0))
scaled_vwc = scaler.fit_transform(clipped_vwc.reshape(-1, 1)).flatten()

# Lưu tham số Min / Max để sau này nạp vào ESP32-S3
scaler_params = {
    "data_min": float(scaler.data_min_[0]),
    "data_max": float(scaler.data_max_[0]),
    "feature_min": 0.0,
    "feature_max": 1.0,
    "window_size": 32,
    "stride": 16
}
with open(SCALER_CONFIG_PATH, "w") as f:
    json.dump(scaler_params, f, indent=4)
print(f"    -> Đã lưu tham số bộ chuẩn hóa ra: {SCALER_CONFIG_PATH}")
print(f"    -> Min VWC: {scaler_params['data_min']:.2f}%, Max VWC: {scaler_params['data_max']:.2f}%")

# 4. Đóng khung cửa sổ trượt (Sliding Windows)
WINDOW_SIZE = 32
STRIDE = 16  # Chồng lấp 50%
print(f"[*] Bước 4: Đóng khung cửa sổ trượt (W_M = {WINDOW_SIZE}, Stride = {STRIDE})...")

windows = []
for start_idx in range(0, len(scaled_vwc) - WINDOW_SIZE + 1, STRIDE):
    window = scaled_vwc[start_idx : start_idx + WINDOW_SIZE]
    windows.append(window)

# Chuyển về định dạng NumPy mảng float32 (N, 32, 1)
X_windows = np.array(windows, dtype=np.float32)
X_windows = np.expand_dims(X_windows, axis=-1)

# 5. Lưu sản phẩm bàn giao Task T02
np.save(OUTPUT_NPY_PATH, X_windows)
print(f"\n[SUCCESS] Đã lưu file bàn giao: {OUTPUT_NPY_PATH}")
print(f"[+] Kích thước mảng: {X_windows.shape} (N = {X_windows.shape[0]} cửa sổ)")
print(f"[+] Dải giá trị mảng: Min={X_windows.min():.4f}, Max={X_windows.max():.4f}")
print(f"[+] Kiểu dữ liệu: {X_windows.dtype}")

# 6. Kiểm tra trực quan ngẫu nhiên 4 cửa sổ để nghiệm thu
fig, axes = plt.subplots(2, 2, figsize=(12, 6))
sample_indices = [0, len(X_windows)//4, len(X_windows)//2, len(X_windows) - 1]

for ax, idx in zip(axes.flatten(), sample_indices):
    ax.plot(X_windows[idx, :, 0], marker='o', markersize=3, color='#1b7837', lw=1.2)
    ax.set_title(f"Cửa sổ mẫu #{idx} (W_M = 32 điểm)", fontsize=10)
    ax.set_ylim(-0.05, 1.05)
    ax.set_xlabel("Điểm dữ liệu trong cửa sổ (15 phút/điểm)")
    ax.set_ylabel("Giá trị chuẩn hóa [0, 1]")
    ax.grid(True, linestyle="--", alpha=0.5)

plt.suptitle("Kiểm định Cấu Trúc Cửa Sổ Trượt (Task T02)", fontsize=13)
plt.tight_layout()
plt.savefig(IMG_INSPECTION_PATH, dpi=200)
print(f"[+] Đã xuất ảnh kiểm định: {IMG_INSPECTION_PATH}")