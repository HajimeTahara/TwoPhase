within EAST.Thermal.HeatTransfer.Examples;

model CylindricalThermalConductor "内側境界温度をステップ変化させ、多層円筒の半径方向の温度伝播の遅れを確認するサンプル"
extends Modelica.Icons.Example;
  EAST.Thermal.HeatTransfer.Components.CylindricalThermalConductor conductor(nLayers = 3, innerDiameter = 0.02, L = 0.1, material = fill(EAST.Thermal.Material.Sus304(), 3), T_start = fill(20 + 273.15, 3), outerDiameter = {0.025, 0.035, 0.038}, use_heat_input = false) "確認対象の多層円筒熱伝導要素" annotation(
    Placement(transformation(origin = {0, 80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature2(T = 473.15) annotation(
    Placement(transformation(origin = {70, 80}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T = 293.15) annotation(
    Placement(transformation(origin = {-70, 80}, extent = {{-10, -10}, {10, 10}})));
  Components.SegmentedCylindricalThermalConductor segmentedCylindricalThermalConductor(nLayers = 3, nNode = 3, innerDiameter = 0.02, outerDiameter = {0.025, 0.035, 0.038}, L = 0.1, material = fill(EAST.Thermal.Material.Sus304(), 3), T_start = fill(20 + 273.15, 3, 3))  annotation(
    Placement(transformation(origin = {0, -40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature11(T = 273.15) annotation(
    Placement(transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature21(T = 473.15) annotation(
    Placement(transformation(origin = {70, -40}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature111(T = 293.15) annotation(
    Placement(transformation(origin = {-70, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature112(T = 313.15) annotation(
    Placement(transformation(origin = {-70, -80}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(fixedTemperature1.port, conductor.port_inner) annotation(
    Line(points = {{-60, 80}, {-20, 80}}, color = {191, 0, 0}));
  connect(conductor.port_outer, fixedTemperature2.port) annotation(
    Line(points = {{20, 80}, {60, 80}}, color = {191, 0, 0}));
  connect(segmentedCylindricalThermalConductor.port_outer[1], fixedTemperature21.port) annotation(
    Line(points = {{20, -40}, {60, -40}}, color = {191, 0, 0}));
  connect(segmentedCylindricalThermalConductor.port_outer[2], fixedTemperature21.port) annotation(
    Line(points = {{20, -40}, {60, -40}}, color = {191, 0, 0}));
  connect(segmentedCylindricalThermalConductor.port_outer[3], fixedTemperature21.port) annotation(
    Line(points = {{20, -40}, {60, -40}}, color = {191, 0, 0}));
  connect(fixedTemperature11.port, segmentedCylindricalThermalConductor.port_inner[1]) annotation(
    Line(points = {{-60, 0}, {-20, 0}, {-20, -40}}, color = {191, 0, 0}));
  connect(fixedTemperature111.port, segmentedCylindricalThermalConductor.port_inner[2]) annotation(
    Line(points = {{-60, -40}, {-20, -40}}, color = {191, 0, 0}));
  connect(fixedTemperature112.port, segmentedCylindricalThermalConductor.port_inner[3]) annotation(
    Line(points = {{-60, -80}, {-20, -80}, {-20, -40}}, color = {191, 0, 0}));
  annotation(
    experiment(StopTime = 300, Interval = 0.5),
    Documentation(info = "<html>
<p>
<code>port_inner</code> の温度を時刻 <code>t_step</code> でステップ変化させ、
<code>port_outer</code> を固定温度に保ったときの、各層の温度
<code>conductor.T[1:nLayers]</code> の時間応答を確認するサンプルです。
</p>
<p>
層ごとに熱容量を持つため、内側から外側の層へ温度変化が遅れて伝わる様子を
<code>conductor.T</code> をプロットすることで確認できます。
</p>
</html>"));
end CylindricalThermalConductor;
