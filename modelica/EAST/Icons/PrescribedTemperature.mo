within EAST.Icons;
partial model PrescribedTemperature
  "MSL Modelica.Thermal.HeatTransfer.Icons.PrescribedTemperature の指定温度源アイコン"
  extends EAST.Icons.FixedTemperature;
  annotation (Icon(graphics={Line(points={{-100,0},{-42,0}}, color={191,0,0})}),
      Documentation(info="<html>
<p>
MSL <code>Modelica.Thermal.HeatTransfer.Icons.PrescribedTemperature</code>
（信号入力で温度を指定する境界条件ソース）のアイコンを流用するための
<code>partial model</code> です。<code>FixedTemperature</code> に
信号入力線を追加したものです。
</p>
<p>
出典: Modelica.Thermal.HeatTransfer.Icons.PrescribedTemperature (Modelica Standard Library),
Copyright &copy; 1998-2025, Modelica Association and contributors.
</p>
</html>"));
end PrescribedTemperature;
