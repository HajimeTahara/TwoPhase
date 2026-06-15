within EAST.TwoPhaseFlow.Component.Sources;
model MassFlowSource_h
  "固定質量流量・固定比エンタルピー ソース"

  replaceable package Medium = EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium
    annotation (choicesAllMatching=true);

  parameter Modelica.Units.SI.MassFlowRate    m_flow_set = 1.0
    "固定質量流量 [kg/s]（正: port へ流出）";
  parameter Modelica.Units.SI.SpecificEnthalpy h_set    = 4.0e5
    "流出流体の比エンタルピー [J/kg]";

  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_b port(redeclare package Medium = Medium)
    "出口ポート（下流コンポーネントへ接続）";

equation
  port.m_flow     = -m_flow_set;  // 流入正規約: 源泉から流出なので負
  port.h_outflow = h_set;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
      Ellipse(
        extent={{-60,60},{60,-60}},
        lineColor={0,127,255},
        fillColor={0,127,255},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{-20,30},{-20,-30},{40,0},{-20,30}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-100,80},{100,62}},
        lineColor={0,0,0},
        textString="%name")}),
    Documentation(info="<html>
<p>
質量流量 <code>m_flow_set</code> と比エンタルピー <code>h_set</code> を固定するソース境界。
圧力は接続先システムによって決定される。
</p>
<p>
MSL の <code>Modelica.Fluid.Sources.MassFlowSource_h</code> に相当する。
<code>port</code>（<code>FluidPort_b</code>型）を下流コンポーネントの
<code>FluidPort_a</code> に接続して使用する。
</p>
<h4>方程式</h4>
<ul>
<li><code>port.m_flow = -m_flow_set</code>（流入正規約のため負符号）</li>
<li><code>port.h_outflow = h_set</code></li>
</ul>
</html>"));
end MassFlowSource_h;
