"""
Module: dashboard/components/sidebar.py
Nhiệm vụ: Render thanh điều hướng Sidebar tinh gọn, giải phóng thị giác.
"""

import streamlit as st


def render_sidebar():
    """Hiển thị sidebar gọn gàng, đưa thông số phụ vào Expander."""
    with st.sidebar:
        # Header định danh trạm đo & trạng thái kết nối
        st.markdown("### 🌱 Ag-IoT TinyML")
        st.caption("ESP32-S3 Soil Anomaly Pipeline")
        st.markdown(":green-badge[ESP32-S3 Online] :blue-badge[Full INT8]")
        st.markdown("---")

        # Thu gọn thông tin đề tài & cấu hình vào expander
        with st.expander("ℹ️ Thông tin Đề tài & MCU", expanded=False):
            st.markdown("**🎓 Khóa luận Tốt nghiệp:**")
            st.markdown("- **SV thực hiện:** Nguyễn Phi Hùng")
            st.markdown("- **Ngành:** Công nghệ Thông tin")
            st.markdown("- **Đơn vị:** Trường ĐH An Giang – ĐHQG-HCM")
            st.markdown("---")
            st.markdown("**⚙️ Cấu hình Tham chiếu:**")
            st.markdown("- **MCU:** ESP32-S3 (Xtensa LX7, 240MHz)")
            st.markdown("- **Cảm biến:** 3× MKE-S13 ($r=5\\text{ cm}$ đối xứng)")
            st.markdown("- **Model:** Dense AE ($96\\to 48\\to 16\\to 48\\to 96$)")
            st.markdown("- **Vùng nhớ:** 32 KB Tensor Arena tĩnh (SRAM)")

        # Nút tiện ích quản lý cache
        if st.button("🔄 Làm mới Cache", width="stretch"):
            st.cache_data.clear()
            st.success("Đã xóa cache thành công!")
            st.rerun()

        st.caption("Phiên bản giao diện: v0.2.0")
