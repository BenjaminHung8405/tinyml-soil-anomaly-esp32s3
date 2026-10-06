import os
import numpy as np

DATA_DIR = os.path.join("data", "processed")
X_test = np.load(os.path.join(DATA_DIR, "test_fault_injected.npy"))
y_mask = np.load(os.path.join(DATA_DIR, "test_ground_truth_mask.npy")).squeeze()

print(f"[*] Tổng số cửa sổ: {len(X_test)}")
print(f"[*] Vị trí các cửa sổ có y_mask > 0:")
fault_indices = [i for i in range(len(y_mask)) if np.any(y_mask[i] > 0)]
print(f"    Số lượng: {len(fault_indices)} cửa sổ")
print(f"    Danh sách index: {fault_indices}")

# Kiểm tra xem có file nhãn nào khác trong data/processed không
files = os.listdir(DATA_DIR)
print(f"\n[*] Các file có trong {DATA_DIR}:")
for f in files:
    print(f"    - {f}")