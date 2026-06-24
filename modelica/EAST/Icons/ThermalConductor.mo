within EAST.Icons;
partial model ThermalConductor
  "MSL Modelica.Thermal.HeatTransfer.Components.ThermalConductor のアイコン"
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-90,70},{90,-70}},
          pattern=LinePattern.None,
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Line(points={{-90,70},{-90,-70}}, thickness=0.5),
        Line(points={{90,70},{90,-70}}, thickness=0.5),
        Text(
          extent={{-150,120},{150,80}},
          textColor={0,0,255},
          textString="%name")}), Documentation(info="<html>
<p>
MSL <code>Modelica.Thermal.HeatTransfer.Components.ThermalConductor</code>
（熱を蓄積せず伝導するだけの要素）のアイコンを流用するための
<code>partial model</code> です。熱伝導率を表示する <code>G=%G</code> ラベルは、
本クラスがパラメータ <code>G</code> を持たないため省略しています。
</p>
<p>
出典: Modelica.Thermal.HeatTransfer.Components.ThermalConductor (Modelica Standard Library),
Copyright &copy; 1998-2025, Modelica Association and contributors.
</p>
</html>"));
end ThermalConductor;
