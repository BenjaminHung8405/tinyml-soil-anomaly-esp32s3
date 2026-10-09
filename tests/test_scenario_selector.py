"""
Test script: tests/test_scenario_selector.py
Kiểm tra tính toàn vẹn của metadata 126 cửa sổ (108 sạch, 18 lỗi).
Bao hàm tỷ lệ phân bổ, shape dữ liệu, và các trường thông tin metadata.
"""

import sys
import os
import pandas as pd
import numpy as np

# Thêm đường dẫn project root
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from dashboard.components.data_loader import load_sample_windows_with_metadata


def test_scenario_distribution():
    print("=" * 65)
    print("KIỂM ĐỊNH BỘ ĐIỀU KHIỂN KỊCH BẢN (TASK T1.2.2)")
    print("=" * 65)

    X_clean, X_corrupt, df_meta = load_sample_windows_with_metadata()

    # 1. Kiểm tra tổng số mẫu & tensor shape
    print(f"[*] Tensor X_clean shape  : {X_clean.shape}")
    print(f"[*] Tensor X_corrupt shape: {X_corrupt.shape}")
    assert len(df_meta) == 126, f"Tổng số cửa sổ phải là 126, nhận được {len(df_meta)}"
    assert X_clean.shape == (126, 32, 3), f"X_clean shape không chuẩn: {X_clean.shape}"
    assert X_corrupt.shape == (126, 32, 3), f"X_corrupt shape không chuẩn: {X_corrupt.shape}"

    # 2. Kiểm tra tỷ lệ 108 Sạch : 18 Lỗi
    num_clean = len(df_meta[df_meta["status"] == "Sạch (Normal)"])
    num_faulty = len(df_meta[df_meta["status"] == "Tiêm Lỗi (Faulty)"])

    print(f"[+] Số cửa sổ Sạch  : {num_clean} / 126 ({num_clean/126*100:.1f}%)")
    print(f"[+] Số cửa sổ Lỗi   : {num_faulty} / 126 ({num_faulty/126*100:.1f}%)")

    assert num_clean == 108, f"Kỳ vọng đúng 108 cửa sổ sạch, thực tế {num_clean}"
    assert num_faulty == 18, f"Kỳ vọng đúng 18 cửa sổ lỗi, thực tế {num_faulty}"

    # 3. Kiểm tra phân bổ 4 dạng lỗi
    fault_counts = df_meta[df_meta["status"] == "Tiêm Lỗi (Faulty)"]["fault_type"].value_counts().to_dict()
    print(f"[+] Phân bổ 4 dạng lỗi: {fault_counts}")
    assert "Spike" in fault_counts, "Thiếu lỗi Spike"
    assert "Noise" in fault_counts, "Thiếu lỗi Noise"
    assert "Stuck-at" in fault_counts, "Thiếu lỗi Stuck-at"
    assert "Drift" in fault_counts, "Thiếu lỗi Drift"

    # Kiểm tra tổng 18 cửa sổ lỗi
    assert sum(fault_counts.values()) == 18, "Tổng các dạng lỗi phải bằng 18"

    # 4. Kiểm tra tính toàn vẹn của DataFrame metadata
    required_cols = ["window_idx", "status", "fault_type", "severity", "target_channel", "description"]
    for col in required_cols:
        assert col in df_meta.columns, f"Thiếu cột {col} trong df_metadata"
        assert not df_meta[col].isnull().any(), f"Cột {col} chứa giá trị null"

    # 5. Kiểm tra tính đồng nhất của 108 cửa sổ sạch (X_clean == X_corrupt)
    for idx in range(108):
        diff = np.max(np.abs(X_clean[idx] - X_corrupt[idx]))
        assert diff < 1e-6, f"Cửa sổ sạch #{idx} bị sai lệch so với corrupt: {diff}"

    # 6. Kiểm tra sự sai khác của 18 cửa sổ lỗi (X_clean != X_corrupt)
    corrupted_count = 0
    for idx in range(108, 126):
        diff = np.max(np.abs(X_clean[idx] - X_corrupt[idx]))
        if diff > 1e-4:
            corrupted_count += 1
    assert corrupted_count == 18, f"Kỳ vọng đúng 18 cửa sổ lỗi có sai khác, thực tế {corrupted_count}"

    print("=" * 65)
    print("✅ NGHIỆM THU ĐẠT: Bộ dữ liệu phân bổ chuẩn 108 sạch : 18 lỗi!")
    print("=" * 65)


if __name__ == "__main__":
    test_scenario_distribution()
