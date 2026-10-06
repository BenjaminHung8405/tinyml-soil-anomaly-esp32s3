import os
import json
import numpy as np

DATA_DIR = os.path.join("data", "processed")
labels_path = os.path.join(DATA_DIR, "test_fault_labels.npy")
meta_path = os.path.join(DATA_DIR, "fault_injection_metadata.json")

labels = np.load(labels_path, allow_pickle=True)
print(f"[*] test_fault_labels shape: {labels.shape}")
print(f"[*] Các giá trị nhãn duy nhất: {np.unique(labels)}")

# Đếm phân bố nhãn
from collections import Counter
print("[*] Phân bố nhãn:", Counter(labels))

if os.path.exists(meta_path):
    with open(meta_path, "r") as f:
        meta = json.load(f)
    print("\n[*] Metadata tiêm lỗi:")
    print(json.dumps(meta, indent=2)[:500])