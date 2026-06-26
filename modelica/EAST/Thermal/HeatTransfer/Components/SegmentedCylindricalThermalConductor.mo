within EAST.Thermal.HeatTransfer.Components;

model SegmentedCylindricalThermalConductor "材料物性と多層円筒形状から半径方向・長さ方向の熱伝導を計算する要素"
  extends EAST.Icons.CylinderThermal;
  parameter Integer nLayers(min = 1) = 1 "層数" annotation(
    Evaluate = true);
  parameter Integer nNode(min = 1) = 5 "長さ方向の分割数" annotation(
    Evaluate = true);
  parameter Modelica.Units.SI.Diameter innerDiameter = 0.02 "最内層の内径";
  parameter Modelica.Units.SI.Diameter outerDiameter[nLayers] = {innerDiameter + 0.02*i for i in 1:nLayers} "各層の外径";
  parameter Modelica.Units.SI.Length L = 0.1 "円筒長さ";
  parameter EAST.Thermal.Material.MaterialProperties material[nLayers] = fill(EAST.Thermal.Material.Sus304(), nLayers) "各層の材料物性";
  parameter Boolean use_heat_input = false
    "true: 外部入力 Q_gen_input、false: 固定値 Q_gen を使用" annotation(
    Evaluate = true);
  parameter Boolean use_temperature_output = false
    "true: 各層・各ノード温度出力を使用" annotation(
    Evaluate = true);
  parameter Modelica.Units.SI.HeatFlowRate Q_gen[nLayers, nNode] =
    fill(0, nLayers, nNode)
    "各層・各ノードの固定内部発熱量（正: 加熱）" annotation(
    Dialog(enable = not use_heat_input));
  parameter Modelica.Units.SI.Temperature T_start[nLayers, nNode] = fill(293.15, nLayers, nNode) "各層・各ノードの初期温度";
  final parameter Integer nRadialInterfaces = max(nLayers - 1, 0) "隣接層間インターフェース数";
  final parameter Integer nAxialInterfaces = max(nNode - 1, 0) "隣接ノード間インターフェース数";
  final parameter Modelica.Units.SI.Length dz = L/nNode "1 ノードあたりの長さ";
  final parameter Modelica.Units.SI.Length r_inner[nLayers] = {if i == 1 then innerDiameter/2 else outerDiameter[i - 1]/2 for i in 1:nLayers} "各層の内半径";
  final parameter Modelica.Units.SI.Length r_outer[nLayers] = {outerDiameter[i]/2 for i in 1:nLayers} "各層の外半径";
  final parameter Modelica.Units.SI.Length r_middle[nLayers] = {sqrt(r_inner[i]*r_outer[i]) for i in 1:nLayers} "各層の熱容量代表半径";
  final parameter Modelica.Units.SI.Area A_cross[nLayers] = {Modelica.Constants.pi*(r_outer[i]^2 - r_inner[i]^2) for i in 1:nLayers} "各層の長さ方向断面積";
  final parameter Modelica.Units.SI.Volume V[nLayers] = {A_cross[i]*dz for i in 1:nLayers} "各層・各ノードあたりの体積";
  final parameter Modelica.Units.SI.HeatCapacity C[nLayers] = {material[i].density*V[i]*material[i].specificHeatCapacity for i in 1:nLayers} "各層・各ノードあたりの熱容量";
  final parameter Modelica.Units.SI.ThermalConductance G_innerHalf[nLayers] = {2*Modelica.Constants.pi*material[i].thermalConductivity*dz/Modelica.Math.log(r_middle[i]/r_inner[i]) for i in 1:nLayers} "各層内側半分の半径方向熱コンダクタンス（ノードあたり）";
  final parameter Modelica.Units.SI.ThermalConductance G_outerHalf[nLayers] = {2*Modelica.Constants.pi*material[i].thermalConductivity*dz/Modelica.Math.log(r_outer[i]/r_middle[i]) for i in 1:nLayers} "各層外側半分の半径方向熱コンダクタンス（ノードあたり）";
  final parameter Modelica.Units.SI.ThermalConductance G_radial[nRadialInterfaces] = {1/(1/G_outerHalf[i] + 1/G_innerHalf[i + 1]) for i in 1:nRadialInterfaces} "隣接層間の等価半径方向熱コンダクタンス（ノードあたり）";
  final parameter Modelica.Units.SI.ThermalConductance G_axial[nLayers] = {material[i].thermalConductivity*A_cross[i]/dz for i in 1:nLayers} "各層の隣接ノード間の長さ方向熱コンダクタンス";
  Modelica.Units.SI.Temperature T[nLayers, nNode](start = T_start) "各層・各ノードの代表温度 [K]";
  Modelica.Units.SI.HeatFlowRate Q_radial[nRadialInterfaces, nNode] "層 i から i+1 へ流れる半径方向熱流量 [W]";
  Modelica.Units.SI.HeatFlowRate Q_axial[nLayers, nAxialInterfaces] "ノード j から j+1 へ流れる長さ方向熱流量 [W]";
  Modelica.Blocks.Interfaces.RealInput Q_gen_input[nLayers, nNode](each final quantity = "HeatFlowRate", each final unit = "W") if use_heat_input "各層・各ノードの内部発熱量入力 [W]（正: 加熱）" annotation(
    Placement(transformation(origin = {-110, 120}, extent = {{-20, 90}, {20, 130}}, rotation = -90), iconTransformation(origin = {-110, 120}, extent = {{-20, 90}, {20, 130}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput layerTemperature[nLayers, nNode](
    each final quantity = "ThermodynamicTemperature",
    each final unit = "K",
    each displayUnit = "degC") if use_temperature_output
    "各層・各ノードの代表温度出力" annotation(
    Placement(transformation(origin = {110, 120}, extent = {{-20, 90}, {20, 130}}, rotation = 90), iconTransformation(origin = {110, 120}, extent = {{-20, 90}, {20, 130}}, rotation = 90)));
  EAST.Thermal.HeatTransfer.Interfaces.HeatPort_a port_inner[nNode] "内側熱ポート（軸方向ノードごと）" annotation(
    Placement(transformation(extent = {{-110, -10}, {-90, 10}}), iconTransformation(extent = {{-110, -10}, {-90, 10}})));
  EAST.Thermal.HeatTransfer.Interfaces.HeatPort_b port_outer[nNode] "外側熱ポート（軸方向ノードごと）" annotation(
    Placement(transformation(extent = {{90, -10}, {110, 10}}), iconTransformation(extent = {{90, -10}, {110, 10}})));
protected
  Modelica.Units.SI.HeatFlowRate Q_gen_internal[nLayers, nNode] "実際に各層・各ノードへ与える内部発熱量 [W]";
public
equation
  assert(innerDiameter > 0, "innerDiameter must be greater than zero.");
  assert(L > 0, "L must be greater than zero.");
  assert(outerDiameter[1] > innerDiameter, "outerDiameter[1] must be greater than innerDiameter.");
  for i in 2:nLayers loop
    assert(outerDiameter[i] > outerDiameter[i - 1], "outerDiameter must be strictly increasing.");
  end for;
  for i in 1:nLayers loop
    for j in 1:nNode loop
      Q_gen_internal[i, j] = if use_heat_input then Q_gen_input[i, j] else Q_gen[i, j];
    end for;
  end for;
  if use_temperature_output then
    for i in 1:nLayers loop
      for j in 1:nNode loop
        layerTemperature[i, j] = T[i, j];
      end for;
    end for;
  end if;
  for j in 1:nNode loop
    port_inner[j].Q_flow = G_innerHalf[1]*(port_inner[j].T - T[1, j]);
    port_outer[j].Q_flow = G_outerHalf[nLayers]*(port_outer[j].T - T[nLayers, j]);
  end for;
  for i in 1:nRadialInterfaces loop
    for j in 1:nNode loop
      Q_radial[i, j] = G_radial[i]*(T[i, j] - T[i + 1, j]);
    end for;
  end for;
  for i in 1:nLayers loop
    for j in 1:nAxialInterfaces loop
      Q_axial[i, j] = G_axial[i]*(T[i, j] - T[i, j + 1]);
    end for;
  end for;
  for i in 1:nLayers loop
    for j in 1:nNode loop
      C[i]*der(T[i, j]) = Q_gen_internal[i, j]
        + (if i == 1 then port_inner[j].Q_flow else Q_radial[i - 1, j])
        + (if i == nLayers then port_outer[j].Q_flow else -Q_radial[i, j])
        + (if j == 1 then 0 else Q_axial[i, j - 1])
        + (if j == nNode then 0 else -Q_axial[i, j]);
    end for;
  end for;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = true), graphics = {Text(origin = {0, -247}, textColor = {0, 0, 255}, extent = {{-100, 147}, {100, 107}}, textString = "%name"), Text(origin = {0, 54},extent = {{-100, -114}, {100, -154}}, textString = "layer=%nLayers"), Text(origin = {-100, 54}, extent = {{-40, -62}, {40, -84}}, textString = "inner"), Text(origin = {0, 214}, textColor = {0, 0, 255}, extent = {{-100, -114}, {100, -154}}, textString = "node=%nNode")}),
    Documentation(info = "<html>
<p>
<code>CylindricalThermalConductor</code> を拡張し、半径方向（層）に加えて長さ方向（ノード）にも
分割することで、円筒長さ方向の温度変化を表現する動的モデルです。
</p>
<p>
半径方向は層数 <code>nLayers</code>、長さ方向はノード数 <code>nNode</code> で分割し、
温度 <code>T[nLayers, nNode]</code> を持つ <code>nLayers</code> 行 × <code>nNode</code> 列の
集中熱容量グリッドとして扱います。各セルの熱容量は、層の断面積
<code>A_cross[i] = pi*(r_outer[i]^2 - r_inner[i]^2)</code> とノードあたりの長さ
<code>dz = L/nNode</code> から求めた体積 <code>V[i] = A_cross[i]*dz</code> と材料物性
<code>material[i]</code> から計算します。
</p>
<p>
半径方向の熱コンダクタンスは <code>CylindricalThermalConductor</code> と同じ考え方で、
各層を内側半分・外側半分の熱抵抗に分割し、隣接層と接続します（ノードごとに同じ式を適用）。
長さ方向は同じ材料の 1 次元熱伝導として隣接ノード間を接続し、
熱コンダクタンスは <code>G_axial[i] = material[i].thermalConductivity*A_cross[i]/dz</code> です。
</p>
<p>
内側・外側の熱ポート <code>port_inner</code>・<code>port_outer</code> はノードごとに 1 つずつ
（要素数 <code>nNode</code> のベクトル）持つため、長さ方向に分布した外部熱源・熱浴と
ノード単位で接続できます。長さ方向の両端は断熱（ノード外への熱伝導は考慮しない）です。
</p>
<p>
<code>Q_gen[i, j]</code> は層 i・ノード j に流入する内部発熱量 [W] です。正の値は加熱します。
<code>use_heat_input=true</code> の場合は、外部入力 <code>Q_gen_input[i, j]</code> が優先されます。
</p>
<p>
<code>use_temperature_output=true</code> の場合、各層・各ノードの代表温度は
<code>layerTemperature[i, j]</code> からReal信号として出力できます。
</p>
</html>"),
    Diagram(graphics));
end SegmentedCylindricalThermalConductor;
