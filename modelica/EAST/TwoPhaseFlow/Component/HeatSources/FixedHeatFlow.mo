within EAST.TwoPhaseFlow.Component.HeatSources;
model FixedHeatFlow "固定熱流量源（HeatPort へ一定の入熱を与える）"

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_set
    "port へ与える熱流量 [W]（正: port を加熱）";

  EAST.TwoPhaseFlow.Component.Interfaces.HeatPort_b port
    "接続先コンポーネントの HeatPort_a へ接続するポート"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

equation
  port.Q_flow = -Q_flow_set;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
      Rectangle(
        extent={{-80,40},{80,-40}},
        lineColor={191,0,0},
        fillColor={255,255,170},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-70,20},{70,-20}},
        lineColor={191,0,0},
        textString="Q_flow"),
      Text(
        extent={{-100,60},{100,42}},
        lineColor={0,0,0},
        textString="%name")}),
    Documentation(info="<html>
<p>
固定の熱流量 <code>Q_flow_set</code> を <code>port</code>（接続先）へ与える熱源。
</p>
<h4>方程式</h4>
<ul>
<li><code>port.Q_flow = -Q_flow_set</code>
    （port 自身から見て出ていく方向が負、接続先から見ると <code>+Q_flow_set</code> が流入する）</li>
</ul>
</html>"));
end FixedHeatFlow;
