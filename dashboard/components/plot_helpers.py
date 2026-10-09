"""
Module: dashboard/components/plot_helpers.py
Nhiệm vụ: Cung cấp bộ công cụ trực quan hóa Plotly tương tác chuẩn học thuật (Academic & Engineering grade):
- plot_triplet_signals: Đối chiếu 3 đường tín hiệu (Ground Truth vs Raw Corrupted vs Selective Imputed)
- plot_confidence_gauge: Đồng hồ đo Điểm Tin cậy Ct in [0.0, 1.0] với 3 phân vùng an toàn
- plot_channel_mse_bar: Biểu đồ cột bóc tách sai số tái tạo đa kênh MSE_k đối chiếu ngưỡng tau
- plot_spatial_consistency: Biểu đồ phân tán và vùng dung sai không gian giữa 3 cảm biến (S1, S2, S3)

Thiết kế tuân thủ hệ thống màu Tailwind/Inter:
- Slate-900 / Slate-500 typography
- Emerald-600 (#059669) cho Ground Truth / Bình thường
- Red-600 (#DC2626) cho Corrupted / Bị lỗi
- Blue-600 (#2563EB) cho Imputed / Phục hồi
- Amber-500 (#D97706) cho Cảnh báo / Nghi ngờ
"""

from typing import List, Optional, Sequence, Union
import numpy as np
import plotly.graph_objects as go

# Bảng màu chuẩn thiết kế (Academic / Modern Ag-IoT)
COLOR_GROUND_TRUTH = "#059669"  # Emerald 600 - Tín hiệu chuẩn
COLOR_CORRUPTED = "#DC2626"     # Red 600 - Tín hiệu thô lỗi
COLOR_IMPUTED = "#2563EB"       # Blue 600 - Tín hiệu phục hồi
COLOR_SUSPICIOUS = "#D97706"    # Amber 500 - Khả nghi
COLOR_MUTED_GRID = "#F1F5F9"    # Slate 100 - Đường lưới nhẹ
COLOR_TEXT_MAIN = "#0F172A"     # Slate 900 - Chữ chính
COLOR_TEXT_MUTED = "#64748B"    # Slate 500 - Chữ phụ


def _apply_academic_theme(fig: go.Figure, height: int = 380) -> go.Figure:
    """Tối ưu hóa layout chung cho biểu đồ theo phong cách hiện đại, thanh thoát."""
    fig.update_layout(
        height=height,
        template="plotly_white",
        font=dict(
            family="Inter, -apple-system, BlinkMacSystemFont, Segoe UI, Roboto, sans-serif",
            color=COLOR_TEXT_MAIN,
            size=12,
        ),
        plot_bgcolor="#FFFFFF",
        paper_bgcolor="rgba(0,0,0,0)",
        hoverlabel=dict(
            bgcolor="#0F172A",
            font=dict(color="#FFFFFF", family="JetBrains Mono, monospace", size=12),
            bordercolor="#334155",
        ),
        margin=dict(l=45, r=25, t=45, b=35),
    )
    return fig


def plot_triplet_signals(
    clean_series: Union[np.ndarray, Sequence[float]],
    corrupt_series: Union[np.ndarray, Sequence[float]],
    imputed_series: Union[np.ndarray, Sequence[float]],
    channel_name: str = "S1",
    title: Optional[str] = None,
    height: int = 400,
    show_uncertainty_band: bool = True,
) -> go.Figure:
    """
    Vẽ 3 đường tín hiệu trên cùng một cửa sổ trượt (W=32 mẫu, mỗi mẫu 5s):
    1. Ground Truth (Sạch) - Đường Emerald liền sắc nét
    2. Raw Corrupted (Thô bị lỗi) - Đường Red đứt nét mảnh kèm scatter marker
    3. Selective Imputed (Đã bù khôi phục) - Đường Blue nét gạch, marker kim cương
    
    Tùy chọn show_uncertainty_band hiển thị vùng dung sai ±0.03 VWC quanh Ground Truth.
    """
    clean_arr = np.asarray(clean_series, dtype=np.float64)
    corrupt_arr = np.asarray(corrupt_series, dtype=np.float64)
    imputed_arr = np.asarray(imputed_series, dtype=np.float64)
    n_samples = len(clean_arr)
    x_axis = np.arange(n_samples)

    fig = go.Figure()

    # Vùng dung sai vật lý tham chiếu (±3% VWC)
    if show_uncertainty_band and n_samples > 0:
        band_upper = clean_arr + 0.03
        band_lower = clean_arr - 0.03
        fig.add_trace(
            go.Scatter(
                x=np.concatenate([x_axis, x_axis[::-1]]),
                y=np.concatenate([band_upper, band_lower[::-1]]),
                fill="toself",
                fillcolor="rgba(5, 150, 105, 0.08)",
                line=dict(color="rgba(255,255,255,0)"),
                hoverinfo="skip",
                showlegend=True,
                name="Vùng dung sai chuẩn (±3% VWC)",
            )
        )

    # 1. Đường Ground Truth (Chuẩn mốc)
    fig.add_trace(
        go.Scatter(
            x=x_axis,
            y=clean_arr,
            mode="lines",
            name=f"{channel_name} Ground Truth (Chuẩn)",
            line=dict(color=COLOR_GROUND_TRUTH, width=2.6),
            hovertemplate="Mẫu %{x}: <b>%{y:.4f}</b> VWC<extra>Ground Truth</extra>",
        )
    )

    # 2. Đường Raw Corrupted (Tín hiệu thô bị lỗi)
    fig.add_trace(
        go.Scatter(
            x=x_axis,
            y=corrupt_arr,
            mode="lines+markers",
            name=f"{channel_name} Raw Corrupted (Thô)",
            line=dict(color=COLOR_CORRUPTED, width=1.6, dash="dot"),
            marker=dict(size=4.5, symbol="circle-open", line=dict(width=1.5, color=COLOR_CORRUPTED)),
            hovertemplate="Mẫu %{x}: <b>%{y:.4f}</b> VWC<extra>Raw Corrupted</extra>",
        )
    )

    # 3. Đường Selective Imputed (Sau phục hồi thích ứng)
    fig.add_trace(
        go.Scatter(
            x=x_axis,
            y=imputed_arr,
            mode="lines+markers",
            name=f"{channel_name} Imputed (Phục hồi)",
            line=dict(color=COLOR_IMPUTED, width=2.2, dash="dash"),
            marker=dict(size=5, symbol="diamond", color=COLOR_IMPUTED),
            hovertemplate="Mẫu %{x}: <b>%{y:.4f}</b> VWC<extra>Imputed</extra>",
        )
    )

    # Tiêu đề biểu đồ
    chart_title = (
        title
        if title
        else f"Đối chiếu 3 dạng sóng kênh {channel_name} trên cửa sổ trượt (W = {n_samples} mẫu • Ts = 5s)"
    )

    y_min = float(min(0.0, np.min(corrupt_arr) - 0.05, np.min(clean_arr) - 0.05))
    y_max = float(max(1.0, np.max(corrupt_arr) + 0.05, np.max(clean_arr) + 0.05))

    _apply_academic_theme(fig, height=height)
    fig.update_layout(
        title=dict(
            text=f"<b>{chart_title}</b>",
            x=0.01,
            y=0.96,
            font=dict(size=14, color=COLOR_TEXT_MAIN),
        ),
        xaxis=dict(
            title="Chỉ số mẫu thời gian trong cửa sổ (Timesteps)",
            gridcolor=COLOR_MUTED_GRID,
            zeroline=False,
            dtick=4 if n_samples <= 32 else None,
        ),
        yaxis=dict(
            title="Độ ẩm thể tích đất VWC (0.00 – 1.00)",
            gridcolor=COLOR_MUTED_GRID,
            zeroline=True,
            zerolinecolor="#E2E8F0",
            range=[y_min, y_max],
        ),
        hovermode="x unified",
        legend=dict(
            orientation="h",
            yanchor="bottom",
            y=1.02,
            xanchor="right",
            x=1.0,
            bgcolor="rgba(255, 255, 255, 0.85)",
            bordercolor="#E2E8F0",
            borderwidth=1,
        ),
    )

    return fig


def plot_confidence_gauge(
    ct_score: float,
    status_label: str = "VALID",
    height: int = 250,
) -> go.Figure:
    """
    Vẽ đồng hồ đo Điểm Tin cậy Ct in [0.0, 1.0] với 3 dải trạng thái chuẩn công nghiệp:
    - 0.00 – 0.50: UNRELIABLE (Đỏ - Khóa Fail-safe Relay ngắt bơm)
    - 0.50 – 0.85: SUSPICIOUS (Hổ phách - Kênh lỗi bị cô lập & bù Selective Imputation)
    - 0.85 – 1.00: VALID (Xanh lục - Dữ liệu sạch, tin cậy tuyệt đối)
    """
    ct_clamped = float(np.clip(ct_score, 0.0, 1.0))

    # Màu thanh kim chỉ báo theo trạng thái
    if ct_clamped < 0.50:
        bar_color = COLOR_CORRUPTED
        status_sub = "Khóa Relay khẩn cấp"
    elif ct_clamped < 0.85:
        bar_color = COLOR_SUSPICIOUS
        status_sub = "Cô lập kênh & bù thích ứng"
    else:
        bar_color = COLOR_GROUND_TRUTH
        status_sub = "Hệ thống tin cậy tuyệt đối"

    fig = go.Figure(
        go.Indicator(
            mode="gauge+number",
            value=ct_clamped,
            domain={"x": [0.05, 0.95], "y": [0.05, 0.95]},
            title={
                "text": f"<b>Điểm Tin Cậy <i>C<sub>t</sub></i></b><br><span style='font-size:12px;color:{COLOR_TEXT_MUTED}'>{status_label} • {status_sub}</span>",
                "font": {"size": 14, "color": COLOR_TEXT_MAIN, "family": "Inter, sans-serif"},
            },
            number={
                "font": {"size": 30, "family": "JetBrains Mono, monospace", "color": COLOR_TEXT_MAIN},
                "valueformat": ".3f",
            },
            gauge={
                "axis": {
                    "range": [0.0, 1.0],
                    "tickwidth": 1,
                    "tickcolor": COLOR_TEXT_MUTED,
                    "tickvals": [0.0, 0.25, 0.50, 0.75, 0.85, 1.0],
                    "ticktext": ["0.0", "0.25", "0.50 (τ_rel)", "0.75", "0.85 (τ_val)", "1.0"],
                },
                "bar": {"color": bar_color, "thickness": 0.24},
                "bgcolor": "#F8FAFC",
                "borderwidth": 1,
                "bordercolor": "#E2E8F0",
                "steps": [
                    {"range": [0.0, 0.50], "color": "rgba(220, 38, 38, 0.18)"},   # Red-50 / Red-100
                    {"range": [0.50, 0.85], "color": "rgba(217, 119, 6, 0.18)"},  # Amber-50 / Amber-100
                    {"range": [0.85, 1.00], "color": "rgba(5, 150, 105, 0.18)"},  # Emerald-50 / Emerald-100
                ],
                "threshold": {
                    "line": {"color": COLOR_TEXT_MAIN, "width": 3},
                    "thickness": 0.75,
                    "value": ct_clamped,
                },
            },
        )
    )

    _apply_academic_theme(fig, height=height)
    fig.update_layout(margin=dict(l=20, r=20, t=45, b=20))
    return fig


def plot_channel_mse_bar(
    mse_channels: Sequence[float],
    threshold_tau: float = 0.0075,
    height: int = 250,
) -> go.Figure:
    """
    Vẽ biểu đồ cột bóc tách sai số tái tạo MSE của từng cảm biến (S1, S2, S3)
    đối chiếu trực tiếp với đường ngưỡng cắt dị thường tau.
    """
    mse_list = [float(v) for v in mse_channels]
    channel_labels = [f"Cảm biến S{i+1}" for i in range(len(mse_list))]
    
    # Kênh vượt ngưỡng chuyển màu đỏ cảnh báo, kênh an toàn giữ màu xanh lục
    colors = [
        COLOR_CORRUPTED if mse > threshold_tau else COLOR_GROUND_TRUTH
        for mse in mse_list
    ]

    fig = go.Figure()

    fig.add_trace(
        go.Bar(
            x=channel_labels,
            y=mse_list,
            marker=dict(
                color=colors,
                line=dict(color="#0F172A", width=1),
                opacity=0.9,
            ),
            text=[f"{mse:.5f}" for mse in mse_list],
            textposition="outside",
            textfont=dict(family="JetBrains Mono, monospace", size=11, color=COLOR_TEXT_MAIN),
            hovertemplate="<b>%{x}</b><br>MSE: <b>%{y:.6f}</b><extra></extra>",
            name="MSE Kênh",
        )
    )

    # Đường ngưỡng cắt dị thường tau
    fig.add_hline(
        y=threshold_tau,
        line_dash="dash",
        line_color=COLOR_CORRUPTED,
        line_width=1.8,
        annotation_text=f"Ngưỡng τ = {threshold_tau:.4f}",
        annotation_position="top right",
        annotation_font=dict(size=11, color=COLOR_CORRUPTED, family="JetBrains Mono, monospace"),
    )

    max_mse = max(mse_list) if mse_list else 0.01
    y_limit = max(max_mse * 1.35, threshold_tau * 1.6, 0.01)

    _apply_academic_theme(fig, height=height)
    fig.update_layout(
        title=dict(
            text="<b>Bóc tách Sai số Tái tạo Cục bộ <i>MSE<sub>k</sub></i></b>",
            x=0.01,
            y=0.96,
            font=dict(size=13, color=COLOR_TEXT_MAIN),
        ),
        margin=dict(l=35, r=20, t=40, b=25),
        yaxis=dict(
            title="Sai số MSE",
            range=[0, y_limit],
            gridcolor=COLOR_MUTED_GRID,
            zeroline=False,
        ),
        xaxis=dict(
            gridcolor="rgba(0,0,0,0)",
        ),
        showlegend=False,
    )
    return fig


def plot_spatial_consistency(
    sensor_readings: Union[np.ndarray, Sequence[Sequence[float]]],
    tolerance_delta: float = 0.05,
    height: int = 300,
) -> go.Figure:
    """
    Biểu đồ phân tán và kiểm tra tính nhất quán không gian (Spatial Consistency) giữa 3 cảm biến.
    
    Trong cụm cảm biến tam giác đối xứng (r = 5cm), sự chênh lệch độ ẩm giữa 2 cảm biến bất kỳ
    không được vượt quá dung sai delta (mặc định 0.05 VWC hay 5%).
    
    Tham số:
    - sensor_readings: Mảng shape (W, 3) hoặc list 3 kênh độ ẩm theo thời gian
    - tolerance_delta: Ngưỡng dung sai chênh lệch không gian cho phép
    """
    readings = np.asarray(sensor_readings, dtype=np.float64)
    if readings.ndim == 1:
        # Nếu chỉ truyền 1 điểm mẫu (3 kênh)
        readings = readings.reshape(1, -1)

    n_samples, n_channels = readings.shape
    x_axis = np.arange(n_samples)

    fig = go.Figure()

    # Tính đường trung bình và dải dung sai bao quanh
    mean_trajectory = np.mean(readings, axis=1)
    upper_bound = mean_trajectory + tolerance_delta
    lower_bound = mean_trajectory - tolerance_delta

    # Vẽ dải dung sai không gian cho phép
    fig.add_trace(
        go.Scatter(
            x=np.concatenate([x_axis, x_axis[::-1]]),
            y=np.concatenate([upper_bound, lower_bound[::-1]]),
            fill="toself",
            fillcolor="rgba(37, 99, 235, 0.08)",
            line=dict(color="rgba(255,255,255,0)"),
            hoverinfo="skip",
            showlegend=True,
            name=f"Vùng dung sai không gian (±{tolerance_delta:.2f})",
        )
    )

    channel_colors = ["#2563EB", "#059669", "#7C3AED"]  # Blue, Emerald, Violet
    channel_symbols = ["circle", "square", "triangle-up"]

    for k in range(min(n_channels, 3)):
        fig.add_trace(
            go.Scatter(
                x=x_axis,
                y=readings[:, k],
                mode="lines+markers",
                name=f"Cảm biến S{k+1}",
                line=dict(color=channel_colors[k], width=1.8),
                marker=dict(size=4.5, symbol=channel_symbols[k]),
                hovertemplate=f"Mẫu %{{x}} • S{k+1}: <b>%{{y:.4f}}</b> VWC<extra></extra>",
            )
        )

    _apply_academic_theme(fig, height=height)
    fig.update_layout(
        title=dict(
            text="<b>Kiểm tra tính nhất quán không gian (Spatial Consistency • r = 5 cm)</b>",
            x=0.01,
            y=0.96,
            font=dict(size=13, color=COLOR_TEXT_MAIN),
        ),
        xaxis=dict(
            title="Chỉ số mẫu thời gian (Timesteps)",
            gridcolor=COLOR_MUTED_GRID,
            zeroline=False,
        ),
        yaxis=dict(
            title="Độ ẩm VWC (0.00 – 1.00)",
            gridcolor=COLOR_MUTED_GRID,
            zeroline=False,
        ),
        hovermode="x unified",
        legend=dict(
            orientation="h",
            yanchor="bottom",
            y=1.02,
            xanchor="right",
            x=1.0,
            bgcolor="rgba(255, 255, 255, 0.85)",
            bordercolor="#E2E8F0",
            borderwidth=1,
        ),
    )

    return fig
