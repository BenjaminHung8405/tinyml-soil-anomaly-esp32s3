import os
import json
import numpy as np
import matplotlib.pyplot as plt
from sklearn.metrics import precision_recall_fscore_support, mean_absolute_error, mean_squared_error

# 1. Đường dẫn file
DATA_DIR = os.path.join("data", "processed")
TEST_CLEAN_PATH = os.path.join(DATA_DIR, "test.npy")
TEST_FAULT_PATH = os.path.join(DATA_DIR, "test_fault_injected.npy")
GROUND_TRUTH_MASK_PATH = os.path.join(DATA_DIR, "test_ground_truth_mask.npy")
GROUND_TRUTH_LABELS_PATH = os.path.join(DATA_DIR, "test_fault_labels.npy")

REPORTS_DIR = "reports"
os.makedirs(REPORTS_DIR, exist_ok=True)
BASELINE_REPORT_PATH = os.path.join(REPORTS_DIR, "baseline_benchmark_report.json")
IMG_BASELINE_PATH = os.path.join(REPORTS_DIR, "baseline_comparison.png")

# 2. Nạp dữ liệu
print(f"[*] Bước 1: Nạp tập dữ liệu kiểm thử và nhãn chuẩn...")
X_clean = np.load(TEST_CLEAN_PATH)          # Shape: (N, 32, 1) - Tín hiệu gốc
X_faulty = np.load(TEST_FAULT_PATH)        # Shape: (N, 32, 1) - Tín hiệu tiêm lỗi
gt_mask = np.load(GROUND_TRUTH_MASK_PATH)  # Shape: (N, 32, 1) - Mặt nạ điểm lỗi (0/1)
gt_labels = np.load(GROUND_TRUTH_LABELS_PATH) # Shape: (N,) - Nhãn loại lỗi (0, 1, 2, 3, 4)

N_windows, window_size, _ = X_faulty.shape
print(f"    -> Nạp {N_windows} cửa sổ kiểm thử ($W_M = {window_size}$).")

# Làm phẳng mảng để tính toán theo từng điểm thời gian (Point-wise Evaluation)
y_true = gt_mask.flatten()
clean_flat = X_clean.flatten()
faulty_flat = X_faulty.flatten()

# ==============================================================================
# BASELINE 1: QUY TẮC NGƯỠNG TĨNH (STATIC THRESHOLD RULES)
# ==============================================================================
print("[*] Bước 2: Chạy Baseline 1 - Static Threshold Rules...")
def run_static_threshold(data, max_rate=0.08):
    pred_mask = np.zeros_like(data, dtype=np.uint8)
    repaired = data.copy()
    
    for i in range(len(data)):
        val = data[i]
        # Kiểm tra biên vật lý ngoài [0, 1] hoặc biến thiên tức thời vượt max_rate
        is_out_of_bound = (val <= 0.0) or (val >= 1.0)
        is_spike_rate = False
        if i > 0 and abs(val - data[i-1]) > max_rate:
            is_spike_rate = True
            
        if is_out_of_bound or is_spike_rate:
            pred_mask[i] = 1
            # Bù bằng giá trị hợp lệ liền trước
            repaired[i] = repaired[i-1] if i > 0 else 0.5
    return pred_mask, repaired

pred_mask_static, repaired_static = run_static_threshold(faulty_flat)

# ==============================================================================
# BASELINE 2: BỘ LỌC HAMPEL (HAMPEL FILTER / MAD)
# ==============================================================================
print("[*] Bước 3: Chạy Baseline 2 - Hampel Filter...")
def run_hampel_filter(data, k=7, n_sigmas=3.0):
    pred_mask = np.zeros_like(data, dtype=np.uint8)
    repaired = data.copy()
    n = len(data)
    
    for i in range(n):
        idx_start = max(0, i - k)
        idx_end = min(n, i + k + 1)
        window = data[idx_start:idx_end]
        
        med = np.median(window)
        mad = 1.4826 * np.median(np.abs(window - med))
        
        threshold = n_sigmas * mad
        if mad > 1e-5 and np.abs(data[i] - med) > threshold:
            pred_mask[i] = 1
            repaired[i] = med  # Thay bằng giá trị trung vị
    return pred_mask, repaired

pred_mask_hampel, repaired_hampel = run_hampel_filter(faulty_flat, k=5, n_sigmas=3.0)

# ==============================================================================
# BASELINE 3: BỘ LỌC KALMAN TUYẾN TÍNH (LINEAR KALMAN FILTER)
# ==============================================================================
print("[*] Bước 4: Chạy Baseline 3 - Linear Kalman Filter...")
def run_kalman_filter(data, Q=1e-4, R=1e-2):
    pred_mask = np.zeros_like(data, dtype=np.uint8)
    repaired = np.zeros_like(data)
    
    x_hat = data[0]
    P = 1.0
    
    for i in range(len(data)):
        # Dự đoán
        x_hat_minus = x_hat
        P_minus = P + Q
        
        # Sai lệch đo đạc (Innovation)
        z = data[i]
        residual = z - x_hat_minus
        
        # Ngưỡng phát hiện bất thường dựa trên hiệp phương sai đổi mới
        S = P_minus + R
        if abs(residual) > 3.0 * np.sqrt(S):
            pred_mask[i] = 1
            
        # Cập nhật
        K = P_minus / S
        x_hat = x_hat_minus + K * residual
        P = (1.0 - K) * P_minus
        repaired[i] = x_hat
        
    return pred_mask, repaired

pred_mask_kalman, repaired_kalman = run_kalman_filter(faulty_flat, Q=1e-4, R=1e-2)

# ==============================================================================
# ĐO LƯỜNG VÀ ĐỐI CHUẨN HIỆU NĂNG
# ==============================================================================
print("[*] Bước 5: Tính toán ma trận chỉ số học thuật...")

def compute_metrics(y_true, y_pred, y_clean, y_repaired, y_raw):
    p, r, f1, _ = precision_recall_fscore_support(y_true, y_pred, average="binary", zero_division=0)
    mae_raw = mean_absolute_error(y_clean, y_raw)
    mae_rep = mean_absolute_error(y_clean, y_repaired)
    rmse_raw = np.sqrt(mean_squared_error(y_clean, y_raw))
    rmse_rep = np.sqrt(mean_squared_error(y_clean, y_repaired))
    
    # Tỷ lệ giảm sai số phục hồi (Error Reduction Rate)
    err_reduction_pct = (1.0 - (rmse_rep / rmse_raw)) * 100.0 if rmse_raw > 0 else 0.0
    
    return {
        "precision": float(p),
        "recall": float(r),
        "f1_score": float(f1),
        "mae_before": float(mae_raw),
        "mae_after": float(mae_rep),
        "rmse_before": float(rmse_raw),
        "rmse_after": float(rmse_rep),
        "error_reduction_pct": float(err_reduction_pct)
    }

metrics_static = compute_metrics(y_true, pred_mask_static, clean_flat, repaired_static, faulty_flat)
metrics_hampel = compute_metrics(y_true, pred_mask_hampel, clean_flat, repaired_hampel, faulty_flat)
metrics_kalman = compute_metrics(y_true, pred_mask_kalman, clean_flat, repaired_kalman, faulty_flat)

report = {
    "total_evaluation_points": len(y_true),
    "total_anomalies_ground_truth": int(y_true.sum()),
    "baselines": {
        "Static_Threshold": metrics_static,
        "Hampel_Filter": metrics_hampel,
        "Kalman_Filter": metrics_kalman
    }
}

with open(BASELINE_REPORT_PATH, "w") as f:
    json.dump(report, f, indent=4)

print("\n" + "="*80)
print(f"{'Phương Pháp Baseline':<20} | {'Precision':<10} | {'Recall':<10} | {'F1-Score':<10} | {'RMSE Sau Bù':<12} | {'Giảm Sai Số %':<12}")
print("-" * 80)
print(f"{'1. Static Threshold':<20} | {metrics_static['precision']:<10.4f} | {metrics_static['recall']:<10.4f} | {metrics_static['f1_score']:<10.4f} | {metrics_static['rmse_after']:<12.4f} | {metrics_static['error_reduction_pct']:<12.2f}%")
print(f"{'2. Hampel Filter':<20} | {metrics_hampel['precision']:<10.4f} | {metrics_hampel['recall']:<10.4f} | {metrics_hampel['f1_score']:<10.4f} | {metrics_hampel['rmse_after']:<12.4f} | {metrics_hampel['error_reduction_pct']:<12.2f}%")
print(f"{'3. Kalman Filter':<20} | {metrics_kalman['precision']:<10.4f} | {metrics_kalman['recall']:<10.4f} | {metrics_kalman['f1_score']:<10.4f} | {metrics_kalman['rmse_after']:<12.4f} | {metrics_kalman['error_reduction_pct']:<12.2f}%")
print("="*80)

# ==============================================================================
# TRỰC QUAN HÓA SO SÁNH TRÊN MỘT CỬA SỔ LỖI PHỨC TẠP
# ==============================================================================
# Tìm cửa sổ có lỗi trôi tín hiệu (Drift - mã 4) hoặc đột biến để minh họa
sample_win_idx = 19  # Cửa sổ có lỗi Drift từ Task T04
start_p = sample_win_idx * window_size
end_p = start_p + window_size

t_steps = np.arange(window_size)
plt.figure(figsize=(13, 6))

plt.plot(t_steps, clean_flat[start_p:end_p], 'k--', lw=1.8, label="Ground Truth (Sạch)")
plt.plot(t_steps, faulty_flat[start_p:end_p], 'r-', lw=1.5, alpha=0.8, label="Tín hiệu Lỗi (Faulty)")
plt.plot(t_steps, repaired_hampel[start_p:end_p], color="#2b5c8f", lw=1.3, label="Sau lọc Hampel")
plt.plot(t_steps, repaired_kalman[start_p:end_p], color="#1b7837", lw=1.3, label="Sau lọc Kalman")

plt.title(f"So Sánh Năng Lực Xử Lý Của Các Baseline Non-AI (Cửa Sổ #{sample_win_idx} - Lỗi Drift)", fontsize=12)
plt.xlabel("Mẫu dữ liệu trong cửa sổ $W_M = 32$ (bước 15 phút)")
plt.ylabel("Độ ẩm chuẩn hóa [0, 1]")
plt.legend(loc="upper left", framealpha=0.9)
plt.grid(True, linestyle="--", alpha=0.5)
plt.tight_layout()

plt.savefig(IMG_BASELINE_PATH, dpi=200)
print(f"[+] Đã xuất báo cáo JSON: {BASELINE_REPORT_PATH}")
print(f"[+] Đã xuất biểu đồ so sánh: {IMG_BASELINE_PATH}")