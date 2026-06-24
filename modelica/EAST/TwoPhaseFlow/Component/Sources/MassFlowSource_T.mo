within EAST.TwoPhaseFlow.Component.Sources;
model MassFlowSource_T
  "固定質量流量・固定温度 ソース"
extends EAST.Icons.MassFlowSource;
  replaceable package Medium = EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium
    annotation (choicesAllMatching=true);

  parameter Boolean use_m_flow_in = false
    "true の場合、質量流量を入力コネクタ m_flow_in から与える"
    annotation(Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter Boolean use_T_in = false
    "true の場合、温度を入力コネクタ T_in から与える"
    annotation(Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter Modelica.Units.SI.MassFlowRate m_flow_set = 1.0
    "固定質量流量（正: port へ流出）"
    annotation (Dialog(enable = not use_m_flow_in));
  parameter Modelica.Units.SI.Temperature  T_set = 300.0
    "流出流体の温度"
    annotation (Dialog(enable = not use_T_in));

  Modelica.Blocks.Interfaces.RealInput m_flow_in(unit="kg/s") if use_m_flow_in
    "質量流量入力 [kg/s]（正: port へ流出）"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput T_in(unit="K") if use_T_in
    "流出流体の温度入力 [K]"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));

  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_b port(redeclare package Medium = Medium)
    "出口ポート（下流コンポーネントへ接続）"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

protected
  Modelica.Blocks.Interfaces.RealInput m_flow_in_internal(unit="kg/s")
    "条件付きコネクタ接続用の内部質量流量入力";
  Modelica.Blocks.Interfaces.RealInput T_in_internal(unit="K")
    "条件付きコネクタ接続用の内部温度入力";

equation
  connect(m_flow_in, m_flow_in_internal);
  connect(T_in, T_in_internal);

  if not use_m_flow_in then
    m_flow_in_internal = m_flow_set;
  end if;

  if not use_T_in then
    T_in_internal = T_set;
  end if;

  port.m_flow     = -m_flow_in_internal;  // 流入正規約: 源泉から流出なので負
  port.h_outflow  = Medium.specificEnthalpy_pT(port.p, T_in_internal);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio = false)),
    Documentation(info="<html>
<p>
質量流量 <code>m_flow_set</code> と温度 <code>T_set</code> を固定するソース境界。
圧力は接続先システムによって決定される。
</p>
<p>
<code>use_m_flow_in</code> または <code>use_T_in</code> を <code>true</code> にすると、
対応する値を外部入力コネクタから与えることができる。
</p>
<p>
<code>MassFlowSource_h</code> の温度指定版。比エンタルピーは
<code>Medium.specificEnthalpy_pT(port.p, T_in_internal)</code> で、実際に解かれた <code>port.p</code>
（系全体の方程式から決まる圧力）と温度入力から計算する。
</p>
<h4>方程式</h4>
<ul>
<li><code>port.m_flow = -m_flow_in_internal</code>（流入正規約のため負符号）</li>
<li><code>port.h_outflow = Medium.specificEnthalpy_pT(port.p, T_in_internal)</code></li>
</ul>
<h4>精度に関する注意</h4>
<p>
<code>specificEnthalpy_pT</code> は飽和点からの定積比熱近似であり、
飽和温度から離れるほど誤差が増える（詳細は
<code>PartialTwoPhaseMedium</code> のドキュメンテーション参照）。
</p>
</html>"));
end MassFlowSource_T;
