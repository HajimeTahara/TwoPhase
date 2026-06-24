within EAST.Icons;
partial model HeatFlowSensor
  "MSL Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor のアイコン"
  extends Modelica.Icons.RoundSensor;
  annotation (Icon(graphics={
        Line(points={{-70,0},{-90,0}}, color={191,0,0}),
        Line(points={{70,0},{90,0}}, color={191,0,0}),
        Line(points={{0,-70},{0,-100}}, color={0,0,127}),
        Text(
          extent={{-150,120},{150,80}},
          textColor={0,0,255},
          textString="%name")}), Documentation(info="<html>
<p>
MSL <code>Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor</code>
（熱流量センサ）のアイコンを流用するための <code>partial model</code> です。
丸型センサ本体は MSL の汎用アイコン <code>Modelica.Icons.RoundSensor</code> を
そのまま <code>extends</code> しています。単位を示す <code>W</code> ラベルは
省略しています。
</p>
<p>
出典: Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor (Modelica Standard Library),
Copyright &copy; 1998-2025, Modelica Association and contributors.
</p>
</html>"));
end HeatFlowSensor;
