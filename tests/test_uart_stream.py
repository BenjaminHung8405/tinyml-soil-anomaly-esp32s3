import os
import sys
import time
import struct
import json
import serial
import serial.tools.list_ports
import numpy as np

# 1. Tìm cổng Serial của ESP32-S3
ports = list(serial.tools.list_ports.comports())
target_port = None
for p in ports:
    if "usbmodem" in p.device.lower() or "usbserial" in p.device.lower() or "ch340" in p.device.lower() or "cp210" in p.device.lower():
        target_port = p.device
        break

if not target_port:
    if len(ports) > 0:
        target_port = ports[0].device
    else:
        print("[!] Khong tim thay cong Serial nao! Hay kiem tra ket noi cap USB.")
        sys.exit(1)

print(f"[*] Ket noi den cong: {target_port} (Baudrate: 115200)")
ser = serial.Serial(target_port, 115200, timeout=1.0)
time.sleep(2.0)  # Cho ESP32-S3 reset CDC
ser.reset_input_buffer()

# 2. Nap tap du lieu kiem thu test_fault_injected.npy
DATA_PATH = os.path.join("data", "processed", "test_fault_injected.npy")
X_test = np.load(DATA_PATH) # (126, 32, 1)
total_windows = len(X_test)
print(f"[*] Nap thanh cong {total_windows} cua so kiem thu.")

# 3. Dong goi va truyen tung khung
acked_count = 0
start_time = time.time()

for idx in range(total_windows):
    samples = X_test[idx].flatten().astype(np.float32)
    payload_bytes = struct.pack(f"{len(samples)}f", *samples)

    # Tinh XOR Checksum tren payload
    checksum = 0
    for b in payload_bytes:
        checksum ^= b

    # Header(2) + Index(2) + Payload(128) + Checksum(1) + Tail(2)
    frame = bytearray([0xAA, 0x55])
    frame.extend(struct.pack("<H", idx))
    frame.extend(payload_bytes)
    frame.append(checksum)
    frame.extend([0x0D, 0x0A])

    # Gui qua UART
    ser.write(frame)
    ser.flush()

    # Cho phan hoi ACK
    line = ser.readline().decode("utf-8", errors="ignore").strip()
    if line.startswith("{") and "ACK" in line:
        try:
            resp = json.loads(line)
            if resp.get("window_idx") == idx:
                acked_count += 1
                if (idx + 1) % 20 == 0 or idx == total_windows - 1:
                    print(f"    -> Da truyen & ACK hop le: {idx + 1}/{total_windows} cua so...")
        except json.JSONDecodeError:
            pass
    else:
        print(f"[!] Canh bao: Mat goi hoac loi Checksum o cua so #{idx}")

elapsed_time = time.time() - start_time
packet_loss_rate = ((total_windows - acked_count) / total_windows) * 100.0

print("\n" + "="*65)
print(f"[+] Tong so cua so da gui : {total_windows}")
print(f"[+] So cua so nhan ACK     : {acked_count}")
print(f"[+] Thoi gian truyen tong  : {elapsed_time:.2f} giay")
print(f"[+] Ty le mat goi (Loss)   : {packet_loss_rate:.2f}%")

if packet_loss_rate == 0.0:
    print("[SUCCESS] TY LE MAT GOI BANG 0.0% -> DAT NGHIEP THU TASK T15!")
else:
    print("[FAILED] Ty le mat goi vuot nguong 0.0%!")
print("="*65)

ser.close()