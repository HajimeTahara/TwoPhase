within EAST.TwoPhaseFlow.Component.HeatSources;

model UniformHeatDistributor
  "単一 HeatPort から複数 HeatPort へ熱流を均等分配する理想分配器"
  parameter Integer nPorts(min=1) = 1 "分配先 HeatPort 数";

  EAST.TwoPhaseFlow.Component.Interfaces.HeatPort_a sourcePort
    "代表 HeatPort（接続先へ分配する熱流を受ける）"
    annotation (Placement(
      transformation(extent={{-10,90},{10,110}}),
      iconTransformation(extent={{-10,90},{10,110}})));
  EAST.TwoPhaseFlow.Component.Interfaces.HeatPort_b distributedPorts[nPorts]
    "分配先 HeatPort"
    annotation (Placement(
      transformation(extent={{-10,-110},{10,-90}}),
      iconTransformation(extent={{-10,-110},{10,-90}})));

equation
  for i in 1:nPorts loop
    distributedPorts[i].Q_flow = sourcePort.Q_flow / nPorts;
  end for;

  sourcePort.T = sum(distributedPorts[i].T for i in 1:nPorts) / nPorts;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
      Rectangle(
        extent={{-60,60},{60,-60}},
        lineColor={191,0,0},
        fillColor={255,255,170},
        fillPattern=FillPattern.Solid),
      Line(points={{0,100},{0,60}}, color={191,0,0}),
      Line(points={{0,-60},{0,-100}}, color={191,0,0}),
      Line(points={{-30,-20},{0,-50},{30,-20}}, color={191,0,0}),
      Text(
        extent={{-100,88},{100,66}},
        lineColor={0,0,0},
        textString="%name")}),
    Documentation(info="<html>
<p>
単一の代表 HeatPort に入る熱流を、複数の分配先 HeatPort へ均等に割り当てる理想分配器。
分配先の温度を代表温度として平均し、<code>sourcePort.T</code> に与える。
</p>
<p>
このモデルは、未接続 HeatPort の <code>flow</code> 変数へツールが自動で
<code>0</code> 方程式を生成する問題を避けるため、各分配先を必ず
<code>connect()</code> で接続して使用する。
</p>
</html>"));
end UniformHeatDistributor;
