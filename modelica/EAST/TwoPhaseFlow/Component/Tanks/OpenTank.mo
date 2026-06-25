within EAST.TwoPhaseFlow.Component.Tanks;

model OpenTank
  "開放タンク（自由表面を大気圧に固定した well-mixed モデル）"
  extends EAST.Icons.OpenTank;
  replaceable package Medium = EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium
    annotation (choicesAllMatching=true);

  parameter Integer nPorts(min=1) = 1
    "流体ポート数"
    annotation (Evaluate=true);
  parameter Modelica.Units.SI.Area crossArea = 1.0
    "タンク断面積";
  parameter Modelica.Units.SI.Height height = 1.0
    "タンク高さ";
  parameter Modelica.Units.SI.Height portHeights[nPorts] = fill(0.0, nPorts)
    "各ポートの高さ（タンク底面から）";
  parameter Modelica.Units.SI.AbsolutePressure p_ambient = 1.0e5
    "自由表面圧力";
  parameter Modelica.Units.SI.Acceleration g = Modelica.Constants.g_n
    "重力加速度";
  parameter Modelica.Units.SI.Height level_start = 0.5 * height
    "初期液位";
  parameter Modelica.Units.SI.SpecificEnthalpy h_start =
    Medium.bubbleEnthalpy(Medium.setSat_p(p_ambient))
    "初期比エンタルピー";
  parameter Modelica.Units.SI.Density d_start =
    Medium.density(Medium.setState_ph(p_ambient, h_start))
    "初期密度";

  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_a ports[nPorts](
    redeclare each package Medium = Medium)
    "流体ポート"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

  EAST.TwoPhaseFlow.Component.Interfaces.HeatPort_a heatPort
    "外部熱源との接続用ポート"
    annotation (Placement(
      transformation(extent={{-10,90},{10,110}}),
      iconTransformation(extent={{-10,90},{10,110}})));

  Modelica.Units.SI.Mass M(start=d_start * crossArea * level_start, fixed=true)
    "タンク内流体質量 [kg]";
  Modelica.Units.SI.SpecificEnthalpy h(start=h_start, fixed=true)
    "タンク内代表比エンタルピー [J/kg]";
  Modelica.Units.SI.Height level
    "液位 [m]";
  Modelica.Units.SI.Volume V_liquid
    "タンク内流体体積 [m3]";

  Medium.BaseProperties props
    "タンク内代表流体状態";

equation
  props.p = p_ambient;
  props.h = h;

  V_liquid = M / props.d;
  level = V_liquid / crossArea;

  der(M) = sum(ports[i].m_flow for i in 1:nPorts);
  M * der(h) =
    sum(ports[i].m_flow * (actualStream(ports[i].h_outflow) - h)
        for i in 1:nPorts) + heatPort.Q_flow;

  for i in 1:nPorts loop
    ports[i].p = p_ambient + props.d * g * max(level - portHeights[i], 0.0);
    ports[i].h_outflow = h;
  end for;

  heatPort.T = props.T;

  assert(level >= -1.0e-6,
    "OpenTank level became negative.");
  assert(level <= height + 1.0e-6,
    "OpenTank level exceeded tank height.");

  annotation (
    Icon(coordinateSystem(preserveAspectRatio = false)),
    Documentation(info="<html>
<p>
自由表面を持つ開放タンクの簡易モデル。
タンク内は well-mixed とし、自由表面圧力を <code>p_ambient</code> に固定する。
ポート圧力は自由表面圧力に静水圧
<code>props.d * g * max(level - portHeight, 0)</code> を加えた値とする。
</p>

<h4>方程式</h4>
<ul>
<li>質量蓄積: <code>der(M) = sum(ports.m_flow)</code></li>
<li>エンタルピー蓄積:
<code>M der(h) = sum(m_flow(actualStream(h_outflow)-h)) + heatPort.Q_flow</code></li>
<li>液位: <code>level = M / (props.d * crossArea)</code></li>
<li>流出エンタルピー: 各ポートで <code>ports[i].h_outflow = h</code></li>
</ul>

<h4>制限事項</h4>
<ul>
<li>気相空間、蒸発によるベント流量、相分離は未実装。</li>
<li>タンク内は単一の代表比エンタルピーを持つ well-mixed 近似。</li>
<li>密度は <code>Medium.BaseProperties(p_ambient, h)</code> で診断的に計算する。</li>
</ul>
</html>"));
end OpenTank;
