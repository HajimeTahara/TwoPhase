within EAST.Icons;
partial model ThermalResistor
  "MSL Modelica.Thermal.HeatTransfer.Components.ThermalResistor のアイコン"
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-90,70},{90,-70}},
          pattern=LinePattern.None,
          fillColor={192,192,192},
          fillPattern=FillPattern.Forward),
        Line(points={{-90,70},{-90,-70}}, thickness=0.5),
        Line(points={{90,70},{90,-70}}, thickness=0.5),
        Text(
          extent={{-150,120},{150,78}},
          textColor={0,0,255},
          textString="%name")}), Documentation(info="<html>
<p>
MSL <code>Modelica.Thermal.HeatTransfer.Components.ThermalResistor</code>
（熱を蓄積せず伝導するだけの要素。熱抵抗で定義）のアイコンを流用するための
<code>partial model</code> です。熱抵抗を表示する <code>R=%R</code> ラベルは、
本クラスがパラメータ <code>R</code> を持たないため省略しています。
</p>
<p>
出典: Modelica.Thermal.HeatTransfer.Components.ThermalResistor (Modelica Standard Library),
Copyright &copy; 1998-2025, Modelica Association and contributors.
</p>
</html>"));
end ThermalResistor;
