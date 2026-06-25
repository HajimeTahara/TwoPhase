within EAST.TwoPhaseFlow.Component.Pipes;

model DynamicPipeSegment "動的管セグメント（単一 well-mixed 制御容積; DynamicPipe の内部要素）"
  extends EAST.Icons.DynamicPipeSegment;
  replaceable package Medium = EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium annotation(
    choicesAllMatching = true);
  parameter PipeGeometry geometry = PipeGeometry.Circular "配管断面形状" annotation(
    Dialog(tab = "Geometry", group = "Geometry"));
  parameter Modelica.Units.SI.Length length(min = Modelica.Constants.small) = 1
    "セグメント長さ" annotation(
    Dialog(tab = "Geometry", group = "Geometry"));
  parameter Modelica.Units.SI.Length rectangularLongSide(min = Modelica.Constants.small) = 0.02
    "矩形管断面の長辺" annotation(
    Dialog(tab = "Geometry", group = "Rectangular duct", enable = geometry == PipeGeometry.Rectangular));
  parameter Modelica.Units.SI.Length rectangularShortSide(min = Modelica.Constants.small) = 0.01
    "矩形管断面の短辺" annotation(
    Dialog(tab = "Geometry", group = "Rectangular duct", enable = geometry == PipeGeometry.Rectangular));
  parameter Modelica.Units.SI.Diameter diameter(min = Modelica.Constants.small) = 0.01
    "円管内径" annotation(
    Dialog(tab = "Geometry", group = "Circular pipe", enable = geometry == PipeGeometry.Circular));
  parameter Modelica.Units.SI.Diameter annularOuterDiameter(min = Modelica.Constants.small) = 0.02
    "環状流路の外側内径" annotation(
    Dialog(tab = "Geometry", group = "Annular duct", enable = geometry == PipeGeometry.Annular));
  parameter Modelica.Units.SI.Diameter annularInnerDiameter(min = Modelica.Constants.small) = 0.01
    "環状流路の内側外径" annotation(
    Dialog(tab = "Geometry", group = "Annular duct", enable = geometry == PipeGeometry.Annular));
  final parameter Modelica.Units.SI.Area crossArea =
    if geometry == PipeGeometry.Rectangular then rectangularLongSide*rectangularShortSide
    elseif geometry == PipeGeometry.Circular then Modelica.Constants.pi/4*diameter^2
    else Modelica.Constants.pi/4*(annularOuterDiameter^2 - annularInnerDiameter^2)
    "流路断面積";
  final parameter Modelica.Units.SI.Length wettedPerimeter =
    if geometry == PipeGeometry.Rectangular then 2*(rectangularLongSide + rectangularShortSide)
    elseif geometry == PipeGeometry.Circular then Modelica.Constants.pi*diameter
    else Modelica.Constants.pi*(annularOuterDiameter + annularInnerDiameter)
    "濡れ縁長さ";
  final parameter Modelica.Units.SI.Diameter equivalentDiameter = 4*crossArea/wettedPerimeter
    "等価直径（水力直径）";
  final parameter Modelica.Units.SI.Volume V = crossArea*length
    "セグメント容積";
  final parameter Modelica.Units.SI.ReynoldsNumber ReynoldsTransition = 2300
    "層流から乱流へ切り替える Reynolds 数";
  parameter FrictionCorrelation frictionCorrelation = FrictionCorrelation.Blasius
    "乱流域の Darcy 摩擦係数相関式" annotation(
    Dialog(tab = "Flow resistance", group = "Turbulent correlation"));
  parameter Modelica.Units.SI.Length roughness(min = 0) = 2.5e-5
    "管内面の絶対粗さ ε" annotation(
    Dialog(
      tab = "Flow resistance",
      group = "Turbulent correlation",
      enable = frictionCorrelation == FrictionCorrelation.Colebrook));
  parameter Modelica.Units.SI.AbsolutePressure p_start = 1.0e5 "CV 内圧力の初期値";
  parameter Modelica.Units.SI.SpecificEnthalpy h_start = Medium.bubbleEnthalpy(Medium.setSat_p(p_start)) "CV 内比エンタルピーの初期値（既定: p_start における飽和液）";
  parameter Boolean use_HeatTransfer = true "= true の場合、外部 HeatPort を使用する" annotation(
    Dialog(tab = "Assumptions", group = "Heat transfer"));
  parameter Real nusseltTurbulentPrandtlExponent(min = 0) = 0.4
    "乱流 Nusselt 数式の Prandtl 数指数" annotation(
    Dialog(tab = "Heat transfer", group = "Heat transfer", enable = use_HeatTransfer));
  parameter Modelica.Units.SI.Area heatTransferArea(min = 0) = wettedPerimeter*length
    "流体への伝熱面積" annotation(
    Dialog(tab = "Heat transfer", group = "Heat transfer", enable = use_HeatTransfer));
  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) "上流ポート（入口）" annotation(
    Placement(transformation(extent = {{-110, -10}, {-90, 10}})));
  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) "下流ポート（出口）" annotation(
    Placement(transformation(extent = {{90, -10}, {110, 10}})));
  EAST.TwoPhaseFlow.Component.Interfaces.HeatPort_a heatPort if use_HeatTransfer
    "外部熱源側の境界温度と熱流を受け取るポート" annotation(
    Placement(transformation(extent = {{-10, 40}, {10, 60}}), iconTransformation(origin = {0, -6}, extent = {{-10, 40}, {10, 60}})));
  // 状態変数（CV: このセグメントの容積 V に蓄えられた流体の代表状態）
  Modelica.Units.SI.AbsolutePressure p(start = p_start) "CV 内圧力 [Pa]（状態変数; port_a.p と一致）";
  Modelica.Units.SI.SpecificEnthalpy h(start = h_start) "CV 内比エンタルピー [J/kg]（状態変数; port_b.h_outflow と一致）";
  // 蓄積量
  Modelica.Units.SI.Mass M "CV内の流体質量 [kg]";
  Modelica.Units.SI.Energy U "CV内の流体内部エネルギー [J]";
  Modelica.Units.SI.VolumeFlowRate volumeFlowRate
    "port_a から port_b 方向を正とする体積流量";
  Modelica.Units.SI.Velocity velocity
    "port_a から port_b 方向を正とする断面平均流速";
  Modelica.Units.SI.KinematicViscosity nu
    "代表密度に基づく動粘性係数 ν = μ/ρ [m²/s]";
  Modelica.Units.SI.ReynoldsNumber Re "等価直径に基づく Reynolds 数";
  Real frictionFactor(unit = "1")
    "Darcy 摩擦係数（層流: 64/Re、乱流: 選択した相関式）";
  Boolean turbulent "乱流判定";
  Modelica.Units.SI.PressureDifference dp
    "摩擦圧力損失 [Pa]（流れ方向に符号を持つ）";
  Modelica.Units.SI.HeatFlowRate Q_flow
    "HeatPort から流体へ流入する熱流量 [W]";
  Modelica.Units.SI.PrandtlNumber Pr "Prandtl 数";
  Modelica.Units.SI.NusseltNumber Nu "Nusselt 数";
  Modelica.Units.SI.CoefficientOfHeatTransfer alpha
    "流体への熱伝達率";
  Modelica.Units.SI.ThermalConductance thermalConductance
    "流体側の対流熱コンダクタンス";
  Modelica.Units.SI.ThermalResistance thermalResistance
    "流体側の対流熱抵抗";
  // CV の代表流体状態（温度・密度・相・飽和物性を参照可能）
  Medium.BaseProperties props "CV内の代表流体状態";
equation
  assert(geometry <> PipeGeometry.Rectangular or rectangularLongSide >= rectangularShortSide,
    "矩形管では rectangularLongSide を rectangularShortSide 以上にしてください。");
  assert(geometry <> PipeGeometry.Annular or annularOuterDiameter > annularInnerDiameter,
    "中空円環では annularOuterDiameter を annularInnerDiameter より大きくしてください。");
// --- CV の代表流体状態 ---
  props.p = p;
  props.h = h;
// --- 質量・エネルギーの蓄積（容積 V を考慮した動的バランス）---
  M = props.d*V;
  U = M*props.u;
  port_a.m_flow + port_b.m_flow = 0;
  der(U) = port_a.m_flow*actualStream(port_a.h_outflow) + port_b.m_flow*actualStream(port_b.h_outflow) + Q_flow;
// --- 流速・Reynolds 数・管摩擦圧力損失 ---
  volumeFlowRate = port_a.m_flow/props.d;
  velocity = volumeFlowRate/crossArea;
  nu = props.mu/props.d;
  Re = abs(velocity)*equivalentDiameter/nu;
  turbulent = Re >= ReynoldsTransition;
  frictionFactor = noEvent(
    if Re <= Modelica.Constants.small then 0
    elseif turbulent then
      if frictionCorrelation == FrictionCorrelation.Blasius then 0.3164/Re^0.25
      else colebrookFrictionFactor(Re, roughness/equivalentDiameter)
    else 64/Re);
  dp = frictionFactor*length/equivalentDiameter*props.d/2*velocity*abs(velocity);
// --- 圧力 ---
  port_a.p = p;
  port_a.p - port_b.p = dp;
// --- Stream 変数の束縛（CV は単一の well-mixed ノード）---
  port_a.h_outflow = h;
  port_b.h_outflow = h;
// --- HeatPort と流体間の熱伝達 ---
  Pr = props.cp*props.mu/props.lambda;
  Nu = pipeNusseltNumber(
    Re,
    Pr,
    ReynoldsTransition,
    nusseltTurbulentPrandtlExponent);
  alpha = Nu*props.lambda/equivalentDiameter;
  thermalConductance =
    if use_HeatTransfer then alpha*heatTransferArea else 0;
  thermalResistance =
    if thermalConductance > Modelica.Constants.small then
      1/thermalConductance
    else Modelica.Constants.inf;
  if use_HeatTransfer then
    Q_flow = thermalConductance*(heatPort.T - props.T);
    heatPort.Q_flow = Q_flow;
  else
    Q_flow = 0;
  end if;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = false)),
    Documentation(info = "<html>
<p>
<code>DynamicPipe</code> の内部要素として使う、単一 well-mixed 制御容積（CV）モデル。
<code>DynamicPipe</code> は本モデルを <code>nNodes</code> 個直列接続し、管内流体の移流
（軸方向の質量・エンタルピー輸送）を近似する。単体としても利用可能。
</p>

<h4>ジオメトリ</h4>
<p>
<code>geometry</code> で矩形管、円管、中空円環（同心二重円管の環状流路）を選択する。
選択した形状に対応する寸法と <code>length</code> から、流路断面積
<code>crossArea</code>、濡れ縁長さ <code>wettedPerimeter</code>、等価直径
<code>equivalentDiameter = 4 &middot; crossArea / wettedPerimeter</code>、および
セグメント容積 <code>V = crossArea &middot; length</code> を自動計算する。
</p>
<ul>
<li>矩形管: <code>rectangularLongSide</code>, <code>rectangularShortSide</code></li>
<li>円管: <code>diameter</code></li>
<li>中空円環: <code>annularOuterDiameter</code>, <code>annularInnerDiameter</code></li>
</ul>

<h4>管摩擦圧力損失</h4>
<p>
断面平均流速と等価直径から Reynolds 数を計算し、
<code>ReynoldsTransition</code>（既定値 2300）を境に層流と乱流を判定する。
粘性係数は媒体状態 <code>props.mu</code> から取得する。動粘性係数
<code>nu</code>（ν, m&sup2;/s）は <code>props.mu / density</code> として内部計算する。
</p>
<ul>
<li>体積流量: <code>volumeFlowRate = m_flow / density</code></li>
<li>流速: <code>velocity = volumeFlowRate / crossArea</code></li>
<li>動粘性係数: <code>nu = props.mu / density</code></li>
<li>Reynolds 数: <code>Re = |velocity| &middot; equivalentDiameter / nu</code></li>
<li>層流 Darcy 摩擦係数: <code>frictionFactor = 64 / Re</code></li>
<li>乱流 Blasius 式: <code>frictionFactor = 0.3164 / Re^0.25</code></li>
<li>乱流 Colebrook-White 式:
    <code>1 / sqrt(frictionFactor) =
    -2 log10(roughness / (3.7 equivalentDiameter)
    + 2.51 / (Re sqrt(frictionFactor)))</code></li>
<li>Darcy-Weisbach 式:
    <code>dp = frictionFactor &middot; length / equivalentDiameter
    &middot; density / 2 &middot; velocity &middot; |velocity|</code></li>
</ul>
<p>
<code>dp</code> は流れ方向に応じて符号が変わるため、逆流にも対応する。
<code>frictionCorrelation</code> で Blasius または Colebrook-White を選択する。
Colebrook-White 選択時は絶対粗さ <code>roughness</code> を使用する。
</p>

<h4>方程式</h4>
<ul>
<li>CV 代表状態: <code>props.p = p</code>, <code>props.h = h</code>（状態変数 <code>p</code>, <code>h</code>）</li>
<li>質量蓄積: <code>M = props.d &middot; V</code>, <code>der(M) = port_a.m_flow + port_b.m_flow</code></li>
<li>エネルギー蓄積: <code>U = M &middot; props.u</code>,
    <code>der(U) = port_a.m_flow &middot; actualStream(port_a.h_outflow)
    + port_b.m_flow &middot; actualStream(port_b.h_outflow) + Q_flow</code></li>
<li>圧力: <code>port_a.p = p</code>, <code>port_a.p - port_b.p = dp</code></li>
<li>Stream 変数（well-mixed 近似）: <code>port_a.h_outflow = h</code>, <code>port_b.h_outflow = h</code></li>
<li>熱伝達:
    <code>thermalConductance = alpha &middot; heatTransferArea</code>,
    <code>thermalResistance = 1 / thermalConductance</code>,
    <code>Q_flow = thermalConductance
    &middot; (heatPort.T - props.T)</code></li>
</ul>

<h4>HeatPort オプション</h4>
<p>
<code>use_HeatTransfer = true</code>（既定値）の場合は <code>heatPort</code> を公開し、
HeatPort 温度と流体代表温度の差から次式で熱流量を計算する。
</p>
<blockquote><pre>
Pr = props.cp * props.mu / props.lambda
Nu = pipeNusseltNumber(Re, Pr, ReynoldsTransition)
alpha = Nu * props.lambda / equivalentDiameter
thermalConductance = alpha * heatTransferArea
thermalResistance = 1 / thermalConductance
Q_flow = thermalConductance * (heatPort.T - props.T)
</pre></blockquote>
<p>
代表定圧比熱と代表熱伝導率は媒体パッケージの
<code>cp_liquid_const</code> と <code>lambda_const</code> を使用する。
層流域では十分発達した円管内強制対流として <code>Nu = 3.66</code>、
乱流域では Dittus-Boelter 式
<code>Nu = 0.023 * Re^0.8 * Pr^n</code> を使用する。
指数 <code>n</code> は <code>nusseltTurbulentPrandtlExponent</code>
（既定値 0.4）で設定できる。
<code>heatTransferArea</code> の既定値は
<code>wettedPerimeter * length</code> である。<code>Q_flow &gt; 0</code> は
HeatPort から流体への加熱を表す。<code>use_HeatTransfer = false</code> の場合は
<code>heatPort</code> を除去し、外部熱流と熱コンダクタンスを 0 として扱う。
このとき熱抵抗は無限大となる。
</p>
<p>
<code>thermalResistance</code> は流体側境膜の対流熱抵抗であり、
管壁の熱伝導抵抗や外側流体の対流熱抵抗は含まない。
</p>

<h4>制限事項</h4>
<ul>
<li>1 CV 単体では well-mixed（井戸混合）近似であり、管内の移流（プラグフロー）は表現できない。
    移流を表現するには <code>DynamicPipe</code> 経由で複数セグメントを直列接続すること。</li>
<li>このバランスは <code>Medium</code> の密度・内部エネルギー関数を介して
    <code>der(M)</code>, <code>der(U)</code> を時間微分する陰関数 DAE であり、
    ツールが当該関数を自動微分（ダミー微分・指標低減）できることを前提とする。</li>
</ul>
</html>"),
    Diagram(graphics));
end DynamicPipeSegment;
