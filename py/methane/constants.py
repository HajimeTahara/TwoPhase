"""メタン物質定数（PR EOS 用）抽出スクリプト

CoolProp から臨界点・三重点・常圧沸点・離心因子を取得し、
LCH パッケージへ直接貼り付け可能な Modelica constant 宣言を出力する。

python/ ディレクトリから実行する:
    python methane/constants.py
"""

from __future__ import annotations

import sys
from pathlib import Path

sys.stdout.reconfigure(encoding="utf-8")
sys.path.insert(0, str(Path(__file__).parent.parent))

from coolprop_utils import get_fluid_constants
from methane import FLUID_NAME

OUTPUT_DIR = Path(__file__).parent.parent / "output"

# (定数名, 型, dict キー, 説明)
ENTRIES: list[tuple[str, str, str, str]] = [
    ("MM_const",         "MolarMass",       "MM",               "モル質量"),
    ("T_critical",       "Temperature",     "T_critical",       "臨界温度"),
    ("p_critical",       "AbsolutePressure", "p_critical",       "臨界圧力"),
    ("d_critical",       "Density",         "d_critical",       "臨界密度"),
    ("T_triple",         "Temperature",     "T_triple",         "三重点温度"),
    ("p_triple",         "AbsolutePressure", "p_triple",         "三重点圧力"),
    ("T_normal_boiling", "Temperature",     "T_normal_boiling", "常圧沸点 (101325 Pa)"),
    ("omega_const",      "Real",            "omega",            "離心因子 (CoolProp acentric, PR EOS 用)"),
    ("cp_liquid_const",  "SpecificHeatCapacity", "cp_liquid",    "飽和液の代表定圧比熱 (101325 Pa, specificEnthalpy_pT 用)"),
    ("cp_vapor_const",   "SpecificHeatCapacity", "cp_vapor",     "飽和蒸気の代表定圧比熱 (101325 Pa, specificEnthalpy_pT 用)"),
    ("mu_const",         "ViscosityCoefficient", "mu_liquid",     "代表粘性係数 (101325 Pa, 飽和液)"),
    ("lambda_const",     "ThermalConductivity", "lambda_liquid", "代表熱伝導率 (101325 Pa, 飽和液)"),
]


def generate_modelica_snippet(constants: dict[str, float]) -> str:
    """LCH パッケージへの挿入用 Modelica スニペットを返す。"""
    name_w = max(len(name) for name, _, _, _ in ENTRIES)
    type_w = max(len(type_) for _, type_, _, _ in ENTRIES)
    lines = [f"  // --- 流体定数（CoolProp/{FLUID_NAME}）---"]
    for name, type_, key, desc in ENTRIES:
        value = constants[key]
        lines.append(
            f'  redeclare constant {type_.ljust(type_w)} {name.ljust(name_w)} = {value:.6g} "{desc}";'
        )
    return "\n".join(lines)


if __name__ == "__main__":
    print(f"{FLUID_NAME} の物質定数を CoolProp から取得中...")
    constants = get_fluid_constants(FLUID_NAME)
    for key, value in constants.items():
        print(f"  {key}: {value:.6g}")

    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    snippet = generate_modelica_snippet(constants)
    snippet_path = OUTPUT_DIR / "lch_constants.mo_snippet"
    snippet_path.write_text(snippet, encoding="utf-8")
    print(f"\nModelica スニペット: {snippet_path}")
    print("\n--- Modelica スニペット ---")
    print(snippet)
