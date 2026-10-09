"""
Module: dashboard/components/scenario_selector.py
Nhiệm vụ: Cung cấp widget điều khiển lọc và chọn kịch bản trong 126 cửa sổ kiểm thử.
Được thiết kế theo tiêu chuẩn UX/UI của Senior Designer:
- Phân tầng bộ lọc rõ ràng: Trạng thái -> Loại lỗi -> Kênh cảm biến -> Mức độ.
- Quick navigation: Nút [Prev] / [Next] lướt nhanh kịch bản.
- Scenario Detail Badge Card: Tóm tắt thông tin ngữ cảnh trực quan với badge màu chuẩn.
- Đồng bộ hóa mượt mà qua st.session_state với tốc độ phản hồi < 0.1s.
"""

import streamlit as st
import pandas as pd
from typing import Dict, Any


def render_scenario_selector(
    df_metadata: pd.DataFrame,
    placement: str = "sidebar"
) -> Dict[str, Any]:
    """
    Hiển thị giao diện điều khiển lọc kịch bản kiểm thử (126 cửa sổ: 108 sạch, 18 lỗi).
    
    Args:
        df_metadata: DataFrame chứa bảng metadata của 126 cửa sổ.
        placement: 'sidebar' hoặc 'main' (mặc định 'sidebar').
        
    Returns:
        dict: {
            "selected_idx": int,
            "scenario_info": dict,
            "filtered_df": pd.DataFrame,
            "target_channel_idx": int (0, 1, 2)
        }
    """
    container = st.sidebar if placement == "sidebar" else st.container()

    with container:
        # 1. Header & Context overview
        st.markdown("### :material/tune: Bộ điều khiển kịch bản")
        st.caption("Cơ cấu chuẩn: **108 Chuỗi Sạch** (85.7%) + **18 Tiêm Lỗi** (14.3%) = **126 Cửa sổ**")

        # Khối chọn bộ lọc
        with st.container(border=True):
            # 2. Bộ lọc Trạng thái (Status filter)
            st.markdown("**1. Trạng thái kiểm thử**")
            status_choice = st.radio(
                "Trạng thái kiểm thử",
                options=["Tất cả (126)", "Chỉ Tiêm Lỗi (18)", "Chỉ Chuỗi Sạch (108)"],
                index=0,
                label_visibility="collapsed",
                key="scenario_status_filter"
            )

            filtered_df = df_metadata.copy()

            if status_choice == "Chỉ Tiêm Lỗi (18)":
                filtered_df = filtered_df[filtered_df["status"] == "Tiêm Lỗi (Faulty)"]
            elif status_choice == "Chỉ Chuỗi Sạch (108)":
                filtered_df = filtered_df[filtered_df["status"] == "Sạch (Normal)"]

            # 3. Bộ lọc Loại lỗi (Fault type filter)
            available_faults = sorted(list(filtered_df["fault_type"].unique()))
            if len(available_faults) > 1 and "None" in available_faults:
                available_faults = ["Tất cả"] + [f for f in available_faults if f != "None"]
            elif len(available_faults) > 1:
                available_faults = ["Tất cả"] + available_faults
            else:
                available_faults = ["Tất cả"]

            if len(available_faults) > 1 and status_choice != "Chỉ Chuỗi Sạch (108)":
                fault_choice = st.selectbox(
                    "2. Dạng bất thường (Fault Type):",
                    options=available_faults,
                    key="scenario_fault_filter"
                )
                if fault_choice != "Tất cả":
                    filtered_df = filtered_df[filtered_df["fault_type"] == fault_choice]

            # 4. Bộ lọc Kênh cảm biến (Target channel filter)
            available_channels = sorted(list(filtered_df["target_channel"].unique()))
            if len(available_channels) > 1 and "None" in available_channels:
                available_channels = ["Tất cả"] + [c for c in available_channels if c != "None"]
            elif len(available_channels) > 1:
                available_channels = ["Tất cả"] + available_channels
            else:
                available_channels = ["Tất cả"]

            if len(available_channels) > 1 and status_choice != "Chỉ Chuỗi Sạch (108)":
                ch_choice = st.selectbox(
                    "3. Kênh cảm biến tác động:",
                    options=available_channels,
                    key="scenario_ch_filter"
                )
                if ch_choice != "Tất cả":
                    filtered_df = filtered_df[filtered_df["target_channel"] == ch_choice]

            # Badge đếm số lượng khớp
            st.caption(f":material/filter_alt: Khớp: **{len(filtered_df)}** / 126 cửa sổ kiểm thử")

        # Xử lý trường hợp bộ lọc không có kết quả
        if filtered_df.empty:
            st.warning("Không tìm thấy cửa sổ nào khớp với bộ lọc!")
            fallback_idx = 0
            fallback_info = df_metadata.iloc[0].to_dict()
            return {
                "selected_idx": fallback_idx,
                "scenario_info": fallback_info,
                "filtered_df": df_metadata,
                "target_channel_idx": 0
            }

        # 5. Bộ chọn Cửa sổ cụ thể (Window Selector Dropdown + Prev/Next buttons)
        window_options = filtered_df["window_idx"].tolist()

        # Quản lý session_state cho index được chọn
        if "selected_scenario_window" not in st.session_state:
            st.session_state["selected_scenario_window"] = window_options[0]

        # Đảm bảo index hiện tại thuộc danh sách đã lọc
        if st.session_state["selected_scenario_window"] not in window_options:
            st.session_state["selected_scenario_window"] = window_options[0]

        current_pos = window_options.index(st.session_state["selected_scenario_window"])

        # Hàng nút điều hướng nhanh Prev / Next
        col_prev, col_pos, col_next = st.columns([1, 2, 1])
        with col_prev:
            if st.button("◀", disabled=(current_pos == 0), width="stretch", help="Cửa sổ trước đó"):
                st.session_state["selected_scenario_window"] = window_options[current_pos - 1]
                st.rerun()

        with col_pos:
            st.markdown(
                f"<div style='text-align: center; line-height: 2.2rem; font-size: 0.85rem; font-weight: 600; color: #888;'>"
                f"{current_pos + 1} / {len(window_options)}</div>",
                unsafe_allow_html=True
            )

        with col_next:
            if st.button("▶", disabled=(current_pos == len(window_options) - 1), width="stretch", help="Cửa sổ tiếp theo"):
                st.session_state["selected_scenario_window"] = window_options[current_pos + 1]
                st.rerun()

        # Format nhãn hiển thị trong selectbox
        def format_window_label(idx: int) -> str:
            row = df_metadata.loc[df_metadata["window_idx"] == idx].iloc[0]
            if row["fault_type"] == "None":
                return f"#{idx:03d} • Sạch (Normal VWC)"
            return f"#{idx:03d} • [{row['fault_type']}] {row['target_channel']} ({row['severity']})"

        selected_window_idx = st.selectbox(
            "Chọn Cửa sổ trượt (W=32 bước):",
            options=window_options,
            index=current_pos,
            format_func=format_window_label,
            key="scenario_window_selectbox"
        )
        st.session_state["selected_scenario_window"] = selected_window_idx

        # Lấy thông tin metadata chi tiết
        scenario_info = df_metadata.loc[df_metadata["window_idx"] == selected_window_idx].iloc[0].to_dict()

        # Xác định kênh cảm biến trọng tâm (target_channel_idx)
        target_ch_str = scenario_info.get("target_channel", "None")
        if target_ch_str in ["S1", "S2", "S3"]:
            target_ch_idx = int(target_ch_str[1]) - 1
        else:
            target_ch_idx = 0

        # 6. Hero Card thông tin Kịch bản
        with st.container(border=True):
            st.markdown(f"**Chi tiết kịch bản #{selected_window_idx:03d}**")

            is_clean = scenario_info["fault_type"] == "None"
            badge_color = "green" if is_clean else "red"
            status_text = "Sạch (Normal)" if is_clean else f"Tiêm lỗi: {scenario_info['fault_type']}"

            st.markdown(f":{badge_color}-badge[{status_text}]")

            if not is_clean:
                st.markdown(
                    f"- **Kênh mục tiêu:** :blue-badge[{scenario_info['target_channel']}]  \n"
                    f"- **Cấp độ:** `{scenario_info['severity']}`  \n"
                    f"- **Mô tả:** *{scenario_info['description']}*"
                )
            else:
                st.caption(f"Động học đất tự nhiên: {scenario_info['description']}")

        return {
            "selected_idx": int(selected_window_idx),
            "scenario_info": scenario_info,
            "filtered_df": filtered_df,
            "target_channel_idx": target_ch_idx
        }
