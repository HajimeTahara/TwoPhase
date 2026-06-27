within EAST.Blocks.UnitConvert;
block KToDegC "KをdegCへ変換"
  extends Modelica.Blocks.Interfaces.PartialConversionBlock(
    u(unit="K"),
    y(unit="degC"));

equation
  y = Modelica.Units.Conversions.to_degC(u);

  annotation(
    defaultComponentName="kToDegC",
    Icon(graphics={
      Text(
        extent={{-92,80},{40,44}},
        textString="K"),
      Text(
        extent={{-40,-42},{92,-78}},
        textString="degC")}),
    Documentation(info="<html>
<p>
入力信号を絶対温度 K から温度 degC へ変換します。
</p>
<pre>
y = Modelica.Units.Conversions.to_degC(u)
</pre>
</html>"));
end KToDegC;
