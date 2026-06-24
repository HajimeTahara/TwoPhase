within EAST.Thermal.HeatTransfer.Components;

model Convection "流速入力から熱伝達率を計算する対流熱伝達要素"
extends EAST.Icons.Convection;
  parameter Modelica.Units.SI.Area A = 1e-4 "伝熱面積";
  parameter Modelica.Units.SI.Length L = 0.1 "代表長さ";
  parameter Modelica.Units.SI.Density rho = 1.2 "流体密度";
  parameter Modelica.Units.SI.DynamicViscosity mu = 1.8e-5 "流体の粘性係数 μ";
  final parameter Modelica.Units.SI.KinematicViscosity nu = mu/rho
    "流体の動粘性係数 ν = μ/ρ";
  parameter Modelica.Units.SI.SpecificHeatCapacity cp = 1005 "流体の定圧比熱";
  parameter Modelica.Units.SI.ThermalConductivity lambda = 0.026 "流体の熱伝導率";
  parameter Real cNu = 0.453 "Nu 相関式の係数";
  parameter Real mRe = 0.5 "Nu 相関式の Re 指数";
  parameter Real nPr = 0.4 "Nu 相関式の Pr 指数";

  Modelica.Blocks.Interfaces.RealInput velocity(unit = "m/s")
    "流体の代表流速 [m/s]" annotation(
    Placement(transformation(origin = {0, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 270),
      iconTransformation(origin = {0, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 270)));

  EAST.Thermal.HeatTransfer.Interfaces.HeatPort_a solid "固体側熱ポート" annotation(
    Placement(transformation(extent = {{-110, -10}, {-90, 10}}), iconTransformation(extent = {{-110, -10}, {-90, 10}})));
  EAST.Thermal.HeatTransfer.Interfaces.HeatPort_b fluid "流体側熱ポート" annotation(
    Placement(transformation(extent = {{90, -10}, {110, 10}}), iconTransformation(extent = {{90, -10}, {110, 10}})));

  Modelica.Units.SI.HeatFlowRate Q_flow "固体側から流体側へ流れる熱流量 [W]";
  Modelica.Units.SI.TemperatureDifference dT "solid.T - fluid.T [K]";
  Real Re(unit = "1") "Reynolds 数";
  Real Pr(unit = "1") "Prandtl 数";
  Real Nu(unit = "1") "Nusselt 数";
  Modelica.Units.SI.CoefficientOfHeatTransfer alpha "熱伝達率 [W/(m2.K)]";
  Modelica.Units.SI.ThermalConductance Gc "対流熱コンダクタンス [W/K]";

equation
  assert(A > 0, "A must be greater than zero.");
  assert(L > 0, "L must be greater than zero.");
  assert(rho > 0, "rho must be greater than zero.");
  assert(mu > 0, "mu must be greater than zero.");
  assert(cp > 0, "cp must be greater than zero.");
  assert(lambda > 0, "lambda must be greater than zero.");

  dT = solid.T - fluid.T;
  Pr = cp*mu/lambda;
  Re = abs(velocity)*L/nu;
  Nu = cNu*Re^mRe*Pr^nPr;
  alpha = Nu*lambda/L;
  Gc = A*alpha;

  solid.Q_flow = Q_flow;
  fluid.Q_flow = -Q_flow;
  Q_flow = Gc*dT;

  annotation(
    Documentation(info = "<html>
<p>
MSL の <code>Modelica.Thermal.HeatTransfer.Components.Convection</code> と同じ
集中対流熱伝達モデルですが、入力を対流熱コンダクタンスではなく流速とします。
</p>
<p>
熱流量は <code>Q_flow = Gc * (solid.T - fluid.T)</code> で、熱コンダクタンスは
<code>Gc = A * alpha</code> です。熱伝達率 <code>alpha</code> は以下で計算します。
</p>
<blockquote><pre>
nu    = mu / rho
Re    = abs(velocity) * L / nu
Pr    = cp * mu / lambda
Nu    = cNu * Re^mRe * Pr^nPr
alpha = Nu * lambda / L
</pre></blockquote>
<p>
デフォルトの係数は MSL の Convection ドキュメントに記載されている平板層流の例
<code>Nu = 0.453 * Re^(1/2) * Pr^(1/3)</code> に合わせています。
</p>
</html>"),
    Diagram(graphics));
end Convection;
