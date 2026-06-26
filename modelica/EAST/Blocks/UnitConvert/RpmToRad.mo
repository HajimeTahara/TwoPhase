within EAST.Blocks.UnitConvert;
block RpmToRad "rpmをrad/sへ変換"
  extends Modelica.Blocks.Interfaces.PartialConversionBlock(
    u(unit="rev/min"),
    y(unit="rad/s"));

equation
  y = Modelica.Units.Conversions.from_rpm(u);

  annotation(
    defaultComponentName="rpmToRad",
    Icon(graphics={
      Text(
        extent={{-92,80},{40,44}},
        textString="rpm"),
      Text(
        extent={{-40,-42},{92,-78}},
        textString="rad/s")}),
    Documentation(info="<html>
<p>
入力信号を回転数 rpm（rev/min）から角速度 rad/s へ変換します。
</p>
<pre>
y = Modelica.Units.Conversions.from_rpm(u)
</pre>
</html>"));
end RpmToRad;
