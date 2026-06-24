within EAST.Thermal.HeatTransfer.Components;

model CylindricalThermalConductor "材料物性と多層円筒形状から半径方向熱伝導を計算する要素"
  parameter Integer nLayers(min = 1) = 1 "層数" annotation(
    Evaluate = true);
  parameter Modelica.Units.SI.Diameter innerDiameter = 0.02 "最内層の内径 [m]";
  parameter Modelica.Units.SI.Diameter outerDiameter[nLayers] = {innerDiameter + 0.02*i for i in 1:nLayers} "各層の外径 [m]";
  parameter Modelica.Units.SI.Length L = 0.1 "円筒長さ [m]";
  parameter EAST.Thermal.Material.MaterialProperties material[nLayers] = fill(EAST.Thermal.Material.Sus304(), nLayers) "各層の材料物性";
  parameter Boolean use_heat_input = false "true の場合、各層の発熱量を外部入力から与える" annotation(
    Evaluate = true);
  parameter Modelica.Units.SI.HeatFlowRate Q_gen[nLayers] = fill(0, nLayers) "各層の固定内部発熱量 [W]（正: 加熱）";
  parameter Modelica.Units.SI.Temperature T_start[nLayers] = fill(293.15, nLayers) "各層の初期温度 [K]";
  final parameter Integer nInterfaces = max(nLayers - 1, 0) "隣接層間インターフェース数";
  final parameter Modelica.Units.SI.Length r_inner[nLayers] = {if i == 1 then innerDiameter/2 else outerDiameter[i - 1]/2 for i in 1:nLayers} "各層の内半径 [m]";
  final parameter Modelica.Units.SI.Length r_outer[nLayers] = {outerDiameter[i]/2 for i in 1:nLayers} "各層の外半径 [m]";
  final parameter Modelica.Units.SI.Length r_middle[nLayers] = {Modelica.Math.sqrt(r_inner[i]*r_outer[i]) for i in 1:nLayers} "各層の熱容量代表半径 [m]";
  final parameter Modelica.Units.SI.Volume V[nLayers] = {Modelica.Constants.pi*L*(r_outer[i]^2 - r_inner[i]^2) for i in 1:nLayers} "各層の体積 [m3]";
  final parameter Modelica.Units.SI.ThermalConductance G_innerHalf[nLayers] = {2*Modelica.Constants.pi*material[i].thermalConductivity*L/Modelica.Math.log(r_middle[i]/r_inner[i]) for i in 1:nLayers} "各層内側半分の熱コンダクタンス [W/K]";
  final parameter Modelica.Units.SI.ThermalConductance G_outerHalf[nLayers] = {2*Modelica.Constants.pi*material[i].thermalConductivity*L/Modelica.Math.log(r_outer[i]/r_middle[i]) for i in 1:nLayers} "各層外側半分の熱コンダクタンス [W/K]";
  final parameter Modelica.Units.SI.ThermalConductance G_between[nInterfaces] = {1/(1/G_outerHalf[i] + 1/G_innerHalf[i + 1]) for i in 1:nInterfaces} "隣接層間の等価熱コンダクタンス [W/K]";
  Modelica.Units.SI.Temperature T[nLayers] "各層の代表温度 [K]";
  Modelica.Units.SI.HeatFlowRate Q_between[nInterfaces] "層 i から i+1 へ流れる熱流量 [W]";
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor layer[nLayers](V = V, material = material, T_start = T_start) "各層の集中熱容量";
  Modelica.Blocks.Interfaces.RealInput Q_gen_input[nLayers](each final quantity = "HeatFlowRate", each final unit = "W") if use_heat_input "各層の内部発熱量入力 [W]（正: 加熱）" annotation(
    Placement(transformation(origin = {-110, 120}, extent = {{-20, 90}, {20, 130}}, rotation = -90), iconTransformation(origin = {-110, 120}, extent = {{-20, 90}, {20, 130}}, rotation = -90)));
  EAST.Thermal.HeatTransfer.Interfaces.HeatPort_a port_inner "内側熱ポート" annotation(
    Placement(transformation(extent = {{-110, -10}, {-90, 10}}), iconTransformation(extent = {{-110, -10}, {-90, 10}})));
  EAST.Thermal.HeatTransfer.Interfaces.HeatPort_b port_outer "外側熱ポート" annotation(
    Placement(transformation(extent = {{90, -10}, {110, 10}}), iconTransformation(extent = {{90, -10}, {110, 10}})));
protected
  Modelica.Units.SI.HeatFlowRate Q_gen_internal[nLayers] "実際に各層へ与える内部発熱量 [W]";
public
equation
  assert(innerDiameter > 0, "innerDiameter must be greater than zero.");
  assert(L > 0, "L must be greater than zero.");
  assert(outerDiameter[1] > innerDiameter, "outerDiameter[1] must be greater than innerDiameter.");
  for i in 2:nLayers loop
    assert(outerDiameter[i] > outerDiameter[i - 1], "outerDiameter must be strictly increasing.");
  end for;
  for i in 1:nLayers loop
    Q_gen_internal[i] = if use_heat_input then Q_gen_input[i] else Q_gen[i];
    T[i] = layer[i].T;
    layer[i].port_top.Q_flow = Q_gen_internal[i];
    layer[i].port_bottom.Q_flow = 0;
  end for;
  port_inner.Q_flow = G_innerHalf[1]*(port_inner.T - layer[1].T);
  layer[1].port_left.Q_flow = port_inner.Q_flow;
  for i in 1:nInterfaces loop
    Q_between[i] = G_between[i]*(layer[i].T - layer[i + 1].T);
    layer[i].port_right.Q_flow = -Q_between[i];
    layer[i + 1].port_left.Q_flow = Q_between[i];
  end for;
  port_outer.Q_flow = G_outerHalf[nLayers]*(port_outer.T - layer[nLayers].T);
  layer[nLayers].port_right.Q_flow = port_outer.Q_flow;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = true), graphics = {Ellipse(lineColor = {191, 0, 0}, fillColor = {170, 0, 0}, fillPattern = FillPattern.Solid, extent = {{-60, 60}, {60, -60}}), Ellipse(lineColor = {191, 0, 0}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Cross, extent = {{-38, 38}, {38, -38}}), Ellipse(lineColor = {191, 0, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-18, 18}, {18, -18}}), Line(points = {{-100, 0}, {-60, 0}}, color = {170, 0, 0}, thickness = 1.5, arrowSize = 7), Line(points = {{18, 0}, {100, 0}}, color = {191, 0, 0}, thickness = 1.5), Text(origin = {0, -247}, textColor = {0, 0, 255}, extent = {{-100, 147}, {100, 107}}, textString = "%name"), Text(extent = {{-100, -68}, {100, -92}}, textString = "n=%nLayers"), Rectangle(origin = {16, 0}, lineColor = {170, 0, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-4, 4}, {4, -4}}), Rectangle(origin = {-60, 0}, lineColor = {170, 0, 0}, fillColor = {170, 0, 0}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-4, 4}, {4, -4}}), Text(origin = {100, 58},extent = {{-40, -62}, {40, -84}}, textString = "inner")}),
    Documentation(info = "<html>
<p>
多層円筒壁の半径方向熱伝導を表す動的モデルのひな型です。
</p>
<p>
層数 <code>nLayers</code>、最内層の内径 <code>innerDiameter</code>、
各層の外径 <code>outerDiameter</code>、各層の材料 <code>material</code>、
各層の内部発熱量 <code>Q_gen</code> を指定します。
</p>
<p>
各層は内部に <code>HeatCapacitor</code> を持ち、材料密度・比熱・体積から熱容量を計算します。
そのため、層ごとの熱移動の遅れを表現できます。
</p>
<p>
<code>Q_gen[i]</code> は層 i に流入する内部発熱量 [W] です。正の値は層を加熱します。
<code>use_heat_input=true</code> の場合は、外部入力 <code>Q_gen_input[i]</code> が優先されます。
</p>
<p>
各層の熱容量代表半径は幾何平均半径
<code>sqrt(r_inner*r_outer)</code> とし、各層を内側半分・外側半分の熱抵抗に分割して
隣接層と接続しています。
</p>
</html>"),
    Diagram(graphics));
end CylindricalThermalConductor;
