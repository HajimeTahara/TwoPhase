within EAST.TwoPhaseFlow.Component.Pipes;

model SimplePipeSegment
  "MSL FluidHeatFlow Pipe 風の軽量動的管セグメント"
  replaceable package Medium = EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium
    annotation (choicesAllMatching=true);

  parameter Modelica.Units.SI.Volume V
    "セグメント容積 [m3]";
  parameter Modelica.Units.SI.PressureDifference dp(min=0) = 0
    "セグメント内の圧力損失 [Pa]（port_a -> port_b 方向の静的近似）";
  parameter Modelica.Units.SI.AbsolutePressure p_start = 1.0e5
    "代表圧力の初期値 [Pa]";
  parameter Modelica.Units.SI.SpecificEnthalpy h_start =
    Medium.bubbleEnthalpy(Medium.setSat_p(p_start))
    "代表比エンタルピーの初期値 [J/kg]";
  parameter Modelica.Units.SI.Density d_nominal =
    Medium.density(Medium.setState_ph(p_start, h_start))
    "熱容量計算に用いる代表密度 [kg/m3]";

  final parameter Modelica.Units.SI.Mass M_nominal = d_nominal * V
    "代表流体質量 [kg]";

  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_a port_a(
    redeclare package Medium = Medium)
    "上流ポート（入口）"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_b port_b(
    redeclare package Medium = Medium)
    "下流ポート（出口）"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  EAST.TwoPhaseFlow.Component.Interfaces.HeatPort_a heatPort
    "外部熱源との接続用ポート（port.T = 代表流体温度）"
    annotation (Placement(
      transformation(extent={{-10,40},{10,60}}),
      iconTransformation(origin={0,20}, extent={{-10,40},{10,60}})));

  Modelica.Units.SI.AbsolutePressure p(start=p_start)
    "代表圧力 [Pa]（代数変数）";
  Modelica.Units.SI.SpecificEnthalpy h(start=h_start, fixed=true)
    "代表比エンタルピー [J/kg]（状態変数）";
  Modelica.Units.SI.MassFlowRate m_flow
    "port_a から port_b へ流れる質量流量 [kg/s]";
  Modelica.Units.SI.SpecificEnthalpy h_a_in
    "port_a 側から流入する比エンタルピー [J/kg]";
  Modelica.Units.SI.SpecificEnthalpy h_b_in
    "port_b 側から流入する比エンタルピー [J/kg]";

  Medium.BaseProperties props
    "代表状態の物性（温度・密度・相・乾き度確認用）";

equation
  props.p = p;
  props.h = h;

  m_flow = port_a.m_flow;

  p = 0.5 * (port_a.p + port_b.p);
  port_b.p = port_a.p - dp;
  port_a.m_flow + port_b.m_flow = 0;

  h_a_in = inStream(port_a.h_outflow);
  h_b_in = inStream(port_b.h_outflow);

  if noEvent(m_flow >= 0) then
    port_a.h_outflow = h;
    h = 0.5 * (h_a_in + port_b.h_outflow);
    M_nominal * der(h) = m_flow * (h_a_in - port_b.h_outflow) + heatPort.Q_flow;
  else
    port_b.h_outflow = h;
    h = 0.5 * (h_b_in + port_a.h_outflow);
    M_nominal * der(h) = -m_flow * (h_b_in - port_a.h_outflow) + heatPort.Q_flow;
  end if;

  heatPort.T = props.T;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
      Rectangle(
        extent={{-100,30},{100,-30}},
        lineColor={0,0,255},
        fillColor={0,170,255},
        fillPattern=FillPattern.HorizontalCylinder),
      Text(
        extent={{-100,60},{100,42}},
        lineColor={0,0,0},
        textString="%name")}),
    Documentation(info="<html>
<p>
<code>PipeSegment</code> より軽量な管セグメントモデル。
圧力と質量蓄積の動的バランスは解かず、代表質量
<code>M_nominal = d_nominal &middot; V</code> を用いた比エンタルピー遅れのみを状態として扱う。
MSL の <code>Modelica.Thermal.FluidHeatFlow.Components.Pipe</code> と同様に、
熱流は入口・出口の比エンタルピー差へ反映される。
</p>

<h4>方程式</h4>
<ul>
<li>質量流量: <code>port_a.m_flow + port_b.m_flow = 0</code></li>
<li>圧力: <code>port_a.p = p</code>, <code>port_b.p = p - dp</code></li>
<li>正流時のエネルギー収支:
<code>M_nominal der(h) = m_flow(h_a_in - h_b_out) + Q_flow</code></li>
<li>代表比エンタルピー:
<code>h = (h_a_in + h_b_out)/2</code>（正流時）</li>
<li>相状態・温度・密度は <code>Medium.BaseProperties(p,h)</code> で診断的に計算する。</li>
</ul>

<h4>意図</h4>
<p>
厳密な <code>der(M)</code> / <code>der(U)</code> を含めないため、
媒体関数 <code>setState_ph</code> や密度関数の時間微分をツールに要求しにくい。
相変化は <code>h</code> と <code>p</code> から <code>Medium</code> により判定する。
</p>
</html>"));
end SimplePipeSegment;
