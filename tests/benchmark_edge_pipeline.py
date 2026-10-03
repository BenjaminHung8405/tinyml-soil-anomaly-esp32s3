import os
import sys
import time
import struct
import json
import serial
import serial.tools.list_ports
import numpy as np

# 1. Tìm cổng Serial
ports = list(serial.tools.list_ports.comports())
target_port = None
for p in ports:
    if any(k in p.device.lower() for k in ["usbmodem", "usbserial", "ch340", "cp210"]):
        target_port = p.device
        break

if not target_port:
    target_port = ports[0].device if ports else None

if not target_port:
    print("[!] Khong tim thay cong Serial!")
    sys.exit(1)

print(f"[*] Ket noi: {target_port} @ 115200 bps")
ser = serial.Serial(target_port, 115200, timeout=1.0)
time.sleep(2.0)
ser.reset_input_buffer()

# 2. Nap tap kiem thu test_fault_injected.npy
DATA_PATH = os.path.join("data", "processed", "test_fault_injected.npy")
X_test = np.load(DATA_PATH)
total_windows = len(X_test)
print(f"[*] Bat dau kiem thu {total_windows} cua so tren Edge Pipeline...")

results = []
start_total = time.time()

for idx in range(total_windows):
    samples = X_test[idx].flatten().astype(np.float32)
    payload_bytes = struct.pack(f"{len(samples)}f", *samples)

    checksum = 0
    for b in payload_bytes:
        checksum ^= b

    frame = bytearray([0xAA, 0x55])
    frame.extend(struct.pack("<H", idx))
    frame.extend(payload_bytes)
    frame.append(checksum)
    frame.extend([0x0D, 0x0A])

    ser.write(frame)
    ser.flush()
    time.sleep(0.005)

    line = ser.readline().decode("utf-8", errors="ignore").strip()
    if line.startswith("{") and '"idx"' in line:
        try:
            data = json.loads(line)
            results.append(data)
            if (idx + 1) % 25 == 0 or idx == total_windows - 1:
                print(f"    [Cửa sổ #{idx:03d}] MSE: {data['mse']:.6f} | Ct: {data['Ct']:.3f} | Latency: {data['lat_us']} us | Anomaly: {data['anomaly']} | Lockout: {data['lockout']}")
        except json.JSONDecodeError:
            pass

ser.close()

# 3. Tong hop thong ke
latencies = [r["lat_us"] for r in results]
anomalies = [r["anomaly"] for r in results]
lockouts = [r["lockout"] for r in results]

avg_lat = np.mean(latencies)
p95_lat = np.percentile(latencies, 95)
total_anomalies = sum(anomalies)
total_lockouts = sum(lockouts)

print("\n" + "="*70)
print(f"[+] So cua so da xu ly hoan tat : {len(results)} / {total_windows}")
print(f"[+] Do tre suy luan trung binh   : {avg_lat:.2f} us ({avg_lat/1000.0:.2f} ms)")
print(f"[+] Do tre 95th Percentile       : {p95_lat:.2f} us ({p95_lat/1000.0:.2f} ms)")
print(f"[+] So cua so bat co bat thuong  : {total_anomalies}")
print(f"[+] So cua so kich hoat Lockout  : {total_lockouts}")
print("="*70)