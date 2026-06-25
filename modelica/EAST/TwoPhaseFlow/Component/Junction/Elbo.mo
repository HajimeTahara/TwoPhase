within EAST.TwoPhaseFlow.Component.Junction;
model Elbo "エルボ部の簡易局所圧力損失モデル"
extends Modelica.Fluid.Dissipation.Utilities.Icons.PressureLoss.Bend_i;
  extends EAST.Icons.TwoPortFlowDevice;

  replaceable package Medium =
    EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium
    annotation (choicesAllMatching=true);

  parameter Modelica.Units.SI.Diameter diameter(
    min=Modelica.Constants.small) = 0.01
    "管内径";
  parameter Real lossCoefficient(min=0) = 0.9
    "エルボ局所損失係数";
  final parameter Modelica.Units.SI.Area crossArea =
    Modelica.Constants.pi*diameter^2/4
    "流路断面積";

  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_a port_a(
    redeclare package Medium = Medium)
    "入口側ポート"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_b port_b(
    redeclare package Medium = Medium)
    "出口側ポート"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  Modelica.Units.SI.MassFlowRate m_flow
    "port_a から port_b 方向を正とする質量流量";
  Modelica.Units.SI.Density upstreamDensity
    "流れ方向上流側の密度";
  Modelica.Units.SI.Velocity velocity
    "断面平均流速";
  Modelica.Units.SI.PressureDifference dp
    "port_a から port_b 方向を正とする圧力損失";

protected
  Medium.BaseProperties properties_a "入口側流体状態";
  Medium.BaseProperties properties_b "出口側流体状態";

equation
  port_a.m_flow + port_b.m_flow = 0;
  m_flow = port_a.m_flow;

  properties_a.p = port_a.p;
  properties_a.h = inStream(port_a.h_outflow);
  properties_b.p = port_b.p;
  properties_b.h = inStream(port_b.h_outflow);

  upstreamDensity = noEvent(if m_flow >= 0 then properties_a.d else properties_b.d);
  velocity = m_flow/(upstreamDensity*crossArea);
  dp = lossCoefficient*upstreamDensity/2*velocity*abs(velocity);
  port_a.p - port_b.p = dp;

  port_b.h_outflow = inStream(port_a.h_outflow);
  port_a.h_outflow = inStream(port_b.h_outflow);

  annotation (
    defaultComponentName="elbo",
    Icon(
      coordinateSystem(preserveAspectRatio = true)),
    Documentation(info="<html>
<p>
指定した局所損失係数 K によりエルボ部の圧力損失を計算する、
断熱・静的な二ポートモデル。
</p>
<pre>
dp = K * rho_upstream/2 * velocity * abs(velocity)
</pre>
<table border='1' cellspacing='0' cellpadding='4'>
<tr><th>パラメータ</th><th>物理量</th><th>単位</th></tr>
<tr><td>diameter</td><td>管内径</td><td>m</td></tr>
<tr><td>lossCoefficient</td><td>局所損失係数 K</td><td>1</td></tr>
</table>
<p>
既定値 K = 0.9 は一般的なエルボを想定した代表値であり、
曲率半径、曲がり角度、表面粗さによる自動補正は行わない。
</p>
</html>"));
end Elbo;
