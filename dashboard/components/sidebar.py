"""
Module: dashboard/components/sidebar.py
Nhiệm vụ: Render thanh điều hướng Sidebar tinh gọn, chuẩn giao diện Lucide Icons hiện đại.
"""

import streamlit as st
from lucide import lucide_icon


def render_sidebar():
    """Hiển thị sidebar gọn gàng với vector Lucide icons, loại bỏ hoàn toàn emoji text."""
    leaf_svg = lucide_icon("leaf", width="22", height="22", stroke="#10B981", stroke_width="2.2")
    school_svg = lucide_icon("graduation-cap", width="16", height="16", stroke="#4B5563", stroke_width="2")
    settings_svg = lucide_icon("cpu", width="16", height="16", stroke="#4B5563", stroke_width="2")
    
    with st.sidebar:
        # Header định danh trạm đo & trạng thái kết nối
        st.markdown(
            f"""
            <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 4px;">
                <span style="display: inline-flex; vertical-align: middle;">{leaf_svg}</span>
                <span style="font-size: 1.25rem; font-weight: 700; color: #111827;">Ag-IoT TinyML</span>
            </div>
            """,
            unsafe_allow_html=True
        )
        st.caption("ESP32-S3 Soil Anomaly Pipeline")
        st.markdown(":green-badge[ESP32-S3 Online] :blue-badge[Full INT8]")
        st.markdown("---")

        # Thu gọn thông tin đề tài & cấu hình vào expander
        with st.expander("Thông tin Đề tài & MCU", icon=":material/info:", expanded=False):
            st.markdown(
                f"""
                <div style="display: flex; align-items: center; gap: 6px; font-weight: 600; margin-bottom: 4px;">
                    {school_svg} <span>Khóa luận Tốt nghiệp:</span>
                </div>
                """,
                unsafe_allow_html=True
            )
            st.markdown("- **SV thực hiện:** Nguyễn Phi Hùng")
            st.markdown("- **Ngành:** Công nghệ Thông tin")
            st.markdown("- **Đơn vị:** Trường ĐH An Giang – ĐHQG-HCM")
            st.markdown("---")
            st.markdown(
                f"""
                <div style="display: flex; align-items: center; gap: 6px; font-weight: 600; margin-bottom: 4px;">
                    {settings_svg} <span>Cấu hình Tham chiếu:</span>
                </div>
                """,
                unsafe_allow_html=True
            )
            st.markdown("- **MCU:** ESP32-S3 (Xtensa LX7, 240MHz)")
            st.markdown("- **Cảm biến:** 3× MKE-S13 ($r=5\\text{ cm}$ đối xứng)")
            st.markdown("- **Model:** Dense AE ($96\\to 48\\to 16\\to 48\\to 96$)")
            st.markdown("- **Vùng nhớ:** 32 KB Tensor Arena tĩnh (SRAM)")

        # Nút tiện ích quản lý cache
        if st.button("Làm mới Cache", icon=":material/refresh:", width="stretch"):
            st.cache_data.clear()
            st.success("Đã xóa cache thành công!")
            st.rerun()

        st.caption("Phiên bản giao diện: v0.2.0")
