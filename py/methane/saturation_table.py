"""メタン飽和テーブル生成スクリプト

圧力軸（対数グリッド）で飽和物性を計算し、
LCH パッケージへ直接貼り付け可能な Modelica constant 宣言を出力する。

python/ ディレクトリから実行する:
    python methane/saturation_table.py
"""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent))

import numpy as np
from coolprop_utils import get_saturation_properties_at_p
from methane import FLUID_NAME, P_TRIPLE, P_CRITICAL

OUTPUT_DIR = Path(__file__).parent.parent / "output"


def compute_saturation_table(
    n_points: int = 100,
    p_min_factor: float = 1.01,   # 三重点より少し高い圧力から開始
    p_max_factor: float = 0.995,  # 臨界点より少し低い圧力で終了
) -> dict[str, np.ndarray]:
    """
    圧力の対数グリッドで飽和物性テーブルを計算する。

    Returns
    -------
    keys: p, T_sat, h_bubble, h_dew, d_bubble, d_dew
    """
    p_min = P_TRIPLE * p_min_factor
    p_max = P_CRITICAL * p_max_factor
    p_values = np.logspace(np.log10(p_min), np.log10(p_max), n_points)

    rows: list[dict] = []
    for p in p_values:
        try:
            props = get_saturation_properties_at_p(FLUID_NAME, p)
            rows.append({
                "p":        p,
                "T_sat":    props["T_sat"],
                "h_bubble": props["h_l"],
                "h_dew":    props["h_v"],
                "d_bubble": props["rho_l"],
                "d_dew":    props["rho_v"],
            })
        except Exception as e:
            print(f"  警告: p={p:.2f} Pa でエラー: {e}", file=sys.stderr)

    keys = ["p", "T_sat", "h_bubble", "h_dew", "d_bubble", "d_dew"]
    return {k: np.array([r[k] for r in rows]) for k in keys}


def _array_literal(values: np.ndarray, items_per_line: int = 5) -> str:
    """numpy 配列を Modelica のカーリーブレース配列リテラルに変換する。"""
    formatted = [f"{v:.8g}" for v in values]
    lines: list[str] = []
    for i in range(0, len(formatted), items_per_line):
        chunk = formatted[i:i + items_per_line]
        lines.append("    " + ", ".join(chunk))
    return "{\n" + ",\n".join(lines) + "}"


def generate_modelica_snippet(table: dict[str, np.ndarray]) -> str:
    """
    LCH パッケージへの挿入用 Modelica スニペットを返す。
    """
    n = len(table["p"])
    meta = (
        f"  // --- 飽和テーブル（CoolProp/{FLUID_NAME}, {n} 点, 対数圧力グリッド）---\n"
        f"  // p: {table['p'][0]:.4g} Pa ~ {table['p'][-1]:.4g} Pa\n"
        f"  constant Integer sat_n = {n};"
    )

    entries = [
        ("sat_p",        "Pa",    "飽和圧力グリッド",       "p"),
        ("sat_T",        "K",     "飽和温度",               "T_sat"),
        ("sat_h_bubble", "J/kg",  "飽和液比エンタルピー",   "h_bubble"),
        ("sat_h_dew",    "J/kg",  "飽和蒸気比エンタルピー", "h_dew"),
        ("sat_d_bubble", "kg/m3", "飽和液密度",             "d_bubble"),
        ("sat_d_dew",    "kg/m3", "飽和蒸気密度",           "d_dew"),
    ]

    decls: list[str] = [meta]
    for var_name, unit, description, key in entries:
        literal = _array_literal(table[key])
        decls.append(
            f'\n  constant Real {var_name}[sat_n](each unit="{unit}") =\n'
            f'  {literal}\n'
            f'  "{description}";'
        )

    return "\n".join(decls)


if __name__ == "__main__":
    print("メタン飽和テーブルを計算中 (100点, 対数グリッド)...")
    table = compute_saturation_table(n_points=100)
    n = len(table["p"])
    print(f"計算完了: {n} 点")
    print(f"  圧力範囲:   {table['p'][0]:.4g} Pa ~ {table['p'][-1]:.4g} Pa")
    print(f"  T_sat 範囲: {table['T_sat'][0]:.4g} K ~ {table['T_sat'][-1]:.4g} K")
    print(f"  h_bubble:   {table['h_bubble'][0]:.4g} ~ {table['h_bubble'][-1]:.4g} J/kg")
    print(f"  h_dew:      {table['h_dew'][0]:.4g} ~ {table['h_dew'][-1]:.4g} J/kg")

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    # Modelica スニペット出力
    snippet = generate_modelica_snippet(table)
    snippet_path = OUTPUT_DIR / "lch_saturation_table.mo_snippet"
    snippet_path.write_text(snippet, encoding="utf-8")
    print(f"\nModelica スニペット: {snippet_path}")

    # CSV 出力（確認用）
    import pandas as pd
    df = pd.DataFrame(table)
    csv_path = OUTPUT_DIR / "methane_saturation_table.csv"
    df.to_csv(csv_path, index=False)
    print(f"CSV:               {csv_path}")

    # スニペット先頭を表示
    print("\n--- Modelica スニペット（先頭部分）---")
    for line in snippet.splitlines()[:12]:
        print(line)
    print("  ...")
