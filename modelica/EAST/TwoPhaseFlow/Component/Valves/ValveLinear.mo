within EAST.TwoPhaseFlow.Component.Valves;
model ValveLinear
  "Cv により流量特性を指定する線形開度バルブ"
extends EAST.Icons.GeneralValve;
  replaceable package Medium = EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium
    annotation (choicesAllMatching=true);

  parameter Real Cv(min=0) = 1.0
    "Cv 流量係数";
  parameter Boolean use_opening_in = false
    "true の場合、開度を入力コネクタ opening_in から与える"
    annotation(Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter Real opening_set(min=0, max=1) = 1.0
    "固定開度"
    annotation (Dialog(enable = not use_opening_in));
  final parameter Modelica.Units.SI.Area Av = Cv*24.0e-6
    "Cv から換算した SI 流量係数";

  Modelica.Blocks.Interfaces.RealInput opening_in(unit="1") if use_opening_in
    "開度入力 [-]"
    annotation (Placement(transformation(extent = {{-20, 100}, {20, 140}}), iconTransformation(origin = {-120, 120},extent = {{-20, 100}, {20, 140}}, rotation = -90)));

  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_a port_a(
    redeclare package Medium = Medium)
    "入口側ポート"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_b port_b(
    redeclare package Medium = Medium)
    "出口側ポート"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  Modelica.Units.SI.MassFlowRate m_flow
    "port_a から port_b へ流れる質量流量 [kg/s]";
  Modelica.Units.SI.PressureDifference dp
    "圧力差 port_a.p - port_b.p [Pa]";
  Modelica.Units.SI.Density rho_upstream
    "流れ方向上流側の密度";
  Real opening(min=0, max=1)
    "実際にバルブ式へ用いる開度 [-]";

protected
  Modelica.Blocks.Interfaces.RealInput opening_internal(unit="1")
    "条件付きコネクタ接続用の内部開度入力";
  Medium.BaseProperties properties_a
    "入口側ポートの流体状態";
  Medium.BaseProperties properties_b
    "出口側ポートの流体状態";

equation
  connect(opening_in, opening_internal);

  if not use_opening_in then
    opening_internal = opening_set;
  end if;

  opening = max(0.0, min(1.0, opening_internal));

  port_a.m_flow + port_b.m_flow = 0;
  m_flow = port_a.m_flow;
  dp = port_a.p - port_b.p;

  properties_a.p = port_a.p;
  properties_a.h = inStream(port_a.h_outflow);
  properties_b.p = port_b.p;
  properties_b.h = inStream(port_b.h_outflow);
  rho_upstream = noEvent(if dp >= 0 then properties_a.d else properties_b.d);

  m_flow = noEvent(
    if dp >= 0 then opening*Av*sqrt(rho_upstream*dp)
    else -opening*Av*sqrt(rho_upstream*(-dp)));

  port_b.h_outflow = inStream(port_a.h_outflow);
  port_a.h_outflow = inStream(port_b.h_outflow);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio = false)),
    Documentation(info="<html>
<p>
Cv 流量係数で容量を指定するバルブモデル。
開度に対する流量係数の変化を線形として扱う。
</p>
<p>
<code>use_opening_in = true</code> の場合、開度を外部入力
<code>opening_in</code> から与える。入力値は <code>0..1</code> に制限して使用する。
<code>false</code> の場合は固定値 <code>opening_set</code> を用いる。
</p>
<pre>
Av = Cv * 24.0e-6
m_flow = opening * Av * sqrt(rho_upstream * abs(dp)) * flowDirection
</pre>
<p>
<code>Cv</code> は米国式 Cv 流量係数として入力し、内部で SI 流量係数
<code>Av</code> へ換算する。密度には流れ方向上流側の媒体密度を使用するため、
正流と逆流の両方に対応する。
</p>
<h4>制限事項</h4>
<ul>
<li>チョーク、キャビテーション、逆止弁特性は未実装。</li>
<li>エンタルピーは断熱・等エンタルピーのパススルー近似。</li>
</ul>
</html>"));
end ValveLinear;
