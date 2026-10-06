import os
import numpy as np

DATA_DIR = os.path.join("data", "processed")
X_test = np.load(os.path.join(DATA_DIR, "test_fault_injected.npy"))
y_mask = np.load(os.path.join(DATA_DIR, "test_ground_truth_mask.npy"))

print("=== KIỂM TRA TẬP TEST ===")
print("X_test shape:", X_test.shape)
print("y_mask shape:", y_mask.shape)
print("y_mask dtype:", y_mask.dtype)
print("y_mask min/max:", np.min(y_mask), np.max(y_mask))
print("y_mask unique values:", np.unique(y_mask))

if y_mask.ndim == 2:
    window_has_fault = np.any(y_mask > 0, axis=1)
    print("Số cửa sổ có lỗi (any > 0):", np.sum(window_has_fault), "/", len(X_test))
    # In phân bố tổng số điểm lỗi mỗi cửa sổ
    fault_counts = np.sum(y_mask > 0, axis=1)
    print("Top 10 số điểm lỗi mỗi cửa sổ:", fault_counts[:10])
    print("Số cửa sổ có đúng 0 điểm lỗi:", np.sum(fault_counts == 0))
    print("Số cửa sổ có > 0 điểm lỗi:", np.sum(fault_counts > 0))
elif y_mask.ndim == 1:
    print("Số phần tử > 0:", np.sum(y_mask > 0), "/", len(y_mask))