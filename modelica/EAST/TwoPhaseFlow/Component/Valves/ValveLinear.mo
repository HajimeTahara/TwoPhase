within EAST.TwoPhaseFlow.Component.Valves;
model ValveLinear
  "圧力差と開度に比例する線形バルブ（MSL ValveLinear 風のひな型）"

  replaceable package Medium = EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium
    annotation (choicesAllMatching=true);

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = 1.0
    "公称質量流量 [kg/s]";
  parameter Modelica.Units.SI.PressureDifference dp_nominal = 1.0e5
    "公称圧力差 [Pa]";
  parameter Boolean use_opening_in = false
    "true の場合、開度を入力コネクタ opening_in から与える"
    annotation(Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter Real opening_set(min=0, max=1) = 1.0
    "固定開度 [-]"
    annotation (Dialog(enable = not use_opening_in));
  final parameter Real Kv(unit="kg/(s.Pa)") =
    m_flow_nominal / dp_nominal
    "線形バルブ係数 [kg/(s.Pa)]";

  Modelica.Blocks.Interfaces.RealInput opening_in(unit="1") if use_opening_in
    "開度入力 [-]"
    annotation (Placement(transformation(extent = {{-20, 100}, {20, 140}}), iconTransformation(origin = {-120, 120},extent = {{-20, 100}, {20, 140}}, rotation = -90)));

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
  Real opening(min=0, max=1)
    "実際にバルブ式へ用いる開度 [-]";

protected
  Modelica.Blocks.Interfaces.RealInput opening_internal(unit="1")
    "条件付きコネクタ接続用の内部開度入力";

equation
  connect(opening_in, opening_internal);

  if not use_opening_in then
    opening_internal = opening_set;
  end if;

  opening = max(0.0, min(1.0, opening_internal));

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
<p>
<code>use_opening_in = true</code> の場合、開度を外部入力
<code>opening_in</code> から与える。入力値は <code>0..1</code> に制限して使用する。
<code>false</code> の場合は固定値 <code>opening_set</code> を用いる。
</p>
<pre>
m_flow = opening * Kv * (port_a.p - port_b.p)
Kv = m_flow_nominal / dp_nominal
</pre>
<h4>制限事項</h4>
<ul>
<li>密度依存、チョーク、キャビテーション、逆止弁特性は未実装。</li>
<li>エンタルピーは断熱・等エンタルピーのパススルー近似。</li>
</ul>
</html>"));
end ValveLinear;
