import os
import json
import numpy as np
import matplotlib.pyplot as plt
import tensorflow as tf
from tensorflow.keras import callbacks

# Import hàm khởi tạo kiến trúc từ Task T05
from model_arch import build_dense_autoencoder

# 1. Định nghĩa đường dẫn
DATA_DIR = os.path.join("data", "processed")
MODELS_DIR = "models"
os.makedirs(MODELS_DIR, exist_ok=True)

TRAIN_DATA_PATH = os.path.join(DATA_DIR, "train.npy")
VAL_DATA_PATH = os.path.join(DATA_DIR, "val.npy")

MODEL_SAVE_PATH = os.path.join(MODELS_DIR, "autoencoder_float32.keras")
HISTORY_LOG_PATH = os.path.join(MODELS_DIR, "training_history.json")
IMG_LOSS_PATH = os.path.join(MODELS_DIR, "training_loss_curve.png")

# 2. Nạp dữ liệu
print(f"[*] Bước 1: Nạp tập dữ liệu Train và Validation...")
X_train = np.load(TRAIN_DATA_PATH)  # Shape: (999, 32, 1)
X_val = np.load(VAL_DATA_PATH)      # Shape: (124, 32, 1)

print(f"    -> X_train shape: {X_train.shape}, Dtype: {X_train.dtype}")
print(f"    -> X_val   shape: {X_val.shape}, Dtype: {X_val.dtype}")

# 3. Khởi tạo mô hình từ Task T05
print(f"[*] Bước 2: Khởi tạo mô hình Dense Autoencoder...")
model = build_dense_autoencoder(input_dim=32, latent_dim=4)

optimizer = tf.keras.optimizers.Adam(learning_rate=0.001)
model.compile(optimizer=optimizer, loss="mse", metrics=["mae"])

# 4. Cấu hình Callbacks (Early Stopping & Learning Rate Reduction)
early_stopping = callbacks.EarlyStopping(
    monitor="val_loss",
    patience=10,
    restore_best_weights=True,
    verbose=1
)

reduce_lr = callbacks.ReduceLROnPlateau(
    monitor="val_loss",
    factor=0.5,
    patience=5,
    min_lr=1e-5,
    verbose=1
)

# 5. Huấn luyện mô hình (Học không giám sát: target chính là input)
EPOCHS = 100
BATCH_SIZE = 32

print(f"[*] Bước 3: Bắt đầu huấn luyện mô hình (Max epochs: {EPOCHS}, Batch size: {BATCH_SIZE})...")
history = model.fit(
    x=X_train,
    y=X_train,
    validation_data=(X_val, X_val),
    epochs=EPOCHS,
    batch_size=BATCH_SIZE,
    callbacks=[early_stopping, reduce_lr],
    verbose=1
)

# 6. Đánh giá kết quả trên tập Validation
best_val_loss = float(min(history.history["val_loss"]))
final_train_loss = float(history.history["loss"][-1])
epochs_trained = len(history.history["loss"])

print("\n" + "="*60)
print(f"[+] Huấn luyện kết thúc tại Epoch: {epochs_trained}")
print(f"[+] Train Loss (MSE) cuối cùng : {final_train_loss:.6f}")
print(f"[+] Best Validation Loss (MSE)  : {best_val_loss:.6f}")

# Kiểm tra tiêu chí nghiệm thu Task T06 (Val Loss < 0.005)
ACCEPTANCE_THRESHOLD = 0.005
if best_val_loss < ACCEPTANCE_THRESHOLD:
    print(f"[SUCCESS] Validation Loss ({best_val_loss:.6f}) < {ACCEPTANCE_THRESHOLD} -> ĐẠT TIÊU CHÍ NGHIỆM THU!")
else:
    print(f"[!] Cảnh báo: Validation Loss ({best_val_loss:.6f}) chưa đạt ngưỡng {ACCEPTANCE_THRESHOLD}.")
print("="*60)

# 7. Lưu mô hình Float32
model.save(MODEL_SAVE_PATH)
print(f"[+] Đã lưu mô hình huấn luyện hoàn chỉnh tại: {MODEL_SAVE_PATH}")

# 8. Lưu lịch sử huấn luyện (Training History)
history_dict = {
    "epochs_trained": epochs_trained,
    "best_val_loss": best_val_loss,
    "final_train_loss": final_train_loss,
    "history": {
        "loss": [float(x) for x in history.history["loss"]],
        "val_loss": [float(x) for x in history.history["val_loss"]],
        "mae": [float(x) for x in history.history["mae"]],
        "val_mae": [float(x) for x in history.history["val_mae"]],
        "lr": [float(x) for x in history.history.get("lr", history.history.get("learning_rate", []))]
    }
}
with open(HISTORY_LOG_PATH, "w") as f:
    json.dump(history_dict, f, indent=4)
print(f"[+] Đã lưu nhật ký huấn luyện tại: {HISTORY_LOG_PATH}")

# 9. Vẽ đường cong hàm mất mát (Loss Curve)
plt.figure(figsize=(10, 5))
plt.plot(history.history["loss"], label="Train Loss (MSE)", color="#1b7837", lw=1.5)
plt.plot(history.history["val_loss"], label="Validation Loss (MSE)", color="#e66101", lw=1.5)
plt.axhline(y=ACCEPTANCE_THRESHOLD, color="red", linestyle="--", alpha=0.7, label=f"Ngưỡng chấp nhận ({ACCEPTANCE_THRESHOLD})")

plt.title("Đường Cong Hội Tụ Huấn Luyện (Training Loss Curve) - Task T06", fontsize=12)
plt.xlabel("Epoch")
plt.ylabel("Sai số bình phương trung bình (MSE)")
plt.yscale("log")  # Thang logarit giúp quan sát rõ độ hội tụ ở sai số nhỏ
plt.legend(loc="upper right", framealpha=0.9)
plt.grid(True, which="both", linestyle="--", alpha=0.5)
plt.tight_layout()

plt.savefig(IMG_LOSS_PATH, dpi=200)
print(f"[+] Đã xuất ảnh kiểm định hội tụ: {IMG_LOSS_PATH}")