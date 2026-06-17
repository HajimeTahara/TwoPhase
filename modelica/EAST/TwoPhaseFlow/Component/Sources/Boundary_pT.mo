within EAST.TwoPhaseFlow.Component.Sources;
model Boundary_pT
  "固定圧力・固定温度 境界（無限大リザーバー）"

  replaceable package Medium = EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium
    annotation (choicesAllMatching=true);

  parameter Boolean use_p_in = false
    "true の場合、圧力を入力コネクタ p_in から与える"
    annotation(Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter Boolean use_T_in = false
    "true の場合、温度を入力コネクタ T_in から与える"
    annotation(Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter Modelica.Units.SI.AbsolutePressure p_set = 1.0e5
    "固定圧力 [Pa]"
    annotation (Dialog(enable = not use_p_in));
  parameter Modelica.Units.SI.Temperature      T_set = 300.0
    "流出流体の温度 [K]"
    annotation (Dialog(enable = not use_T_in));

  Modelica.Blocks.Interfaces.RealInput p_in(unit="Pa") if use_p_in
    "境界圧力入力 [Pa]"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput T_in(unit="K") if use_T_in
    "流出流体の温度入力 [K]"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));

  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_b port(redeclare package Medium = Medium)
    "出口ポート（下流コンポーネントへ接続）"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

protected
  Modelica.Blocks.Interfaces.RealInput p_in_internal(unit="Pa")
    "条件付きコネクタ接続用の内部圧力入力";
  Modelica.Blocks.Interfaces.RealInput T_in_internal(unit="K")
    "条件付きコネクタ接続用の内部温度入力";

equation
  connect(p_in, p_in_internal);
  connect(T_in, T_in_internal);

  if not use_p_in then
    p_in_internal = p_set;
  end if;

  if not use_T_in then
    T_in_internal = T_set;
  end if;

  port.p         = p_in_internal;
  port.h_outflow = Medium.specificEnthalpy_pT(p_in_internal, T_in_internal);

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
        textString="p,T"),
      Text(
        extent={{-100,80},{100,62}},
        lineColor={0,0,0},
        textString="%name")}),
    Documentation(info="<html>
<p>
圧力 <code>p_set</code> と温度 <code>T_set</code> を固定する境界条件モデル。
質量流量は接続先システムによって決定される（ソースにもシンクにもなる）。
</p>
<p>
<code>use_p_in</code> または <code>use_T_in</code> を <code>true</code> にすると、
対応する値を外部入力コネクタから与えることができる。
</p>
<p>
<code>Boundary_ph</code> の温度指定版。比エンタルピーは
<code>Medium.specificEnthalpy_pT(p_in_internal, T_in_internal)</code> で計算する。
</p>
<h4>方程式</h4>
<ul>
<li><code>port.p = p_in_internal</code></li>
<li><code>port.h_outflow = Medium.specificEnthalpy_pT(p_in_internal, T_in_internal)</code></li>
</ul>
<h4>精度に関する注意</h4>
<p>
<code>specificEnthalpy_pT</code> は飽和点からの
定積比熱近似であり、指定温度が飽和温度から離れるほど誤差が増える
（詳細は <code>PartialTwoPhaseMedium</code> のドキュメンテーション参照）。
<code>T_in_internal</code> が <code>Tsat(p_in_internal)</code> に近い場合は二相状態となるため、
この境界条件では厳密な乾き度を指定できない点に注意。
</p>
</html>"));
end Boundary_pT;
