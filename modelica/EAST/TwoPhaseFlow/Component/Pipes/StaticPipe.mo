within EAST.TwoPhaseFlow.Component.Pipes;
model StaticPipe "流体蓄積を持たない静的管抵抗"
  extends EAST.Icons.StaticPipe;

  replaceable package Medium =
    EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium
    annotation (choicesAllMatching=true);

  parameter PipeGeometry geometry = PipeGeometry.Circular
    "配管断面形状"
    annotation (Dialog(tab="Geometry", group="Geometry"));
  parameter Modelica.Units.SI.Length length(
    min=Modelica.Constants.small) = 1
    "管長"
    annotation (Dialog(tab="Geometry", group="Geometry"));
  parameter Modelica.Units.SI.Length rectangularLongSide(
    min=Modelica.Constants.small) = 0.02
    "矩形管断面の長辺"
    annotation (Dialog(
      tab="Geometry",
      group="Rectangular duct",
      enable=geometry == PipeGeometry.Rectangular));
  parameter Modelica.Units.SI.Length rectangularShortSide(
    min=Modelica.Constants.small) = 0.01
    "矩形管断面の短辺"
    annotation (Dialog(
      tab="Geometry",
      group="Rectangular duct",
      enable=geometry == PipeGeometry.Rectangular));
  parameter Modelica.Units.SI.Diameter diameter(
    min=Modelica.Constants.small) = 0.01
    "円管内径"
    annotation (Dialog(
      tab="Geometry",
      group="Circular pipe",
      enable=geometry == PipeGeometry.Circular));
  parameter Modelica.Units.SI.Diameter annularOuterDiameter(
    min=Modelica.Constants.small) = 0.02
    "環状流路の外側内径"
    annotation (Dialog(
      tab="Geometry",
      group="Annular duct",
      enable=geometry == PipeGeometry.Annular));
  parameter Modelica.Units.SI.Diameter annularInnerDiameter(
    min=Modelica.Constants.small) = 0.01
    "環状流路の内側外径"
    annotation (Dialog(
      tab="Geometry",
      group="Annular duct",
      enable=geometry == PipeGeometry.Annular));

  final parameter Modelica.Units.SI.Area crossArea =
    if geometry == PipeGeometry.Rectangular then
      rectangularLongSide*rectangularShortSide
    elseif geometry == PipeGeometry.Circular then
      Modelica.Constants.pi/4*diameter^2
    else
      Modelica.Constants.pi/4*
        (annularOuterDiameter^2 - annularInnerDiameter^2)
    "流路断面積";
  final parameter Modelica.Units.SI.Length wettedPerimeter =
    if geometry == PipeGeometry.Rectangular then
      2*(rectangularLongSide + rectangularShortSide)
    elseif geometry == PipeGeometry.Circular then
      Modelica.Constants.pi*diameter
    else
      Modelica.Constants.pi*
        (annularOuterDiameter + annularInnerDiameter)
    "濡れ縁長さ";
  final parameter Modelica.Units.SI.Diameter equivalentDiameter =
    4*crossArea/wettedPerimeter
    "等価直径（水力直径）";

  final parameter Modelica.Units.SI.ReynoldsNumber ReynoldsTransition = 2300
    "層流から乱流へ切り替える Reynolds 数";
  parameter FrictionCorrelation frictionCorrelation =
    FrictionCorrelation.Blasius
    "乱流域の Darcy 摩擦係数相関式"
    annotation (Dialog(
      tab="Flow resistance",
      group="Turbulent correlation"));
  parameter Modelica.Units.SI.Length roughness(min=0) = 2.5e-5
    "管内面の絶対粗さ ε"
    annotation (Dialog(
      tab="Flow resistance",
      group="Turbulent correlation",
      enable=frictionCorrelation == FrictionCorrelation.Colebrook));
  parameter Modelica.Units.SI.AbsolutePressure p_a_start = 1.0e5
    "port_a 圧力の初期推定値"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.Units.SI.AbsolutePressure p_b_start = p_a_start
    "port_b 圧力の初期推定値"
    annotation (Dialog(tab="Initialization"));

  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_a port_a(
    redeclare package Medium = Medium,
    p(start=p_a_start, nominal=1.0e5))
    "設計流れ方向の入口ポート"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_b port_b(
    redeclare package Medium = Medium,
    p(start=p_b_start, nominal=1.0e5))
    "設計流れ方向の出口ポート"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  Modelica.Units.SI.MassFlowRate m_flow
    "port_a から port_b 方向を正とする質量流量";
  Modelica.Units.SI.Density upstreamDensity
    "流れ方向上流側の密度";
  Modelica.Units.SI.DynamicViscosity upstreamMu
    "流れ方向上流側の粘性係数 μ";
  Modelica.Units.SI.Velocity velocity
    "断面平均流速";
  Modelica.Units.SI.KinematicViscosity nu
    "流れ方向上流側密度に基づく動粘性係数 ν";
  Modelica.Units.SI.ReynoldsNumber Re
    "等価直径に基づく Reynolds 数";
  Real frictionFactor(unit="1")
    "Darcy 摩擦係数";
  Boolean turbulent
    "乱流判定";
  Modelica.Units.SI.PressureDifference dp
    "port_a から port_b 方向を正とする摩擦圧力損失";

protected
  Medium.BaseProperties properties_a "port_a 側流体状態";
  Medium.BaseProperties properties_b "port_b 側流体状態";

equation
  assert(
    geometry <> PipeGeometry.Rectangular or
      rectangularLongSide >= rectangularShortSide,
    "矩形管では rectangularLongSide を rectangularShortSide 以上にしてください。");
  assert(
    geometry <> PipeGeometry.Annular or
      annularOuterDiameter > annularInnerDiameter,
    "中空円環では annularOuterDiameter を annularInnerDiameter より大きくしてください。");

  port_a.m_flow + port_b.m_flow = 0;
  m_flow = port_a.m_flow;

  properties_a.p = port_a.p;
  properties_a.h = inStream(port_a.h_outflow);
  properties_b.p = port_b.p;
  properties_b.h = inStream(port_b.h_outflow);

  upstreamDensity = noEvent(
    if m_flow >= 0 then properties_a.d else properties_b.d);
  upstreamMu = noEvent(
    if m_flow >= 0 then properties_a.mu else properties_b.mu);
  velocity = m_flow/(upstreamDensity*crossArea);
  nu = upstreamMu/upstreamDensity;
  Re = abs(velocity)*equivalentDiameter/nu;
  turbulent = Re >= ReynoldsTransition;
  frictionFactor = noEvent(
    if Re <= Modelica.Constants.small then 0
    elseif turbulent then
      if frictionCorrelation == FrictionCorrelation.Blasius then
        0.3164/Re^0.25
      else
        colebrookFrictionFactor(Re, roughness/equivalentDiameter)
    else
      64/Re);
  dp = frictionFactor*length/equivalentDiameter*
    upstreamDensity/2*velocity*abs(velocity);
  port_a.p - port_b.p = dp;

  port_b.h_outflow = inStream(port_a.h_outflow);
  port_a.h_outflow = inStream(port_b.h_outflow);

  annotation (
    defaultComponentName="staticPipe",
    Icon(coordinateSystem(preserveAspectRatio=true)),
    Documentation(info="<html>
<p>
<code>DynamicPipeSegment</code> と同じ断面形状および管摩擦相関式を使用し、
流体の質量・エネルギー蓄積を持たない静的な二ポート管抵抗モデル。
</p>
<p>
内部制御容積、状態変数、初期値、HeatPort を持たず、圧力差と質量流量の
代数関係だけを計算する。流体は断熱・等エンタルピーで通過する。
</p>
<p>
<code>port_a.p</code> と <code>port_b.p</code> の初期反復値は、
それぞれ <code>p_a_start</code> と
<code>p_b_start</code> で設定できる。これらは圧力を固定する境界条件ではなく、
初期化ソルバーへ与える推定値である。実際の圧力は、接続された圧力境界、
タンク、動的配管などの圧力条件と、本モデルの圧力損失式を連立して
代数的に決定する。
</p>
<h4>圧力損失</h4>
<pre>
velocity = m_flow / (upstreamDensity * crossArea)
upstreamMu = upstreamProperties.mu
nu = upstreamMu / upstreamDensity
Re = abs(velocity) * equivalentDiameter / nu
dp = frictionFactor * length / equivalentDiameter
     * upstreamDensity / 2 * velocity * abs(velocity)
</pre>
<ul>
<li>層流域: <code>frictionFactor = 64/Re</code></li>
<li>乱流域: Blasius式またはColebrook-White式</li>
<li>流れ方向上流側の媒体密度と粘性係数を使用し、正流・逆流に対応</li>
</ul>
<h4>DynamicPipeSegmentとの違い</h4>
<ul>
<li>制御容積と流体蓄積を持たない</li>
<li>圧力・比エンタルピーの状態変数を持たない</li>
<li>熱伝達を扱わない</li>
<li>定常計算や、配管圧損だけが必要な系に適する</li>
</ul>
</html>"));
end StaticPipe;
