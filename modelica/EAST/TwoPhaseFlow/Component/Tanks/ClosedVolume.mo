within EAST.TwoPhaseFlow.Component.Tanks;
model ClosedVolume
  "固定容積の well-mixed タンク（MSL ClosedVolume 風のひな型）"
  extends EAST.Icons.ClosedVolume;
  replaceable package Medium = EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium
    annotation (choicesAllMatching=true);

  parameter Integer nPorts(min=1) = 2 "流体ポート数" annotation (Evaluate=true);
  parameter Modelica.Units.SI.Volume V = 1.0 "容積";
  parameter Modelica.Units.SI.AbsolutePressure p_start = 1.0e5
    "初期圧力";
  parameter Modelica.Units.SI.SpecificEnthalpy h_start =
    Medium.bubbleEnthalpy(Medium.setSat_p(p_start))
    "初期比エンタルピー";

  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_a ports[nPorts](
    redeclare each package Medium = Medium)
    "流体ポート"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

  EAST.TwoPhaseFlow.Component.Interfaces.HeatPort_a heatPort
    "外部熱源との接続用ポート"
    annotation (Placement(
      transformation(extent={{-10,90},{10,110}}),
      iconTransformation(extent={{-10,90},{10,110}})));

  Modelica.Units.SI.AbsolutePressure p(start=p_start)
    "タンク内代表圧力 [Pa]";
  Modelica.Units.SI.SpecificEnthalpy h(start=h_start)
    "タンク内代表比エンタルピー [J/kg]";
  Modelica.Units.SI.Mass M "タンク内流体質量 [kg]";
  Modelica.Units.SI.Energy U "タンク内内部エネルギー [J]";

  Medium.BaseProperties props "タンク内代表流体状態";

equation
  props.p = p;
  props.h = h;

  M = props.d * V;
  U = M * props.u;

  der(M) = sum(ports[i].m_flow for i in 1:nPorts);
  der(U) =
    sum(ports[i].m_flow * actualStream(ports[i].h_outflow)
        for i in 1:nPorts) + heatPort.Q_flow;

  for i in 1:nPorts loop
    ports[i].p = p;
    ports[i].h_outflow = h;
  end for;

  heatPort.T = props.T;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio = false)),
    Documentation(info="<html>
<p>
固定容積 <code>V</code> に流体を蓄える well-mixed タンクのひな型。
MSL の <code>Modelica.Fluid.Vessels.ClosedVolume</code> の考え方に倣い、
複数の流体ポート、質量蓄積、エネルギー蓄積、熱ポートを持つ。
</p>
<h4>制限事項</h4>
<ul>
<li>液面高さ・重力ヘッド・相分離は未実装。</li>
<li>全ポートは同一の代表圧力・代表比エンタルピーを共有する。</li>
<li>媒体関数を介した陰関数 DAE になるため、媒体モデルの精度と滑らかさに依存する。</li>
</ul>
</html>"),
  Diagram(graphics));
end ClosedVolume;
