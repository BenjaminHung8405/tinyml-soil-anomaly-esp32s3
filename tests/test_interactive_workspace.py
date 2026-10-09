"""
Test script: tests/test_interactive_workspace.py
Kiểm tra khả năng sinh biểu đồ và tính toán của Main Workspace A/B (Task T1.2.3).
"""

import sys
import os
import time

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from dashboard.components.data_loader import load_sample_windows_with_metadata
from dashboard.components.plot_helpers import plot_triplet_signals, plot_multichannel_spatial_grid
from src.pipeline.edge_pipeline import EdgePipeline
from src.pipeline.tflite_engine import TFLiteInferenceEngine


def test_workspace_modes():
    print("=" * 65)
    print("KIỂM ĐỊNH MAIN WORKSPACE SO SÁNH A/B (TASK T1.2.3)")
    print("=" * 65)

    X_clean, X_corrupt, df_meta = load_sample_windows_with_metadata()
    pipeline = EdgePipeline(tflite_engine=TFLiteInferenceEngine())

    # Warm-up plotly
    _ = plot_triplet_signals(
        X_clean[0, :, 0],
        X_corrupt[0, :, 0],
        X_corrupt[0, :, 0],
        channel_name="S1"
    )

    # Kiểm tra kịch bản lỗi mẫu (kịch bản 108)
    test_idx = 108
    t0 = time.perf_counter()
    res = pipeline.evaluate_window(X_corrupt[test_idx])

    # 1. Test Mode 1 Kênh
    fig1 = plot_triplet_signals(
        X_clean[test_idx, :, 0],
        X_corrupt[test_idx, :, 0],
        X_corrupt[test_idx, :, 0],
        channel_name="S1"
    )
    assert len(fig1.data) >= 3, "Mode 1 kênh phải có đủ ít nhất 3 traces!"

    # 2. Test Mode Cụm 3 Kênh
    fig_grid = plot_multichannel_spatial_grid(
        X_clean_win=X_clean[test_idx],
        X_corrupt_win=X_corrupt[test_idx],
        imputed_current=res.imputed_current,
        faulty_mask=res.faulty_mask
    )
    assert len(fig_grid.data) >= 6, "Mode 3 kênh phải render đầy đủ traces!"

    total_calc_ms = (time.perf_counter() - t0) * 1000
    print(f"[+] Thời gian tính toán và tạo biểu đồ cả 2 views: {total_calc_ms:.2f} ms")
    assert total_calc_ms < 60.0, f"Thời gian tính toán vượt ngưỡng 60ms ({total_calc_ms:.2f} ms)!"

    print("=" * 65)
    print("✅ NGHIỆM THU ĐẠT: Không gian làm việc A/B phản hồi cực nhanh, sẵn sàng!")
    print("=" * 65)


if __name__ == "__main__":
    test_workspace_modes()
