"""
Module: src/pipeline/pipeline_factory.py
Nhiệm vụ: Cung cấp Factory khởi tạo Singleton Instance cho EdgePipeline & TFLiteInferenceEngine
sử dụng @st.cache_resource để triệt tiêu thời gian khởi tạo lại mô hình nhúng.
"""

import streamlit as st
from src.pipeline.edge_pipeline import EdgePipeline
from src.pipeline.tflite_engine import TFLiteInferenceEngine


@st.cache_resource(show_spinner=False)
def get_cached_edge_pipeline() -> EdgePipeline:
    """
    Khởi tạo và lưu đệm Singleton Instance của EdgePipeline.
    Tránh việc load lại TFLite model và phân bổ RAM mỗi khi Streamlit re-run.
    """
    engine = TFLiteInferenceEngine()
    pipeline = EdgePipeline(tflite_engine=engine, spatial_eps=0.05, threshold_tau=0.0075)
    return pipeline
