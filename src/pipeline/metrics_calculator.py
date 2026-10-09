"""
Module: src/pipeline/metrics_calculator.py
Nhiệm vụ: Tính toán tức thời các chỉ số hiệu năng (KPI Metrics) cho từng cửa sổ trượt:
- Sai số MAE, RMSE trước và sau khi phục hồi
- Phần trăm suy giảm sai số (% Reduction)
- Xác định Anomaly Flag và thông điệp chẩn đoán
- Ước lượng độ trễ nhúng và mức tiêu hao ngân sách thời gian thực
- Cung cấp Metadata Icon chuẩn Lucide (phục vụ SVG render hoặc native fallback)
"""

import numpy as np
from dataclasses import dataclass
from typing import List, Dict, Any, Union
from .edge_pipeline import PipelineResult

try:
    from lucide import lucide_icon
    LUCIDE_AVAILABLE = True
except ImportError:
    LUCIDE_AVAILABLE = False


def get_lucide_svg(name: str, size: int = 18, color: str = "currentColor", stroke_width: int = 2) -> str:
    """Trả về SVG icon chuẩn từ python-lucide hoặc chuỗi rỗng nếu chưa cài đặt."""
    if not LUCIDE_AVAILABLE:
        return ""
    try:
        return lucide_icon(name, width=str(size), height=str(size), stroke=color, stroke_width=str(stroke_width))
    except Exception:
        return ""


@dataclass
class KPIMetricsPayload:
    # 1. Anomaly Flag Metrics
    status: str                         # NORMAL, CHANNEL_FAULT, MULTI_FAULT
    status_color: str                   # success, warning, error
    fault_mask: List[bool]              # [kênh 1 lỗi?, kênh 2 lỗi?, kênh 3 lỗi?]
    fault_description: str              # Chuỗi mô tả trạng thái lỗi
    
    # 2. Latency Metrics
    host_latency_ms: float              # Độ trễ đo trên host (ms)
    estimated_mcu_latency_ms: float     # Độ trễ tương đương trên ESP32-S3 (ms)
    latency_budget_pct: float           # % tiêu hao so với ngân sách 50ms
    
    # 3. Accuracy / Error Reduction Metrics
    mae_raw: float                      # Sai số MAE của tín hiệu thô so với Ground Truth
    mae_imputed: float                  # Sai số MAE sau phục hồi so với Ground Truth
    mae_reduction_pct: float            # % Cắt giảm MAE
    rmse_raw: float                     # Sai số RMSE thô
    rmse_imputed: float                 # Sai số RMSE sau phục hồi
    rmse_reduction_pct: float           # % Cắt giảm RMSE
    
    # 4. Confidence & Actuation Metrics
    ct_score: float                     # Điểm tin cậy Ct [0.0, 1.0]
    is_safe: bool                       # True: Bật relay, False: Khóa an toàn
    actuation_status: str               # "CHO PHÉP TƯỚI" / "KHÓA BƠM AN TOÀN"

    def to_dict(self) -> Dict[str, Any]:
        """Xuất payload thành dict JSON-compatible chuẩn Lucide icons phục vụ UI và logging."""
        # Ánh xạ Lucide icon metadata dựa theo trạng thái
        if self.status == "NORMAL":
            anomaly_icon = "shield-check"
            anomaly_color = "#10B981"  # Emerald green
        elif self.status == "CHANNEL_FAULT":
            anomaly_icon = "shield-alert"
            anomaly_color = "#F59E0B"  # Amber warning
        else:
            anomaly_icon = "shield-x"
            anomaly_color = "#EF4444"  # Crimson error

        actuation_icon = "circle-check" if self.is_safe else "lock"
        actuation_color = "#10B981" if self.is_safe else "#EF4444"

        return {
            "anomaly_flag": {
                "status": self.status,
                "color": self.status_color,
                "fault_mask": self.fault_mask,
                "description": self.fault_description,
                "lucide_icon": anomaly_icon,
                "icon_color": anomaly_color,
                "icon_svg": get_lucide_svg(anomaly_icon, size=18, color=anomaly_color)
            },
            "latency": {
                "host_ms": round(self.host_latency_ms, 3),
                "mcu_ms": round(self.estimated_mcu_latency_ms, 2),
                "budget_pct": round(self.latency_budget_pct, 1),
                "lucide_icon": "cpu",
                "icon_color": "#3B82F6",
                "icon_svg": get_lucide_svg("cpu", size=18, color="#3B82F6")
            },
            "error_metrics": {
                "mae_raw": round(self.mae_raw, 4),
                "mae_imputed": round(self.mae_imputed, 4),
                "mae_reduction_pct": round(self.mae_reduction_pct, 1),
                "rmse_raw": round(self.rmse_raw, 4),
                "rmse_imputed": round(self.rmse_imputed, 4),
                "rmse_reduction_pct": round(self.rmse_reduction_pct, 1),
                "lucide_icon": "wand-sparkles",
                "icon_color": "#8B5CF6",
                "icon_svg": get_lucide_svg("wand-sparkles", size=18, color="#8B5CF6")
            },
            "confidence": {
                "ct_score": round(self.ct_score, 4),
                "is_safe": self.is_safe,
                "actuation": self.actuation_status,
                "lucide_icon": actuation_icon,
                "icon_color": actuation_color,
                "icon_svg": get_lucide_svg(actuation_icon, size=18, color=actuation_color)
            }
        }


class KPIMetricsCalculator:
    # Hằng số chuẩn hóa từ đo đạc on-chip Sprint 4.2 trên ESP32-S3
    ESP32S3_NOMINAL_LATENCY_MS = 18.40
    REALTIME_BUDGET_MS = 50.00

    @staticmethod
    def calculate_window_kpi(
        pipeline_result: PipelineResult,
        clean_window_32x3: np.ndarray,
        corrupt_window_32x3: np.ndarray,
        measured_host_time_ms: float = 0.50,
        target_channel: int = 0
    ) -> KPIMetricsPayload:
        """
        Tính toán toàn bộ số liệu KPI đối chuẩn cho một cửa sổ trượt W=32.
        clean_window_32x3: mảng đối chứng Ground Truth (32, 3)
        corrupt_window_32x3: mảng tín hiệu thô tiêm lỗi (32, 3)
        """
        # --- 1. XỬ LÝ ANOMALY FLAG & FAULT DESCRIPTION ---
        num_faults = sum(pipeline_result.faulty_mask)
        if num_faults == 0:
            status = "NORMAL"
            status_color = "success"
            fault_desc = "Tín hiệu 3 kênh đồng thuận, chuẩn xác"
        elif num_faults == 1:
            status = "CHANNEL_FAULT"
            status_color = "warning"
            bad_ch = [f"S{k+1}" for k, is_f in enumerate(pipeline_result.faulty_mask) if is_f][0]
            fault_desc = f"Phát hiện dị thường kênh {bad_ch} - Đã cô lập & bù không gian"
        else:
            status = "MULTI_FAULT"
            status_color = "error"
            fault_desc = "Suy biến đa kênh đồng thời - Đã kích hoạt ngắt an toàn"

        # --- 2. TÍNH SAI SỐ MAE VÀ RMSE TRÊN KÊNH KHẢO SÁT ---
        gt_ch = clean_window_32x3[:, target_channel]
        raw_ch = corrupt_window_32x3[:, target_channel]
        
        # Tái lập chuỗi imputed trên toàn cửa sổ khảo sát
        imp_ch = raw_ch.copy()
        if pipeline_result.faulty_mask[target_channel]:
            # Điểm tức thời cuối cửa sổ được thay bằng giá trị đã bù
            imp_ch[-1] = pipeline_result.imputed_current[target_channel]

        # MAE: Mean Absolute Error
        mae_raw = float(np.mean(np.abs(raw_ch - gt_ch)))
        mae_imputed = float(np.mean(np.abs(imp_ch - gt_ch)))
        
        # RMSE: Root Mean Squared Error
        rmse_raw = float(np.sqrt(np.mean((raw_ch - gt_ch) ** 2)))
        rmse_imputed = float(np.sqrt(np.mean((imp_ch - gt_ch) ** 2)))

        # % Giảm sai số (Reduction Rate)
        if mae_raw > 1e-5:
            mae_reduc_pct = float(((mae_raw - mae_imputed) / mae_raw) * 100.0)
        else:
            mae_reduc_pct = 0.0

        if rmse_raw > 1e-5:
            rmse_reduc_pct = float(((rmse_raw - rmse_imputed) / rmse_raw) * 100.0)
        else:
            rmse_reduc_pct = 0.0

        # --- 3. ĐỘ TRỄ NHÚNG & TIÊU HAO NGÂN SÁCH ---
        mcu_latency = KPIMetricsCalculator.ESP32S3_NOMINAL_LATENCY_MS
        budget_pct = (mcu_latency / KPIMetricsCalculator.REALTIME_BUDGET_MS) * 100.0

        # --- 4. TÌNH TRẠNG CHẤP HÀNH RELAY ---
        actuation_label = "CHO PHÉP TƯỚI" if pipeline_result.is_safe_for_actuation else "KHÓA BƠM AN TOÀN"

        return KPIMetricsPayload(
            status=status,
            status_color=status_color,
            fault_mask=pipeline_result.faulty_mask,
            fault_description=fault_desc,
            host_latency_ms=measured_host_time_ms,
            estimated_mcu_latency_ms=mcu_latency,
            latency_budget_pct=budget_pct,
            mae_raw=mae_raw,
            mae_imputed=mae_imputed,
            mae_reduction_pct=mae_reduc_pct,
            rmse_raw=rmse_raw,
            rmse_imputed=rmse_imputed,
            rmse_reduction_pct=rmse_reduc_pct,
            ct_score=pipeline_result.confidence_score_ct,
            is_safe=pipeline_result.is_safe_for_actuation,
            actuation_status=actuation_label
        )
