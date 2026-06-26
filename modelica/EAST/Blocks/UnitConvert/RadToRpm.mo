within EAST.Blocks.UnitConvert;
block RadToRpm "rad/sをrpmへ変換"
  extends Modelica.Blocks.Interfaces.PartialConversionBlock(
    u(unit="rad/s"),
    y(unit="rev/min"));

equation
  y = Modelica.Units.Conversions.to_rpm(u);

  annotation(
    defaultComponentName="radToRpm",
    Icon(graphics={
      Text(
        extent={{-92,80},{40,44}},
        textString="rad/s"),
      Text(
        extent={{-40,-42},{92,-78}},
        textString="rpm")}),
    Documentation(info="<html>
<p>
入力信号を角速度 rad/s から回転数 rpm（rev/min）へ変換します。
</p>
<pre>
y = Modelica.Units.Conversions.to_rpm(u)
</pre>
</html>"));
end RadToRpm;
