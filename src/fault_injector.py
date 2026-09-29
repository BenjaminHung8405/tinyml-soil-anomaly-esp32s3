import os
import json
import numpy as np
import matplotlib.pyplot as plt

# 1. Đường dẫn file
DATA_DIR = os.path.join("data", "processed")
TEST_INPUT_PATH = os.path.join(DATA_DIR, "test.npy")

TEST_FAULT_PATH = os.path.join(DATA_DIR, "test_fault_injected.npy")
GROUND_TRUTH_MASK_PATH = os.path.join(DATA_DIR, "test_ground_truth_mask.npy")
GROUND_TRUTH_LABELS_PATH = os.path.join(DATA_DIR, "test_fault_labels.npy")
METADATA_PATH = os.path.join(DATA_DIR, "fault_injection_metadata.json")
IMG_INSPECTION_PATH = os.path.join(DATA_DIR, "fault_inspection.png")

print(f"[*] Bước 1: Nạp tập dữ liệu kiểm thử gốc từ: {TEST_INPUT_PATH}")
X_test = np.load(TEST_INPUT_PATH)  # Shape: (N_test, 32, 1)
n_windows, window_size, channels = X_test.shape
print(f"    -> Đã nạp {n_windows} cửa sổ kiểm thử, kích thước mỗi cửa sổ: {window_size} điểm.")

# Sao chép để tiêm lỗi độc lập
X_test_faulty = X_test.copy()

# Mặt nạ nhị phân theo từng điểm dữ liệu: Shape (N_test, 32, 1)
# 0 = Mẫu bình thường (Normal), 1 = Mẫu lỗi (Anomaly)
ground_truth_mask = np.zeros_like(X_test, dtype=np.uint8)

# Nhãn phân loại theo từng cửa sổ trượt: Shape (N_test,)
# 0 = Normal, 1 = Spike, 2 = Missing/Noise, 3 = Stuck-at, 4 = Drift
fault_labels = np.zeros(n_windows, dtype=np.int32)

# 2. Thiết lập tỷ lệ tiêm lỗi: 15% tổng số cửa sổ (~19 cửa sổ trên 126 cửa sổ)
np.random.seed(42)  # Cố định seed bảo đảm tính tái lập kết quả (Reproducible)
FAULT_RATIO = 0.15
n_faulty_windows = int(n_windows * FAULT_RATIO)

# Chọn ngẫu nhiên các chỉ mục cửa sổ để tiêm lỗi (không trùng nhau)
target_window_indices = np.random.choice(n_windows, size=n_faulty_windows, replace=False)
target_window_indices.sort()
print(f"[*] Bước 2: Số lượng cửa sổ được chọn để tiêm lỗi: {n_faulty_windows}/{n_windows} ({FAULT_RATIO*100:.1f}%)")

# Phân chia đều 4 dạng lỗi và 3 cấp độ
fault_types = ["spike", "noise_missing", "stuck_at", "drift"]
severities = ["mild", "moderate", "severe"]

injection_records = []

# Tính toán độ lệch chuẩn tổng thể của tập Test làm mốc tỷ lệ
sigma_x = float(np.std(X_test))
if sigma_x < 1e-4:
    sigma_x = 0.05

for i, win_idx in enumerate(target_window_indices):
    f_type = fault_types[i % len(fault_types)]
    severity = severities[(i // len(fault_types)) % len(severities)]
    
    window = X_test_faulty[win_idx, :, 0].copy()
    mask = np.zeros(window_size, dtype=np.uint8)
    
    if f_type == "spike":
        # Lỗi đột biến: Tiêm xung tại 1 - 2 vị trí ngẫu nhiên
        alpha_map = {"mild": 3.0, "moderate": 5.0, "severe": 7.5}
        alpha = alpha_map[severity]
        spike_pos = np.random.randint(5, window_size - 5)
        sign = 1.0 if np.random.rand() > 0.5 else -1.0
        
        spike_magnitude = sign * alpha * sigma_x
        window[spike_pos] += spike_magnitude
        mask[spike_pos] = 1
        fault_code = 1
        
    elif f_type == "noise_missing":
        # Lỗi mất mẫu hoặc nhiễu cao tần
        if severity == "severe":
            # Missing: 4 - 8 mẫu liên tiếp bị rớt về 0.0
            start_p = np.random.randint(5, 20)
            length = np.random.randint(4, 9)
            window[start_p : start_p + length] = 0.0
            mask[start_p : start_p + length] = 1
        else:
            # High-frequency noise
            noise_sigma_map = {"mild": 0.12, "moderate": 0.25}
            n_sigma = noise_sigma_map[severity]
            start_p = np.random.randint(5, 15)
            length = np.random.randint(8, 14)
            window[start_p : start_p + length] += np.random.normal(0, n_sigma, size=length)
            mask[start_p : start_p + length] = 1
        fault_code = 2
        
    elif f_type == "stuck_at":
        # Lỗi kẹt trị số: Khóa cứng giá trị qua 10 - 20 mẫu
        stuck_len_map = {"mild": 8, "moderate": 14, "severe": 20}
        stuck_len = stuck_len_map[severity]
        start_p = np.random.randint(2, window_size - stuck_len)
        const_val = window[start_p]
        window[start_p : start_p + stuck_len] = const_val
        mask[start_p : start_p + stuck_len] = 1
        fault_code = 3
        
    elif f_type == "drift":
        # Lỗi trôi tín hiệu tiệm tiến
        drift_slope_map = {"mild": 0.006, "moderate": 0.012, "severe": 0.020}
        slope = drift_slope_map[severity]
        sign = 1.0 if np.random.rand() > 0.5 else -1.0
        start_p = np.random.randint(5, 12)
        
        drift_steps = np.arange(window_size - start_p)
        window[start_p :] += sign * slope * drift_steps
        mask[start_p :] = 1
        fault_code = 4

    # Giới hạn vật lý sau khi tiêm [0.0, 1.0]
    window = np.clip(window, 0.0, 1.0)
    
    # Cập nhật mảng
    X_test_faulty[win_idx, :, 0] = window
    ground_truth_mask[win_idx, :, 0] = mask
    fault_labels[win_idx] = fault_code
    
    injection_records.append({
        "window_index": int(win_idx),
        "fault_type": f_type,
        "fault_code": int(fault_code),
        "severity": severity,
        "affected_points": int(mask.sum())
    })

# 3. Lưu các file bàn giao
np.save(TEST_FAULT_PATH, X_test_faulty.astype(np.float32))
np.save(GROUND_TRUTH_MASK_PATH, ground_truth_mask)
np.save(GROUND_TRUTH_LABELS_PATH, fault_labels)

meta = {
    "total_test_windows": n_windows,
    "faulty_windows_count": n_faulty_windows,
    "fault_ratio": float(n_faulty_windows / n_windows),
    "fault_type_distribution": {
        "spike": sum(1 for r in injection_records if r["fault_type"] == "spike"),
        "noise_missing": sum(1 for r in injection_records if r["fault_type"] == "noise_missing"),
        "stuck_at": sum(1 for r in injection_records if r["fault_type"] == "stuck_at"),
        "drift": sum(1 for r in injection_records if r["fault_type"] == "drift"),
    },
    "details": injection_records
}

with open(METADATA_PATH, "w") as f:
    json.dump(meta, f, indent=4)

print(f"\n[SUCCESS] Đã hoàn thành tiêm lỗi nhân tạo:")
print(f"  [1] File Test tiêm lỗi : {TEST_FAULT_PATH} -> Shape: {X_test_faulty.shape}")
print(f"  [2] Mặt nạ Ground-Truth: {GROUND_TRUTH_MASK_PATH} -> Shape: {ground_truth_mask.shape}")
print(f"  [3] Nhãn loại lỗi      : {GROUND_TRUTH_LABELS_PATH} -> Shape: {fault_labels.shape}")
print(f"  [4] Metadata tiêm lỗi  : {METADATA_PATH}")

# 4. Vẽ biểu đồ trực quan hóa 4 dạng lỗi đại diện để nghiệm thu
fig, axes = plt.subplots(2, 2, figsize=(13, 7))
sample_fault_types = ["spike", "noise_missing", "stuck_at", "drift"]
titles = [
    "(a) Lỗi Đột Biến Xung (Spike Fault)",
    "(b) Lỗi Mất Mẫu / Nhiễu (Missing/Noise Fault)",
    "(c) Lỗi Kẹt Trị Số (Stuck-at Fault)",
    "(d) Lỗi Trôi Tín Hiệu (Drift Fault)"
]

for ax, f_name, title in zip(axes.flatten(), sample_fault_types, titles):
    # Tìm cửa sổ đại diện đầu tiên của dạng lỗi này
    rec = next(r for r in injection_records if r["fault_type"] == f_name)
    w_idx = rec["window_index"]
    
    clean_sig = X_test[w_idx, :, 0]
    fault_sig = X_test_faulty[w_idx, :, 0]
    mask_sig = ground_truth_mask[w_idx, :, 0]
    
    ax.plot(clean_sig, color="#2b5c8f", linestyle="--", lw=1.5, label="Tín hiệu gốc (Clean)")
    ax.plot(fault_sig, color="#d95f02", marker='o', markersize=3, lw=1.3, label=f"Tín hiệu lỗi ({rec['severity']})")
    
    # Tô sáng vùng bị tiêm lỗi
    fault_indices = np.where(mask_sig == 1)[0]
    if len(fault_indices) > 0:
        ax.axvspan(fault_indices[0] - 0.3, fault_indices[-1] + 0.3, color="#fee08b", alpha=0.4, label="Vùng tiêm lỗi")
        
    ax.set_title(title, fontsize=11, fontweight="bold")
    ax.set_ylim(-0.05, 1.05)
    ax.set_xlabel("Mẫu dữ liệu trong cửa sổ $W_M = 32$ (bước 15p)")
    ax.set_ylabel("Giá trị chuẩn hóa [0, 1]")
    ax.legend(loc="upper left", fontsize=9, framealpha=0.85)
    ax.grid(True, linestyle="--", alpha=0.5)

plt.suptitle("Bộ Công Cụ Tiêm Lỗi Nhân Tạo (Fault Injection Suite) - Task T04", fontsize=13)
plt.tight_layout()
plt.savefig(IMG_INSPECTION_PATH, dpi=200)
print(f"[+] Đã xuất ảnh kiểm định: {IMG_INSPECTION_PATH}")