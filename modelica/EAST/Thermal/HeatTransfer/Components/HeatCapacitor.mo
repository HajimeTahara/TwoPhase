within EAST.Thermal.HeatTransfer.Components;

model HeatCapacitor "体積と材料物性から熱容量を計算する集中熱容量"
  parameter Modelica.Units.SI.Volume V = 1e-6 "体積 [m3]";
  parameter EAST.Thermal.Material.MaterialProperties material = EAST.Thermal.Material.Sus304() "材料物性";
  parameter Modelica.Units.SI.Temperature T_start = 293.15 "初期温度 [K]";
  final parameter Modelica.Units.SI.Mass m = material.density*V "質量 [kg]";
  final parameter Modelica.Units.SI.HeatCapacity C = m*material.specificHeatCapacity "熱容量 [J/K]";
  Modelica.Units.SI.Temperature T(start = T_start) "温度 [K]";
  EAST.Thermal.HeatTransfer.Interfaces.HeatPort_a port_top "上側熱ポート" annotation(
    Placement(transformation(extent = {{-10, 90}, {10, 110}}), iconTransformation(extent = {{-10, 90}, {10, 110}})));
  EAST.Thermal.HeatTransfer.Interfaces.HeatPort_a port_right "右側熱ポート" annotation(
    Placement(transformation(extent = {{90, -10}, {110, 10}}), iconTransformation(extent = {{90, -10}, {110, 10}})));
  EAST.Thermal.HeatTransfer.Interfaces.HeatPort_a port_bottom "下側熱ポート" annotation(
    Placement(transformation(extent = {{-10, -110}, {10, -90}}), iconTransformation(extent = {{-10, -110}, {10, -90}})));
  EAST.Thermal.HeatTransfer.Interfaces.HeatPort_a port_left "左側熱ポート" annotation(
    Placement(transformation(extent = {{-110, -10}, {-90, 10}}), iconTransformation(extent = {{-110, -10}, {-90, 10}})));
equation
  T = port_top.T;
  T = port_right.T;
  T = port_bottom.T;
  T = port_left.T;
  C*der(T) = port_top.Q_flow + port_right.Q_flow + port_bottom.Q_flow + port_left.Q_flow;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = true), graphics = {Rectangle(lineColor = {191, 0, 0}, fillColor = {98, 0, 0}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {0, -253}, textColor = {0, 0, 255}, extent = {{-100, 153}, {100, 113}}, textString = "%name"), Text(origin = {2, 290}, textColor = {255, 255, 255},extent = {{-70, -251}, {70, -330}}, textString = "C=%C")}),
    Documentation(info = "<html>
<p>
MSL の HeatCapacitor と同じ集中熱容量モデルですが、熱容量 <code>C</code> を
直接指定する代わりに、体積 <code>V</code> と材料レコード <code>material</code> から
自動計算します。
</p>
<p>
熱容量は <code>C = V * material.density * material.specificHeatCapacity</code> です。
</p>
<p>
熱ポートはアイコンの上下左右に 1 つずつ配置されています。内部は集中熱容量として扱うため、
すべてのポート温度は同一温度 <code>T</code> に束縛されます。
</p>
</html>"));
end HeatCapacitor;
