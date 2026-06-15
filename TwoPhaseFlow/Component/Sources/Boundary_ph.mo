within TwoPhaseFlow.Component.Sources;
model Boundary_ph
  "固定圧力・固定比エンタルピー 境界（無限大リザーバー）"

  replaceable package Medium = TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium
    annotation (choicesAllMatching=true);

  parameter Modelica.Units.SI.AbsolutePressure  p_set = 1.0e5
    "固定圧力 [Pa]";
  parameter Modelica.Units.SI.SpecificEnthalpy  h_set = 4.0e5
    "流出流体の比エンタルピー [J/kg]";

  TwoPhaseFlow.Component.Interfaces.FluidPort_b port(redeclare package Medium = Medium)
    "出口ポート（下流コンポーネントへ接続）";

equation
  port.p         = p_set;
  port.h_outflow = h_set;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
      Rectangle(
        extent={{-80,60},{80,-60}},
        lineColor={0,127,255},
        fillColor={170,213,255},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-70,30},{70,-30}},
        lineColor={0,0,255},
        textString="p,h"),
      Text(
        extent={{-100,80},{100,62}},
        lineColor={0,0,0},
        textString="%name")}),
    Documentation(info="<html>
<p>
圧力 <code>p_set</code> と比エンタルピー <code>h_set</code> を固定する境界条件モデル。
質量流量は接続先システムによって決定される（ソースにもシンクにもなる）。
</p>
<p>
MSL の <code>Modelica.Fluid.Sources.Boundary_ph</code> に相当する。
<code>port</code>（<code>FluidPort_b</code>型）を下流コンポーネントの
<code>FluidPort_a</code> に接続して使用する。
</p>
<h4>方程式</h4>
<ul>
<li><code>port.p = p_set</code></li>
<li><code>port.h_outflow = h_set</code></li>
</ul>
<h4>典型的な使い方</h4>
<p>
上流側は <code>Boundary_ph</code>（圧力固定）、下流側は
<code>MassFlowSource_h</code>（流量固定）と組み合わせることで
管路の境界条件が一意に定まる。あるいは 2 つの <code>Boundary_ph</code> で
差圧駆動の系を構成できる。
</p>
</html>"));
end Boundary_ph;
