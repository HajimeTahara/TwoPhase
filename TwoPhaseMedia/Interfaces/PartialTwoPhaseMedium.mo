within TwoPhaseMedia.Interfaces;
partial package PartialTwoPhaseMedium
  "気液二相媒体の抽象基底クラス（MSL 非依存）"

  // =====================================================================
  // 媒体定数（具体的流体で上書き）
  // =====================================================================
  constant String  mediumName  = "unnamed" "媒体名";
  constant Boolean singleState = false
    "= true のとき密度・内部エネルギーが圧力に依存しない";

  // =====================================================================
  // 型エイリアス
  // =====================================================================
  type AbsolutePressure       = Modelica.Units.SI.AbsolutePressure;
  type Temperature            = Modelica.Units.SI.Temperature;
  type Density                = Modelica.Units.SI.Density;
  type SpecificEnthalpy       = Modelica.Units.SI.SpecificEnthalpy;
  type SpecificInternalEnergy = Modelica.Units.SI.SpecificInternalEnergy;
  type SpecificHeatCapacity   = Modelica.Units.SI.SpecificHeatCapacity;
  type MolarMass              = Modelica.Units.SI.MolarMass;
  type DynamicViscosity       = Modelica.Units.SI.DynamicViscosity;
  type ThermalConductivity    = Modelica.Units.SI.ThermalConductivity;

  // =====================================================================
  // 基礎レコード（具体的流体で redeclare）
  // =====================================================================
  replaceable record ThermodynamicState
    "熱力学状態レコード（具体的流体で拡張）"
  end ThermodynamicState;

  replaceable record SaturationProperties
    "飽和物性レコード（具体的流体で拡張）"
    AbsolutePressure psat "飽和圧力 [Pa]";
    Temperature      Tsat "飽和温度 [K]";
  end SaturationProperties;

  // =====================================================================
  // BaseProperties モデル
  //
  // 設計方針:
  //   - 普遍的な熱力学恒等式はこのクラスに記述する
  //   - 流体固有の物性算出（d, T, phase, MM）はパッケージ関数に委譲する
  //   - 具体的流体は replaceable 関数を実装するだけでよく、
  //     BaseProperties の redeclare は不要
  // =====================================================================
  partial model BaseProperties
    "二相媒体の基礎物性（p, h 独立変数）"

    connector InputAbsolutePressure = input Modelica.Units.SI.AbsolutePressure;
    connector InputSpecificEnthalpy = input Modelica.Units.SI.SpecificEnthalpy;

    // 独立変数
    InputAbsolutePressure p "圧力 [Pa]";
    InputSpecificEnthalpy h "比エンタルピー [J/kg]";

    // 計算物性
    Density             d   "密度 [kg/m³]";
    Temperature         T   "温度 [K]";
    SpecificInternalEnergy u   "比内部エネルギー [J/kg]";
    SpecificHeatCapacity   R_s "比気体定数 [J/(kg·K)]";
    MolarMass              MM  "モル質量 [kg/mol]";

    // 相状態
    Integer phase(min=0, max=2, start=1)
      "相状態: 1 = 単相, 2 = 二相, 0 = 不明";

    // 熱力学状態
    ThermodynamicState state "熱力学状態レコード";

    parameter Boolean preferredMediumStates = false
      "= true のとき StateSelect.prefer を p, h に付与"
      annotation (Evaluate=true, Dialog(tab="Advanced"));

  equation
    // 流体固有の物性算出（具体的流体が replaceable 関数で実装）
    state = setState_ph(p, h);
    d     = density(state);
    T     = temperature(state);
    phase = phaseOf(state);
    MM    = molarMass(state);

    // 普遍的熱力学恒等式（すべての媒体で成立、ここで一度だけ定義）
    u   = h - p / d;
    R_s = Modelica.Constants.R / MM;

    annotation (Documentation(info="<html>
<p>
気液二相媒体の基礎物性モデル（<code>p</code>, <code>h</code> 独立変数）。
</p>
<h4>方程式分担</h4>
<ul>
<li><b>PartialTwoPhaseMedium（本クラス）:</b>
  <code>u = h - p/d</code>,
  <code>R_s = R/MM</code> — 普遍的熱力学恒等式</li>
<li><b>具体的流体パッケージ（LCH 等）:</b>
  <code>setState_ph</code>, <code>density</code>, <code>temperature</code>,
  <code>phaseOf</code>, <code>molarMass</code> を実装し
  <code>d</code>, <code>T</code>, <code>phase</code>, <code>MM</code> を決定する</li>
</ul>
</html>"));
  end BaseProperties;

  // =====================================================================
  // 関数インターフェース（具体的流体で redeclare 実装）
  // =====================================================================

  replaceable function setState_ph
    "p, h から熱力学状態を生成する（主要ルックアップ関数）"
    input  AbsolutePressure   p "圧力 [Pa]";
    input  SpecificEnthalpy   h "比エンタルピー [J/kg]";
    output ThermodynamicState state;
  algorithm
    assert(false, "setState_ph: 具体的流体パッケージで実装してください");
  end setState_ph;

  replaceable function density
    "熱力学状態から密度を返す [kg/m³]"
    input  ThermodynamicState state;
    output Density            d;
  algorithm
    assert(false, "density: 具体的流体パッケージで実装してください");
  end density;

  replaceable function temperature
    "熱力学状態から温度を返す [K]"
    input  ThermodynamicState state;
    output Temperature        T;
  algorithm
    assert(false, "temperature: 具体的流体パッケージで実装してください");
  end temperature;

  replaceable function phaseOf
    "熱力学状態から相状態を返す (1=単相, 2=二相)"
    input  ThermodynamicState state;
    output Integer            phase(min=0, max=2);
  algorithm
    assert(false, "phaseOf: 具体的流体パッケージで実装してください");
  end phaseOf;

  replaceable function molarMass
    "モル質量を返す [kg/mol]"
    input  ThermodynamicState state;
    output MolarMass          MM;
  algorithm
    assert(false, "molarMass: 具体的流体パッケージで実装してください");
  end molarMass;

  replaceable function pressure
    "熱力学状態から圧力を返す [Pa]"
    input  ThermodynamicState state;
    output AbsolutePressure   p;
  algorithm
    assert(false, "pressure: 具体的流体パッケージで実装してください");
  end pressure;

  replaceable function vapourQuality
    "乾き度 x を返す（単相では 0 または 1）"
    input  ThermodynamicState state;
    output Real x(unit="1", min=0, max=1);
  algorithm
    assert(false, "vapourQuality: 具体的流体パッケージで実装してください");
  end vapourQuality;

  replaceable function setSat_p
    "圧力から飽和物性を返す"
    input  AbsolutePressure     p;
    output SaturationProperties sat;
  algorithm
    assert(false, "setSat_p: 具体的流体パッケージで実装してください");
  end setSat_p;

  replaceable function bubbleDensity
    "飽和液密度を返す [kg/m³]"
    input  SaturationProperties sat;
    output Density              dl;
  algorithm
    assert(false, "bubbleDensity: 具体的流体パッケージで実装してください");
  end bubbleDensity;

  replaceable function dewDensity
    "飽和蒸気密度を返す [kg/m³]"
    input  SaturationProperties sat;
    output Density              dv;
  algorithm
    assert(false, "dewDensity: 具体的流体パッケージで実装してください");
  end dewDensity;

  replaceable function bubbleEnthalpy
    "飽和液比エンタルピーを返す [J/kg]"
    input  SaturationProperties sat;
    output SpecificEnthalpy     hl;
  algorithm
    assert(false, "bubbleEnthalpy: 具体的流体パッケージで実装してください");
  end bubbleEnthalpy;

  replaceable function dewEnthalpy
    "飽和蒸気比エンタルピーを返す [J/kg]"
    input  SaturationProperties sat;
    output SpecificEnthalpy     hv;
  algorithm
    assert(false, "dewEnthalpy: 具体的流体パッケージで実装してください");
  end dewEnthalpy;

  // =====================================================================
  // ボイド率（HEM、共通実装）
  // =====================================================================
  function voidFraction
    "ボイド率 α を返す（均質平衡モデル、スリップ比 S = 1）"
    input  ThermodynamicState state "熱力学状態";
    output Real alpha(unit="1", min=0, max=1) "ボイド率";
  protected
    Real                 x     "乾き度";
    SaturationProperties sat   "飽和物性";
    Density              rho_l "飽和液密度 [kg/m³]";
    Density              rho_v "飽和蒸気密度 [kg/m³]";
  algorithm
    x := vapourQuality(state);
    if x <= 0.0 then
      alpha := 0.0;
    elseif x >= 1.0 then
      alpha := 1.0;
    else
      sat   := setSat_p(pressure(state));
      rho_l := bubbleDensity(sat);
      rho_v := dewDensity(sat);
      // HEM: α = 1 / (1 + (1-x)/x · ρv/ρl)
      alpha := 1.0 / (1.0 + (1.0 - x) / x * rho_v / rho_l);
    end if;
    annotation (Documentation(info="<html>
<p>
均質平衡モデル (HEM) に基づくボイド率計算。スリップ比 S = 1 を仮定。
ドリフトフラックスモデルへ拡張する場合は具体的流体パッケージで
<code>redeclare</code> してスリップ相関を追加する。
</p>
</html>"));
  end voidFraction;

  annotation (Documentation(info="<html>
<p>
<em>cEAST.TwoPhaseMedia</em> の抽象基底クラス。
<code>Modelica.Media</code> に依存しない独立したインターフェースを提供する。
</p>
<h4>設計方針</h4>
<ul>
<li>普遍的な熱力学方程式（<code>u = h - p/d</code>, <code>R_s = R/MM</code>）は
    <code>BaseProperties</code> に一度だけ記述する</li>
<li>具体的流体パッケージは <code>replaceable</code> 関数を実装するだけでよい
    （<code>BaseProperties</code> の <code>redeclare</code> 不要）</li>
<li>独立変数: <code>p</code>（圧力）と <code>h</code>（比エンタルピー）</li>
</ul>
</html>"));
end PartialTwoPhaseMedium;
