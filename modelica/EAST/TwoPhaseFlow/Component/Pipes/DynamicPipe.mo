within EAST.TwoPhaseFlow.Component.Pipes;

model DynamicPipe "動的管モデル（N 分割 CV チェーンで流体の移流を近似; セグメントごとの HeatPort を公開）"
  extends EAST.Icons.DynamicPipe;
  replaceable package Medium = EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium annotation(
    choicesAllMatching = true);
  // ジオメトリ（断面形状は全セグメント共通、長さ方向だけ nNodes 分割）
  parameter PipeGeometry geometry = PipeGeometry.Circular "配管断面形状" annotation(
    Dialog(tab = "Geometry", group = "Geometry"));
  parameter Modelica.Units.SI.Length length(min = Modelica.Constants.small) = 1 "管全長" annotation(
    Dialog(tab = "Geometry", group = "Geometry"));
  parameter Modelica.Units.SI.Length rectangularLongSide(min = Modelica.Constants.small) = 0.02 "矩形管断面の長辺" annotation(
    Dialog(tab = "Geometry", group = "Rectangular duct", enable = geometry == PipeGeometry.Rectangular));
  parameter Modelica.Units.SI.Length rectangularShortSide(min = Modelica.Constants.small) = 0.01 "矩形管断面の短辺" annotation(
    Dialog(tab = "Geometry", group = "Rectangular duct", enable = geometry == PipeGeometry.Rectangular));
  parameter Modelica.Units.SI.Diameter diameter(min = Modelica.Constants.small) = 0.01 "円管内径" annotation(
    Dialog(tab = "Geometry", group = "Circular pipe", enable = geometry == PipeGeometry.Circular));
  parameter Modelica.Units.SI.Diameter annularOuterDiameter(min = Modelica.Constants.small) = 0.02 "環状流路の外側内径" annotation(
    Dialog(tab = "Geometry", group = "Annular duct", enable = geometry == PipeGeometry.Annular));
  parameter Modelica.Units.SI.Diameter annularInnerDiameter(min = Modelica.Constants.small) = 0.01 "環状流路の内側外径" annotation(
    Dialog(tab = "Geometry", group = "Annular duct", enable = geometry == PipeGeometry.Annular));
  final parameter Modelica.Units.SI.Area crossArea = if geometry == PipeGeometry.Rectangular then rectangularLongSide*rectangularShortSide elseif geometry == PipeGeometry.Circular then Modelica.Constants.pi/4*diameter^2 else Modelica.Constants.pi/4*(annularOuterDiameter^2 - annularInnerDiameter^2) "流路断面積";
  final parameter Modelica.Units.SI.Length wettedPerimeter = if geometry == PipeGeometry.Rectangular then 2*(rectangularLongSide + rectangularShortSide) elseif geometry == PipeGeometry.Circular then Modelica.Constants.pi*diameter else Modelica.Constants.pi*(annularOuterDiameter + annularInnerDiameter) "濡れ縁長さ";
  final parameter Modelica.Units.SI.Diameter equivalentDiameter = 4*crossArea/wettedPerimeter "等価直径（水力直径）";
  final parameter Modelica.Units.SI.Volume V = crossArea*length "管内総容積";
  // 軸方向分割（移流の近似精度; 1 にすると従来の単一 CV モデルと等価）
  parameter Integer nNodes(min = 1) = 3 "軸方向の分割数（直列接続する制御容積の数）";
  parameter FrictionCorrelation frictionCorrelation = FrictionCorrelation.Blasius "乱流域の Darcy 摩擦係数相関式" annotation(
    Dialog(tab = "Flow resistance", group = "Turbulent correlation"));
  parameter Modelica.Units.SI.Length roughness(min = 0) = 2.5e-5 "管内面の絶対粗さ ε" annotation(
    Dialog(tab = "Flow resistance", group = "Turbulent correlation", enable = frictionCorrelation == FrictionCorrelation.Colebrook));
  // 初期条件（既定値: p_start における飽和液; 全セグメント共通）
  parameter Modelica.Units.SI.AbsolutePressure p_start = 1.0e5 "各セグメント CV 内圧力の初期値";
  parameter Modelica.Units.SI.SpecificEnthalpy h_start = Medium.bubbleEnthalpy(Medium.setSat_p(p_start)) "各セグメント CV 内比エンタルピーの初期値（既定: p_start における飽和液）";
  parameter Boolean use_HeatTransfer = true "= true の場合、各セグメントの外部 HeatPort を使用する" annotation(
    Dialog(tab = "Assumptions", group = "Heat transfer"));
  parameter Real nusseltTurbulentPrandtlExponent(min = 0) = 0.4 "乱流 Nusselt 数式の Prandtl 数指数" annotation(
    Dialog(tab = "Heat transfer", group = "Heat transfer", enable = use_HeatTransfer));
  parameter Modelica.Units.SI.Area heatTransferArea(min = 0) = wettedPerimeter*length "管全体の伝熱面積" annotation(
    Dialog(tab = "Heat transfer", group = "Heat transfer", enable = use_HeatTransfer));
  // ポート
  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium) "上流ポート（入口）" annotation(
    Placement(transformation(extent = {{-110, -10}, {-90, 10}})));
  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium) "下流ポート（出口）" annotation(
    Placement(transformation(extent = {{90, -10}, {110, 10}})));
  EAST.TwoPhaseFlow.Component.Interfaces.HeatPorts_a heatPorts[nNodes] if use_HeatTransfer "各セグメントへの外部熱ポート" annotation(
    Placement(transformation(extent = {{-10, 40}, {10, 60}}), iconTransformation(origin = {-1, 0}, extent = {{-37, 36}, {37, 54}})));
  DynamicPipeSegment segment[nNodes](redeclare each package Medium = Medium, each geometry = geometry, each length = length/nNodes, each rectangularLongSide = rectangularLongSide, each rectangularShortSide = rectangularShortSide, each diameter = diameter, each annularOuterDiameter = annularOuterDiameter, each annularInnerDiameter = annularInnerDiameter, each frictionCorrelation = frictionCorrelation, each roughness = roughness, each p_start = p_start, each h_start = h_start, each use_HeatTransfer = use_HeatTransfer, each nusseltTurbulentPrandtlExponent = nusseltTurbulentPrandtlExponent, each heatTransferArea = heatTransferArea/nNodes) "直列接続された制御容積（管内流体の移流を近似）" annotation(
    Placement(visible = false, transformation(origin = {1, 0}, extent = {{-17, -16}, {17, 16}})));
  Modelica.Units.SI.PressureDifference dp = port_a.p - port_b.p "管全体の計算圧力損失 [Pa]（流れ方向に符号を持つ）";
equation
  assert(geometry <> PipeGeometry.Rectangular or rectangularLongSide >= rectangularShortSide, "矩形管では rectangularLongSide を rectangularShortSide 以上にしてください。");
  assert(geometry <> PipeGeometry.Annular or annularOuterDiameter > annularInnerDiameter, "中空円環では annularOuterDiameter を annularInnerDiameter より大きくしてください。");
// --- セグメントの直列接続（管内流体の移流を表現）---
  connect(port_a, segment[1].port_a);
  for i in 1:nNodes - 1 loop
    connect(segment[i].port_b, segment[i + 1].port_a);
  end for;
  connect(segment[nNodes].port_b, port_b);
// --- HeatPort（セグメントごとに外部へ公開）---
  if use_HeatTransfer then
    for i in 1:nNodes loop
      connect(heatPorts[i], segment[i].heatPort);
    end for;
  end if;
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = false)),
    Documentation(info = "<html>
<p>
動的単相・二相管モデル。選択した断面形状から求める流路断面積
<code>crossArea</code> と管全長 <code>length</code> により、
管内総容積 <code>V = crossArea &middot; length</code> を計算する。これを
<code>nNodes</code> 個の <code>DynamicPipeSegment</code>（各容積 <code>V/nNodes</code> の
軽量 well-mixed セグメント）に分割し、直列接続することで管内流体の移流（軸方向の質量・
エンタルピー輸送）を近似する。<code>nNodes = 1</code> の場合は単一 CV モデルと等価。
</p>

<h4>構成</h4>
<pre>
port_a → segment[1] → segment[2] → ... → segment[nNodes] → port_b
</pre>
<p>
各セグメントの方程式（質量・エネルギー蓄積、圧力、stream 変数、熱伝達）は
<code>DynamicPipeSegment</code> を参照。セグメント間は <code>FluidPort</code> の
<code>connect()</code> によって接続され、<code>port_b.h_outflow</code>（上流セグメントの
出口エンタルピー）が下流セグメントの入口エンタルピーとして自然に伝播する。これにより、
初期に管内にあった流体が入口側から流入する流体によって時間をかけて押し出される
（移流）挙動が再現される。
</p>

<h4>圧力損失・初期条件</h4>
<ul>
<li>各セグメントが流速、Reynolds 数、層流/乱流判定、Darcy 摩擦係数から圧力損失を計算する。</li>
<li>乱流域では <code>frictionCorrelation</code> により Blasius または
    Colebrook-White 式を選択する。Colebrook-White 選択時は
    <code>roughness</code> を使用する。</li>
<li><code>dp = port_a.p - port_b.p</code> は全セグメントの圧力損失の合計として参照できる。</li>
<li><code>p_start</code>, <code>h_start</code> は全セグメント共通の初期条件。
    <code>h_start</code> の既定値は <code>p_start</code> における飽和液エンタルピー。</li>
</ul>

<h4>HeatPort</h4>
<p>
<code>use_HeatTransfer = true</code>（既定値）の場合、外側に公開する
<code>heatPorts[nNodes]</code> は、各 <code>DynamicPipeSegment</code> の
<code>heatPort</code> と 1 対 1 で接続される。これにより DiagramView 上で
セグメントごとに異なる熱境界条件を直接接続できる。
各セグメントは Reynolds 数と Prandtl 数から Nusselt 数、熱伝達率を計算し、
HeatPort 温度と流体温度の差、および分割された伝熱面積
<code>heatTransferArea/nNodes</code> から熱流量を計算する。
管全体へ単一 HeatPort から一様入熱を与えたい場合は、ラッパーモデル
<code>PipeUniformHeatTransfer</code> を使用する。
<code>use_HeatTransfer = false</code> の場合は外部 HeatPort と各セグメントの
HeatPort を除去し、全セグメントの外部熱流を 0 W として扱う。
</p>

<h4>ジオメトリ</h4>
<p>
<code>geometry</code> で矩形管、円管、中空円環を選択する。断面形状と断面寸法は
すべてのセグメントで共通とし、管全長 <code>length</code> だけを
<code>length/nNodes</code> に分割する。断面積、濡れ縁長さ、等価直径、
管内総容積は <code>DynamicPipeSegment</code> と同じ式で計算する。
</p>

<h4>参照可能な内部変数</h4>
<ul>
<li><code>segment[i].props.T</code>, <code>segment[i].props.d</code>,
    <code>segment[i].props.phase</code> — i 番目セグメントの温度・密度・相
    （管軸方向の分布を確認できる）</li>
</ul>

<h4>制限事項・将来拡張</h4>
<ul>
<li><code>nNodes</code> が小さいほど数値拡散（セグメント内の井戸混合による平滑化）が大きく、
    プラグフローからのずれが大きくなる。<code>nNodes</code> を増やすほど精度は上がるが
    計算コストも増える。</li>
<li>現在の摩擦係数は単相流向けの層流式、Blasius 式、Colebrook-White 式であり、気液二相流固有の
    Friedel / Lockhart-Martinelli 等の補正は未実装。</li>
<li>セグメントごとの個別入熱は <code>heatPorts[i]</code> へ接続して与える。</li>
<li>各セグメントは代表密度 <code>d_nominal</code> による
    <code>M_nominal der(h)</code> 型の軽量エンタルピー遅れであり、
    厳密な圧縮性・質量蓄積は表現しない。熱流は入口・出口の比エンタルピー差として
    反映される。</li>
</ul>
</html>"),
    Diagram(graphics));
end DynamicPipe;
