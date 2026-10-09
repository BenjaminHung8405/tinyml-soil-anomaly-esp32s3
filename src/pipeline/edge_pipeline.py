"""
Module: src/pipeline/edge_pipeline.py
Nhiệm vụ: Hiện thực hóa EdgePipeline tích hợp 7 tầng:
Fast-path, TFLite INT8 Inference, Đánh giá điểm tin cậy Ct,
Selective Spatial Imputation và Khóa ngắt an toàn Fail-safe.
"""

import numpy as np
from dataclasses import dataclass
from typing import List, Dict, Any
from .tflite_engine import TFLiteInferenceEngine


@dataclass
class PipelineResult:
    timestamp: float
    raw_current: List[float]             # [S1, S2, S3] hiện tại
    spatial_median: float               # Trung vị không gian tức thời
    mse_channels: List[float]           # [MSE_1, MSE_2, MSE_3]
    faulty_mask: List[bool]             # [kênh 1 lỗi?, kênh 2 lỗi?, kênh 3 lỗi?]
    confidence_score_ct: float          # Ct in [0.0, 1.0]
    imputed_current: List[float]        # Tín hiệu sau khi phục hồi
    consensus_vwc: float                # Giá trị độ ẩm thể tích chốt để điều khiển
    is_safe_for_actuation: bool         # Cờ ngắt Relay: True=Cho phép tưới, False=Khóa ngắt
    status_label: str                   # "VALID", "SUSPICIOUS", "UNRELIABLE"


class EdgePipeline:
    def __init__(self, 
                 tflite_engine: TFLiteInferenceEngine = None, 
                 spatial_eps: float = 0.05,
                 threshold_tau: float = 0.0075):
        self.engine = tflite_engine if tflite_engine is not None else TFLiteInferenceEngine()
        self.spatial_eps = spatial_eps
        self.threshold_tau = threshold_tau

    def evaluate_window(self, window_32x3: np.ndarray, timestamp: float = 0.0) -> PipelineResult:
        """
        Xử lý toàn diện 1 cửa sổ trượt (32, 3) và trả về gói tin PipelineResult.
        """
        assert window_32x3.shape == (32, 3), "Cửa sổ phải có kích thước chuẩn (32, 3)"
        
        # Mẫu tức thời hiện tại (dòng cuối cùng của cửa sổ)
        curr_raw = window_32x3[-1, :].copy()
        spatial_median = float(np.median(curr_raw))

        # --- TẦNG 3: FAST-PATH KIỂM TRA BIÊN & VI PHẠM KHÔNG GIAN ---
        spatial_deviations = np.abs(curr_raw - spatial_median)
        spatial_violation = np.any(spatial_deviations > self.spatial_eps)

        # --- TẦNG 4: SUY LUẬN AUTOENCODER & TÁCH SAI SỐ KÊNH ---
        reconstructed_win, mse_channels = self.engine.infer(window_32x3)
        
        # Nhận diện kênh lỗi độc lập:
        # Lỗi nếu MSE_k vượt ngưỡng tau HOẶC kênh đó lệch quá eps so với trung vị không gian
        faulty_mask = [
            bool(mse_channels[k] > self.threshold_tau or spatial_deviations[k] > self.spatial_eps)
            for k in range(3)
        ]
        num_faults = sum(faulty_mask)

        # --- TẦNG 5: TÍNH TOÁN ĐIỂM TIN CẬY Ct ---
        max_mse = float(np.max(mse_channels))
        alpha = 1.5
        beta = 0.4 if spatial_violation else 0.0
        
        # Công thức suy giảm mũ mượt
        ct = float(np.exp(- (alpha * (max_mse / self.threshold_tau) ** 2 + beta)))
        ct = float(np.clip(ct, 0.0, 1.0))

        # Phân loại trạng thái
        if ct >= 0.85 and num_faults == 0:
            status = "VALID"
            is_safe = True
        elif ct >= 0.50 and num_faults <= 1:
            status = "SUSPICIOUS"
            is_safe = True
        else:
            status = "UNRELIABLE"
            is_safe = False

        # --- TẦNG 6: SELECTIVE SPATIAL IMPUTATION (Phục hồi có chọn lọc) ---
        imputed_current = curr_raw.copy()
        
        if num_faults == 0:
            # Không lỗi: giữ nguyên dữ liệu gốc
            pass
        elif num_faults == 1:
            # 1 Cảm biến bị suy biến: CHỈ THAY THẾ KÊNH LỖI bằng trung bình 2 kênh lành lặn
            healthy_indices = [k for k in range(3) if not faulty_mask[k]]
            healthy_mean = float(np.mean(curr_raw[healthy_indices]))
            for k in range(3):
                if faulty_mask[k]:
                    imputed_current[k] = healthy_mean
        else:
            # 2 hoặc cả 3 cảm biến suy biến đồng thời: Không thể bù cậy tin cậy -> Gán về trung vị
            imputed_current[:] = spatial_median

        # Giá trị độ ẩm chốt cho bộ điều khiển tưới
        consensus_vwc = float(np.median(imputed_current))

        # Trả về kết quả đóng gói chuẩn
        return PipelineResult(
            timestamp=timestamp,
            raw_current=[float(x) for x in curr_raw],
            spatial_median=spatial_median,
            mse_channels=[float(x) for x in mse_channels],
            faulty_mask=faulty_mask,
            confidence_score_ct=ct,
            imputed_current=[float(x) for x in imputed_current],
            consensus_vwc=consensus_vwc,
            is_safe_for_actuation=is_safe,
            status_label=status
        )