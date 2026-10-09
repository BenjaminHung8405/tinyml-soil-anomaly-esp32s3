#!/usr/bin/env bash
# ==============================================================================
# Script: run_dashboard.sh
# Purpose: Kiểm tra môi trường, dependencies và khởi chạy Streamlit Dashboard
# Usage: ./scripts/run_dashboard.sh [--port PORT] [--host HOST] [--headless]
# ==============================================================================

set -euo pipefail

# 1. Xác định thư mục dự án
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

# Thiết lập các tham số mặc định (có thể override bằng biến môi trường hoặc arguments)
PORT="${STREAMLIT_PORT:-8501}"
HOST="${STREAMLIT_HOST:-localhost}"
HEADLESS="${STREAMLIT_HEADLESS:-false}"
EXTRA_ARGS=()

# Parse arguments dòng lệnh
while [[ $# -gt 0 ]]; do
    case "$1" in
        -p|--port)
            PORT="$2"
            shift 2
            ;;
        -h|--host)
            HOST="$2"
            shift 2
            ;;
        --headless)
            HEADLESS="true"
            shift
            ;;
        *)
            EXTRA_ARGS+=("$1")
            shift
            ;;
    esac
done

echo "=========================================================="
echo " KHỞI CHẠY HỆ THỐNG AG-IOT SOIL ANOMALY DASHBOARD"
echo " Project Root : $PROJECT_ROOT"
echo " Host / Port  : http://$HOST:$PORT"
echo "=========================================================="

# 2. Kiểm tra môi trường ảo Python
VENV_DIR="$PROJECT_ROOT/.venv"

if [ ! -d "$VENV_DIR" ]; then
    echo "[!] Môi trường ảo chưa tồn tại. Đang khởi tạo tại .venv..."
    python3 -m venv "$VENV_DIR"
    echo "[+] Đã tạo môi trường ảo thành công."

    echo "[+] Đang cài đặt thư viện phụ thuộc từ requirements.txt..."
    "$VENV_DIR/bin/pip" install --upgrade pip
    "$VENV_DIR/bin/pip" install -r requirements.txt
fi

# Kích hoạt venv
# shellcheck disable=SC1091
source "$VENV_DIR/bin/activate"

# 3. Kiểm tra streamlit đã cài đặt trong venv hay chưa
if ! command -v streamlit &> /dev/null; then
    echo "[!] Không tìm thấy lệnh 'streamlit' trong môi trường ảo."
    echo "[+] Đang tiến hành cài đặt bổ sung streamlit & plotly..."
    pip install streamlit plotly
fi

# 4. Kiểm tra file app.py chính
APP_FILE="$PROJECT_ROOT/dashboard/app.py"
if [ ! -f "$APP_FILE" ]; then
    echo "[X] Lỗi: Không tìm thấy file $APP_FILE!"
    exit 1
fi

# 5. Thiết lập PYTHONPATH để dashboard có thể import components trực tiếp
export PYTHONPATH="$PROJECT_ROOT:$PROJECT_ROOT/dashboard:${PYTHONPATH:-}"

# 6. Khởi chạy Streamlit Dashboard
CMD=(
    streamlit run "$APP_FILE"
    --server.port "$PORT"
    --server.address "$HOST"
    --server.headless "$HEADLESS"
    --theme.base "light"
)

if [ ${#EXTRA_ARGS[@]} -gt 0 ]; then
    CMD+=("${EXTRA_ARGS[@]}")
fi

echo "[+] Đang khởi chạy Streamlit..."
exec "${CMD[@]}"
