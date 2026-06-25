within EAST.TwoPhaseFlow.Component.Tanks;

model GasPressuredTank "ガス押しタンク（気相体積と理想気体式から内圧を計算）"
  extends EAST.Icons.GasPressuredTank;
  replaceable package Medium = EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium annotation(
    choicesAllMatching = true);
  parameter Integer nPorts(min = 1) = 1 "液相流体ポート数" annotation(
    Evaluate = true);
  parameter Modelica.Units.SI.Area crossArea = 1.0 "タンク断面積";
  parameter Modelica.Units.SI.Height height = 1.0 "タンク高さ";
  final parameter Modelica.Units.SI.Volume V_total = crossArea*height "タンク全容積";
  parameter Modelica.Units.SI.Height portHeights[nPorts] = fill(0.0, nPorts) "各液相ポートの高さ（タンク底面から）";
  parameter Modelica.Units.SI.Acceleration g = Modelica.Constants.g_n "重力加速度";
  parameter Modelica.Units.SI.AbsolutePressure p_gas_start = 1.0e5 "初期気相圧力";
  parameter Modelica.Units.SI.Temperature T_gas = 300.0 "気相温度（等温近似）";
  parameter Modelica.Units.SI.MolarMass gasMolarMass = 0.0289652 "押しガスのモル質量（既定: 空気）";
  final parameter Real R_gas(unit = "J/(kg.K)") = Modelica.Constants.R/gasMolarMass "押しガスの比気体定数";
  parameter Modelica.Units.SI.Height level_start = 0.5*height "初期液位";
  parameter Modelica.Units.SI.SpecificEnthalpy h_start = Medium.bubbleEnthalpy(Medium.setSat_p(p_gas_start)) "初期液相比エンタルピー";
  parameter Modelica.Units.SI.Density d_start = Medium.density(Medium.setState_ph(p_gas_start, h_start)) "初期液相密度";
  final parameter Modelica.Units.SI.Volume V_liquid_start = crossArea*level_start "初期液相体積";
  final parameter Modelica.Units.SI.Volume V_gas_start = max(V_total - V_liquid_start, 1.0e-9) "初期気相体積";
  final parameter Modelica.Units.SI.Mass M_gas_start = p_gas_start*V_gas_start/(R_gas*T_gas) "初期気相質量";
  Modelica.Blocks.Interfaces.RealInput mGas_flow_in(unit = "kg/s") "押しガス質量流量入力 [kg/s]（正: タンク気相へ流入）" annotation(
    Placement(transformation(extent = {{-20, 100}, {20, 140}}), iconTransformation(origin = {-120, -40}, extent = {{-20, 100}, {20, 140}})));
  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_a ports[nPorts](redeclare each package Medium = Medium) "液相流体ポート" annotation(
    Placement(transformation(extent = {{-10, -110}, {10, -90}})));
  EAST.TwoPhaseFlow.Component.Interfaces.HeatPort_a heatPort "液相への外部熱源接続用ポート" annotation(
    Placement(transformation(extent = {{70, 70}, {90, 90}}), iconTransformation(origin = {20, -20}, extent = {{70, 70}, {90, 90}})));
  Modelica.Units.SI.Mass M_liquid(start = d_start*V_liquid_start, fixed = true) "タンク内液相質量 [kg]";
  Modelica.Units.SI.Mass M_gas(start = M_gas_start, fixed = true) "タンク内気相質量 [kg]";
  Modelica.Units.SI.SpecificEnthalpy h(start = h_start, fixed = true) "液相代表比エンタルピー [J/kg]";
  Modelica.Units.SI.AbsolutePressure p_gas "気相圧力 [Pa]";
  Modelica.Units.SI.Height level "液位 [m]";
  Modelica.Units.SI.Volume V_liquid "液相体積 [m3]";
  Modelica.Units.SI.Volume V_gas "気相体積 [m3]";
  Medium.BaseProperties props "液相代表流体状態";
equation
  props.p = p_gas;
  props.h = h;
  V_liquid = M_liquid/props.d;
  V_gas = V_total - V_liquid;
  level = V_liquid/crossArea;
  p_gas = M_gas*R_gas*T_gas/max(V_gas, 1.0e-9);
  der(M_gas) = mGas_flow_in;
  der(M_liquid) = sum(ports[i].m_flow for i in 1:nPorts);
  M_liquid*der(h) = sum(ports[i].m_flow*(actualStream(ports[i].h_outflow) - h) for i in 1:nPorts) + heatPort.Q_flow;
  for i in 1:nPorts loop
    ports[i].p = p_gas + props.d*g*max(level - portHeights[i], 0.0);
    ports[i].h_outflow = h;
  end for;
  heatPort.T = props.T;
  assert(M_gas >= -1.0e-9, "GasPressuredTank gas mass became negative.");
  assert(level >= -1.0e-6, "GasPressuredTank liquid level became negative.");
  assert(level <= height + 1.0e-6, "GasPressuredTank liquid level exceeded tank height.");
  assert(V_gas >= 1.0e-9, "GasPressuredTank gas volume became too small.");
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = false)),
    Documentation(info = "<html>
<p>
押しガスで加圧されるタンクの簡易モデル。
液相は well-mixed とし、気相は等温理想気体として扱う。
気相圧力は <code>p_gas = M_gas R_gas T_gas / V_gas</code> で計算し、
液相ポート圧力は気相圧力に静水圧を加えた値とする。
</p>

<h4>入力</h4>
<ul>
<li><code>mGas_flow_in</code>: 押しガス質量流量 [kg/s]。正値でタンク気相へ流入。</li>
</ul>

<h4>体積管理</h4>
<ul>
<li><code>V_liquid = M_liquid / props.d</code></li>
<li><code>V_gas = V_total - V_liquid</code></li>
<li><code>level = V_liquid / crossArea</code></li>
</ul>

<h4>制限事項</h4>
<ul>
<li>気相は等温理想気体。気相エネルギー方程式は未実装。</li>
<li>液相と気相の蒸発・凝縮、溶解、相分離は未実装。</li>
<li>液相は単一の代表比エンタルピーを持つ well-mixed 近似。</li>
</ul>
</html>"));
end GasPressuredTank;
