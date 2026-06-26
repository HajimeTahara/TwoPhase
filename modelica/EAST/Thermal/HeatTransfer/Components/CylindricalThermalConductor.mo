within EAST.Thermal.HeatTransfer.Components;

model CylindricalThermalConductor "材料物性と多層円筒形状から半径方向熱伝導を計算する要素"
  extends EAST.Icons.CylinderThermal;
  parameter Integer nLayers(min = 1) = 1 "層数" annotation(
    Evaluate = true);
  parameter Modelica.Units.SI.Diameter innerDiameter = 0.02 "最内層の内径";
  parameter Modelica.Units.SI.Diameter outerDiameter[nLayers] = {innerDiameter + 0.02*i for i in 1:nLayers} "各層の外径";
  parameter Modelica.Units.SI.Length L = 0.1 "円筒長さ";
  parameter EAST.Thermal.Material.MaterialProperties material[nLayers] = fill(EAST.Thermal.Material.Sus304(), nLayers) "各層の材料物性";
  parameter Boolean use_heat_input = false
    "true: 外部入力 Q_gen_input、false: 固定値 Q_gen を使用" annotation(
    Evaluate = true);
  parameter Boolean use_temperature_output = false
    "true: 各層温度出力を使用" annotation(
    Evaluate = true);
  parameter Modelica.Units.SI.HeatFlowRate Q_gen[nLayers] = fill(0, nLayers)
    "各層の固定内部発熱量（正: 加熱）" annotation(
    Dialog(enable = not use_heat_input));
  parameter Modelica.Units.SI.Temperature T_start[nLayers] = fill(293.15, nLayers) "各層の初期温度";
  final parameter Integer nInterfaces = max(nLayers - 1, 0) "隣接層間インターフェース数";
  final parameter Modelica.Units.SI.Length r_inner[nLayers] = {if i == 1 then innerDiameter/2 else outerDiameter[i - 1]/2 for i in 1:nLayers} "各層の内半径";
  final parameter Modelica.Units.SI.Length r_outer[nLayers] = {outerDiameter[i]/2 for i in 1:nLayers} "各層の外半径";
  final parameter Modelica.Units.SI.Length r_middle[nLayers] = {sqrt(r_inner[i]*r_outer[i]) for i in 1:nLayers} "各層の熱容量代表半径";
  final parameter Modelica.Units.SI.Volume V[nLayers] = {Modelica.Constants.pi*L*(r_outer[i]^2 - r_inner[i]^2) for i in 1:nLayers} "各層の体積";
  final parameter Modelica.Units.SI.HeatCapacity C[nLayers] = {material[i].density*V[i]*material[i].specificHeatCapacity for i in 1:nLayers} "各層の熱容量";
  final parameter Modelica.Units.SI.ThermalConductance G_innerHalf[nLayers] = {2*Modelica.Constants.pi*material[i].thermalConductivity*L/Modelica.Math.log(r_middle[i]/r_inner[i]) for i in 1:nLayers} "各層内側半分の熱コンダクタンス";
  final parameter Modelica.Units.SI.ThermalConductance G_outerHalf[nLayers] = {2*Modelica.Constants.pi*material[i].thermalConductivity*L/Modelica.Math.log(r_outer[i]/r_middle[i]) for i in 1:nLayers} "各層外側半分の熱コンダクタンス";
  final parameter Modelica.Units.SI.ThermalConductance G_between[nInterfaces] = {1/(1/G_outerHalf[i] + 1/G_innerHalf[i + 1]) for i in 1:nInterfaces} "隣接層間の等価熱コンダクタンス";
  Modelica.Units.SI.Temperature T[nLayers](start = T_start) "各層の代表温度 [K]";
  Modelica.Units.SI.HeatFlowRate Q_between[nInterfaces] "層 i から i+1 へ流れる熱流量 [W]";
  Modelica.Blocks.Interfaces.RealInput Q_gen_input[nLayers](each final quantity = "HeatFlowRate", each final unit = "W") if use_heat_input "各層の内部発熱量入力 [W]（正: 加熱）" annotation(
    Placement(transformation(origin = {-110, 120}, extent = {{-20, 90}, {20, 130}}, rotation = -90), iconTransformation(origin = {-110, 120}, extent = {{-20, 90}, {20, 130}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput layerTemperature[nLayers](
    each final quantity = "ThermodynamicTemperature",
    each final unit = "K",
    each displayUnit = "degC") if use_temperature_output
    "各層の代表温度出力" annotation(
    Placement(transformation(origin = {20, 120}, extent = {{-20, 90}, {20, 130}}, rotation = 90), iconTransformation(origin = {30, 120}, extent = {{-20, 90}, {20, 130}}, rotation = 90)));
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
  end for;
  if use_temperature_output then
    for i in 1:nLayers loop
      layerTemperature[i] = T[i];
    end for;
  end if;
  port_inner.Q_flow = G_innerHalf[1]*(port_inner.T - T[1]);
  for i in 1:nInterfaces loop
    Q_between[i] = G_between[i]*(T[i] - T[i + 1]);
  end for;
  port_outer.Q_flow = G_outerHalf[nLayers]*(port_outer.T - T[nLayers]);
  if nLayers == 1 then
    C[1]*der(T[1]) =
      Q_gen_internal[1] + port_inner.Q_flow + port_outer.Q_flow;
  else
    C[1]*der(T[1]) =
      Q_gen_internal[1] + port_inner.Q_flow - Q_between[1];
    for i in 2:nLayers - 1 loop
      C[i]*der(T[i]) =
        Q_gen_internal[i] + Q_between[i - 1] - Q_between[i];
    end for;
    C[nLayers]*der(T[nLayers]) =
      Q_gen_internal[nLayers] + Q_between[nLayers - 1] +
      port_outer.Q_flow;
  end if;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = true), graphics = {Text(origin = {0, -247}, textColor = {0, 0, 255}, extent = {{-100, 147}, {100, 107}}, textString = "%name"), Text(origin = {0, 54}, extent = {{-100, -114}, {100, -154}}, textString = "layer=%nLayers"), Text(origin = {-98, 52},extent = {{-40, -62}, {40, -84}}, textString = "inner")}),
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
各層の温度 <code>T[i]</code> を状態変数とし、材料密度・比熱・体積から
計算した熱容量 <code>C[i]</code> のエネルギー収支を直接記述します。
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
<p>
<code>use_temperature_output=true</code> の場合、各層の代表温度は
<code>layerTemperature[i]</code> からReal信号として出力できます。
</p>
<p>
内部の未接続 HeatPort は使用せず、各層について次の形式の収支を直接計算します。
</p>
<pre>
C[i] * der(T[i]) = Q_gen[i] + Q_from_inner - Q_to_outer
</pre>
</html>"),
    Diagram(graphics));
end CylindricalThermalConductor;
