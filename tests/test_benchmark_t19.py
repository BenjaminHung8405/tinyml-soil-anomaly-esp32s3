"""
Test script: tests/test_benchmark_t19.py
Kiểm tra tính đúng đắn toán học của ma trận đối chuẩn phục hồi dữ liệu T19.
Bao gồm:
1. Tính toàn vẹn cấu trúc dữ liệu (48 bản ghi: 4 phương pháp x 4 dạng lỗi x 3 mức độ)
2. Tính đúng đắn công thức giảm sai số % Reduction MAE và RMSE
3. Tiêu chuẩn nghiệm thu đề tài: Proposed INT8 giảm MAE >= 40.0% (thực tế >= 75.0%)
4. Khả năng phục hồi vượt trội ở dạng lỗi khó Drift (vượt Hampel ít nhất 50%)
5. Kiểm tra cấu hình thẻ KPI Cards và Lucide metadata (chuẩn báo cáo KLTN)
"""

import sys
import os
import pandas as pd

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from src.pipeline.benchmark_t19_loader import BenchmarkT19Loader


def test_t19_benchmark_math():
    print("=" * 70)
    print("KIỂM ĐỊNH TOÁN HỌC MA TRẬN ĐỐI CHUẨN PHỤC HỒI DỮ LIỆU T19")
    print("=" * 70)

    # 1. Khởi tạo và nạp dữ liệu
    df_raw = BenchmarkT19Loader.generate_default_t19_dataset()
    print(f"[+] Khởi tạo thành công {len(df_raw)} bản ghi ma trận T19.")
    assert len(df_raw) == 48, f"Kỳ vọng 48 bản ghi, nhận được {len(df_raw)}"

    # 2. Kiểm tra tính toàn vẹn công thức % Reduction
    for idx, row in df_raw.iterrows():
        expected_reduc = ((row["mae_raw"] - row["mae_imputed"]) / row["mae_raw"]) * 100.0
        assert abs(row["mae_reduction_pct"] - expected_reduc) < 0.15, (
            f"Lỗi công thức MAE Reduction tại dòng {idx}: tính {row['mae_reduction_pct']} vs kỳ vọng {expected_reduc}"
        )

        expected_rmse_reduc = ((row["rmse_raw"] - row["rmse_imputed"]) / row["rmse_raw"]) * 100.0
        assert abs(row["rmse_reduction_pct"] - expected_rmse_reduc) < 0.15, (
            f"Lỗi công thức RMSE Reduction tại dòng {idx}"
        )

    print("[+] Kiểm định công thức MAE/RMSE Reduction: HOÀN HẢO 100%.")

    # 3. Kiểm tra chỉ tiêu đề cương: Proposed đạt reduction >= 40% (thực tế >= 75%)
    summary = BenchmarkT19Loader.get_summary_by_method(df_raw)
    proposed_reduc = summary.loc[summary["method_name"] == "Proposed: Hybrid TinyML INT8", "mae_reduction_pct"].values[0]

    print(f"[+] Proposed INT8 Average MAE Reduction : {proposed_reduc:.2f}% (Mục tiêu đề tài: >= 40.0%)")
    assert proposed_reduc >= 40.0, f"Phương pháp đề xuất phải giảm MAE >= 40.0%! Nhận: {proposed_reduc}"
    assert proposed_reduc >= 75.0, f"Thực tế kiểm thử Proposed INT8 phải đạt MAE Reduction >= 75.0%! Nhận: {proposed_reduc}"

    # 4. Kiểm tra xử lý kịch bản lỗi Drift (Trôi dốc)
    df_drift = BenchmarkT19Loader.load_t19_data(fault_filter="Drift")
    summary_drift = BenchmarkT19Loader.get_summary_by_method(df_drift)
    
    proposed_drift_reduc = summary_drift.loc[summary_drift["method_name"] == "Proposed: Hybrid TinyML INT8", "mae_reduction_pct"].values[0]
    hampel_drift_reduc = summary_drift.loc[summary_drift["method_name"] == "Baseline 2: Bộ lọc Hampel", "mae_reduction_pct"].values[0]

    print(f"[+] Lỗi Drift - Proposed MAE Reduction : {proposed_drift_reduc:.2f}%")
    print(f"[+] Lỗi Drift - Hampel MAE Reduction   : {hampel_drift_reduc:.2f}%")
    assert proposed_drift_reduc > hampel_drift_reduc + 50.0, "Proposed phải vượt trội hơn Hampel ít nhất 50% ở lỗi Drift!"

    # 5. Kiểm tra hàm trích xuất KPI Cards & Lucide icon metadata
    cards = BenchmarkT19Loader.get_kpi_cards_payload(df_raw)
    assert len(cards) == 4, f"Kỳ vọng 4 thẻ KPI phương pháp, nhận được {len(cards)}"
    assert cards[0]["is_proposed"] is True
    assert cards[0]["lucide_icon"] == "sparkles"
    assert "icon_svg" in cards[0]
    print(f"[+] KPI Cards Payload & Lucide Metadata: HOÀN TOÀN CHÍNH XÁC (4/4 thẻ).")

    print("=" * 70)
    print("✅ NGHIỆM THU ĐẠT: Backend xử lý Ma trận T19 & Test Suite hoàn tất 100%!")
    print("=" * 70)


if __name__ == "__main__":
    test_t19_benchmark_math()
