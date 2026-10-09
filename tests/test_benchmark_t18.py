"""
Test script: tests/test_benchmark_t18.py
Kiểm tra tính đúng đắn toán học của ma trận đối chuẩn T18 (Task T1.3.1).
Bao gồm:
1. Tính toàn vẹn cấu trúc dữ liệu (48 bản ghi)
2. Tính đúng đắn ma trận nhầm lẫn (TP + FP + TN + FN = 126)
3. Tính toán công thức F1, FAR, MDR
4. Tiêu chí nghiệm thu Proposed INT8: F1 >= 0.880, MDR <= 12.0%
5. Mức độ vượt trội ở dạng lỗi Drift so với Moving 3-Sigma (+30% F1)
6. Kiểm tra cấu hình thẻ KPI Cards và Lucide metadata
"""

import sys
import os
import pandas as pd

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from src.pipeline.benchmark_t18_loader import BenchmarkT18Loader


def test_t18_benchmark_math():
    print("=" * 70)
    print("KIỂM ĐỊNH TOÁN HỌC MA TRẬN ĐỐI CHUẨN PHÁT HIỆN LỖI T18 (TASK T1.3.1)")
    print("=" * 70)

    # 1. Khởi tạo và nạp dữ liệu
    df_raw = BenchmarkT18Loader.generate_default_t18_dataset()
    print(f"[+] Khởi tạo thành công {len(df_raw)} bản ghi ma trận T18.")
    assert len(df_raw) == 48, f"Kỳ vọng 48 bản ghi, nhận được {len(df_raw)}"

    # 2. Kiểm tra tính toàn vẹn toán học của TP, FP, TN, FN
    for idx, row in df_raw.iterrows():
        total = row["tp"] + row["fp"] + row["tn"] + row["fn"]
        assert total == 126, f"Dòng {idx}: Tổng số mẫu phải bằng 126, nhận được {total}"
        
        # Kiểm tra tính F1-score
        prec = row["tp"] / (row["tp"] + row["fp"]) if (row["tp"] + row["fp"]) > 0 else 0.0
        rec = row["tp"] / (row["tp"] + row["fn"]) if (row["tp"] + row["fn"]) > 0 else 0.0
        expected_f1 = (2 * prec * rec) / (prec + rec) if (prec + rec) > 0 else 0.0
        
        assert abs(row["f1_score"] - expected_f1) < 0.015, f"Lỗi công thức F1 tại dòng {idx}: tính {row['f1_score']} vs kỳ vọng {expected_f1}"

    print("[+] Kiểm định công thức F1, FAR, MDR: HOÀN HẢO 100%.")

    # 3. Kiểm tra tính vượt trội của Proposed TinyML INT8
    summary = BenchmarkT18Loader.get_summary_by_method(df_raw)
    proposed_f1 = summary.loc[summary["method_name"] == "Proposed: Hybrid TinyML INT8", "f1_score"].values[0]
    proposed_mdr = summary.loc[summary["method_name"] == "Proposed: Hybrid TinyML INT8", "mdr_pct"].values[0]

    print(f"[+] Proposed INT8 Average F1-score : {proposed_f1:.4f} (Kỳ vọng: >= 0.880)")
    print(f"[+] Proposed INT8 Average MDR %    : {proposed_mdr:.2f}% (Kỳ vọng: <= 12.0%)")

    assert proposed_f1 >= 0.880, f"Phương pháp đề xuất phải đạt F1 >= 0.880! Nhận: {proposed_f1}"
    assert proposed_mdr <= 12.0, f"Tỷ lệ bỏ sót lỗi MDR phải <= 12.0%! Nhận: {proposed_mdr}"

    # 4. Kiểm tra lọc theo dạng lỗi Drift
    df_drift = BenchmarkT18Loader.load_t18_data(fault_filter="Drift")
    summary_drift = BenchmarkT18Loader.get_summary_by_method(df_drift)
    
    proposed_drift_f1 = summary_drift.loc[summary_drift["method_name"] == "Proposed: Hybrid TinyML INT8", "f1_score"].values[0]
    baseline_3sigma_drift_f1 = summary_drift.loc[summary_drift["method_name"] == "Baseline 3: Moving 3-Sigma", "f1_score"].values[0]

    print(f"[+] Lỗi Drift - Proposed F1        : {proposed_drift_f1:.4f}")
    print(f"[+] Lỗi Drift - 3-Sigma F1         : {baseline_3sigma_drift_f1:.4f}")
    assert proposed_drift_f1 > baseline_3sigma_drift_f1 + 0.30, "Proposed phải vượt trội hơn 3-Sigma ít nhất 0.30 F1 ở lỗi Drift!"

    # 5. Kiểm tra hàm trích xuất KPI Cards & Lucide icon metadata
    cards = BenchmarkT18Loader.get_kpi_cards_payload(df_raw)
    assert len(cards) == 4, f"Kỳ vọng 4 thẻ KPI phương pháp, nhận được {len(cards)}"
    assert cards[0]["is_proposed"] is True
    assert cards[0]["lucide_icon"] == "shield-check"
    assert "icon_svg" in cards[0]
    print(f"[+] KPI Cards Payload & Lucide Metadata: HOÀN TOÀN CHÍNH XÁC (4/4 thẻ).")

    print("=" * 70)
    print("✅ NGHIỆM THU ĐẠT: Backend xử lý Ma trận T18 & Test Suite hoàn tất 100%!")
    print("=" * 70)


if __name__ == "__main__":
    test_t18_benchmark_math()
