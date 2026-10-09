#!/usr/bin/env bash
# ==============================================================================
# Script: scripts/run_dashboard.sh
# Purpose: Tự động khởi chạy Dashboard Ag-IoT ở Chế độ Offline cho Buổi Demo 5 Phút
# Project: TinyML Soil Anomaly Detection & Adaptive Imputation (ESP32-S3)
# ==============================================================================

set -e

# Xác định thư mục gốc của repository
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "======================================================================"
echo " 🌱 AG-IOT TINYML SOIL ANOMALY DASHBOARD - DEMO LAUNCHER"
echo " Project Root: $PROJECT_ROOT"
echo " Mode        : Standalone Offline Presentation"
echo "======================================================================"

# 1. Kiểm tra môi trường ảo Python
VENV_DIR="$PROJECT_ROOT/.venv"

if [ ! -d "$VENV_DIR" ]; then
    echo "[!] Môi trường ảo chưa tồn tại. Đang khởi tạo tại .venv..."
    python3 -m venv "$VENV_DIR"
    echo "[+] Đã tạo môi trường ảo thành công."
    
    echo "[+] Cài đặt các gói phụ thuộc từ requirements_demo.txt..."
    # shellcheck disable=SC1091
    source "$VENV_DIR/bin/activate"
    pip install --upgrade pip
    pip install -r requirements_demo.txt
else
    # shellcheck disable=SC1091
    source "$VENV_DIR/bin/activate"
    echo "[+] Đã kích hoạt môi trường ảo Python: $(python3 --version)"
fi

# 2. Khởi tạo và kiểm tra tính sẵn sàng của bộ dữ liệu đối chuẩn
echo "[+] Kiểm tra tính sẵn sàng của bộ dữ liệu đối chuẩn..."
python3 -c "
from src.pipeline.benchmark_t18_loader import BenchmarkT18Loader
from src.pipeline.benchmark_t19_loader import BenchmarkT19Loader
from src.pipeline.hardware_economics_loader import HardwareEconomicsLoader
BenchmarkT18Loader.load_t18_data()
BenchmarkT19Loader.load_t19_data()
HardwareEconomicsLoader.load_bom_data()
print('    -> Đã xác nhận đầy đủ bộ dữ liệu CSV: T18, T19, BOM.')
"

# 3. Cấu hình biến môi trường Streamlit Offline
export STREAMLIT_BROWSER_GATHER_USAGE_STATS=false
export STREAMLIT_SERVER_HEADLESS=false
export PYTHONPATH="$PROJECT_ROOT:$PROJECT_ROOT/dashboard:${PYTHONPATH:-}"

echo "======================================================================"
echo " 🚀 Đang khởi chạy Streamlit Dashboard trên cổng http://localhost:8501"
echo " Nhấn Ctrl+C để dừng hệ thống."
echo "======================================================================"

streamlit run "$PROJECT_ROOT/dashboard/app.py" \
    --server.port=8501 \
    --server.address=localhost \
    --theme.base="light" \
    --theme.primaryColor="#10b981"
