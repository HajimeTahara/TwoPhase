within EAST.Icons;
partial model Thermometer
  "MSL Modelica.Fluid.Sensors.TemperatureTwoPort の温度計アイコン"
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Line(points={{0,100},{0,50}}, color={0,0,127}),
        Line(points={{-92,0},{100,0}}, color={0,128,255}),
        Ellipse(
          extent={{-20,-68},{20,-30}},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-12,50},{12,-34}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-12,50},{-12,70},{-10,76},{-6,78},{0,80},{6,78},{10,76},{12,70},{12,50},{-12,50}},
          lineThickness=0.5),
        Line(points={{-12,50},{-12,-35}}, thickness=0.5),
        Line(points={{12,50},{12,-34}}, thickness=0.5),
        Line(points={{-40,-10},{-12,-10}}),
        Line(points={{-40,20},{-12,20}}),
        Line(points={{-40,50},{-12,50}}),
        Text(
          extent={{-150,140},{150,110}},
          textColor={0,0,255},
          textString="%name")}), Documentation(info="<html>
<p>
MSL <code>Modelica.Fluid.Sensors.TemperatureTwoPort</code>（二方ポート温度センサ）の
温度計アイコンを流用するための <code>partial model</code> です。
</p>
<p>
計測量を示す固定テキスト（<code>T</code>）は省略し、代わりに名前ラベル
<code>%name</code> を上部に追加しています
（元のアイコンでは名前ラベルは継承元 <code>Interfaces.PartialTwoPort</code>
から提供されますが、本クラスは二方ポートを持たないため独自に追加しました）。
</p>
<p>
出典: Modelica.Fluid.Sensors.TemperatureTwoPort (Modelica Standard Library),
Copyright &copy; 2002-2025, Modelica Association and contributors.
</p>
</html>"));
end Thermometer;
