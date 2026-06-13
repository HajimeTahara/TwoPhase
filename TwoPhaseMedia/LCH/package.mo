within TwoPhaseMedia;
partial package LCH "液体メタン (CH₄) 媒体パッケージ"
  extends TwoPhaseMedia.Interfaces.PartialTwoPhaseMedium(
    mediumName  = "Liquid Methane (CH4)",
    singleState = false);

  // =====================================================================
  // 物質定数
  // =====================================================================
  constant MolarMass        MM_const         = 0.016043 "モル質量 [kg/mol]";
  constant Temperature      T_critical       = 190.564  "臨界温度 [K]";
  constant AbsolutePressure p_critical       = 4.5992e6 "臨界圧力 [Pa]";
  constant Density          d_critical       = 162.66   "臨界密度 [kg/m³]";
  constant Temperature      T_triple         = 90.694   "三重点温度 [K]";
  constant AbsolutePressure p_triple         = 11696.0  "三重点圧力 [Pa]";
  constant Temperature      T_normal_boiling = 111.66   "常圧沸点 [K] (101325 Pa)";

  // =====================================================================
  // 熱力学状態レコード（p, h, phase を保持）
  // =====================================================================
  redeclare record extends ThermodynamicState
    AbsolutePressure p          "圧力 [Pa]";
    SpecificEnthalpy h          "比エンタルピー [J/kg]";
    Integer phase(min=0, max=2) "相状態: 1=単相, 2=二相, 0=不明";
  end ThermodynamicState;

  // =====================================================================
  // 飽和物性レコード（psat, Tsat に加えてエンタルピー・密度を保持）
  // =====================================================================
  redeclare record extends SaturationProperties
    SpecificEnthalpy h_bubble "飽和液比エンタルピー [J/kg]";
    SpecificEnthalpy h_dew    "飽和蒸気比エンタルピー [J/kg]";
    Density          d_bubble "飽和液密度 [kg/m³]";
    Density          d_dew    "飽和蒸気密度 [kg/m³]";
  end SaturationProperties;

  // =====================================================================
  // 関数実装
  //
  // 定数で決まるもの（molarMass, pressure, phaseOf, bubbleDensity 等）は
  // ここで完全実装する。
  // 物性テーブルが必要なもの（setState_ph, density, temperature, setSat_p）は
  // python/methane/export.py でテーブルを生成後に実装する。
  // =====================================================================

  redeclare function extends molarMass
    "メタンのモル質量を返す（定数）"
  algorithm
    MM := MM_const;
  end molarMass;

  redeclare function extends pressure
    "状態レコードから圧力を返す"
  algorithm
    p := state.p;
  end pressure;

  redeclare function extends phaseOf
    "状態レコードから相状態を返す"
  algorithm
    phase := state.phase;
  end phaseOf;

  redeclare function extends bubbleDensity
    "飽和物性レコードから飽和液密度を返す"
  algorithm
    dl := sat.d_bubble;
  end bubbleDensity;

  redeclare function extends dewDensity
    "飽和物性レコードから飽和蒸気密度を返す"
  algorithm
    dv := sat.d_dew;
  end dewDensity;

  redeclare function extends bubbleEnthalpy
    "飽和物性レコードから飽和液比エンタルピーを返す"
  algorithm
    hl := sat.h_bubble;
  end bubbleEnthalpy;

  redeclare function extends dewEnthalpy
    "飽和物性レコードから飽和蒸気比エンタルピーを返す"
  algorithm
    hv := sat.h_dew;
  end dewEnthalpy;

  redeclare function extends vapourQuality
    "乾き度 x を返す（飽和エンタルピーとの比較）"
  protected
    SaturationProperties sat;
  algorithm
    sat := setSat_p(state.p);
    if state.phase == 1 then
      x := if state.h <= sat.h_bubble then 0.0 else 1.0;
    else
      x := if sat.h_dew > sat.h_bubble then
             (state.h - sat.h_bubble) / (sat.h_dew - sat.h_bubble)
           else 0.0;
    end if;
  end vapourQuality;

  // --- 物性テーブル実装待ち ---

  redeclare function extends setState_ph
    "p, h から熱力学状態を生成する（物性テーブル実装待ち）"
  algorithm
    state.p     := p;
    state.h     := h;
    state.phase := 0;
    assert(false, "LCH.setState_ph: python/methane/export.py でテーブルを生成後に実装してください");
  end setState_ph;

  redeclare function extends density
    "密度を返す（物性テーブル実装待ち）"
  algorithm
    assert(false, "LCH.density: 物性テーブル未実装");
    d := 0.0;
  end density;

  redeclare function extends temperature
    "温度を返す（物性テーブル実装待ち）"
  algorithm
    assert(false, "LCH.temperature: 物性テーブル未実装");
    T := 0.0;
  end temperature;

  redeclare function extends setSat_p
    "圧力から飽和物性を返す（物性テーブル実装待ち）"
  algorithm
    sat.psat     := p;
    sat.Tsat     := 0.0;
    sat.h_bubble := 0.0;
    sat.h_dew    := 0.0;
    sat.d_bubble := 0.0;
    sat.d_dew    := 0.0;
    assert(false, "LCH.setSat_p: 物性テーブル未実装");
  end setSat_p;

  annotation (Documentation(info="<html>
<p>
液体メタン (LCH: Liquid CHane, CH₄) の熱物性パッケージ。
</p>
<h4>実装方針</h4>
<p>
このパッケージは <b>物質固有のデータ入力のみ</b> を担う。
普遍的な熱力学方程式（<code>u = h - p/d</code>, <code>R_s = R/MM</code> 等）は
<code>TwoPhaseMedia.Interfaces.PartialTwoPhaseMedium.BaseProperties</code> に定義済みであり、
ここで再定義する必要はない。
</p>
<h4>物質定数（実装済み）</h4>
<ul>
<li>モル質量: 16.043 g/mol</li>
<li>臨界温度: 190.564 K / 臨界圧力: 4.5992 MPa</li>
<li>三重点温度: 90.694 K / 常圧沸点: 111.66 K</li>
</ul>
<h4>物性テーブル（未実装、CoolProp パイプライン待ち）</h4>
<ul>
<li><code>setState_ph</code> — p, h グリッドから d, T, phase をルックアップ</li>
<li><code>density</code>, <code>temperature</code> — state から物性を抽出</li>
<li><code>setSat_p</code> — 飽和曲線テーブルから飽和物性をルックアップ</li>
</ul>
<p>
<code>python/methane/export.py</code> を実行して Modelica テーブルスニペットを生成し、
上記関数に補間テーブルを実装すること。
</p>
</html>"));
end LCH;
