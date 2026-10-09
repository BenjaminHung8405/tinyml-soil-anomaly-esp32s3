"""
Module: src/pipeline/tflite_engine.py
Mục đích: Chạy suy luận TFLite INT8 và bóc tách sai số tái tạo 3 kênh (MSE_k).
Hỗ trợ fallback giả lập nếu chưa có file .tflite.
"""

import os
import json
import numpy as np

# Thử import TensorFlow Lite runtime hoặc tf.lite
try:
    import tflite_runtime.interpreter as tflite
except ImportError:
    try:
        import tensorflow.lite as tflite
    except ImportError:
        tflite = None


class TFLiteInferenceEngine:
    def __init__(self, model_path: str = None, config_path: str = None):
        self.model_path = model_path
        self.config_path = config_path
        self.interpreter = None
        self.input_details = None
        self.output_details = None
        
        # Mặc định tham số lượng tử hóa và ngưỡng
        self.input_scale = 0.0039215686
        self.input_zero_point = -128
        self.output_scale = 0.0039215686
        self.output_zero_point = -128
        self.threshold_tau = 0.0075
        self.use_mock = True

        self._load_config()
        self._initialize_interpreter()

    def _load_config(self):
        """Đọc ngưỡng và thông số scale từ file cấu hình nếu có."""
        if self.config_path and os.path.exists(self.config_path):
            try:
                with open(self.config_path, "r") as f:
                    cfg = json.load(f)
                    self.threshold_tau = cfg.get("threshold_tau", self.threshold_tau)
                    self.input_scale = cfg.get("input_scale", self.input_scale)
                    self.input_zero_point = cfg.get("input_zero_point", self.input_zero_point)
                    self.output_scale = cfg.get("output_scale", self.output_scale)
                    self.output_zero_point = cfg.get("output_zero_point", self.output_zero_point)
            except Exception as e:
                print(f"[!] Lỗi nạp cấu hình: {e}. Sử dụng tham số mặc định.")

    def _initialize_interpreter(self):
        """Khởi tạo TFLite Interpreter hoặc chuyển sang chế độ Mock."""
        if tflite is not None and self.model_path and os.path.exists(self.model_path):
            try:
                self.interpreter = tflite.Interpreter(model_path=self.model_path)
                self.interpreter.allocate_tensors()
                self.input_details = self.interpreter.get_input_details()
                self.output_details = self.interpreter.get_output_details()
                
                # Cập nhật scale và zero-point thực tế từ model INT8
                in_quant = self.input_details[0].get("quantization", (0.0, 0))
                if in_quant[0] != 0.0:
                    self.input_scale, self.input_zero_point = in_quant
                
                out_quant = self.output_details[0].get("quantization", (0.0, 0))
                if out_quant[0] != 0.0:
                    self.output_scale, self.output_zero_point = out_quant

                self.use_mock = False
                print("[+] Khởi tạo TFLite Interpreter INT8 thành công!")
                return
            except Exception as e:
                print(f"[!] Không thể khởi tạo TFLite Interpreter: {e}. Chuyển sang Mock Engine.")
        
        self.use_mock = True

    def quantize_input(self, float_array: np.ndarray) -> np.ndarray:
        """Chuyển đổi số thực [0.0, 1.0] sang int8 [-128, 127]."""
        q = np.round(float_array / self.input_scale) + self.input_zero_point
        return np.clip(q, -128, 127).astype(np.int8)

    def dequantize_output(self, int8_array: np.ndarray) -> np.ndarray:
        """Chuyển đổi int8 [-128, 127] ngược lại số thực."""
        return (int8_array.astype(np.float32) - self.output_zero_point) * self.output_scale

    def infer(self, window_32x3: np.ndarray):
        """
        Thực hiện suy luận cho 1 cửa sổ (32, 3).
        Đầu ra:
            - reconstructed_window: (32, 3)
            - mse_channels: [mse_s1, mse_s2, mse_s3]
        """
        assert window_32x3.shape == (32, 3), "Cửa sổ đầu vào phải có kích thước (32, 3)"
        flat_input = window_32x3.flatten().astype(np.float32)  # shape (96,)

        if not self.use_mock:
            # 1. Ép kiểu INT8
            quantized_in = self.quantize_input(flat_input).reshape(self.input_details[0]["shape"])
            self.interpreter.set_tensor(self.input_details[0]["index"], quantized_in)
            
            # 2. Suy luận trên chip / TFLM
            self.interpreter.invoke()
            
            # 3. Giải lượng tử hóa đầu ra
            quantized_out = self.interpreter.get_tensor(self.output_details[0]["index"]).flatten()
            reconstructed_flat = self.dequantize_output(quantized_out)
        else:
            # MOCK ENGINE: Tái tạo xấp xỉ tín hiệu sạch dựa trên trung vị không gian và làm mịn
            spatial_med = np.median(window_32x3, axis=1, keepdims=True)
            # Tái tạo là giá trị hội tụ về đường trung vị của các kênh lành lặn
            reconstructed_mock = np.tile(spatial_med, (1, 3))
            reconstructed_flat = reconstructed_mock.flatten()

        reconstructed_window = reconstructed_flat.reshape(32, 3)

        # Tính sai số tái tạo bóc tách từng kênh (MSE_k)
        mse_channels = np.mean((window_32x3 - reconstructed_window) ** 2, axis=0)

        return reconstructed_window, mse_channels