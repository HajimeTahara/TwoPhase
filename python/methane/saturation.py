"""メタン飽和物性の抽出スクリプト

python/ ディレクトリから実行する:
    python methane/saturation.py
"""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent))

import numpy as np
import pandas as pd
from coolprop_utils import get_saturation_properties_at_T
from methane import FLUID_NAME, T_TRIPLE, T_CRITICAL


def compute_saturation_curve(
    n_points: int = 200,
    T_min: float = T_TRIPLE + 0.5,
    T_max: float = T_CRITICAL - 0.1,
) -> pd.DataFrame:
    """
    飽和曲線データを計算して DataFrame で返す。

    Parameters
    ----------
    n_points : 計算点数
    T_min    : 最小温度 [K]（三重点よりわずかに高い値を推奨）
    T_max    : 最大温度 [K]（臨界点よりわずかに低い値を推奨）
    """
    T_values = np.linspace(T_min, T_max, n_points)
    records: list[dict] = []

    for T in T_values:
        try:
            records.append(get_saturation_properties_at_T(FLUID_NAME, T))
        except Exception as e:
            print(f"  警告: T={T:.2f} K でエラーが発生しました: {e}")

    return pd.DataFrame(records)


if __name__ == "__main__":
    print("メタン飽和曲線を計算中...")
    df = compute_saturation_curve(n_points=200)
    print(df.to_string(index=False, max_rows=10))
    print(f"\n計算点数: {len(df)} 点")

    output_path = Path(__file__).parent.parent / "output" / "methane_saturation.csv"
    df.to_csv(output_path, index=False)
    print(f"保存先: {output_path}")
