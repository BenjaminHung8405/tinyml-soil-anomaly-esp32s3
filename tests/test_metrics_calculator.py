"""
Test script: tests/test_metrics_calculator.py
Kiểm tra tính toán toán học của KPIMetricsCalculator trên các ca kiểm thử điển hình.
"""

import sys
import os
import numpy as np

# Thêm đường dẫn project
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from src.pipeline.edge_pipeline import EdgePipeline, PipelineResult
from src.pipeline.tflite_engine import TFLiteInferenceEngine
from src.pipeline.metrics_calculator import KPIMetricsCalculator


def test_metrics_calculation_cases():
    print("=" * 65)
    print("KIỂM ĐỊNH LOGIC TÍNH TOÁN KPI METRICS (TASK T1.2.4)")
    print("=" * 65)

    pipeline = EdgePipeline(tflite_engine=TFLiteInferenceEngine())
    
    # 1. TEST CASE 1: KỊCH BẢN CHUỖI SẠCH (NORMAL CASE)
    clean_win = np.full((32, 3), 0.35, dtype=np.float32)
    clean_win += np.random.normal(0, 0.002, (32, 3)).astype(np.float32)
    corrupt_win = clean_win.copy()

    res1 = pipeline.evaluate_window(corrupt_win)
    kpi1 = KPIMetricsCalculator.calculate_window_kpi(res1, clean_win, corrupt_win, target_channel=0)

    print("[+] Test Case 1 (Chuỗi sạch):")
    print(f"    - Status: {kpi1.status} | Color: {kpi1.status_color}")
    print(f"    - Relay: {kpi1.actuation_status} | Ct: {kpi1.ct_score:.4f}")
    assert kpi1.status == "NORMAL"
    assert kpi1.status_color == "success"
    assert kpi1.is_safe is True
    assert kpi1.mae_raw < 0.01

    # 2. TEST CASE 2: KỊCH BẢN LỖI 1 KÊNH (SPIKE TRÊN S1)
    corrupt_win_spike = clean_win.copy()
    corrupt_win_spike[-1, 0] += 0.15  # Gai nhọn tại mẫu cuối cùng của S1

    res2 = pipeline.evaluate_window(corrupt_win_spike)
    kpi2 = KPIMetricsCalculator.calculate_window_kpi(res2, clean_win, corrupt_win_spike, target_channel=0)

    print("\n[+] Test Case 2 (Spike Kênh S1):")
    print(f"    - Status: {kpi2.status} | Mask: {kpi2.fault_mask}")
    print(f"    - MAE Raw: {kpi2.mae_raw:.4f} -> MAE Imputed: {kpi2.mae_imputed:.4f}")
    print(f"    - Giảm MAE: {kpi2.mae_reduction_pct:.1f}% (Kỳ vọng: > 50%)")
    assert kpi2.status == "CHANNEL_FAULT"
    assert kpi2.fault_mask[0] is True
    assert kpi2.mae_reduction_pct > 50.0  # Phục hồi thành công làm giảm sai số đáng kể
    assert kpi2.is_safe is True

    # 3. TEST CASE 3: KỊCH BẢN HỎNG ĐA KÊNH (MULTI-FAULT -> FAIL-SAFE)
    corrupt_win_multi = clean_win.copy()
    corrupt_win_multi[:, 0] = 0.0   # S1 mất nguồn
    corrupt_win_multi[:, 1] = 0.95  # S2 chạm VCC

    res3 = pipeline.evaluate_window(corrupt_win_multi)
    kpi3 = KPIMetricsCalculator.calculate_window_kpi(res3, clean_win, corrupt_win_multi, target_channel=0)

    print("\n[+] Test Case 3 (Multi-Fault Fail-safe Lockout):")
    print(f"    - Status: {kpi3.status} | Color: {kpi3.status_color}")
    print(f"    - Relay Status: {kpi3.actuation_status} (An toàn: {kpi3.is_safe})")
    assert kpi3.status == "MULTI_FAULT"
    assert kpi3.status_color == "error"
    assert kpi3.is_safe is False
    assert kpi3.actuation_status == "KHÓA BƠM AN TOÀN"

    # 4. KIỂM TRA ĐỊNH DẠNG PAYLOAD XUẤT RA
    payload_dict = kpi2.to_dict()
    assert "anomaly_flag" in payload_dict
    assert "error_metrics" in payload_dict
    assert "latency" in payload_dict
    assert payload_dict["anomaly_flag"]["lucide_icon"] == "shield-alert"
    assert "<svg" in payload_dict["anomaly_flag"]["icon_svg"]
    assert payload_dict["latency"]["lucide_icon"] == "cpu"
    assert payload_dict["error_metrics"]["lucide_icon"] == "wand-sparkles"
    assert payload_dict["confidence"]["lucide_icon"] == "circle-check"

    print("\n" + "=" * 65)
    print("✅ TẤT CẢ TEST CASES ĐÃ ĐẠT: Bộ tính toán KPI đáp ứng 100% yêu cầu!")
    print("=" * 65)


if __name__ == "__main__":
    test_metrics_calculation_cases()
