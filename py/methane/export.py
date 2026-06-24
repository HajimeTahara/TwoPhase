"""物性データのエクスポートユーティリティ

CSV ファイルおよび Modelica の CombiTable1Ds/CombiTable2Ds
に読み込み可能な形式でデータを出力する。

python/ ディレクトリから実行する:
    python methane/export.py
"""

from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent))

import pandas as pd

OUTPUT_DIR = Path(__file__).parent.parent / "output"


def to_csv(df: pd.DataFrame, filename: str) -> Path:
    """DataFrame を output/ 以下の CSV ファイルに保存する。"""
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    path = OUTPUT_DIR / filename
    df.to_csv(path, index=False)
    print(f"保存: {path}")
    return path


def to_modelica_table1d(
    df: pd.DataFrame,
    x_col: str,
    y_cols: list[str],
    var_name: str,
    description: str = "",
) -> str:
    """
    1次元テーブルデータを Modelica の parameter Real[][] リテラルとして返す。

    Modelica.Blocks.Tables.CombiTable1Ds の tableOnFile=false 形式に対応する。

    Parameters
    ----------
    x_col       : 独立変数の列名（テーブルの第 1 列）
    y_cols      : 従属変数の列名リスト
    var_name    : Modelica パラメータ変数名
    description : コメント文字列
    """
    cols = [x_col] + y_cols
    data = df[cols].dropna().reset_index(drop=True)
    n_rows = len(data)
    n_cols = len(cols)

    rows_str = ",\n".join(
        "    {" + ", ".join(f"{v:.8g}" for v in row) + "}"
        for _, row in data.iterrows()
    )
    col_comment = f"// [{', '.join(cols)}]"
    desc_str = f'"{description}"' if description else '""'

    return (
        f"  {col_comment}\n"
        f"  parameter Real {var_name}[{n_rows},{n_cols}](\n"
        f"    each unit=\"1\") = {{\n"
        f"{rows_str}\n"
        f"  }} annotation(Dialog(group={desc_str}));"
    )


def to_modelica_table2d(
    df: pd.DataFrame,
    x1_col: str,
    x2_col: str,
    y_col: str,
    var_name: str,
) -> str:
    """
    2次元テーブルデータを Modelica の parameter Real[][] リテラルとして返す。

    Modelica.Blocks.Tables.CombiTable2Ds の tableOnFile=false 形式に対応する。
    x1, x2 の一意な値でピボットし、先頭行・列にインデックスを挿入する。
    """
    x1_vals = sorted(df[x1_col].unique())
    x2_vals = sorted(df[x2_col].unique())

    pivot = df.pivot(index=x1_col, columns=x2_col, values=y_col)

    # CombiTable2Ds 形式: 先頭行 = x2 値, 先頭列 = x1 値
    header_row = [0.0] + list(x2_vals)
    data_rows = []
    for x1 in x1_vals:
        row = [x1] + [pivot.loc[x1, x2] for x2 in x2_vals]
        data_rows.append(row)

    all_rows = [header_row] + data_rows
    n_rows = len(all_rows)
    n_cols = len(header_row)

    rows_str = ",\n".join(
        "    {" + ", ".join(f"{v:.8g}" for v in row) + "}"
        for row in all_rows
    )

    return (
        f"  // x1={x1_col}, x2={x2_col}, y={y_col}\n"
        f"  parameter Real {var_name}[{n_rows},{n_cols}] = {{\n"
        f"{rows_str}\n"
        f"  }};"
    )


if __name__ == "__main__":
    from methane.saturation import compute_saturation_curve

    print("飽和曲線データを生成中...")
    df_sat = compute_saturation_curve(n_points=100)
    to_csv(df_sat, "methane_saturation.csv")

    # Modelica テーブル出力例（飽和液密度と飽和蒸気密度を温度の関数として）
    mo_str = to_modelica_table1d(
        df_sat,
        x_col="T",
        y_cols=["p_sat", "rho_l", "rho_v", "h_l", "h_v"],
        var_name="saturationTable",
        description="Methane saturation properties vs T",
    )
    print("\n--- Modelica テーブル（先頭 5 行のみ表示）---")
    print("\n".join(mo_str.splitlines()[:8]) + "\n  ...")

    mo_path = OUTPUT_DIR / "methane_saturation_table.mo_snippet"
    mo_path.write_text(mo_str, encoding="utf-8")
    print(f"保存: {mo_path}")
