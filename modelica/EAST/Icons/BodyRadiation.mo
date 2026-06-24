within EAST.Icons;
partial model BodyRadiation
  "MSL Modelica.Thermal.HeatTransfer.Components.BodyRadiation のアイコン"
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{50,80},{90,-80}},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-90,80},{-50,-80}},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Line(points={{-36,10},{36,10}}, color={191,0,0}),
        Line(points={{-36,10},{-26,16}}, color={191,0,0}),
        Line(points={{-36,10},{-26,4}}, color={191,0,0}),
        Line(points={{-36,-10},{36,-10}}, color={191,0,0}),
        Line(points={{26,-16},{36,-10}}, color={191,0,0}),
        Line(points={{26,-4},{36,-10}}, color={191,0,0}),
        Line(points={{-36,-30},{36,-30}}, color={191,0,0}),
        Line(points={{-36,-30},{-26,-24}}, color={191,0,0}),
        Line(points={{-36,-30},{-26,-36}}, color={191,0,0}),
        Line(points={{-36,30},{36,30}}, color={191,0,0}),
        Line(points={{26,24},{36,30}}, color={191,0,0}),
        Line(points={{26,36},{36,30}}, color={191,0,0}),
        Text(
          extent={{-150,125},{150,85}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-50,80},{-44,-80}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{45,80},{50,-80}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>
MSL <code>Modelica.Thermal.HeatTransfer.Components.BodyRadiation</code>
（2物体間の熱輻射要素）のアイコンを流用するための <code>partial model</code> です。
輻射コンダクタンスを表示する <code>Gr=%Gr</code> ラベルは、本クラスがパラメータ
<code>Gr</code> を持たないため省略しています。
</p>
<p>
出典: Modelica.Thermal.HeatTransfer.Components.BodyRadiation (Modelica Standard Library),
Copyright &copy; 1998-2025, Modelica Association and contributors.
</p>
</html>"));
end BodyRadiation;
