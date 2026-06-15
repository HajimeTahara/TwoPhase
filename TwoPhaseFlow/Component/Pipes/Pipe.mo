within TwoPhaseFlow.Component.Pipes;
model Pipe
  "定常管モデル（圧損・入熱パラメータ直接指定）"

  replaceable package Medium = TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium
    annotation (choicesAllMatching=true);

  // ジオメトリ（将来の圧損・熱伝達相関式で参照）
  parameter Modelica.Units.SI.Length   L = 1.0  "管長 [m]";
  parameter Modelica.Units.SI.Diameter D = 0.01 "内径 [m]";

  // 直接指定パラメータ
  parameter Modelica.Units.SI.PressureDifference dp(min=0) = 0
    "圧力損失 [Pa]（port_a → port_b 方向）";
  parameter Modelica.Units.SI.HeatFlowRate Q_flow = 0
    "入熱量 [W]（正: 加熱、負: 冷却）";

  // ポート
  TwoPhaseFlow.Component.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium)
    "上流ポート（入口）";
  TwoPhaseFlow.Component.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium)
    "下流ポート（出口）";

  // 流量・エンタルピー
  Modelica.Units.SI.MassFlowRate     m_flow "質量流量 [kg/s]（a→b 方向正）";
  Modelica.Units.SI.SpecificEnthalpy h_in  "入口比エンタルピー [J/kg]";
  Modelica.Units.SI.SpecificEnthalpy h_out "出口比エンタルピー [J/kg]";

  // 入口・出口の流体状態（温度・密度・相・飽和物性を参照可能）
  Medium.BaseProperties props_a "入口流体状態";
  Medium.BaseProperties props_b "出口流体状態";

equation
  // --- 質量保存（定常）---
  port_a.m_flow + port_b.m_flow = 0;
  m_flow = port_a.m_flow;

  // --- 圧力損失（port_a → port_b 方向）---
  port_b.p = port_a.p - dp;

  // --- 入口エンタルピー（stream 変数から取得）---
  h_in = inStream(port_a.h_outflow);

  // --- エネルギー保存（定常）---
  // 積形式にすることで m_flow = 0, Q_flow = 0 時に 0 = 0 と整合する
  m_flow * h_out = m_flow * h_in + Q_flow;

  // --- 流体状態の計算（BaseProperties 経由）---
  props_a.p = port_a.p;
  props_a.h = h_in;
  props_b.p = port_b.p;
  props_b.h = h_out;

  // --- Stream 変数の束縛 ---
  port_b.h_outflow = h_out;                       // 正流（a→b）時の出口エンタルピー
  port_a.h_outflow = inStream(port_b.h_outflow);  // 逆流（b→a）時はパススルー近似

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
      Rectangle(
        extent={{-100,30},{100,-30}},
        lineColor={0,0,255},
        fillColor={0,128,255},
        fillPattern=FillPattern.HorizontalCylinder),
      Text(
        extent={{-100,60},{100,42}},
        lineColor={0,0,0},
        textString="%name")}),
    Documentation(info="<html>
<p>
定常単相・二相管モデル。圧力損失 <code>dp</code> と入熱量 <code>Q_flow</code> を
パラメータで直接指定する簡易版。
</p>

<h4>方程式</h4>
<ul>
<li>質量保存（定常）: <code>port_a.m_flow + port_b.m_flow = 0</code></li>
<li>圧力降下: <code>port_b.p = port_a.p - dp</code></li>
<li>エネルギー保存（定常）:
    <code>m_flow &middot; h_out = m_flow &middot; h_in + Q_flow</code></li>
</ul>

<h4>参照可能な内部変数</h4>
<ul>
<li><code>props_a.T</code>, <code>props_a.d</code>, <code>props_a.phase</code>
    — 入口の温度・密度・相</li>
<li><code>props_b.T</code>, <code>props_b.d</code>, <code>props_b.phase</code>
    — 出口の温度・密度・相</li>
<li><code>props_a.sat</code>, <code>props_b.sat</code>
    — 入口・出口圧力での飽和物性（泡点/露点エンタルピー・密度・温度）</li>
</ul>

<h4>制限事項・将来拡張</h4>
<ul>
<li>定常モデル: 流体の慣性・蓄積は考慮しない</li>
<li>逆流（b→a）時のエンタルピー変化は計算しない（パススルー近似）</li>
<li><code>m_flow = 0</code> かつ <code>Q_flow &ne; 0</code> は定常的に矛盾する条件</li>
<li>将来: <code>dp</code> を Friedel / Lockhart-Martinelli 等の相関式に、
    <code>Q_flow</code> を沸騰・凝縮熱伝達相関式に置き換え可能</li>
</ul>
</html>"));
end Pipe;
