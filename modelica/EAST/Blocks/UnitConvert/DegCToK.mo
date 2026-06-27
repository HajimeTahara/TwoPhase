within EAST.Blocks.UnitConvert;
block DegCToK "degCをKへ変換"
  extends Modelica.Blocks.Interfaces.PartialConversionBlock(
    u(unit="degC"),
    y(unit="K"));

equation
  y = Modelica.Units.Conversions.from_degC(u);

  annotation(
    defaultComponentName="degCToK",
    Icon(graphics={
      Text(
        extent={{-92,80},{40,44}},
        textString="degC"),
      Text(
        extent={{-40,-42},{92,-78}},
        textString="K")}),
    Documentation(info="<html>
<p>
入力信号を温度 degC から絶対温度 K へ変換します。
</p>
<pre>
y = Modelica.Units.Conversions.from_degC(u)
</pre>
</html>"));
end DegCToK;
