"""
Test script: tests/test_edge_pipeline.py
Kiểm tra tính đúng đắn của TFLiteInferenceEngine và EdgePipeline.
"""

import sys
import os
import numpy as np

# Thêm đường dẫn project
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from src.pipeline.tflite_engine import TFLiteInferenceEngine
from src.pipeline.edge_pipeline import EdgePipeline


def test_edge_pipeline_scenarios():
    print("=" * 65)
    print("KIỂM ĐỊNH PIPELINE 7 TẦNG & SELECTIVE IMPUTATION (TASK T1.1.3)")
    print("=" * 65)

    engine = TFLiteInferenceEngine()
    pipeline = EdgePipeline(tflite_engine=engine, spatial_eps=0.05, threshold_tau=0.0075)

    # 1. KỊCH BẢN 1: Dữ liệu sạch, bình thường (Normal Case)
    base_window = np.full((32, 3), 0.35, dtype=np.float32)
    base_window += np.random.normal(0, 0.003, (32, 3))
    
    res1 = pipeline.evaluate_window(base_window, timestamp=1796123400)
    print(f"[+] Kịch bản 1 (Chuỗi sạch):")
    print(f"    - Raw: {res1.raw_current}")
    print(f"    - Ct score: {res1.confidence_score_ct:.4f} | Status: {res1.status_label}")
    print(f"    - Relay Safe: {res1.is_safe_for_actuation} | Mask: {res1.faulty_mask}")
    assert res1.status_label == "VALID"
    assert res1.is_safe_for_actuation is True
    assert not any(res1.faulty_mask)

    # 2. KỊCH BẢN 2: Lỗi Spike / Drift trên Kênh 0 (Single Sensor Fault)
    corrupted_win_1 = base_window.copy()
    corrupted_win_1[:, 0] += 0.25  # Kênh 0 vọt cao bất thường lên 0.60
    
    res2 = pipeline.evaluate_window(corrupted_win_1, timestamp=1796123460)
    print(f"\n[+] Kịch bản 2 (Lỗi Kênh 0 - Single Fault):")
    print(f"    - Raw: {[round(x, 3) for x in res2.raw_current]}")
    print(f"    - Faulty mask: {res2.faulty_mask}")
    print(f"    - MSE channels: {[round(x, 5) for x in res2.mse_channels]}")
    print(f"    - Imputed: {[round(x, 3) for x in res2.imputed_current]}")
    print(f"    - Status: {res2.status_label} | Relay Safe: {res2.is_safe_for_actuation}")
    assert res2.faulty_mask[0] is True
    assert res2.faulty_mask[1] is False and res2.faulty_mask[2] is False
    # Khẳng định kênh 0 được bù bằng giá trị của kênh 1 & 2
    assert abs(res2.imputed_current[0] - res2.imputed_current[1]) < 0.015

    # 3. KỊCH BẢN 3: Đứt cáp / Suy biến 2 kênh đồng thời (Multi-sensor Failure -> Lockout)
    corrupted_win_2 = base_window.copy()
    corrupted_win_2[:, 0] = 0.0   # Kênh 0 mất tín hiệu
    corrupted_win_2[:, 1] = 0.95  # Kênh 1 chạm nguồn
    
    res3 = pipeline.evaluate_window(corrupted_win_2, timestamp=1796123520)
    print(f"\n[+] Kịch bản 3 (Suy biến đa cảm biến - Fail-safe Trigger):")
    print(f"    - Raw: {[round(x, 3) for x in res3.raw_current]}")
    print(f"    - Ct score: {res3.confidence_score_ct:.4f} | Status: {res3.status_label}")
    print(f"    - Relay Safe: {res3.is_safe_for_actuation} (Khóa bơm an toàn!)")
    assert res3.status_label == "UNRELIABLE"
    assert res3.is_safe_for_actuation is False

    print("\n" + "=" * 65)
    print("✅ TẤT CẢ CÁC BÀI TEST NGHIỆM THU ĐẠT CHUẨN 100%!")
    print("=" * 65)


if __name__ == "__main__":
    test_edge_pipeline_scenarios()