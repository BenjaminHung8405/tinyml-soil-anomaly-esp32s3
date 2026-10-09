"""
dashboard/components/__init__.py
Cung cấp các component và helper dùng chung trong dashboard Ag-IoT TinyML.
"""

from .plot_helpers import (
    plot_triplet_signals,
    plot_confidence_gauge,
    plot_channel_mse_bar,
    plot_spatial_consistency,
)
from .sidebar import render_sidebar
from .data_loader import load_sample_windows

__all__ = [
    "plot_triplet_signals",
    "plot_confidence_gauge",
    "plot_channel_mse_bar",
    "plot_spatial_consistency",
    "render_sidebar",
    "load_sample_windows",
]
