within EAST.Icons;
partial model FixedTemperature
  "MSL Modelica.Thermal.HeatTransfer.Icons.FixedTemperature の固定温度源アイコン"
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          pattern=LinePattern.None,
          fillColor={159,159,223},
          fillPattern=FillPattern.Backward),
        Line(
          points={{-42,0},{66,0}},
          color={191,0,0},
          thickness=0.5),
        Polygon(
          points={{52,-20},{52,20},{90,0},{52,-20}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textColor={0,0,255},
          textString="%name")}), Documentation(info="<html>
<p>
MSL <code>Modelica.Thermal.HeatTransfer.Icons.FixedTemperature</code>
（固定温度境界条件ソース）のアイコンを流用するための <code>partial model</code> です。
MSL 側ではこのアイコンを <code>Celsius</code>/<code>Fahrenheit</code>/<code>Rankine</code>
単位系の派生モデルが <code>extends</code> していますが、本クラスは名前ラベルも
含めて単体で完結させています。
</p>
<p>
出典: Modelica.Thermal.HeatTransfer.Icons.FixedTemperature (Modelica Standard Library),
Copyright &copy; 1998-2025, Modelica Association and contributors.
</p>
</html>"));
end FixedTemperature;
