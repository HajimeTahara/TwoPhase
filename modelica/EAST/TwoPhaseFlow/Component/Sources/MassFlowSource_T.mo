within EAST.TwoPhaseFlow.Component.Sources;
model MassFlowSource_T
  "固定質量流量・固定温度 ソース"

  replaceable package Medium = EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium
    annotation (choicesAllMatching=true);

  parameter Modelica.Units.SI.MassFlowRate m_flow_set = 1.0
    "固定質量流量 [kg/s]（正: port へ流出）";
  parameter Modelica.Units.SI.Temperature  T_set = 300.0
    "流出流体の温度 [K]";

  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_b port(redeclare package Medium = Medium)
    "出口ポート（下流コンポーネントへ接続）"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

equation
  port.m_flow     = -m_flow_set;  // 流入正規約: 源泉から流出なので負
  port.h_outflow  = Medium.specificEnthalpy_pT(port.p, T_set);

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
質量流量 <code>m_flow_set</code> と温度 <code>T_set</code> を固定するソース境界。
圧力は接続先システムによって決定される。
</p>
<p>
<code>MassFlowSource_h</code> の温度指定版。比エンタルピーは
<code>Medium.specificEnthalpy_pT(port.p, T_set)</code> で、実際に解かれた <code>port.p</code>
（系全体の方程式から決まる圧力）と <code>T_set</code> から計算する。
</p>
<h4>方程式</h4>
<ul>
<li><code>port.m_flow = -m_flow_set</code>（流入正規約のため負符号）</li>
<li><code>port.h_outflow = Medium.specificEnthalpy_pT(port.p, T_set)</code></li>
</ul>
<h4>精度に関する注意</h4>
<p>
<code>specificEnthalpy_pT</code> は飽和点からの定積比熱近似であり、
飽和温度から離れるほど誤差が増える（詳細は
<code>PartialTwoPhaseMedium</code> のドキュメンテーション参照）。
</p>
</html>"));
end MassFlowSource_T;
