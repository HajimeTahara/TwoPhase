within EAST.Thermal.HeatTransfer.Examples;

model HeatCapacitor "HeatCapacitor へ一定の熱流量を与えたときの温度上昇を確認するサンプル"
extends Modelica.Icons.Example;
  parameter Integer n=10;
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor capacitor(V = 0.1^3, T_start = 293.15, material = EAST.Thermal.Material.Sus304()) "確認対象の熱容量要素"annotation(
    Placement(transformation(origin = {-66, 112}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow(Q_flow = 100)  annotation(
    Placement(transformation(origin = {-120, 112}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.ThermalConductor conductor(A = 0.1*0.1, L = 1, material = EAST.Thermal.Material.Sus304())  "確認対象の熱伝導要素" annotation(
    Placement(transformation(origin = {-6, 112}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor capacitor1(T_start = 293.15, V = 0.1^3, material = EAST.Thermal.Material.Sus304()) "確認対象の熱容量要素" annotation(
    Placement(transformation(origin = {52, 112}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.SegmentedThermalConductor conductor1(material = EAST.Thermal.Material.Sus304(), T_start = fill(20 + 273.15, n), A = 0.1*0.1, L = 0.1, nSegments = n) "確認対象の長さ方向分割熱伝導要素" annotation(
    Placement(transformation(origin = {-4, 10}, extent = {{-30, -30}, {30, 30}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature annotation(
    Placement(transformation(origin = {98, 112}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T = 473.15) annotation(
    Placement(transformation(origin = {-70, 10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature2(T = 293.15) annotation(
    Placement(transformation(origin = {66, 10}, extent = {{10, -10}, {-10, 10}})));
  EAST.Thermal.HeatTransfer.Components.SegmentedThermalConductor conductor11(A = 0.1*0.1, L = 0.1, T_start = fill(20 + 273.15, n), material = EAST.Thermal.Material.Sus304(), nSegments = n) "確認対象の長さ方向分割熱伝導要素" annotation(
    Placement(transformation(origin = {-4, -88}, extent = {{-30, -30}, {30, 30}})));
  Components.Convection convection(A = 10)  annotation(
    Placement(transformation(origin = {60, -88}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature21(T = 253.15) annotation(
    Placement(transformation(origin = {100, -88}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = 10)  annotation(
    Placement(transformation(origin = {100, -42}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow1(Q_flow = 100)  annotation(
    Placement(transformation(origin = {-82, -88}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(fixedHeatFlow.port, capacitor.port_left) annotation(
    Line(points = {{-110, 112}, {-76, 112}}, color = {191, 0, 0}));
  connect(capacitor.port_right, conductor.port_a) annotation(
    Line(points = {{-56, 112}, {-16, 112}}, color = {191, 0, 0}));
  connect(conductor.port_b, capacitor1.port_left) annotation(
    Line(points = {{4, 112}, {42, 112}}, color = {191, 0, 0}));
  connect(capacitor1.port_right, fixedTemperature.port) annotation(
    Line(points = {{62, 112}, {88, 112}}, color = {191, 0, 0}));
  connect(fixedTemperature1.port, conductor1.port_a) annotation(
    Line(points = {{-60, 10}, {-34, 10}}, color = {191, 0, 0}));
  connect(conductor1.port_b, fixedTemperature2.port) annotation(
    Line(points = {{26, 10}, {56, 10}}, color = {191, 0, 0}));
  connect(conductor11.port_b, convection.solid) annotation(
    Line(points = {{26, -88}, {50, -88}}, color = {191, 0, 0}));
  connect(convection.fluid, fixedTemperature21.port) annotation(
    Line(points = {{70, -88}, {90, -88}}, color = {191, 0, 0}));
  connect(convection.velocity, const.y) annotation(
    Line(points = {{60, -78}, {60, -42}, {89, -42}}, color = {0, 0, 127}));
  connect(fixedHeatFlow1.port, conductor11.port_a) annotation(
    Line(points = {{-72, -88}, {-34, -88}}, color = {191, 0, 0}));
  annotation(
    experiment(StopTime = 1000, Interval = 0.1),
    Documentation(info = "<html>
<p>
<code>HeatCapacitor</code> の <code>port_top</code> に一定の熱流量 <code>Q_flow_in</code> を
与え、温度 <code>capacitor.T</code> が時間とともに線形に上昇することを確認するサンプルです。
</p>
<p>
<code>port_right</code>・<code>port_bottom</code>・<code>port_left</code> はどこにも接続しないため、
Modelica の仕様により熱流量が自動的にゼロとして扱われます。
</p>
</html>"),
  Diagram(coordinateSystem(extent = {{-140, 80}, {120, -80}})));
end HeatCapacitor;
