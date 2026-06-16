"""CoolProp 汎用ラッパーユーティリティ

python/ ディレクトリから実行することを前提としている。
"""

from __future__ import annotations

try:
    from CoolProp.CoolProp import PropsSI
except ImportError as exc:
    raise ImportError(
        "CoolProp をインストールしてください: pip install CoolProp"
    ) from exc


# 物性識別子と SI 単位の対応
PROPERTY_UNITS: dict[str, str] = {
    "T":       "K",
    "P":       "Pa",
    "D":       "kg/m3",
    "H":       "J/kg",
    "S":       "J/(kg·K)",
    "C":       "J/(kg·K)",    # Cp
    "Cvmass":  "J/(kg·K)",    # Cv
    "V":       "Pa·s",        # 動粘度
    "L":       "W/(m·K)",     # 熱伝導率
    "Q":       "-",           # クオリティ
}


def get_property(
    output: str,
    input1: str,
    val1: float,
    input2: str,
    val2: float,
    fluid: str,
) -> float:
    """PropsSI の薄いラッパー。単一物性値を返す。"""
    return PropsSI(output, input1, val1, input2, val2, fluid)


def get_critical_point(fluid: str) -> dict[str, float]:
    """臨界点物性を返す。"""
    T_c = PropsSI("Tcrit", fluid)
    p_c = PropsSI("Pcrit", fluid)
    return {
        "T_crit":   T_c,
        "p_crit":   p_c,
        "rho_crit": PropsSI("rhomass_critical", fluid),
    }


def get_triple_point(fluid: str) -> dict[str, float]:
    """三重点物性を返す。"""
    return {
        "T_triple": PropsSI("Ttriple", fluid),
        "p_triple": PropsSI("ptriple", fluid),
    }


def get_fluid_constants(fluid: str, p_ref: float = 101325.0) -> dict[str, float]:
    """
    Modelica 側の PartialTwoPhaseMedium が要求する抽象定数を一括取得する。

    Peng-Robinson EOS（densitySinglePhase）が必要とする
    T_critical, p_critical, MM, omega に加え、
    specificEnthalpy_pT の定積比熱近似に使う cp_liquid/cp_vapor を
    基準圧力 p_ref [Pa] での飽和比熱として取得する。
    """
    sat_ref = get_saturation_properties_at_p(fluid, p_ref)
    return {
        "MM":               PropsSI("M", fluid),
        "T_critical":       PropsSI("Tcrit", fluid),
        "p_critical":       PropsSI("Pcrit", fluid),
        "d_critical":       PropsSI("rhomass_critical", fluid),
        "T_triple":         PropsSI("Ttriple", fluid),
        "p_triple":         PropsSI("ptriple", fluid),
        "T_normal_boiling": PropsSI("T", "P", 101325.0, "Q", 0, fluid),
        "omega":            PropsSI("acentric", fluid),
        "cp_liquid":        sat_ref["cp_l"],
        "cp_vapor":         sat_ref["cp_v"],
    }


def get_saturation_properties_at_T(fluid: str, T: float) -> dict[str, float]:
    """
    指定温度 T [K] での飽和物性（泡点・露点）を返す。

    Returns
    -------
    dict
        T, p_sat, rho_l/v, h_l/v, s_l/v, cp_l/v, mu_l/v, lambda_l/v を含む辞書
    """

    def _sat(prop: str, quality: float) -> float:
        return PropsSI(prop, "T", T, "Q", quality, fluid)

    return {
        "T":        T,
        "p_sat":    _sat("P",      0),
        "rho_l":    _sat("D",      0),
        "rho_v":    _sat("D",      1),
        "h_l":      _sat("H",      0),
        "h_v":      _sat("H",      1),
        "s_l":      _sat("S",      0),
        "s_v":      _sat("S",      1),
        "cp_l":     _sat("C",      0),
        "cp_v":     _sat("C",      1),
        "mu_l":     _sat("V",      0),
        "mu_v":     _sat("V",      1),
        "lambda_l": _sat("L",      0),
        "lambda_v": _sat("L",      1),
    }


def get_saturation_properties_at_p(fluid: str, p: float) -> dict[str, float]:
    """
    指定圧力 p [Pa] での飽和物性（泡点・露点）を返す。
    """

    def _sat(prop: str, quality: float) -> float:
        return PropsSI(prop, "P", p, "Q", quality, fluid)

    return {
        "p":        p,
        "T_sat":    _sat("T",      0),
        "rho_l":    _sat("D",      0),
        "rho_v":    _sat("D",      1),
        "h_l":      _sat("H",      0),
        "h_v":      _sat("H",      1),
        "s_l":      _sat("S",      0),
        "s_v":      _sat("S",      1),
        "cp_l":     _sat("C",      0),
        "cp_v":     _sat("C",      1),
        "mu_l":     _sat("V",      0),
        "mu_v":     _sat("V",      1),
        "lambda_l": _sat("L",      0),
        "lambda_v": _sat("L",      1),
    }
