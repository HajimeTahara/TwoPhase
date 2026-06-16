within EAST.TwoPhaseFlow.Component.Sources;
model Boundary_pT
  "固定圧力・固定温度 境界（無限大リザーバー）"

  replaceable package Medium = EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium
    annotation (choicesAllMatching=true);

  parameter Modelica.Units.SI.AbsolutePressure p_set = 1.0e5
    "固定圧力 [Pa]";
  parameter Modelica.Units.SI.Temperature      T_set = 300.0
    "流出流体の温度 [K]";

  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_b port(redeclare package Medium = Medium)
    "出口ポート（下流コンポーネントへ接続）"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

equation
  port.p         = p_set;
  port.h_outflow = Medium.specificEnthalpy_pT(p_set, T_set);

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
<code>Boundary_ph</code> の温度指定版。比エンタルピーは
<code>Medium.specificEnthalpy_pT(p_set, T_set)</code> で計算する。
</p>
<h4>方程式</h4>
<ul>
<li><code>port.p = p_set</code></li>
<li><code>port.h_outflow = Medium.specificEnthalpy_pT(p_set, T_set)</code></li>
</ul>
<h4>精度に関する注意</h4>
<p>
<code>specificEnthalpy_pT</code> は飽和点（<code>Tsat(p_set)</code>）からの
定積比熱近似であり、<code>T_set</code> が飽和温度から離れるほど誤差が増える
（詳細は <code>PartialTwoPhaseMedium</code> のドキュメンテーション参照）。
<code>T_set</code> が <code>Tsat(p_set)</code> に近い場合は二相状態となるため、
この境界条件では厳密な乾き度を指定できない点に注意。
</p>
</html>"));
end Boundary_pT;
