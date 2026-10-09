"""
Test script: tests/test_performance_and_cache.py
Kiểm tra hiệu năng truy xuất cache đệm, thời gian khởi tạo Singleton Pipeline
và đo đạc độ trễ xử lý đáp ứng chuẩn SLA < 100ms (Task T1.3.4).
"""

import sys
import os
import time

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from src.pipeline.pipeline_factory import get_cached_edge_pipeline
from src.pipeline.benchmark_t18_loader import BenchmarkT18Loader
from src.pipeline.benchmark_t19_loader import BenchmarkT19Loader
from src.pipeline.hardware_economics_loader import HardwareEconomicsLoader
from dashboard.components.state_manager import DashboardStateManager


def test_performance_and_caching():
    print("=" * 65)
    print("KIỂM ĐỊNH HIỆU NĂNG TỐI ƯU HÓA CACHE VÀ PHẢN HỒI (TASK T1.3.4)")
    print("=" * 65)

    # 1. Kiểm tra Singleton Resource cho EdgePipeline
    t0 = time.perf_counter()
    p1 = get_cached_edge_pipeline()
    t_init1 = (time.perf_counter() - t0) * 1000

    t0 = time.perf_counter()
    p2 = get_cached_edge_pipeline()
    t_init2 = (time.perf_counter() - t0) * 1000

    print(f"[+] Lần khởi tạo Pipeline đầu tiên : {t_init1:.2f} ms")
    print(f"[+] Lần lấy Pipeline từ Cache 2    : {t_init2:.4f} ms")
    assert p1 is p2, "Singleton Instance phải trả về cùng một đối tượng memory!"
    assert t_init2 < 1.0, "Lấy Instance từ cache phải dưới 1.0 ms!"

    # 2. Kiểm tra State Manager
    DashboardStateManager.initialize_state()
    DashboardStateManager.set_window_idx(108)
    assert DashboardStateManager.get_window_idx() == 108
    DashboardStateManager.set_channel(1)
    assert DashboardStateManager.get_channel() == 1
    DashboardStateManager.reset_all_state()
    assert DashboardStateManager.get_window_idx() == 108
    assert DashboardStateManager.get_channel() == 0
    print("[+] State Manager hoạt động chính xác và an toàn.")

    # 3. Kiểm tra tốc độ nạp dữ liệu từ CSV DataLoader Cache
    t0 = time.perf_counter()
    df_t18 = BenchmarkT18Loader.load_t18_data()
    df_t19 = BenchmarkT19Loader.load_t19_data()
    df_bom = HardwareEconomicsLoader.load_bom_data()
    t_data_load = (time.perf_counter() - t0) * 1000

    print(f"[+] Thời gian nạp đồng thời T18, T19, BOM: {t_data_load:.2f} ms")
    assert t_data_load < 50.0, "Thời gian nạp dữ liệu CSV phải dưới 50 ms!"

    # 4. Tổng thời gian xử lý toàn trình (Benchmark Performance)
    total_latency_ms = t_init2 + t_data_load
    print(f"[+] Tổng độ trễ phục vụ UI render     : {total_latency_ms:.2f} ms (Target: < 100 ms)")
    assert total_latency_ms < 100.0, "Độ trễ tổng thể vượt quá chuẩn 100 ms SLA!"

    print("=" * 65)
    print("✅ NGHIỆM THU ĐẠT: Tối ưu hóa Cache & Phản hồi UI đạt mốc Xuất sắc!")
    print("=" * 65)


if __name__ == "__main__":
    test_performance_and_caching()
