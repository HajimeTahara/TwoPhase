within EAST.Thermal.HeatTransfer.Components;
model SegmentedThermalConductor
  "長さ方向の熱容量分布で時間応答遅れを表現する熱伝導要素"
  parameter Integer nSegments(min=1) = 5
    "長さ方向の分割数" annotation (Evaluate=true);
  parameter Modelica.Units.SI.Area A = 1e-4 "伝熱面積";
  parameter Modelica.Units.SI.Length L = 0.1 "伝熱長さ";
  parameter EAST.Thermal.Material.MaterialProperties material =
    EAST.Thermal.Material.Sus304() "材料物性";
  parameter Modelica.Units.SI.Temperature T_start[nSegments] =
    fill(293.15, nSegments) "各セグメントの初期温度";

  final parameter Integer nInterfaces = max(nSegments - 1, 0)
    "隣接セグメント間インターフェース数";
  final parameter Modelica.Units.SI.Length dx = L / nSegments
    "1 セグメントあたりの長さ";
  final parameter Modelica.Units.SI.Volume V_segment = A * dx
    "1 セグメントあたりの体積";
  final parameter Modelica.Units.SI.Mass m_segment =
    material.density * V_segment
    "1 セグメントあたりの質量";
  final parameter Modelica.Units.SI.HeatCapacity C_segment =
    m_segment * material.specificHeatCapacity
    "1 セグメントあたりの熱容量";
  final parameter Modelica.Units.SI.ThermalConductance G_boundary =
    2 * material.thermalConductivity * A / dx
    "端面から端部セグメント中心までの熱コンダクタンス";
  final parameter Modelica.Units.SI.ThermalConductance G_between =
    material.thermalConductivity * A / dx
    "隣接セグメント中心間の熱コンダクタンス";

  Modelica.Units.SI.Temperature T[nSegments](start=T_start)
    "各セグメントの代表温度 [K]";
  Modelica.Units.SI.HeatFlowRate Q_between[nInterfaces]
    "セグメント i から i+1 へ流れる熱流量 [W]";

  EAST.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a "熱ポート a" annotation(
    Placement(transformation(extent = {{-110, -10}, {-90, 10}}), iconTransformation(extent = {{-110, -10}, {-90, 10}})));
  EAST.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b "熱ポート b"
    annotation (Placement(
      transformation(extent={{90,-10},{110,10}}),
      iconTransformation(extent={{90,-10},{110,10}})));

equation
  assert(L > 0, "L must be greater than zero.");
  assert(A > 0, "A must be greater than zero.");

  port_a.Q_flow = G_boundary * (port_a.T - T[1]);

  for i in 1:nInterfaces loop
    Q_between[i] = G_between * (T[i] - T[i + 1]);
  end for;

  port_b.Q_flow = G_boundary * (port_b.T - T[nSegments]);

  if nSegments == 1 then
    C_segment * der(T[1]) = port_a.Q_flow + port_b.Q_flow;
  else
    C_segment * der(T[1]) = port_a.Q_flow - Q_between[1];
    for i in 2:nSegments - 1 loop
      C_segment * der(T[i]) = Q_between[i - 1] - Q_between[i];
    end for;
    C_segment * der(T[nSegments]) =
      Q_between[nSegments - 1] + port_b.Q_flow;
  end if;

  annotation(
    Icon(coordinateSystem(preserveAspectRatio = true), graphics = {Text(origin = {0, 20}, extent = {{-100, -80}, {100, -120}}, textString = "n=%nSegments"), Rectangle(fillColor = {192, 192, 192}, pattern = LinePattern.None, fillPattern = FillPattern.Backward, extent = {{-20, 60}, {20, -60}}), Line(origin = {70, -10}, points = {{-90, 70}, {-90, -50}}, thickness = 0.5), Line(origin = {110, -10}, points = {{-90, 70}, {-90, -50}}, thickness = 0.5), Text(origin = {0, -220}, textColor = {0, 0, 255}, extent = {{-100, 120}, {100, 80}}, textString = "%name"), Rectangle(origin = {-41, 0},lineColor = {191, 0, 0}, fillColor = {98, 0, 0}, fillPattern = FillPattern.Solid, extent = {{-21, 60}, {21, -60}}), Rectangle(origin = {41, 0}, lineColor = {191, 0, 0}, fillColor = {98, 0, 0}, fillPattern = FillPattern.Solid, extent = {{-21, 60}, {21, -60}})}),
    Documentation(info = "<html>
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
<p>
各セグメント温度 <code>T[i]</code> を状態変数として、次のエネルギー収支を
直接記述します。内部の未接続 HeatPort は使用しません。
</p>
<pre>
C_segment * der(T[i]) = Q_from_left - Q_to_right
</pre>
</html>"),
  Diagram(graphics));
end SegmentedThermalConductor;
