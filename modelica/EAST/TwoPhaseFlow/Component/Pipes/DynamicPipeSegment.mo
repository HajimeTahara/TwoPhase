within EAST.TwoPhaseFlow.Component.Pipes;

model DynamicPipeSegment "動的管セグメント（単一 well-mixed 制御容積; DynamicPipe の内部要素）"
  replaceable package Medium = EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium annotation(
    choicesAllMatching = true);
  parameter Modelica.Units.SI.Volume V "セグメント容積 [m³]";
  parameter Modelica.Units.SI.PressureDifference dp(min = 0) = 0 "セグメント内の圧力損失 [Pa]（CV → port_b 方向の静的近似）";
  parameter Modelica.Units.SI.AbsolutePressure p_start = 1.0e5 "CV 内圧力の初期値 [Pa]";
  parameter Modelica.Units.SI.SpecificEnthalpy h_start = Medium.bubbleEnthalpy(Medium.setSat_p(p_start)) "CV 内比エンタルピーの初期値 [J/kg]（既定: p_start における飽和液）";
  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) "上流ポート（入口）" annotation(
    Placement(transformation(extent = {{-110, -10}, {-90, 10}})));
  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) "下流ポート（出口）" annotation(
    Placement(transformation(extent = {{90, -10}, {110, 10}})));
  EAST.TwoPhaseFlow.Component.Interfaces.HeatPort_a heatPort "外部熱源との接続用ポート（port.T = CV内の代表流体温度）" annotation(
    Placement(transformation(extent = {{-10, 40}, {10, 60}}), iconTransformation(origin = {0, -6}, extent = {{-10, 40}, {10, 60}})));
  // 状態変数（CV: このセグメントの容積 V に蓄えられた流体の代表状態）
  Modelica.Units.SI.AbsolutePressure p(start = p_start) "CV 内圧力 [Pa]（状態変数; port_a.p と一致）";
  Modelica.Units.SI.SpecificEnthalpy h(start = h_start) "CV 内比エンタルピー [J/kg]（状態変数; port_b.h_outflow と一致）";
  // 蓄積量
  Modelica.Units.SI.Mass M "CV内の流体質量 [kg]";
  Modelica.Units.SI.Energy U "CV内の流体内部エネルギー [J]";
  // CV の代表流体状態（温度・密度・相・飽和物性を参照可能）
  Medium.BaseProperties props "CV内の代表流体状態";
equation
// --- CV の代表流体状態 ---
  props.p = p;
  props.h = h;
// --- 質量・エネルギーの蓄積（容積 V を考慮した動的バランス）---
  M = props.d*V;
  U = M*props.u;
  port_a.m_flow + port_b.m_flow = 0;
  der(U) = port_a.m_flow*actualStream(port_a.h_outflow) + port_b.m_flow*actualStream(port_b.h_outflow) + heatPort.Q_flow;
// --- 圧力（CV → port_b 方向の静的圧損）---
  port_a.p = p;
  port_b.p = p - dp;
// --- Stream 変数の束縛（CV は単一の well-mixed ノード）---
  port_a.h_outflow = h;
  port_b.h_outflow = h;
// --- HeatPort 温度（CV の動的温度を使用）---
  heatPort.T = props.T;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = false), graphics = {Text(origin = {0, -233}, textColor = {0, 0, 255},extent = {{-100, 133}, {100, 93}}, textString = "%name"), Rectangle(fillColor = {0, 127, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, 44}, {100, -44}})}),
    Documentation(info = "<html>
<p>
<code>DynamicPipe</code> の内部要素として使う、単一 well-mixed 制御容積（CV）モデル。
<code>DynamicPipe</code> は本モデルを <code>nNodes</code> 個直列接続し、管内流体の移流
（軸方向の質量・エンタルピー輸送）を近似する。単体としても利用可能。
</p>

<h4>方程式</h4>
<ul>
<li>CV 代表状態: <code>props.p = p</code>, <code>props.h = h</code>（状態変数 <code>p</code>, <code>h</code>）</li>
<li>質量蓄積: <code>M = props.d &middot; V</code>, <code>der(M) = port_a.m_flow + port_b.m_flow</code></li>
<li>エネルギー蓄積: <code>U = M &middot; props.u</code>,
    <code>der(U) = port_a.m_flow &middot; actualStream(port_a.h_outflow)
    + port_b.m_flow &middot; actualStream(port_b.h_outflow) + heatPort.Q_flow</code></li>
<li>圧力: <code>port_a.p = p</code>, <code>port_b.p = p - dp</code></li>
<li>Stream 変数（well-mixed 近似）: <code>port_a.h_outflow = h</code>, <code>port_b.h_outflow = h</code></li>
<li>HeatPort 温度: <code>heatPort.T = props.T</code>（CV の動的温度をそのまま使用）</li>
</ul>

<h4>制限事項</h4>
<ul>
<li>1 CV 単体では well-mixed（井戸混合）近似であり、管内の移流（プラグフロー）は表現できない。
    移流を表現するには <code>DynamicPipe</code> 経由で複数セグメントを直列接続すること。</li>
<li>このバランスは <code>Medium</code> の密度・内部エネルギー関数を介して
    <code>der(M)</code>, <code>der(U)</code> を時間微分する陰関数 DAE であり、
    ツールが当該関数を自動微分（ダミー微分・指標低減）できることを前提とする。</li>
</ul>
</html>"),
    Diagram(graphics));
end DynamicPipeSegment;
