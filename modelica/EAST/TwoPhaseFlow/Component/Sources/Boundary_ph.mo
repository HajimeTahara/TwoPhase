within EAST.TwoPhaseFlow.Component.Sources;
model Boundary_ph
  "固定圧力・固定比エンタルピー 境界（無限大リザーバー）"

  replaceable package Medium = EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium
    annotation (choicesAllMatching=true);

  parameter Boolean use_p_in = false
    "true の場合、圧力を入力コネクタ p_in から与える"
    annotation(Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter Boolean use_h_in = false
    "true の場合、比エンタルピーを入力コネクタ h_in から与える"
    annotation(Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter Modelica.Units.SI.AbsolutePressure  p_set = 1.0e5
    "固定圧力 [Pa]"
    annotation (Dialog(enable = not use_p_in));
  parameter Modelica.Units.SI.SpecificEnthalpy  h_set = 4.0e5
    "流出流体の比エンタルピー [J/kg]"
    annotation (Dialog(enable = not use_h_in));

  Modelica.Blocks.Interfaces.RealInput p_in(unit="Pa") if use_p_in
    "境界圧力入力 [Pa]"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput h_in(unit="J/kg") if use_h_in
    "流出流体の比エンタルピー入力 [J/kg]"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));

  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_b port(redeclare package Medium = Medium)
    "出口ポート（下流コンポーネントへ接続）"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

protected
  Modelica.Blocks.Interfaces.RealInput p_in_internal(unit="Pa")
    "条件付きコネクタ接続用の内部圧力入力";
  Modelica.Blocks.Interfaces.RealInput h_in_internal(unit="J/kg")
    "条件付きコネクタ接続用の内部比エンタルピー入力";

equation
  connect(p_in, p_in_internal);
  connect(h_in, h_in_internal);

  if not use_p_in then
    p_in_internal = p_set;
  end if;

  if not use_h_in then
    h_in_internal = h_set;
  end if;

  port.p         = p_in_internal;
  port.h_outflow = h_in_internal;

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
<code>use_p_in</code> または <code>use_h_in</code> を <code>true</code> にすると、
対応する値を外部入力コネクタから与えることができる。
</p>
<p>
MSL の <code>Modelica.Fluid.Sources.Boundary_ph</code> に相当する。
<code>port</code>（<code>FluidPort_b</code>型）を下流コンポーネントの
<code>FluidPort_a</code> に接続して使用する。
</p>
<h4>方程式</h4>
<ul>
<li><code>port.p = p_in_internal</code></li>
<li><code>port.h_outflow = h_in_internal</code></li>
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
