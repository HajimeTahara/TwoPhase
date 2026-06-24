within EAST.TwoPhaseFlow.Component.Junction;

model TeeJunction "圧力損失を持たない理想三方分岐・合流"
extends EAST.Icons.TeeJunction;
  replaceable package Medium =
    EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium
    annotation (choicesAllMatching=true);

  parameter Modelica.Units.SI.AbsolutePressure p_start = 1.0e5
    "共通圧力の初期推定値"
    annotation (Dialog(tab="Initialization"));

  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_a port_1(
    redeclare package Medium = Medium,
    p(start=p_start, nominal=1.0e5))
    "直管側ポート1"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_b port_2(
    redeclare package Medium = Medium,
    p(start=p_start, nominal=1.0e5))
    "直管側ポート2"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_a port_3(
    redeclare package Medium = Medium,
    p(start=p_start, nominal=1.0e5))
    "分岐側ポート"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

equation
  connect(port_1, port_2);
  connect(port_1, port_3);

  annotation (
    Documentation(info="<html>
<p>
無限小容積の理想 T 字継手。3ポートを理想接続し、接続集合の規則により
質量保存、エンタルピー混合、共通圧力を計算する。
</p>
<ul>
<li>質量保存: <code>port_1.m_flow + port_2.m_flow + port_3.m_flow = 0</code></li>
<li>圧力損失: なし</li>
<li>流れ方向: 各ポートで双方向</li>
</ul>
<p>
<code>p_start</code> は3ポート共通圧力の初期反復値として使用する。
圧力を固定する境界条件ではなく、実際の圧力は接続された系の方程式から決まる。
</p>
<p>
分岐・合流に伴う局所圧力損失や流量配分係数は考慮しない。
</p>
</html>"));
end TeeJunction;
