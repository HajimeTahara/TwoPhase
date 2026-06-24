"""メタン熱力学・輸送物性の抽出スクリプト（単相・二相）

python/ ディレクトリから実行する:
    python methane/properties.py
"""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent))

from itertools import product

import numpy as np
import pandas as pd
from CoolProp.CoolProp import PropsSI
from methane import FLUID_NAME

# 抽出する物性識別子（CoolProp 準拠）
_PROPS = ["D", "H", "S", "C", "Cvmass", "V", "L", "Q"]


def compute_properties_at(T: float, p: float) -> dict[str, float]:
    """
    指定 (T [K], p [Pa]) での熱力学・輸送物性を返す。

    Returns
    -------
    dict : T, P, D, H, S, C (Cp), Cvmass, V (粘度), L (熱伝導率), Q (クオリティ)
    """
    result: dict[str, float] = {"T": T, "P": p}
    for prop in _PROPS:
        try:
            result[prop] = PropsSI(prop, "T", T, "P", p, FLUID_NAME)
        except Exception:
            result[prop] = float("nan")
    return result


def compute_properties_at_ph(p: float, h: float) -> dict[str, float]:
    """
    指定 (p [Pa], h [J/kg]) での熱力学・輸送物性を返す。
    二相域を自然に扱えるため、Modelica の ph 基底変数と対応している。
    """
    result: dict[str, float] = {"P": p, "H": h}
    for prop in ["T", "D", "S", "C", "Cvmass", "V", "L", "Q"]:
        try:
            result[prop] = PropsSI(prop, "P", p, "H", h, FLUID_NAME)
        except Exception:
            result[prop] = float("nan")
    return result


def compute_Tp_grid(
    T_range: tuple[float, float] = (95.0, 400.0),
    p_range: tuple[float, float] = (0.1e6, 10.0e6),
    n_T: int = 50,
    n_p: int = 30,
) -> pd.DataFrame:
    """
    (T, p) グリッド上で物性を計算して DataFrame で返す。

    Parameters
    ----------
    T_range : 温度範囲 [K]
    p_range : 圧力範囲 [Pa]
    n_T     : 温度方向の点数
    n_p     : 圧力方向の点数
    """
    T_values = np.linspace(*T_range, n_T)
    p_values = np.linspace(*p_range, n_p)
    total = n_T * n_p

    records: list[dict] = []
    for i, (T, p) in enumerate(product(T_values, p_values)):
        records.append(compute_properties_at(T, p))
        if (i + 1) % 500 == 0:
            print(f"  {i + 1}/{total} 点完了")

    return pd.DataFrame(records)


if __name__ == "__main__":
    print("動作確認: T=150 K, p=1 MPa")
    props = compute_properties_at(T=150.0, p=1.0e6)
    col_width = max(len(k) for k in props)
    for k, v in props.items():
        print(f"  {k:<{col_width}} = {v:.6g}")

    print("\n動作確認: p=0.5 MPa, 二相域 (T=T_sat)")
    from CoolProp.CoolProp import PropsSI as _P
    T_sat = _P("T", "P", 0.5e6, "Q", 0, FLUID_NAME)
    h_l   = _P("H", "P", 0.5e6, "Q", 0, FLUID_NAME)
    h_v   = _P("H", "P", 0.5e6, "Q", 1, FLUID_NAME)
    h_mid = (h_l + h_v) / 2
    props2 = compute_properties_at_ph(p=0.5e6, h=h_mid)
    for k, v in props2.items():
        print(f"  {k:<{col_width}} = {v:.6g}")
