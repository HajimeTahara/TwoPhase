within EAST.TwoPhaseFlow.Media.Interfaces;
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
  replaceable constant Real             omega_const                  "離心因子 (Pitzer acentric factor, PR EOS 用)";
  replaceable constant SpecificHeatCapacity cp_liquid_const            "飽和液の代表定圧比熱 [J/(kg·K)]（specificEnthalpy_pT 近似用）";
  replaceable constant SpecificHeatCapacity cp_vapor_const             "飽和蒸気の代表定圧比熱 [J/(kg·K)]（specificEnthalpy_pT 近似用）";

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
  // 単相物性（Peng-Robinson 状態方程式）
  // =====================================================================

  function prSolveZ
    "PR 3次方程式 Z³-(1-B)Z²+(A-3B²-2B)Z-(AB-B²-B³)=0 の圧縮因子を返す"
    input  Real    A      "PR 無次元パラメータ A = a(T)·p/(R·T)²";
    input  Real    B      "PR 無次元パラメータ B = b·p/(R·T)";
    input  Boolean liquid "true: 液相根（最小根）、false: 気相根（最大根）";
    output Real    Z      "圧縮因子";
  protected
    Real c2, c1, c0, p_, q_, D, m, alpha;
    Real u, v_, Z1, Z2, Z3;
  algorithm
    // PR 3次を標準形 Z³ + c2·Z² + c1·Z + c0 = 0 に整理
    c2 := -(1.0 - B);
    c1 :=  A - 3.0*B^2 - 2.0*B;
    c0 := -(A*B - B^2 - B^3);
    // 変数変換 Z = t - c2/3（2次項を消した抑圧3次: t³ + p_·t + q_ = 0）
    p_ := c1 - c2^2/3.0;
    q_ := c0 - c1*c2/3.0 + 2.0*c2^3/27.0;
    D  := (p_/3.0)^3 + (q_/2.0)^2;
    if D >= 0.0 then
      // 実根1つ（Cardano 公式）
      u  := -q_/2.0 + sqrt(D);
      v_ := -q_/2.0 - sqrt(D);
      Z  := (if u >= 0.0 then u^(1.0/3.0) else -((-u)^(1.0/3.0)))
          + (if v_ >= 0.0 then v_^(1.0/3.0) else -((-v_)^(1.0/3.0)))
          - c2/3.0;
    else
      // 実根3つ（三角関数法: t = m·cos(φ)）
      m     := 2.0*sqrt(-p_/3.0);
      alpha := Modelica.Math.acos(max(-1.0, min(1.0, -4.0*q_/m^3)));
      Z1    := m*Modelica.Math.cos(alpha/3.0)                                     - c2/3.0;
      Z2    := m*Modelica.Math.cos(alpha/3.0 + 2.0*Modelica.Constants.pi/3.0)    - c2/3.0;
      Z3    := m*Modelica.Math.cos(alpha/3.0 + 4.0*Modelica.Constants.pi/3.0)    - c2/3.0;
      Z     := if liquid then min(Z1, min(Z2, Z3)) else max(Z1, max(Z2, Z3));
    end if;
    Z := max(Z, 1.0e-10);  // 非物理的な負値・ゼロを排除
  end prSolveZ;

  function prDensity
    "Peng-Robinson 状態方程式による密度 [kg/m³]（単相; p と T が必要）"
    input  AbsolutePressure p;
    input  Temperature      T;
    input  Boolean          liquid "true: 液相根、false: 気相根";
    output Density          d;
  protected
    Real kappa, Tr, alpha_pr, a, b, A, B, Z;
  algorithm
    kappa    := 0.37464 + 1.54226*omega_const - 0.26992*omega_const^2;
    Tr       := T / T_critical;
    alpha_pr := (1.0 + kappa*(1.0 - sqrt(Tr)))^2;
    a := 0.45724 * Modelica.Constants.R^2 * T_critical^2 / p_critical * alpha_pr;
    b := 0.07780 * Modelica.Constants.R   * T_critical   / p_critical;
    A := a * p / (Modelica.Constants.R * T)^2;
    B := b * p / (Modelica.Constants.R * T);
    Z := prSolveZ(A, B, liquid);
    d := MM_const * p / (Z * Modelica.Constants.R * T);
  end prDensity;

  function densitySinglePhase
    "単相密度 [kg/m³]（PR EOS; T は飽和温度で近似。T(p,h) 実装後に精度向上）"
    input  AbsolutePressure p;
    input  SpecificEnthalpy h;
    output Density          d;
  protected
    SaturationProperties sat;
  algorithm
    sat := setSat_p(p);
    d   := prDensity(p, sat.Tsat, h < sat.h_bubble);
  end densitySinglePhase;

  function temperatureSinglePhase
    "単相温度 [K]（暫定: 飽和温度を返す。NASA 多項式 + PR 実装待ち）"
    input  AbsolutePressure p;
    input  SpecificEnthalpy h;
    output Temperature      T;
  protected
    SaturationProperties sat;
  algorithm
    sat := setSat_p(p);
    T   := sat.Tsat;
  end temperatureSinglePhase;

  function specificEnthalpy_pT
    "比エンタルピー [J/kg] を p, T から計算する（T 指定境界条件用; 定積比熱近似）"
    input  AbsolutePressure p;
    input  Temperature      T;
    output SpecificEnthalpy h;
  protected
    SaturationProperties sat;
  algorithm
    sat := setSat_p(p);
    if T <= sat.Tsat then
      h := sat.h_bubble + cp_liquid_const * (T - sat.Tsat);  // 過冷却液（近似）
    else
      h := sat.h_dew    + cp_vapor_const  * (T - sat.Tsat);  // 過熱蒸気（近似）
    end if;
  end specificEnthalpy_pT;

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
    <code>sat_h_bubble</code>, <code>sat_h_dew</code>, <code>sat_d_bubble</code>, <code>sat_d_dew</code>,
    <code>T_critical</code>, <code>p_critical</code>, <code>omega_const</code>,
    <code>cp_liquid_const</code>, <code>cp_vapor_const</code></li>
<li>単相域の密度（<code>densitySinglePhase</code>）は表引きではなく
    Peng-Robinson (PR) 状態方程式で計算する（後述）</li>
</ul>

<h4>単相密度モデル: Peng-Robinson (PR) 状態方程式</h4>
<p>
<code>densitySinglePhase</code> は表引きを使わず、PR 状態方程式から解析的に密度を計算する。
PR EOS は炭化水素・冷媒など幅広い流体に適用できる汎用立方状態方程式であり、
流体ごとに必要なパラメータが少ない（流体固有データを 4 個だけ持てばよい）という利点がある。
複数流体への展開（テーブル再生成が不要）を重視してこの方式を採用した。
</p>

<h5>状態方程式</h5>
<pre>
p = R·T / (v - b) - a(T) / (v² + 2bv - b²)
</pre>
<p>
ここで <code>v</code> はモル体積 [m³/mol]、<code>R</code> は気体定数。
パラメータ <code>a(T)</code>, <code>b</code> は臨界点物性と離心因子から次式で決まる。
</p>
<pre>
a(T) = 0.45724 · R²·Tc² / pc · α(T)
b    = 0.07780 · R·Tc / pc
α(T) = [1 + κ·(1 - √(T/Tc))]²
κ    = 0.37464 + 1.54226·ω - 0.26992·ω²
</pre>
<p>
<code>0.45724</code>, <code>0.07780</code>, <code>0.37464</code>, <code>1.54226</code>, <code>0.26992</code>
は PR EOS の普遍定数であり、流体には依存しない（Peng &amp; Robinson, 1976）。
流体ごとに異なるのは臨界温度 <code>Tc</code>、臨界圧力 <code>pc</code>、離心因子 <code>ω</code> のみ。
</p>

<h5>圧縮因子 Z の3次方程式（<code>prSolveZ</code>）</h5>
<p>
無次元パラメータ <code>A = a(T)·p/(R·T)²</code>, <code>B = b·p/(R·T)</code> を用いると、
圧縮因子 <code>Z = p·v/(R·T)</code> は次の3次方程式の根として得られる。
</p>
<pre>
Z³ - (1-B)·Z² + (A - 3B² - 2B)·Z - (AB - B² - B³) = 0
</pre>
<p>
液相条件では最小の実根、気相条件では最大の実根を採用する
（<code>prSolveZ</code> の <code>liquid</code> 引数で切替）。
判別式 D の符号に応じて Cardano の公式（実根1つ）または三角関数法（実根3つ）で解く。
密度は <code>d = MM·p / (Z·R·T)</code> から得られる（<code>prDensity</code>）。
</p>

<h5>流体ごとに必要なパラメータ</h5>
<table border=\"1\" cellspacing=\"0\">
<tr><th>定数</th><th>役割</th></tr>
<tr><td><code>T_critical</code></td><td>臨界温度 Tc [K]</td></tr>
<tr><td><code>p_critical</code></td><td>臨界圧力 pc [Pa]</td></tr>
<tr><td><code>omega_const</code></td><td>離心因子 ω (Pitzer acentric factor)</td></tr>
<tr><td><code>MM_const</code></td><td>モル質量 [kg/mol]</td></tr>
</table>
<p>
4 つすべて CoolProp から取得できる（<code>python/coolprop_utils.py</code> の
<code>get_fluid_constants</code>、生成スクリプトは <code>python/methane/constants.py</code>）。
</p>

<h5>精度・既知の制限</h5>
<ul>
<li>気相密度: 誤差 1% 程度。低圧～中圧の気相に対して良好な精度を持つ。</li>
<li>液相密度: 誤差 10～30% に達することがある（特に還元温度 T/Tc が低い極低温液体）。
    PR EOS は元来気相向けに開発された式であり、液相密度は系統的に過小評価される傾向がある。</li>
<li>体積補正（Péneloux 補正）を加えると液相誤差を大幅に改善できるが、現時点では未実装
    （次の増分として検討中）。</li>
<li><b><code>densitySinglePhase(p, h)</code> は現状、T に飽和温度 <code>sat.Tsat</code> を暫定的に使用している。</b>
    真の温度 T(p,h) を求める実装（NASA 多項式による理想気体エンタルピーを前提とした Newton 反復）は
    未着手であり、過冷却・過熱状態での温度・密度精度は限定的。</li>
<li>NASA 多項式・Péneloux 補正は現段階では実装しない（PR EOS のみの単相密度実装にとどめる方針）。</li>
</ul>

<h4>T 指定境界条件: specificEnthalpy_pT（定積比熱近似）</h4>
<p>
<code>specificEnthalpy_pT(p, T)</code> は、<code>Boundary_pT</code> / <code>MassFlowSource_T</code>
など温度で境界条件を与えるモデルのために、(p, T) から比エンタルピー h を計算する。
</p>
<pre>
T &le; Tsat(p):  h = h_bubble(p) + cp_liquid_const &middot; (T - Tsat(p))   過冷却液
T &gt;  Tsat(p):  h = h_dew(p)    + cp_vapor_const  &middot; (T - Tsat(p))   過熱蒸気
</pre>
<p>
<b>これは比熱を一定とみなした粗い近似であり、正確な熱力学関係式ではない。</b>
正確な h(p,T) には理想気体エンタルピー項（NASA 多項式）+ PR EOS 離脱関数が必要だが、
現段階ではこの構成要素を実装していないため、飽和点からの線形外挿で代用している。
飽和点に近い条件（小さな過冷却度・過熱度）では妥当だが、飽和点から離れるほど誤差が増大する。
</p>
<p>
<code>cp_liquid_const</code>, <code>cp_vapor_const</code> は具体的流体が提供する代表比熱
[J/(kg·K)]（CoolProp から代表圧力での飽和比熱を取得して設定する想定）。
</p>
</html>"));
end PartialTwoPhaseMedium;
