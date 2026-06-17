within EAST.TwoPhaseFlow.Component.Sources;
model MassFlowSource_h
  "固定質量流量・固定比エンタルピー ソース"

  replaceable package Medium = EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium
    annotation (choicesAllMatching=true);

  parameter Boolean use_m_flow_in = false
    "true の場合、質量流量を入力コネクタ m_flow_in から与える"
    annotation(Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter Boolean use_h_in = false
    "true の場合、比エンタルピーを入力コネクタ h_in から与える"
    annotation(Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter Modelica.Units.SI.MassFlowRate    m_flow_set = 1.0
    "固定質量流量 [kg/s]（正: port へ流出）"
    annotation (Dialog(enable = not use_m_flow_in));
  parameter Modelica.Units.SI.SpecificEnthalpy h_set    = 4.0e5
    "流出流体の比エンタルピー [J/kg]"
    annotation (Dialog(enable = not use_h_in));

  Modelica.Blocks.Interfaces.RealInput m_flow_in(unit="kg/s") if use_m_flow_in
    "質量流量入力 [kg/s]（正: port へ流出）"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput h_in(unit="J/kg") if use_h_in
    "流出流体の比エンタルピー入力 [J/kg]"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));

  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_b port(redeclare package Medium = Medium)
    "出口ポート（下流コンポーネントへ接続）"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

protected
  Modelica.Blocks.Interfaces.RealInput m_flow_in_internal(unit="kg/s")
    "条件付きコネクタ接続用の内部質量流量入力";
  Modelica.Blocks.Interfaces.RealInput h_in_internal(unit="J/kg")
    "条件付きコネクタ接続用の内部比エンタルピー入力";

equation
  connect(m_flow_in, m_flow_in_internal);
  connect(h_in, h_in_internal);

  if not use_m_flow_in then
    m_flow_in_internal = m_flow_set;
  end if;

  if not use_h_in then
    h_in_internal = h_set;
  end if;

  port.m_flow     = -m_flow_in_internal;  // 流入正規約: 源泉から流出なので負
  port.h_outflow = h_in_internal;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
      Ellipse(
        extent={{-60,60},{60,-60}},
        lineColor={0,127,255},
        fillColor={0,127,255},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{-20,30},{-20,-30},{40,0},{-20,30}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-100,80},{100,62}},
        lineColor={0,0,0},
        textString="%name")}),
    Documentation(info="<html>
<p>
質量流量 <code>m_flow_set</code> と比エンタルピー <code>h_set</code> を固定するソース境界。
圧力は接続先システムによって決定される。
</p>
<p>
<code>use_m_flow_in</code> または <code>use_h_in</code> を <code>true</code> にすると、
対応する値を外部入力コネクタから与えることができる。
</p>
<p>
MSL の <code>Modelica.Fluid.Sources.MassFlowSource_h</code> に相当する。
<code>port</code>（<code>FluidPort_b</code>型）を下流コンポーネントの
<code>FluidPort_a</code> に接続して使用する。
</p>
<h4>方程式</h4>
<ul>
<li><code>port.m_flow = -m_flow_in_internal</code>（流入正規約のため負符号）</li>
<li><code>port.h_outflow = h_in_internal</code></li>
</ul>
</html>"));
end MassFlowSource_h;
