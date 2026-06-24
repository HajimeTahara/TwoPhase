within EAST.Icons;
partial model TemperatureSensor
  "MSL Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor のアイコン"
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Ellipse(
          extent={{-20,-98},{20,-60}},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-12,40},{12,-68}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{12,0},{100,0}}, color={0,0,127}),
        Line(points={{-90,0},{-12,0}}, color={191,0,0}),
        Polygon(
          points={{-12,40},{-12,80},{-10,86},{-6,88},{0,90},{6,88},{10,86},{12,80},{12,40},{-12,40}},
          lineThickness=0.5),
        Line(points={{-12,40},{-12,-64}}, thickness=0.5),
        Line(points={{12,40},{12,-64}}, thickness=0.5),
        Line(points={{-40,-20},{-12,-20}}),
        Line(points={{-40,20},{-12,20}}),
        Line(points={{-40,60},{-12,60}}),
        Text(
          extent={{-150,140},{150,100}},
          textColor={0,0,255},
          textString="%name")}), Documentation(info="<html>
<p>
MSL <code>Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor</code>
（絶対温度センサ）のアイコンを流用するための <code>partial model</code> です。
単位を示す <code>K</code> ラベルは省略しています。
</p>
<p>
出典: Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor (Modelica Standard Library),
Copyright &copy; 1998-2025, Modelica Association and contributors.
</p>
</html>"));
end TemperatureSensor;
