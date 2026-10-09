"""
Test script: tests/test_loader_speed.py
Kiểm tra tính đúng đắn và tốc độ nạp dữ liệu của Data Loader.
"""

import time
import sys
import os

# Thêm thư mục gốc vào đường dẫn hệ thống
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from dashboard.components.data_loader import load_sample_windows, load_benchmark_metrics, load_hardware_bom


def test_data_loader_performance():
    print("=" * 60)
    print("KIỂM ĐỊNH HIỆU NĂNG DATA LOADER (TASK T1.1.2)")
    print("=" * 60)

    # 1. Đo thời gian nạp lần 1 (Cold load / Tính toán khởi tạo)
    t0 = time.perf_counter()
    X_clean, X_corrupt, labels = load_sample_windows(126)
    df_metrics = load_benchmark_metrics()
    df_bom = load_hardware_bom()
    cold_load_time = time.perf_counter() - t0

    print(f"[+] Lần nạp đầu tiên (Cold Load): {cold_load_time * 1000:.2f} ms")
    print(f"    - Shape X_clean   : {X_clean.shape} (Kỳ vọng: 126, 32, 3)")
    print(f"    - Shape X_corrupt : {X_corrupt.shape} (Kỳ vọng: 126, 32, 3)")
    print(f"    - Số lượng nhãn   : {len(labels)} nhãn")
    print(f"    - Bảng metrics    : {len(df_metrics)} phương pháp đối chuẩn")

    assert X_clean.shape == (126, 32, 3), "Sai kích thước X_clean!"
    assert X_corrupt.shape == (126, 32, 3), "Sai kích thước X_corrupt!"
    assert len(labels) == 126, "Sai kích thước nhãn!"

    # 2. Đo thời gian nạp lần 2 (Warm / Cached load)
    t0 = time.perf_counter()
    _ = load_sample_windows(126)
    _ = load_benchmark_metrics()
    _ = load_hardware_bom()
    cached_load_time = time.perf_counter() - t0

    print(f"[+] Lần nạp thứ hai (Cached Load) : {cached_load_time * 1000:.2f} ms")

    # 3. Đánh giá điều kiện nghiệm thu (< 0.5s = 500 ms)
    target_limit_sec = 0.5
    print("-" * 60)
    if cold_load_time < target_limit_sec and cached_load_time < 0.05:
        print(f"✅ NGHIỆM THU ĐẠT: Thời gian nạp ({cold_load_time:.4f}s) nhỏ hơn rất nhiều so với ngưỡng 0.5s!")
    else:
        print("❌ CẢNH BÁO: Thời gian nạp vượt ngưỡng cho phép.")
    print("=" * 60)


if __name__ == "__main__":
    test_data_loader_performance()