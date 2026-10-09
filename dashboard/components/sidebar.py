"""
Module: dashboard/components/sidebar.py
Nhiệm vụ: Render thanh điều hướng Sidebar đồng bộ, thông tin phần cứng tham chiếu,
trạng thái hệ thống và công cụ quản trị cache.
"""

import streamlit as st


def render_sidebar():
    """Hiển thị sidebar chuyên nghiệp chứa thông tin đề tài, sinh viên, phần cứng và trạng thái trạm đo."""
    with st.sidebar:
        # Header trạm đo
        st.markdown("### Ag-IoT TinyML POC")
        st.caption("ESP32-S3 Soil Moisture Anomaly Pipeline")

        # Khối thông tin khóa luận
        with st.container(border=True):
            st.markdown("**Thông tin đề tài khóa luận**")
            st.markdown(
                "- **Sinh viên:** Nguyễn Phi Hùng  \n"
                "- **Ngành:** Công nghệ Thông tin  \n"
                "- **Đơn vị:** Trường ĐH An Giang – ĐHQG-HCM  \n"
                "- **Giai đoạn:** Phase 1 – Prototype Validation"
            )

        # Khối cấu hình phần cứng tham chiếu
        with st.container(border=True):
            st.markdown("**Cấu hình phần cứng tham chiếu**")
            st.markdown(
                "- **MCU:** ESP32-S3 (Xtensa Dual-Core LX7 @ 240 MHz)  \n"
                "- **Bộ nhớ:** 16 MB Flash • 8 MB Octal PSRAM  \n"
                "- **Cảm biến:** 3× MKE-S13 ($r = 5\\text{ cm}$ tam giác đối xứng)  \n"
                "- **Mô hình:** Dense AE ($96 \\to 48 \\to 16 \\to 48 \\to 96$)  \n"
                "- **Lượng tử hóa:** Full INT8 (PTQ - TFLite Micro)"
            )

        # Khối trạng thái & công cụ
        with st.container(border=True):
            st.markdown("**Trạng thái trạm biên**")
            st.markdown(":green-badge[Trực tuyến] :blue-badge[INT8 Active] :violet-badge[Fail-safe Ready]")
            st.caption("Cơ chế phục hồi Selective Imputation sẵn sàng can thiệp tức thời.")

            if st.button("Làm mới bộ nhớ đệm (Cache)", icon=":material/refresh:", width="stretch"):
                st.cache_data.clear()
                st.toast("Đã làm mới bộ đệm dữ liệu thành công!", icon=":material/check_circle:")
                st.rerun()

        st.caption("Phiên bản hệ thống: v0.1.4 • Sprint 1.1 Multi-page")
