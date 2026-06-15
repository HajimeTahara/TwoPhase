within TwoPhaseMedia.Interfaces;
partial package PartialTwoPhaseMedium
  "気液二相媒体の抽象基底クラス（MSL 非依存）"

  // =====================================================================
  // 媒体定数（具体的流体で上書き）
  // =====================================================================
  constant String  mediumName  = "unnamed" "媒体名";
  constant Boolean singleState = false
    "= true のとき密度・内部エネルギーが圧力に依存しない";

  // 具体的流体が提供する抽象定数（値なし; extends 時に具体値を与える）
  replaceable constant MolarMass MM_const                           "モル質量 [kg/mol]";
  replaceable constant Temperature      T_critical                  "臨界温度 [K]";
  replaceable constant AbsolutePressure p_critical                  "臨界圧力 [Pa]";
  replaceable constant Density          d_critical                  "臨界密度 [kg/m³]";
  replaceable constant Temperature      T_triple                    "三重点温度 [K]";
  replaceable constant AbsolutePressure p_triple                    "三重点圧力 [Pa]";
  replaceable constant Temperature      T_normal_boiling             "常圧沸点 [K] (101325 Pa)";
  
  replaceable constant Integer   sat_n                                   "飽和テーブル点数";
  replaceable constant Real      sat_p[sat_n]        (each unit="Pa")    "飽和圧力グリッド [Pa]";
  replaceable constant Real      sat_T[sat_n]        (each unit="K")     "飽和温度 [K]";
  replaceable constant Real      sat_h_bubble[sat_n] (each unit="J/kg")  "飽和液比エンタルピー [J/kg]";
  replaceable constant Real      sat_h_dew[sat_n]    (each unit="J/kg")  "飽和蒸気比エンタルピー [J/kg]";
  replaceable constant Real      sat_d_bubble[sat_n] (each unit="kg/m3") "飽和液密度 [kg/m³]";
  replaceable constant Real      sat_d_dew[sat_n]    (each unit="kg/m3") "飽和蒸気密度 [kg/m³]";

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
  // 基礎レコード
  //
  // 共通フィールドをここで定義することで、このパッケージ内の関数が
  // ThermodynamicState / SaturationProperties のフィールドを直接参照できる。
  // 具体的流体は redeclare record extends で追加フィールドを設けてもよい。
  // =====================================================================
  replaceable record ThermodynamicState
    "熱力学状態レコード（p, h, phase を保持）"
    AbsolutePressure p          "圧力 [Pa]";
    SpecificEnthalpy h          "比エンタルピー [J/kg]";
    Integer phase(min=0, max=2) "相状態: 1=単相, 2=二相, 0=不明";
  end ThermodynamicState;

  replaceable record SaturationProperties
    "飽和物性レコード"
    AbsolutePressure psat     "飽和圧力 [Pa]";
    Temperature      Tsat     "飽和温度 [K]";
    SpecificEnthalpy h_bubble "飽和液比エンタルピー [J/kg]";
    SpecificEnthalpy h_dew    "飽和蒸気比エンタルピー [J/kg]";
    Density          d_bubble "飽和液密度 [kg/m³]";
    Density          d_dew    "飽和蒸気密度 [kg/m³]";
  end SaturationProperties;

  // =====================================================================
  // BaseProperties モデル
  //
  // 普遍的な熱力学恒等式をここで定義する。
  // 流体固有の算出（d, T, phase, MM）はパッケージ関数に委譲する。
  // 具体的流体は抽象定数に値を与えるだけでよい。
  // =====================================================================
  model BaseProperties
    "二相媒体の基礎物性（p, h 独立変数）"

    connector InputAbsolutePressure = input Modelica.Units.SI.AbsolutePressure;
    connector InputSpecificEnthalpy = input Modelica.Units.SI.SpecificEnthalpy;

    InputAbsolutePressure p "圧力 [Pa]";
    InputSpecificEnthalpy h "比エンタルピー [J/kg]";

    Density             d   "密度 [kg/m³]";
    Temperature         T   "温度 [K]";
    SpecificInternalEnergy u   "比内部エネルギー [J/kg]";
    SpecificHeatCapacity   R_s "比気体定数 [J/(kg·K)]";
    MolarMass              MM  "モル質量 [kg/mol]";

    Integer phase(min=0, max=2, start=1)
      "相状態: 1 = 単相, 2 = 二相, 0 = 不明";

    ThermodynamicState   state "熱力学状態レコード";
    SaturationProperties sat   "圧力 p における飽和物性";

    parameter Boolean preferredMediumStates = false
      annotation (Evaluate=true, Dialog(tab="Advanced"));

  equation
    state = setState_ph(p, h);
    sat   = setSat_p(p);
    d     = density(state);
    T     = temperature(state);
    phase = phaseOf(state);
    MM    = molarMass(state);
    // 普遍的熱力学恒等式
    u   = h - p / d;
    R_s = Modelica.Constants.R / MM;

  end BaseProperties;

  // =====================================================================
  // ユーティリティ関数
  // =====================================================================

  function interpolate1D
    "1次元テーブルの線形補間（範囲外はクランプ）"
    input  Real xTable[:] "独立変数テーブル（昇順）";
    input  Real yTable[:] "従属変数テーブル（xTable と同サイズ）";
    input  Real x         "補間点";
    output Real y         "補間値";
  protected
    Integer n = size(xTable, 1);
    Integer i;
  algorithm
    if x <= xTable[1] then
      y := yTable[1];
    elseif x >= xTable[n] then
      y := yTable[n];
    else
      i := 1;
      while i < n - 1 and x > xTable[i + 1] loop
        i := i + 1;
      end while;
      y := yTable[i] + (yTable[i + 1] - yTable[i]) *
           (x - xTable[i]) / (xTable[i + 1] - xTable[i]);
    end if;
  end interpolate1D;

  // =====================================================================
  // 熱力学状態関数（基底クラスに実装、具体的流体は変更不要）
  // =====================================================================

  function setState_ph
    "p, h から熱力学状態を生成する（飽和テーブルで相判定）"
    input  AbsolutePressure   p;
    input  SpecificEnthalpy   h;
    output ThermodynamicState state;
  protected
    SaturationProperties sat;
  algorithm
    state.p := p;
    state.h := h;
    sat := setSat_p(p);
    if h <= sat.h_bubble then
      state.phase := 1;      // 過冷却液
    elseif h >= sat.h_dew then
      state.phase := 1;      // 過熱蒸気
    else
      state.phase := 2;      // 気液二相
    end if;
  end setState_ph;

  function pressure
    "熱力学状態から圧力を返す [Pa]"
    input  ThermodynamicState state;
    output AbsolutePressure   p;
  algorithm
    p := state.p;
  end pressure;

  function phaseOf
    "熱力学状態から相状態を返す (1=単相, 2=二相)"
    input  ThermodynamicState state;
    output Integer            phase(min=0, max=2);
  algorithm
    phase := state.phase;
  end phaseOf;

  function vapourQuality
    "乾き度 x を返す（単相: 0=液, 1=蒸気）"
    input  ThermodynamicState state;
    output Real x(unit="1", min=0, max=1);
  protected
    SaturationProperties sat;
  algorithm
    sat := setSat_p(state.p);
    if state.phase == 2 then
      x := max(0.0, min(1.0,
             (state.h - sat.h_bubble) / (sat.h_dew - sat.h_bubble)));
    else
      x := if state.h <= sat.h_bubble then 0.0 else 1.0;
    end if;
  end vapourQuality;

  function density
    "密度を返す [kg/m³]（二相: 混合密度式; 単相: densitySinglePhase に委譲）"
    input  ThermodynamicState state;
    output Density            d;
  protected
    SaturationProperties sat;
    Real x;
  algorithm
    if state.phase == 2 then
      sat := setSat_p(state.p);
      x   := max(0.0, min(1.0,
               (state.h - sat.h_bubble) / (sat.h_dew - sat.h_bubble)));
      // HEM 混合密度: 1/d = x/ρv + (1-x)/ρl
      d := 1.0 / (x / sat.d_dew + (1.0 - x) / sat.d_bubble);
    else
      d := densitySinglePhase(state.p, state.h);
    end if;
  end density;

  function temperature
    "温度を返す [K]（二相: 飽和温度; 単相: temperatureSinglePhase に委譲）"
    input  ThermodynamicState state;
    output Temperature        T;
  protected
    SaturationProperties sat;
  algorithm
    if state.phase == 2 then
      sat := setSat_p(state.p);
      T   := sat.Tsat;
    else
      T := temperatureSinglePhase(state.p, state.h);
    end if;
  end temperature;

  function bubbleDensity
    "飽和液密度を返す [kg/m³]"
    input  SaturationProperties sat;
    output Density              dl;
  algorithm
    dl := sat.d_bubble;
  end bubbleDensity;

  function dewDensity
    "飽和蒸気密度を返す [kg/m³]"
    input  SaturationProperties sat;
    output Density              dv;
  algorithm
    dv := sat.d_dew;
  end dewDensity;

  function bubbleEnthalpy
    "飽和液比エンタルピーを返す [J/kg]"
    input  SaturationProperties sat;
    output SpecificEnthalpy     hl;
  algorithm
    hl := sat.h_bubble;
  end bubbleEnthalpy;

  function dewEnthalpy
    "飽和蒸気比エンタルピーを返す [J/kg]"
    input  SaturationProperties sat;
    output SpecificEnthalpy     hv;
  algorithm
    hv := sat.h_dew;
  end dewEnthalpy;

  // =====================================================================
  // ボイド率（HEM、共通実装）
  // =====================================================================
  function voidFraction
    "ボイド率 α を返す（均質平衡モデル、スリップ比 S = 1）"
    input  ThermodynamicState state;
    output Real alpha(unit="1", min=0, max=1) "ボイド率";
  protected
    Real                 x;
    SaturationProperties sat;
  algorithm
    x := vapourQuality(state);
    if x <= 0.0 then
      alpha := 0.0;
    elseif x >= 1.0 then
      alpha := 1.0;
    else
      sat   := setSat_p(state.p);
      // HEM: α = 1 / (1 + (1-x)/x · ρv/ρl)
      alpha := 1.0 / (1.0 + (1.0 - x) / x * sat.d_dew / sat.d_bubble);
    end if;
  end voidFraction;

  // =====================================================================
  // 飽和物性・物質定数（抽象定数を参照する共通実装）
  // =====================================================================

  function setSat_p
    "圧力から飽和物性を返す（飽和テーブルで線形補間）"
    input  AbsolutePressure     p;
    output SaturationProperties sat;
  algorithm
    sat.psat     := p;
    sat.Tsat     := interpolate1D(sat_p, sat_T,        p);
    sat.h_bubble := interpolate1D(sat_p, sat_h_bubble, p);
    sat.h_dew    := interpolate1D(sat_p, sat_h_dew,    p);
    sat.d_bubble := interpolate1D(sat_p, sat_d_bubble, p);
    sat.d_dew    := interpolate1D(sat_p, sat_d_dew,    p);
  end setSat_p;

  function molarMass
    "モル質量を返す [kg/mol]"
    input  ThermodynamicState state;
    output MolarMass          MM;
  algorithm
    MM := MM_const;
  end molarMass;

  // =====================================================================
  // 単相物性スタブ（2D テーブル追加後にこのクラスへ実装）
  // =====================================================================

  function densitySinglePhase
    "単相密度 [kg/m³]（2D テーブル実装待ち）"
    input  AbsolutePressure p;
    input  SpecificEnthalpy h;
    output Density          d;
  algorithm
    d := 0;
  end densitySinglePhase;

  function temperatureSinglePhase
    "単相温度 [K]（2D テーブル実装待ち）"
    input  AbsolutePressure p;
    input  SpecificEnthalpy h;
    output Temperature      T;
  algorithm
    T := 0;
  end temperatureSinglePhase;

  annotation (Documentation(info="<html>
<p>
<em>cEAST.TwoPhaseMedia</em> の抽象基底クラス。<code>Modelica.Media</code> 非依存。
</p>
<h4>設計方針</h4>
<ul>
<li>普遍的な熱力学方程式（<code>u = h - p/d</code>, <code>R_s = R/MM</code>）は
    <code>BaseProperties</code> に一度だけ記述する</li>
<li>二相域の物性計算（密度・温度・乾き度・ボイド率）はこのクラスに実装済み</li>
<li>具体的流体が提供すべき抽象定数:
    <code>MM_const</code>, <code>sat_n</code>, <code>sat_p</code>, <code>sat_T</code>,
    <code>sat_h_bubble</code>, <code>sat_h_dew</code>, <code>sat_d_bubble</code>, <code>sat_d_dew</code></li>
<li>単相域の実装（<code>densitySinglePhase</code>, <code>temperatureSinglePhase</code>）は
    2次元物性テーブル生成後にこのクラスへ追加する</li>
</ul>
</html>"));
end PartialTwoPhaseMedium;
