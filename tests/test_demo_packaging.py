"""
Test script: tests/test_demo_packaging.py
Kiểm tra tính toàn vẹn của gói phân phối Offline Demo cho Sprint 1.3:
- Kiểm tra sự tồn tại của script run_dashboard.sh và quyền thực thi
- Kiểm tra file requirements_demo.txt
- Kiểm tra tài liệu kịch bản docs/DEMO_GUIDE.md
- Kiểm tra đầy đủ 5 trang giao diện Streamlit
"""

import sys
import os
import stat

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))


def test_demo_packaging_integrity():
    print("=" * 65)
    print("KIỂM ĐỊNH ĐÓNG GÓI & KỊCH BẢN DEMO OFFLINE (TASK T1.3.5)")
    print("=" * 65)

    base_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))

    # 1. Kiểm tra file requirements_demo.txt
    req_file = os.path.join(base_dir, "requirements_demo.txt")
    print(f"[+] Kiểm tra file cấu hình phụ thuộc: {req_file}")
    assert os.path.exists(req_file), "Cần có file requirements_demo.txt!"

    # 2. Kiểm tra script scripts/run_dashboard.sh
    script_file = os.path.join(base_dir, "scripts", "run_dashboard.sh")
    print(f"[+] Kiểm tra script khởi chạy: {script_file}")
    assert os.path.exists(script_file), "Cần có script scripts/run_dashboard.sh!"
    
    # Kiểm tra quyền thực thi (executable flag)
    st = os.stat(script_file)
    is_executable = bool(st.st_mode & stat.S_IXUSR)
    print(f"    -> Quyền thực thi script (Executable): {is_executable}")
    assert is_executable, "Script run_dashboard.sh phải có quyền thực thi (chmod +x)!"

    # 3. Kiểm tra tài liệu kịch bản docs/DEMO_GUIDE.md
    guide_file = os.path.join(base_dir, "docs", "DEMO_GUIDE.md")
    print(f"[+] Kiểm tra tài liệu kịch bản: {guide_file}")
    assert os.path.exists(guide_file), "Cần có tài liệu docs/DEMO_GUIDE.md!"

    # 4. Kiểm tra sự tồn tại của 5 trang Streamlit trong dashboard/pages/
    pages_dir = os.path.join(base_dir, "dashboard", "pages")
    expected_pages = [
        "1_Interactive_Fault_Visualizer.py",
        "2_System_Architecture.py",
        "3_Hardware_Economics.py",
        "4_Benchmark_Comparison.py",
        "5_System_Diagnostic.py"
    ]

    for p in expected_pages:
        p_path = os.path.join(pages_dir, p)
        exists = os.path.exists(p_path)
        print(f"    -> Trang {p}: {'SẴN SÀNG' if exists else 'THIẾU'}")
        assert exists, f"Thiếu file trang Streamlit {p}!"

    print("=" * 65)
    print("✅ NGHIỆM THU ĐẠT: Gói ứng dụng Offline và Kịch bản Demo 5 phút sẵn sàng 100%!")
    print("=" * 65)


if __name__ == "__main__":
    test_demo_packaging_integrity()
