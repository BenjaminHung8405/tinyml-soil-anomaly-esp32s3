"""
Test script: tests/test_hardware_economics.py
Kiểm tra tính đúng đắn toán học của bài toán luận chứng kinh tế BOM và TCO (Task T1.3.3).
"""

import sys
import os
import pandas as pd

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from src.pipeline.hardware_economics_loader import HardwareEconomicsLoader


def test_hardware_economics_math():
    print("=" * 65)
    print("KIỂM ĐỊNH BÀI TOÁN LUẬN CHỨNG KINH TẾ PHẦN CỨNG (TASK T1.3.3)")
    print("=" * 65)

    # 1. Khởi tạo và nạp dữ liệu BOM
    df_bom = HardwareEconomicsLoader.generate_default_bom_dataset()
    print(f"[+] Nạp thành công {len(df_bom)} hạng mục linh kiện BOM.")
    assert len(df_bom) == 7, "Bảng BOM phải chứa đúng 7 hạng mục chính"

    # 2. Kiểm tra tổng chi phí
    total_cost = df_bom["total_price_vnd"].sum()
    print(f"[+] Tổng chi phí cụm phần cứng Ag-IoT TinyML: {total_cost:,.0f} VNĐ")
    assert 300000 <= total_cost <= 400000, f"Tổng chi phí phải trong khoảng 300k - 400k, thực tế {total_cost}"

    # 3. Kiểm tra tỷ lệ tiết kiệm chi phí (> 60%)
    cost_comp = HardwareEconomicsLoader.calculate_cost_comparison()
    print(f"[+] Chi phí Cảm biến Công nghiệp đối chứng: {cost_comp['industrial_sensor_avg_vnd']:,.0f} VNĐ")
    print(f"[+] Số tiền tiết kiệm                 : {cost_comp['savings_vnd']:,.0f} VNĐ")
    print(f"[+] Tỷ lệ tiết kiệm chi phí           : {cost_comp['savings_pct']}% (Kỳ vọng: > 60.0%)")

    assert cost_comp["savings_pct"] >= 60.0, "Tỷ lệ tiết kiệm chi phí phải >= 60.0%!"

    # 4. Kiểm tra chi phí rủi ro thay thế cảm biến hỏng
    replace_pct = cost_comp["single_sensor_replace_pct"]
    print(f"[+] Chi phí thay 1 cảm biến MKE-S13 hỏng: {cost_comp['single_sensor_replace_cost_vnd']:,.0f} VNĐ ({replace_pct}% cảm biến công nghiệp)")
    assert replace_pct < 10.0, "Chi phí thay 1 cảm biến lẻ phải < 10% chi phí cảm biến công nghiệp!"

    # 5. Kiểm tra dữ liệu Radar Chart
    radar_data = HardwareEconomicsLoader.get_radar_chart_data()
    assert len(radar_data["categories"]) == 5, "Biểu đồ Radar phải có 5 tiêu chí so sánh"
    assert len(radar_data["proposed_scores"]) == 5
    assert len(radar_data["industrial_scores"]) == 5

    # 6. Kiểm tra dữ liệu mô phỏng TCO
    df_tco = HardwareEconomicsLoader.get_tco_simulation_data()
    assert len(df_tco) == 4, "Bảng TCO phải có 4 mốc thời gian"
    assert df_tco.iloc[-1]["Chênh lệch Tiết kiệm (VNĐ)"] > 1000000, "Tổng tiết kiệm sau 24 tháng phải vượt trội"

    print("=" * 65)
    print("✅ NGHIỆM THU ĐẠT: Luận chứng kinh tế phần cứng đạt chuẩn 100%!")
    print("=" * 65)


if __name__ == "__main__":
    test_hardware_economics_math()
