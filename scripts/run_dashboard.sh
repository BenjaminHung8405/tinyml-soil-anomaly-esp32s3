#!/usr/bin/env bash
# ==============================================================================
# Script: run_dashboard.sh
# Purpose: Kiểm tra môi trường và khởi chạy Streamlit Dashboard Khóa Luận Tốt Nghiệp
# ==============================================================================

set -e

# Xác định thư mục gốc của repository
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "=========================================================="
echo " KHỞI CHẠY HỆ THỐNG AG-IOT SOIL ANOMALY DASHBOARD"
echo " Project Root: $PROJECT_ROOT"
echo "=========================================================="

# 1. Kiểm tra môi trường ảo Python
VENV_DIR="$PROJECT_ROOT/.venv"

if [ ! -d "$VENV_DIR" ]; then
    echo "[!] Môi trường ảo chưa tồn tại. Đang khởi tạo tại .venv..."
    python3 -m venv "$VENV_DIR"
    echo "[+] Đã tạo môi trường ảo thành công."
    
    echo "[+] Cài đặt các gói phụ thuộc từ requirements.txt..."
    source "$VENV_DIR/bin/activate"
    pip install --upgrade pip
    pip install -r requirements.txt
else
    source "$VENV_DIR/bin/activate"
    echo "[+] Môi trường ảo .venv đã được kích hoạt."
fi

# 2. Khởi tạo thư mục dashboard mẫu nếu chưa có file app.py
if [ ! -f "$PROJECT_ROOT/dashboard/app.py" ]; then
    echo "[!] Chưa tìm thấy dashboard/app.py. Khởi tạo trang chính mẫu..."
    mkdir -p "$PROJECT_ROOT/dashboard/pages"
    cat << 'EOF' > "$PROJECT_ROOT/dashboard/app.py"
import streamlit as st

st.set_page_config(
    page_title="Ag-IoT Soil Anomaly Pipeline",
    page_icon="🌱",
    layout="wide"
)

st.title("🌱 Ag-IoT Soil Anomaly Detection & Adaptive Imputation")
st.markdown("---")
st.success("Hệ thống khởi chạy thành công! Sprint 1.1 đã sẵn sàng.")
st.info("Vui lòng chọn các chuyên đề bên thanh điều hướng để xem chi tiết kiến trúc.")
EOF
fi

# 3. Khởi chạy Streamlit
echo "[+] Khởi chạy Streamlit trên cổng mặc định (http://localhost:8501)..."
streamlit run "$PROJECT_ROOT/dashboard/app.py"
