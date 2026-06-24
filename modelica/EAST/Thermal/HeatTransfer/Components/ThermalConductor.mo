within EAST.Thermal.HeatTransfer.Components;

model ThermalConductor "材料物性と形状から熱コンダクタンスを計算する熱伝導要素"
  parameter Modelica.Units.SI.Area A = 1e-4 "伝熱面積";
  parameter Modelica.Units.SI.Length L = 1e-3 "伝熱長さ";
  parameter EAST.Thermal.Material.MaterialProperties material = EAST.Thermal.Material.Sus304() "材料物性";
  final parameter Modelica.Units.SI.ThermalConductance G = material.thermalConductivity*A/L "熱コンダクタンス";
  EAST.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a "熱ポート a" annotation(
    Placement(transformation(extent = {{-110, -10}, {-90, 10}}), iconTransformation(extent = {{-110, -10}, {-90, 10}})));
  EAST.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b "熱ポート b" annotation(
    Placement(transformation(extent = {{90, -10}, {110, 10}}), iconTransformation(extent = {{90, -10}, {110, 10}})));
equation
  port_a.Q_flow + port_b.Q_flow = 0;
  port_a.Q_flow = G*(port_a.T - port_b.T);
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = true), graphics = {Text(origin = {0, -220}, textColor = {0, 0, 255},extent = {{-100, 120}, {100, 80}}, textString = "%name"), Text(origin = {0, 20},extent = {{-100, -80}, {100, -120}}, textString = "G=%G"), Rectangle(fillColor = {192, 192, 192}, pattern = LinePattern.None, fillPattern = FillPattern.Backward, extent = {{-80, 60}, {80, -60}}), Line(origin = {10, -10}, points = {{-90, 70}, {-90, -50}}, thickness = 0.5), Line(origin = {170, -10}, points = {{-90, 70}, {-90, -50}}, thickness = 0.5)}),
    Documentation(info = "<html>
<p>
MSL の ThermalConductor と同じ集中熱伝導モデルですが、熱コンダクタンス
<code>G</code> を直接指定する代わりに、材料の熱伝導率と形状から自動計算します。
</p>
<p>
熱コンダクタンスは <code>G = material.thermalConductivity * A / L</code> です。
</p>
</html>"),
    Diagram(graphics));
end ThermalConductor;
