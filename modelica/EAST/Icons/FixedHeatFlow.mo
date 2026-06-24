within EAST.Icons;
partial model FixedHeatFlow
  "MSL Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow の固定熱流源アイコン"
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-150,100},{150,60}},
          textColor={0,0,255},
          textString="%name"),
        Line(
          points={{-100,-20},{48,-20}},
          color={191,0,0},
          thickness=0.5),
        Line(
          points={{-100,20},{46,20}},
          color={191,0,0},
          thickness=0.5),
        Polygon(
          points={{40,0},{40,40},{70,20},{40,0}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,-40},{40,0},{70,-20},{40,-40}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{70,40},{90,-40}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>
MSL <code>Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow</code>
（固定熱流量境界条件ソース）のアイコンを流用するための <code>partial model</code> です。
</p>
<p>
出典: Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow (Modelica Standard Library),
Copyright &copy; 1998-2025, Modelica Association and contributors.
</p>
</html>"));
end FixedHeatFlow;
