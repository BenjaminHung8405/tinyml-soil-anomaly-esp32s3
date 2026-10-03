import os
import json
import numpy as np
import matplotlib.pyplot as plt

# 1. Định nghĩa đường dẫn
DATA_DIR = os.path.join("data", "processed")
MODELS_DIR = "models"
REPORTS_DIR = "reports"
os.makedirs(MODELS_DIR, exist_ok=True)
os.makedirs(REPORTS_DIR, exist_ok=True)

TRAIN_PATH = os.path.join(DATA_DIR, "train.npy")
REP_DATA_OUT_PATH = os.path.join(DATA_DIR, "representative_dataset.npy")
METADATA_PATH = os.path.join(MODELS_DIR, "representative_dataset_metadata.json")
IMG_DIST_PATH = os.path.join(REPORTS_DIR, "representative_distribution.png")

print(f"[*] Bước 1: Nạp tập dữ liệu Train sạch từ: {TRAIN_PATH}")
X_train = np.load(TRAIN_PATH)  # Shape: (999, 32, 1)
n_train = len(X_train)
print(f"    -> Đã nạp {n_train} cửa sổ huấn luyện.")

# 2. Lựa chọn mẫu đại diện (Stratified / Uniform Random Sampling)
# Chọn N = 300 mẫu (nằm gọn trong khoảng 200 - 500 mẫu)
NUM_REP_SAMPLES = 300
np.random.seed(42)  # Cố định seed bảo đảm tính tái lập

# Để đảm bảo bao quát toàn dải từ khô đến ướt, ta phân tầng theo giá trị trung bình của từng cửa sổ
mean_per_window = np.mean(X_train, axis=(1, 2))
sorted_indices = np.argsort(mean_per_window)

# Lấy đều các chỉ mục trải dọc theo phân phối độ ẩm
step = n_train / NUM_REP_SAMPLES
selected_indices = [sorted_indices[int(i * step)] for i in range(NUM_REP_SAMPLES)]
selected_indices = np.array(selected_indices)

X_rep = X_train[selected_indices].copy()
print(f"[*] Bước 2: Đã trích xuất {len(X_rep)} cửa sổ đại diện (Shape: {X_rep.shape}).")

# 3. Phân tích phân phối giá trị để thẩm định tính bao quát
rep_min = float(np.min(X_rep))
rep_max = float(np.max(X_rep))
rep_mean = float(np.mean(X_rep))
rep_std = float(np.std(X_rep))

train_min = float(np.min(X_train))
train_max = float(np.max(X_train))
train_mean = float(np.mean(X_train))
train_std = float(np.std(X_train))

print("\n" + "="*65)
print(f"{'Chỉ số':<15} | {'Tập Train gốc (999 mẫu)':<22} | {'Tập Đại diện (300 mẫu)':<22}")
print("-" * 65)
print(f"{'Giá trị Min':<15} | {train_min:<22.6f} | {rep_min:<22.6f}")
print(f"{'Giá trị Max':<15} | {train_max:<22.6f} | {rep_max:<22.6f}")
print(f"{'Giá trị Mean':<15} | {train_mean:<22.6f} | {rep_mean:<22.6f}")
print(f"{'Độ lệch chuẩn':<15} | {train_std:<22.6f} | {rep_std:<22.6f}")
print("="*65)

# 4. Lưu mảng dữ liệu đại diện và metadata
np.save(REP_DATA_OUT_PATH, X_rep.astype(np.float32))

metadata = {
    "num_samples": NUM_REP_SAMPLES,
    "window_size": int(X_rep.shape[1]),
    "channels": int(X_rep.shape[2]),
    "source_dataset": "data/processed/train.npy",
    "distribution_stats": {
        "min_value": rep_min,
        "max_value": rep_max,
        "mean_value": rep_mean,
        "std_value": rep_std
    },
    "train_reference_stats": {
        "min_value": train_min,
        "max_value": train_max,
        "mean_value": train_mean,
        "std_value": train_std
    }
}

with open(METADATA_PATH, "w") as f:
    json.dump(metadata, f, indent=4)

print(f"[+] Đã lưu mảng đại diện tại: {REP_DATA_OUT_PATH}")
print(f"[+] Đã lưu metadata cấu hình tại: {METADATA_PATH}")

# 5. Vẽ biểu đồ đối chứng phân phối (Histogram & Boxplot)
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(13, 5))

# (a) Histogram so sánh phân phối giá trị điểm
ax1.hist(X_train.flatten(), bins=50, alpha=0.5, color="#1b7837", density=True, label="Tập Train gốc (D_clean)")
ax1.hist(X_rep.flatten(), bins=50, alpha=0.6, color="#7570b3", density=True, label="Tập Đại diện (Representative)")
ax1.set_title("(a) Phân Phối Mật Độ Điểm Dữ Liệu", fontsize=11, fontweight="bold")
ax1.set_xlabel("Giá trị độ ẩm chuẩn hóa [0, 1]")
ax1.set_ylabel("Mật độ xác suất")
ax1.legend(loc="upper right", fontsize=9)
ax1.grid(True, linestyle="--", alpha=0.5)

# (b) So sánh độ ẩm trung bình của từng cửa sổ
ax2.plot(np.sort(mean_per_window), color="#1b7837", lw=1.5, label="Train trung bình cửa sổ (999)")
ax2.plot(np.linspace(0, n_train, NUM_REP_SAMPLES), np.sort(mean_per_window[selected_indices]), 
         'o', color="#e66101", markersize=3, label="Mẫu đại diện chọn lọc (300)")
ax2.set_title("(b) Độ Phủ Toàn Dải Khô - Ẩm Bão Hòa", fontsize=11, fontweight="bold")
ax2.set_xlabel("Thứ tự phân vị (Quantile Index)")
ax2.set_ylabel("Độ ẩm trung bình cửa sổ [0, 1]")
ax2.legend(loc="upper left", fontsize=9)
ax2.grid(True, linestyle="--", alpha=0.5)

plt.suptitle("Kiểm Định Tính Đại Diện Của Dữ Liệu Calibration - Task T09", fontsize=13)
plt.tight_layout()
plt.savefig(IMG_DIST_PATH, dpi=200)
print(f"[+] Đã xuất ảnh kiểm định phân phối: {IMG_DIST_PATH}")