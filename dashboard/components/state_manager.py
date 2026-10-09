"""
Module: dashboard/components/state_manager.py
Nhiệm vụ: Quản lý tập trung st.session_state cho toàn bộ Dashboard Ag-IoT:
- Lưu giữ cửa sổ thời gian thực nghiệm đang chọn (selected_window_idx)
- Đồng bộ kênh cảm biến khảo sát (selected_channel)
- Lưu giữ chế độ hiển thị A/B (view_mode)
- Lưu trữ bộ lọc ma trận T18/T19
- Reset và đồng bộ hóa trạng thái phiên làm việc không gây re-render thừa
"""

import streamlit as st
from typing import Dict, Any


class DashboardStateManager:
    # Keys được sử dụng trong Session State
    KEY_WINDOW_IDX = "app_selected_window_idx"
    KEY_CHANNEL = "app_selected_channel"
    KEY_VIEW_MODE = "app_view_mode"
    KEY_T18_FAULT_FILTER = "app_t18_fault_filter"
    KEY_T18_SEV_FILTER = "app_t18_sev_filter"
    KEY_T19_FAULT_FILTER = "app_t19_fault_filter"
    KEY_T19_METRIC_MODE = "app_t19_metric_mode"

    @classmethod
    def initialize_state(cls):
        """Khởi tạo trạng thái mặc định nếu chưa tồn tại trong Session State."""
        if cls.KEY_WINDOW_IDX not in st.session_state:
            st.session_state[cls.KEY_WINDOW_IDX] = 108  # Mặc định kịch bản lỗi đầu tiên

        if cls.KEY_CHANNEL not in st.session_state:
            st.session_state[cls.KEY_CHANNEL] = 0        # Kênh S1

        if cls.KEY_VIEW_MODE not in st.session_state:
            st.session_state[cls.KEY_VIEW_MODE] = "1 Kênh Chuyên sâu"

        if cls.KEY_T18_FAULT_FILTER not in st.session_state:
            st.session_state[cls.KEY_T18_FAULT_FILTER] = "Tất cả"

        if cls.KEY_T18_SEV_FILTER not in st.session_state:
            st.session_state[cls.KEY_T18_SEV_FILTER] = "Tất cả"

        if cls.KEY_T19_FAULT_FILTER not in st.session_state:
            st.session_state[cls.KEY_T19_FAULT_FILTER] = "Tất cả"

        if cls.KEY_T19_METRIC_MODE not in st.session_state:
            st.session_state[cls.KEY_T19_METRIC_MODE] = "MAE"

    @classmethod
    def get_window_idx(cls) -> int:
        cls.initialize_state()
        return st.session_state[cls.KEY_WINDOW_IDX]

    @classmethod
    def set_window_idx(cls, idx: int):
        cls.initialize_state()
        st.session_state[cls.KEY_WINDOW_IDX] = int(idx)

    @classmethod
    def get_channel(cls) -> int:
        cls.initialize_state()
        return st.session_state[cls.KEY_CHANNEL]

    @classmethod
    def set_channel(cls, channel: int):
        cls.initialize_state()
        st.session_state[cls.KEY_CHANNEL] = int(channel)

    @classmethod
    def get_view_mode(cls) -> str:
        cls.initialize_state()
        return st.session_state[cls.KEY_VIEW_MODE]

    @classmethod
    def set_view_mode(cls, mode: str):
        cls.initialize_state()
        st.session_state[cls.KEY_VIEW_MODE] = str(mode)

    @classmethod
    def reset_all_state(cls):
        """Reset toàn bộ state về trạng thái ban đầu."""
        st.session_state[cls.KEY_WINDOW_IDX] = 108
        st.session_state[cls.KEY_CHANNEL] = 0
        st.session_state[cls.KEY_VIEW_MODE] = "1 Kênh Chuyên sâu"
        st.session_state[cls.KEY_T18_FAULT_FILTER] = "Tất cả"
        st.session_state[cls.KEY_T18_SEV_FILTER] = "Tất cả"
        st.session_state[cls.KEY_T19_FAULT_FILTER] = "Tất cả"
        st.session_state[cls.KEY_T19_METRIC_MODE] = "MAE"
