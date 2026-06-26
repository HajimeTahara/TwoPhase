within EAST.Thermal.HeatTransfer.Examples;

model ExampleCylindricalThermalConductorV2 "内側境界温度をステップ変化させ、多層円筒の半径方向の温度伝播の遅れを確認するサンプル"
extends Modelica.Icons.Example;
  Thermal.HeatTransfer.Components.CylindricalThermalConductor conductor(nLayers = 3, innerDiameter = 0.02, L = 0.1, material = fill(Thermal.Material.Sus304(), 3), T_start = fill(20 + 273.15, 3), outerDiameter = {0.025, 0.035, 0.038}, use_heat_input = true) "確認対象の多層円筒熱伝導要素" annotation(
    Placement(transformation(origin = {0, 26}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature2(T = 293.15) annotation(
    Placement(transformation(origin = {70, 26}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T = 293.15) annotation(
    Placement(transformation(origin = {-70, 26}, extent = {{-10, -10}, {10, 10}})));
  Blocks.Sources.ConstantArray constArray(k = {100, 200, 300})  annotation(
    Placement(transformation(origin = {-68, 72}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.CylindricalThermalConductor conductor1(L = 0.1, T_start = fill(20 + 273.15, 3), innerDiameter = 0.02, material = fill(Thermal.Material.Sus304(), 3), nLayers = 3, outerDiameter = {0.025, 0.035, 0.038}, use_heat_input = true) "確認対象の多層円筒熱伝導要素" annotation(
    Placement(transformation(origin = {0, -72}, extent = {{-20, -20}, {20, 20}})));
  EAST.Blocks.Sources.ConstantArray constArray1(k = {100, 200, 300}) annotation(
    Placement(transformation(origin = {-58, -28}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(fixedTemperature1.port, conductor.port_inner) annotation(
    Line(points = {{-60, 26}, {-20, 26}}, color = {191, 0, 0}));
  connect(conductor.port_outer, fixedTemperature2.port) annotation(
    Line(points = {{20, 26}, {60, 26}}, color = {191, 0, 0}));
  connect(constArray.y, conductor.Q_gen_input) annotation(
    Line(points = {{-57, 72}, {0, 72}, {0, 50}}, color = {0, 0, 127}, thickness = 0.5));
  connect(constArray1.y, conductor1.Q_gen_input) annotation(
    Line(points = {{-46, -28}, {0, -28}, {0, -48}}, color = {0, 0, 127}, thickness = 0.5));
  annotation(
    experiment(StopTime = 5, Interval = 0.5),
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
</html>"),
  Diagram(graphics = {Text(origin = {68, 76}, extent = {{-38, 6}, {38, -6}}, textString = "constantArrayでの熱入力"), Text(origin = {74, -36}, extent = {{-38, 6}, {38, -6}}, textString = "両端のHeatPortは接続なしでもOK")}));
end ExampleCylindricalThermalConductorV2;
