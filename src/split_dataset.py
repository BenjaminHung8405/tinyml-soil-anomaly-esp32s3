import os
import json
import numpy as np
import matplotlib.pyplot as plt

# 1. Định nghĩa đường dẫn
PROCESSED_NPY_PATH = os.path.join("data", "processed", "processed_windows.npy")
DATA_DIR = os.path.join("data", "processed")

TRAIN_PATH = os.path.join(DATA_DIR, "train.npy")
VAL_PATH = os.path.join(DATA_DIR, "val.npy")
TEST_PATH = os.path.join(DATA_DIR, "test.npy")
SPLIT_INFO_PATH = os.path.join(DATA_DIR, "split_metadata.json")
IMG_SPLIT_PATH = os.path.join(DATA_DIR, "split_inspection.png")

print(f"[*] Bước 1: Nạp mảng dữ liệu đã đóng khung từ: {PROCESSED_NPY_PATH}")
X = np.load(PROCESSED_NPY_PATH)
n_total = len(X)
print(f"    -> Tổng số cửa sổ sẵn có: {n_total}, Shape: {X.shape}, Dtype: {X.dtype}")

# 2. Tính toán điểm cắt theo trục thời gian (80% - 10% - 10%)
TRAIN_RATIO = 0.8
VAL_RATIO = 0.1
TEST_RATIO = 0.1

n_train = int(n_total * TRAIN_RATIO)
n_val = int(n_total * VAL_RATIO)
n_test = n_total - (n_train + n_val)

print(f"[*] Bước 2: Phân chia tập dữ liệu Out-of-Time:")
print(f"    -> Train (80%): {n_train} cửa sổ (từ index 0 đến {n_train - 1})")
print(f"    -> Val   (10%): {n_val} cửa sổ (từ index {n_train} đến {n_train + n_val - 1})")
print(f"    -> Test  (10%): {n_test} cửa sổ (từ index {n_train + n_val} đến {n_total - 1})")

# 3. Cắt mảng NumPy theo lát cắt tuần tự
X_train = X[:n_train].copy()
X_val = X[n_train : n_train + n_val].copy()
X_test = X[n_train + n_val :].copy()

# 4. Lưu 3 file độc lập bàn giao Task T03
np.save(TRAIN_PATH, X_train)
np.save(VAL_PATH, X_val)
np.save(TEST_PATH, X_test)

# 5. Lưu thông tin metadata để truy xuất nguồn gốc
split_meta = {
    "total_samples": int(n_total),
    "window_size": int(X.shape[1]),
    "channels": int(X.shape[2]),
    "train_count": int(n_train),
    "val_count": int(n_val),
    "test_count": int(n_test),
    "train_ratio": TRAIN_RATIO,
    "val_ratio": VAL_RATIO,
    "test_ratio": TEST_RATIO,
    "data_type": str(X.dtype)
}

with open(SPLIT_INFO_PATH, "w") as f:
    json.dump(split_meta, f, indent=4)

print(f"\n[SUCCESS] Đã lưu 3 tập dữ liệu bàn giao:")
print(f"  [1] Train (D_clean) : {TRAIN_PATH} -> Shape: {X_train.shape}")
print(f"  [2] Val   (D_val)   : {VAL_PATH}   -> Shape: {X_val.shape}")
print(f"  [3] Test  (D_test)  : {TEST_PATH}  -> Shape: {X_test.shape}")
print(f"  [4] Metadata        : {SPLIT_INFO_PATH}")

# 6. Vẽ đồ thị kiểm định phân chia trục thời gian
# Lấy điểm giá trị đầu tiên của mỗi cửa sổ để tái hiện chuỗi thời gian liên tục
first_points_train = X_train[:, 0, 0]
first_points_val = X_val[:, 0, 0]
first_points_test = X_test[:, 0, 0]

plt.figure(figsize=(14, 5))
x_axis_train = np.arange(len(first_points_train))
x_axis_val = np.arange(len(first_points_train), len(first_points_train) + len(first_points_val))
x_axis_test = np.arange(len(first_points_train) + len(first_points_val), n_total)

plt.plot(x_axis_train, first_points_train, color="#1b7837", lw=1.2, label=f"Train - D_clean ({len(X_train)} windows - 80%)")
plt.plot(x_axis_val, first_points_val, color="#e66101", lw=1.2, label=f"Validation - D_val ({len(X_val)} windows - 10%)")
plt.plot(x_axis_test, first_points_test, color="#5e3c99", lw=1.2, label=f"Test - D_test ({len(X_test)} windows - 10%)")

# Vẽ đường phân cách
plt.axvline(x=len(first_points_train), color="red", linestyle="--", alpha=0.7)
plt.axvline(x=len(first_points_train) + len(first_points_val), color="purple", linestyle="--", alpha=0.7)

plt.title("Phân Chia Dữ Liệu Theo Trục Thời Gian (Time-based Out-of-Time Splitting) - Task T03", fontsize=12)
plt.xlabel("Chỉ số cửa sổ trượt (Thứ tự thời gian tuần tự)")
plt.ylabel("Giá trị chuẩn hóa [0, 1]")
plt.legend(loc="upper right", framealpha=0.9)
plt.grid(True, linestyle="--", alpha=0.5)
plt.tight_layout()

plt.savefig(IMG_SPLIT_PATH, dpi=200)
print(f"[+] Đã xuất ảnh kiểm định phân chia: {IMG_SPLIT_PATH}")