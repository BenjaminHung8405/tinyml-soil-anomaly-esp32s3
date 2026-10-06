import os
import json
import numpy as np

DATA_DIR = os.path.join("data", "processed")
X_test = np.load(os.path.join(DATA_DIR, "test_fault_injected.npy"))
labels = np.load(os.path.join(DATA_DIR, "test_fault_labels.npy")).astype(int)

stuck_indices = np.where(labels == 3)[0]
drift_indices = np.where(labels == 4)[0]

print(f"[*] Cửa sổ Stuck-at (nhãn 3): {stuck_indices}")
for idx in stuck_indices:
    w = X_test[idx].flatten()
    print(f"    Index #{idx:03d} | Min: {np.min(w):.6f}, Max: {np.max(w):.6f}, Diff (Max-Min): {np.max(w) - np.min(w):.6f}, Std: {np.std(w):.6f}")

print(f"\n[*] Cửa sổ Drift (nhãn 4): {drift_indices}")
for idx in drift_indices:
    w = X_test[idx].flatten()
    slope = w[-1] - w[0]
    print(f"    Index #{idx:03d} | Start: {w[0]:.6f}, End: {w[-1]:.6f}, Total Delta: {slope:.6f}, Std: {np.std(w):.6f}")

# Kiểm tra thêm mẫu Clean bình thường để so sánh
clean_indices = np.where(labels == 0)[0][:5]
print(f"\n[*] 5 cửa sổ Clean đầu tiên:")
for idx in clean_indices:
    w = X_test[idx].flatten()
    print(f"    Index #{idx:03d} | Min: {np.min(w):.6f}, Max: {np.max(w):.6f}, Diff (Max-Min): {np.max(w) - np.min(w):.6f}, Std: {np.std(w):.6f}")