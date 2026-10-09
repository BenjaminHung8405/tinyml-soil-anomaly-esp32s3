"""
Test script: tests/test_plot_helpers.py
Kiểm tra tính đúng đắn và tốc độ tạo đối tượng biểu đồ của plot_helpers.py (Task T1.2.1).
"""

import os
import sys
import time
import numpy as np

# Thêm đường dẫn project
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from dashboard.components.plot_helpers import (
    plot_triplet_signals,
    plot_confidence_gauge,
    plot_channel_mse_bar,
    plot_spatial_consistency,
)


def test_plot_helpers_execution():
    print("=" * 65)
    print("KIỂM ĐỊNH MODULE BIỂU ĐỒ PLOTLY PLOT_HELPERS (TASK T1.2.1)")
    print("=" * 65)

    # 1. Giả lập dữ liệu 3 đường tín hiệu cho cửa sổ 32 mẫu
    w_size = 32
    clean_data = np.full(w_size, 0.35)
    corrupt_data = clean_data.copy()
    corrupt_data[15] += 0.30  # Lỗi Spike tại mẫu 15
    imputed_data = clean_data.copy()

    # Warmup để nạp các bộ validator schema nội bộ của thư viện Plotly
    _ = plot_triplet_signals(clean_data, corrupt_data, imputed_data, channel_name="S1")

    # 2. Đo thời gian sinh biểu đồ 3 đường tín hiệu (Steady-state)
    t0 = time.perf_counter()
    fig_triplet = plot_triplet_signals(clean_data, corrupt_data, imputed_data, channel_name="S1")
    t_triplet = (time.perf_counter() - t0) * 1000
    print(f"[+] Sinh biểu đồ plot_triplet_signals thành công: {t_triplet:.2f} ms")
    assert len(fig_triplet.data) >= 3, "Biểu đồ phải chứa ít nhất 3 trace dữ liệu!"

    # 3. Đo thời gian sinh Gauge Chart
    t0 = time.perf_counter()
    fig_gauge = plot_confidence_gauge(ct_score=0.925, status_label="VALID")
    t_gauge = (time.perf_counter() - t0) * 1000
    print(f"[+] Sinh biểu đồ plot_confidence_gauge thành công: {t_gauge:.2f} ms")
    assert len(fig_gauge.data) == 1, "Gauge chart phải khởi tạo hợp lệ!"

    # 4. Đo thời gian sinh Channel MSE Bar Chart
    t0 = time.perf_counter()
    mse_vals = [0.0152, 0.0012, 0.0015]  # Kênh 0 vượt ngưỡng
    fig_bar = plot_channel_mse_bar(mse_channels=mse_vals, threshold_tau=0.0075)
    t_bar = (time.perf_counter() - t0) * 1000
    print(f"[+] Sinh biểu đồ plot_channel_mse_bar thành công: {t_bar:.2f} ms")
    assert len(fig_bar.data) == 1, "Bar chart phải khởi tạo hợp lệ!"

    # 5. Đo thời gian sinh Spatial Consistency Chart
    t0 = time.perf_counter()
    sensor_win = np.column_stack([clean_data, corrupt_data, clean_data])
    fig_spatial = plot_spatial_consistency(sensor_win, tolerance_delta=0.05)
    t_spatial = (time.perf_counter() - t0) * 1000
    print(f"[+] Sinh biểu đồ plot_spatial_consistency thành công: {t_spatial:.2f} ms")
    assert len(fig_spatial.data) >= 3, "Spatial chart phải chứa ít nhất 3 đường cảm biến!"

    # 6. Tổng thời gian sinh trọn bộ biểu đồ trong runtime thực tế
    total_time = t_triplet + t_gauge + t_bar + t_spatial
    print("-" * 65)
    print(f"Tổng thời gian sinh toàn bộ 4 biểu đồ: {total_time:.2f} ms")
    assert total_time < 50.0, f"Thời gian sinh biểu đồ vượt quá 50ms ({total_time:.2f} ms)!"
    print("✅ NGHIỆM THU ĐẠT: Module plot_helpers.py hoạt động chuẩn xác và cực nhanh (< 50ms)!")
    print("=" * 65)


if __name__ == "__main__":
    test_plot_helpers_execution()
