within EAST.Thermal.HeatTransfer.Components;
model SegmentedThermalConductor
  "長さ方向の熱容量分布で時間応答遅れを表現する熱伝導要素"
  parameter Integer nSegments(min=1) = 5
    "長さ方向の分割数" annotation (Evaluate=true);
  parameter Modelica.Units.SI.Area A = 1e-4 "伝熱面積 [m2]";
  parameter Modelica.Units.SI.Length L = 0.1 "伝熱長さ [m]";
  parameter EAST.Thermal.Material.MaterialProperties material =
    EAST.Thermal.Material.Sus304() "材料物性";
  parameter Modelica.Units.SI.Temperature T_start[nSegments] =
    fill(293.15, nSegments) "各セグメントの初期温度 [K]";

  final parameter Integer nInterfaces = max(nSegments - 1, 0)
    "隣接セグメント間インターフェース数";
  final parameter Modelica.Units.SI.Length dx = L / nSegments
    "1 セグメントあたりの長さ [m]";
  final parameter Modelica.Units.SI.Volume V_segment = A * dx
    "1 セグメントあたりの体積 [m3]";
  final parameter Modelica.Units.SI.ThermalConductance G_boundary =
    2 * material.thermalConductivity * A / dx
    "端面から端部セグメント中心までの熱コンダクタンス [W/K]";
  final parameter Modelica.Units.SI.ThermalConductance G_between =
    material.thermalConductivity * A / dx
    "隣接セグメント中心間の熱コンダクタンス [W/K]";

  Modelica.Units.SI.Temperature T[nSegments]
    "各セグメントの代表温度 [K]";
  Modelica.Units.SI.HeatFlowRate Q_between[nInterfaces]
    "セグメント i から i+1 へ流れる熱流量 [W]";

  EAST.Thermal.HeatTransfer.Components.HeatCapacitor segment[nSegments](
    each V = V_segment,
    each material = material,
    T_start = T_start) "長さ方向に分割した集中熱容量";

  EAST.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a "熱ポート a"
    annotation (Placement(
      transformation(extent={{-110,-10},{-90,10}}),
      iconTransformation(extent={{-110,-10},{-90,10}})));
  EAST.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b "熱ポート b"
    annotation (Placement(
      transformation(extent={{90,-10},{110,10}}),
      iconTransformation(extent={{90,-10},{110,10}})));

equation
  assert(L > 0, "L must be greater than zero.");
  assert(A > 0, "A must be greater than zero.");

  for i in 1:nSegments loop
    T[i] = segment[i].T;
    segment[i].port_top.Q_flow = 0;
    segment[i].port_bottom.Q_flow = 0;
  end for;

  port_a.Q_flow = G_boundary * (port_a.T - segment[1].T);
  segment[1].port_left.Q_flow = port_a.Q_flow;

  for i in 1:nInterfaces loop
    Q_between[i] = G_between * (segment[i].T - segment[i + 1].T);
    segment[i].port_right.Q_flow = -Q_between[i];
    segment[i + 1].port_left.Q_flow = Q_between[i];
  end for;

  port_b.Q_flow = G_boundary * (port_b.T - segment[nSegments].T);
  segment[nSegments].port_right.Q_flow = port_b.Q_flow;

  annotation (Icon(coordinateSystem(preserveAspectRatio=true), graphics={
      Rectangle(
        extent={{-70,24},{70,-24}},
        lineColor={191,0,0},
        fillColor={255,170,170},
        fillPattern=FillPattern.Solid),
      Line(
        points={{-42,24},{-42,-24}},
        color={191,0,0}),
      Line(
        points={{-14,24},{-14,-24}},
        color={191,0,0}),
      Line(
        points={{14,24},{14,-24}},
        color={191,0,0}),
      Line(
        points={{42,24},{42,-24}},
        color={191,0,0}),
      Line(
        points={{-100,0},{-70,0}},
        color={191,0,0}),
      Line(
        points={{70,0},{100,0}},
        color={191,0,0}),
      Text(
        extent={{-100,74},{100,50}},
        textString="%name",
        lineColor={0,0,0}),
      Text(
        extent={{-100,-50},{100,-74}},
        textString="n=%nSegments",
        lineColor={0,0,0})}),
    Documentation(info="<html>
<p>
長さ方向の熱伝導を複数の集中熱容量と熱抵抗で近似する動的モデルです。
</p>
<p>
通常の <code>ThermalConductor</code> は定常熱抵抗のみを表しますが、このモデルは
伝熱長さ <code>L</code> を <code>nSegments</code> 個の熱容量に分割することで、
長さ方向の時間応答遅れを表現します。
</p>
<p>
各セグメントの熱容量は <code>V_segment = A * L / nSegments</code> と材料物性から計算します。
端面から端部セグメント中心までは半セル長 <code>dx/2</code>、セグメント間は
中心間距離 <code>dx</code> の熱抵抗として扱います。
</p>
</html>"));
end SegmentedThermalConductor;
