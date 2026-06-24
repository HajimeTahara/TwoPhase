within EAST.TwoPhaseFlow.Component.Junction;
model Expansion "急拡大部の簡易局所圧力損失モデル"
  extends EAST.Icons.Adaptor;

  replaceable package Medium =
    EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium
    annotation (choicesAllMatching=true);

  parameter Modelica.Units.SI.Diameter inletDiameter(
    min=Modelica.Constants.small) = 0.01
    "入口側内径";
  parameter Modelica.Units.SI.Diameter outletDiameter(
    min=Modelica.Constants.small) = 0.02
    "出口側内径";
  final parameter Modelica.Units.SI.Area inletArea =
    Modelica.Constants.pi*inletDiameter^2/4
    "入口側流路断面積";
  final parameter Modelica.Units.SI.Area outletArea =
    Modelica.Constants.pi*outletDiameter^2/4
    "出口側流路断面積";
  final parameter Real lossCoefficient(min=0) =
    (1 - inletArea/outletArea)^2
    "急拡大局所損失係数";

  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_a port_a(
    redeclare package Medium = Medium)
    "小径側ポート"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_b port_b(
    redeclare package Medium = Medium)
    "大径側ポート"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  Modelica.Units.SI.MassFlowRate m_flow
    "小径側から大径側を正とする質量流量";
  Modelica.Units.SI.Density upstreamDensity
    "流れ方向上流側の密度";
  Modelica.Units.SI.Area upstreamArea
    "流れ方向上流側の断面積";
  Modelica.Units.SI.Velocity upstreamVelocity
    "流れ方向上流側の断面平均流速";
  Modelica.Units.SI.PressureDifference dp
    "port_a から port_b 方向を正とする圧力損失";

protected
  Medium.BaseProperties properties_a "小径側流体状態";
  Medium.BaseProperties properties_b "大径側流体状態";

equation
  assert(outletDiameter > inletDiameter,
    "outletDiameter は inletDiameter より大きく設定してください。");

  port_a.m_flow + port_b.m_flow = 0;
  m_flow = port_a.m_flow;

  properties_a.p = port_a.p;
  properties_a.h = inStream(port_a.h_outflow);
  properties_b.p = port_b.p;
  properties_b.h = inStream(port_b.h_outflow);

  upstreamDensity = noEvent(if m_flow >= 0 then properties_a.d else properties_b.d);
  upstreamArea = noEvent(if m_flow >= 0 then inletArea else outletArea);
  upstreamVelocity = m_flow/(upstreamDensity*upstreamArea);
  dp = lossCoefficient*upstreamDensity/2*
    upstreamVelocity*abs(upstreamVelocity);
  port_a.p - port_b.p = dp;

  port_b.h_outflow = inStream(port_a.h_outflow);
  port_a.h_outflow = inStream(port_b.h_outflow);

  annotation (
    defaultComponentName="expansion",
    Icon(coordinateSystem(preserveAspectRatio=true)),
    Documentation(info="<html>
<p>
円管の急拡大部を表す断熱・静的な二ポートモデル。
入口断面積 A1 と出口断面積 A2 から Borda-Carnot 型の損失係数を計算する。
</p>
<pre>
K = (1 - A1/A2)^2
dp = K * rho_upstream/2 * velocity * abs(velocity)
</pre>
<table border='1' cellspacing='0' cellpadding='4'>
<tr><th>パラメータ</th><th>物理量</th><th>単位</th></tr>
<tr><td>inletDiameter</td><td>小径側内径</td><td>m</td></tr>
<tr><td>outletDiameter</td><td>大径側内径</td><td>m</td></tr>
</table>
<p>
逆流時も同じ損失係数を使用する簡易近似であり、急縮小固有の相関式は使用しない。
</p>
</html>"));
end Expansion;
