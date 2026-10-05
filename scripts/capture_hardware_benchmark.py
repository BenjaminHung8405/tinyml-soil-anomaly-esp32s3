import os
import sys
import time
import serial
import serial.tools.list_ports

REPORTS_DIR = "reports"
os.makedirs(REPORTS_DIR, exist_ok=True)
CSV_OUT_PATH = os.path.join(REPORTS_DIR, "hardware_benchmarks.csv")
BIN_PATH = os.path.join("firmware_tflm_esp32s3", ".pio", "build", "esp32-s3-devkitc-1", "firmware.bin")

# 1. Kiểm tra dung lượng file nhị phân
if os.path.exists(BIN_PATH):
    flash_firmware_bytes = os.path.getsize(BIN_PATH)
    flash_firmware_kb = flash_firmware_bytes / 1024.0
    print(f"[*] Dung luong file firmware.bin: {flash_firmware_bytes} bytes ({flash_firmware_kb:.2f} KB)")
else:
    flash_firmware_kb = 0.0
    print("[!] Khong tim thay firmware.bin")

# 2. Tìm cổng Serial
ports = list(serial.tools.list_ports.comports())
target_port = None
for p in ports:
    if any(k in p.device.lower() for k in ["usbmodem", "usbserial", "ch340", "cp210"]):
        target_port = p.device
        break

if not target_port and ports:
    target_port = ports[0].device

if not target_port:
    print("[!] Khong tim thay cong Serial!")
    sys.exit(1)

print(f"[*] Mo cong: {target_port} @ 115200 bps")
ser = serial.Serial(target_port, 115200, timeout=1.0)
time.sleep(1.5)

# Xóa buffer và gửi lệnh 'B' kích hoạt
ser.reset_input_buffer()
print("[*] Gui lenh 'B' kich hoat Benchmark tren ESP32-S3...")
ser.write(b"B\n")
ser.flush()

# 3. Thu thập dữ liệu
lines_captured = []
is_capturing = False
timeout_start = time.time()

while time.time() - timeout_start < 8.0:
    line = ser.readline().decode("utf-8", errors="ignore").strip()
    if not line:
        continue
    print(f"    [ESP32] {line}")
    if "[CSV_EXPORT_BEGIN]" in line:
        is_capturing = True
        continue
    if "[CSV_EXPORT_END]" in line:
        break
    if is_capturing:
        lines_captured.append(line)

ser.close()

if not lines_captured:
    print("[!] Khong ghi nhan duoc du lieu CSV tu ESP32-S3! Hay kiem tra ket noi.")
    sys.exit(1)

# Bổ sung chỉ số Flash
flash_status = "PASSED" if flash_firmware_kb < 500.0 else "WARNING"
lines_captured.append(f"flash_firmware_size,{flash_firmware_kb:.2f},KB,< 500.0,{flash_status}")

with open(CSV_OUT_PATH, "w", encoding="utf-8") as f:
    for l in lines_captured:
        f.write(l + "\n")

print(f"\n[+] Da xuat thanh cong bang so lieu: {CSV_OUT_PATH}\n")
with open(CSV_OUT_PATH, "r") as f:
    print(f.read())