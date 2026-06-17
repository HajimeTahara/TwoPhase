within EAST.TwoPhaseFlow.Component.Pipes;

model PipeUniformHeatTransfer
  "単一 HeatPort から Pipe の各セグメントへ熱流を均等分配するラッパー"
  replaceable package Medium = EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium
    annotation (choicesAllMatching=true);

  parameter Modelica.Units.SI.Length L = 1.0 "管長 [m]";
  parameter Modelica.Units.SI.Diameter D = 0.01 "内径 [m]";
  parameter Integer nNodes(min=1) = 3
    "軸方向の分割数（直列接続する制御容積の数）";
  parameter Modelica.Units.SI.PressureDifference dp(min=0) = 0
    "管全体の圧力損失 [Pa]";
  parameter Modelica.Units.SI.AbsolutePressure p_start = 1.0e5
    "各セグメント CV 内圧力の初期値 [Pa]";
  parameter Modelica.Units.SI.SpecificEnthalpy h_start =
    Medium.bubbleEnthalpy(Medium.setSat_p(p_start))
    "各セグメント CV 内比エンタルピーの初期値 [J/kg]";

  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_a port_a(
    redeclare package Medium = Medium)
    "上流ポート（入口）"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_b port_b(
    redeclare package Medium = Medium)
    "下流ポート（出口）"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  EAST.TwoPhaseFlow.Component.Interfaces.HeatPort_a heatPort
    "管全体への一様入熱ポート"
    annotation (Placement(
      transformation(extent={{-10,90},{10,110}}),
      iconTransformation(extent={{-10,90},{10,110}})));

  Pipe pipe(
    redeclare package Medium = Medium,
    L = L,
    D = D,
    nNodes = nNodes,
    dp = dp,
    p_start = p_start,
    h_start = h_start)
    "分布 HeatPort を持つ基本 Pipe";

  EAST.TwoPhaseFlow.Component.HeatSources.UniformHeatDistributor heatDistributor(
    nPorts = nNodes)
    "単一 HeatPort から各セグメントへ熱流を均等分配する内部コンポーネント";

equation
  connect(port_a, pipe.port_a);
  connect(pipe.port_b, port_b);
  connect(heatPort, heatDistributor.sourcePort);

  for i in 1:nNodes loop
    connect(heatDistributor.distributedPorts[i], pipe.heatPorts[i]);
  end for;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
      Rectangle(
        extent={{-100,30},{100,-30}},
        lineColor={0,0,255},
        fillColor={0,128,255},
        fillPattern=FillPattern.HorizontalCylinder),
      Line(points={{0,100},{0,30}}, color={191,0,0}),
      Text(
        extent={{-100,60},{100,42}},
        lineColor={0,0,0},
        textString="%name")}),
    Documentation(info="<html>
<p>
<code>Pipe</code> を内包し、単一の <code>heatPort</code> から
<code>nNodes</code> 個の内部セグメントへ熱流を均等分配するラッパーモデル。
</p>
<p>
セグメントごとの個別熱境界条件を DiagramView 上で接続したい場合は、
基本モデル <code>Pipe</code> の <code>heatPorts[nNodes]</code> を直接使用する。
管全体に一様な熱流を与えたい場合は本モデルを使用する。
</p>
<p>
<code>heatPort.T</code> は内部の <code>UniformHeatDistributor</code> により、
各セグメント HeatPort 温度の単純平均で代表させる。
</p>
</html>"));
end PipeUniformHeatTransfer;
