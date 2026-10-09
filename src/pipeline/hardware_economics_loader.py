"""
Module: src/pipeline/hardware_economics_loader.py
Nhiệm vụ: Quản lý danh mục linh kiện BOM, tính toán so sánh chi phí TCO
và khởi tạo dữ liệu biểu đồ Radar cho trang Luận chứng Kinh tế & Phần cứng.
"""

import os
import pandas as pd
import numpy as np
from typing import Dict, List, Any


class HardwareEconomicsLoader:
    REPORTS_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "../../reports"))
    BOM_CSV_FILENAME = "hardware_bom_metrics.csv"

    @staticmethod
    def get_csv_path() -> str:
        os.makedirs(HardwareEconomicsLoader.REPORTS_DIR, exist_ok=True)
        return os.path.join(HardwareEconomicsLoader.REPORTS_DIR, HardwareEconomicsLoader.BOM_CSV_FILENAME)

    @staticmethod
    def generate_default_bom_dataset() -> pd.DataFrame:
        """
        Khởi tạo bảng danh mục linh kiện BOM thực tế của đề tài (Tổng ~345.000 VNĐ).
        """
        bom_data = [
            {
                "item_id": "BOM_01",
                "component_name": "Kit ESP32-S3-WROOM-1-N16R8 (16MB Flash, 8MB PSRAM)",
                "unit_price_vnd": 135000,
                "quantity": 1,
                "technical_role": "Vi xử lý trung tâm, nạp TFLM INT8 & FreeRTOS",
                "category": "MCU & Compute"
            },
            {
                "item_id": "BOM_02",
                "component_name": "03 Cảm biến độ ẩm đất MKE-S13 (Điện dung chống ăn mòn)",
                "unit_price_vnd": 25000,
                "quantity": 3,
                "technical_role": "Thu thập VWC đa điểm (đối xứng r=5cm)",
                "category": "Sensors"
            },
            {
                "item_id": "BOM_03",
                "component_name": "Module thẻ MicroSD SPI + Thẻ nhớ 8GB Class 10",
                "unit_price_vnd": 45000,
                "quantity": 1,
                "technical_role": "Lưu trữ dữ liệu telemetry offline & Ring Buffer log",
                "category": "Storage"
            },
            {
                "item_id": "BOM_04",
                "component_name": "Module RTC DS3231 + Pin nuôi CR2032",
                "unit_price_vnd": 25000,
                "quantity": 1,
                "technical_role": "Cung cấp nhãn thời gian thực chuẩn giây",
                "category": "Peripherals"
            },
            {
                "item_id": "BOM_05",
                "component_name": "Module Relay 5V cách ly quang + Bơm chìm mini 5V",
                "unit_price_vnd": 30000,
                "quantity": 1,
                "technical_role": "Cơ cấu chấp hành tưới & Khóa ngắt an toàn Fail-safe",
                "category": "Actuators"
            },
            {
                "item_id": "BOM_06",
                "component_name": "Module nguồn Breadboard MB102 + Adapter 9V 2A",
                "unit_price_vnd": 35000,
                "quantity": 1,
                "technical_role": "Cấp nguồn ổn định 5V/3.3V cách ly nhiễu",
                "category": "Power Supply"
            },
            {
                "item_id": "BOM_07",
                "component_name": "Breadboard 830 lỗ + Dây cắm Jumper + Tụ lọc 100nF",
                "unit_price_vnd": 0,  # Linh kiện phụ trợ sẵn có/phụ kiện
                "quantity": 1,
                "technical_role": "Mạch cắm nối thử nghiệm & lọc gai nhiễu điện áp ADC",
                "category": "Accessories"
            }
        ]

        df = pd.DataFrame(bom_data)
        df["total_price_vnd"] = df["unit_price_vnd"] * df["quantity"]
        # Lưu file CSV đồng bộ
        df.to_csv(HardwareEconomicsLoader.get_csv_path(), index=False)
        return df

    @classmethod
    def load_bom_data(cls) -> pd.DataFrame:
        """Nạp dữ liệu BOM từ CSV hoặc sinh mới nếu chưa tồn tại."""
        csv_path = cls.get_csv_path()
        if not os.path.exists(csv_path):
            df = cls.generate_default_bom_dataset()
        else:
            df = pd.read_csv(csv_path)
            # Đảm bảo trường total_price_vnd chính xác
            df["total_price_vnd"] = df["unit_price_vnd"] * df["quantity"]
        return df

    @classmethod
    def calculate_cost_comparison(cls) -> Dict[str, Any]:
        """
        So sánh chi phí trực tiếp giữa Cụm Ag-IoT TinyML và Cảm biến Công nghiệp.
        """
        df_bom = cls.load_bom_data()
        proposed_total_vnd = int(df_bom["total_price_vnd"].sum())
        
        # Mức giá cảm biến công nghiệp trung bình trên thị trường (FDR/TDR Probe)
        industrial_sensor_avg_vnd = 980000
        
        savings_vnd = industrial_sensor_avg_vnd - proposed_total_vnd
        savings_pct = (savings_vnd / industrial_sensor_avg_vnd) * 100.0

        return {
            "proposed_total_vnd": proposed_total_vnd,
            "industrial_sensor_avg_vnd": industrial_sensor_avg_vnd,
            "savings_vnd": savings_vnd,
            "savings_pct": round(savings_pct, 1),
            "single_sensor_replace_cost_vnd": 25000,
            "single_sensor_replace_pct": round((25000 / industrial_sensor_avg_vnd) * 100.0, 1)
        }

    @classmethod
    def get_radar_chart_data(cls) -> Dict[str, List[Any]]:
        """
        Dữ liệu phục vụ vẽ biểu đồ Radar so sánh 5 tiêu chí (thang điểm 1 - 10).
        """
        categories = [
            "Tiết kiệm Chi phí (Cost)",
            "Chịu lỗi & Dung lỗi (Fault Tolerance)",
            "Dễ bảo trì / Thay thế (Maintainability)",
            "Linh hoạt Nâng cấp (Flexibility)",
            "Độ chính xác Đo thô (Raw Precision)"
        ]

        # Thang điểm đánh giá kỹ thuật (10 là tốt nhất)
        proposed_scores = [9.5, 9.5, 9.0, 9.0, 7.5]   # Cụm TinyML Đề xuất
        industrial_scores = [3.0, 3.0, 3.5, 4.0, 9.5] # Cảm biến Công nghiệp Đơn lẻ

        return {
            "categories": categories,
            "proposed_scores": proposed_scores,
            "industrial_scores": industrial_scores
        }

    @classmethod
    def get_tco_simulation_data(cls) -> pd.DataFrame:
        """
        Mô phỏng chi phí sở hữu dài hạn TCO (24 tháng) theo các mốc thời gian:
        - Mua sắm ban đầu (Tháng 0)
        - Bảo trì định kỳ (Tháng 12)
        - Sự cố hư hỏng 1 cảm biến đột xuất (Tháng 18)
        - Tổng chi phí luỹ kế (Tháng 24)
        """
        tco_records = [
            {
                "Milestone": "Tháng 0 (Đầu tư ban đầu)",
                "Giải pháp TinyML Đề xuất (VNĐ)": 345000,
                "Cảm biến Công nghiệp (VNĐ)": 980000,
                "Chênh lệch Tiết kiệm (VNĐ)": 635000
            },
            {
                "Milestone": "Tháng 12 (Vận hành 1 năm)",
                "Giải pháp TinyML Đề xuất (VNĐ)": 345000,
                "Cảm biến Công nghiệp (VNĐ)": 980000,
                "Chênh lệch Tiết kiệm (VNĐ)": 635000
            },
            {
                "Milestone": "Tháng 18 (Hỏng 1 cảm biến do ăn mòn)",
                "Giải pháp TinyML Đề xuất (VNĐ)": 370000,  # Thay 1 cảm biến 25.000 VNĐ
                "Cảm biến Công nghiệp (VNĐ)": 1960000, # Thay nguyên khối 980.000 VNĐ
                "Chênh lệch Tiết kiệm (VNĐ)": 1590000
            },
            {
                "Milestone": "Tháng 24 (Tổng kết TCO 2 năm)",
                "Giải pháp TinyML Đề xuất (VNĐ)": 370000,
                "Cảm biến Công nghiệp (VNĐ)": 1960000,
                "Chênh lệch Tiết kiệm (VNĐ)": 1590000
            }
        ]
        return pd.DataFrame(tco_records)
