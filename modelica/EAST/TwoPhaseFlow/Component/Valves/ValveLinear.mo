within EAST.TwoPhaseFlow.Component.Valves;
model ValveLinear
  "圧力差と開度に比例する線形バルブ（MSL ValveLinear 風のひな型）"

  replaceable package Medium = EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium
    annotation (choicesAllMatching=true);

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = 1.0
    "公称質量流量 [kg/s]";
  parameter Modelica.Units.SI.PressureDifference dp_nominal = 1.0e5
    "公称圧力差 [Pa]";
  parameter Real opening(min=0, max=1) = 1.0
    "固定開度 [-]";
  final parameter Real Kv(unit="kg/(s.Pa)") =
    m_flow_nominal / dp_nominal
    "線形バルブ係数 [kg/(s.Pa)]";

  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_a port_a(
    redeclare package Medium = Medium)
    "入口側ポート"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_b port_b(
    redeclare package Medium = Medium)
    "出口側ポート"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  Modelica.Units.SI.MassFlowRate m_flow
    "port_a から port_b へ流れる質量流量 [kg/s]";
  Modelica.Units.SI.PressureDifference dp
    "圧力差 port_a.p - port_b.p [Pa]";

equation
  port_a.m_flow + port_b.m_flow = 0;
  m_flow = port_a.m_flow;
  dp = port_a.p - port_b.p;

  m_flow = opening * Kv * dp;

  port_b.h_outflow = inStream(port_a.h_outflow);
  port_a.h_outflow = inStream(port_b.h_outflow);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
      Polygon(
        points={{-70,40},{0,0},{-70,-40},{-70,40}},
        lineColor={0,0,255},
        fillColor={170,213,255},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{70,40},{0,0},{70,-40},{70,40}},
        lineColor={0,0,255},
        fillColor={170,213,255},
        fillPattern=FillPattern.Solid),
      Line(points={{-100,0},{-70,0}}, color={0,0,255}),
      Line(points={{70,0},{100,0}}, color={0,0,255}),
      Text(
        extent={{-100,80},{100,56}},
        lineColor={0,0,0},
        textString="%name")}),
    Documentation(info="<html>
<p>
圧力差と固定開度に比例して質量流量を与える線形バルブのひな型。
MSL の <code>Modelica.Fluid.Valves.ValveLinear</code> の最小構成に倣う。
</p>
<pre>
m_flow = opening * Kv * (port_a.p - port_b.p)
Kv = m_flow_nominal / dp_nominal
</pre>
<h4>制限事項</h4>
<ul>
<li>密度依存、チョーク、キャビテーション、逆止弁特性は未実装。</li>
<li>エンタルピーは断熱・等エンタルピーのパススルー近似。</li>
<li>開度入力は未実装。必要に応じて <code>use_opening_input</code> を追加する。</li>
</ul>
</html>"));
end ValveLinear;
