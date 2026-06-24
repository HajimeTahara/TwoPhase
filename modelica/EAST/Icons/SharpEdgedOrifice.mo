within EAST.Icons;
partial model SharpEdgedOrifice
  "MSL Modelica.Fluid.Fittings.SharpEdgedOrifice の鋭角オリフィスアイコン"
  extends EAST.Icons.TwoPortFlowDevice;
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,44},{100,-44}},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Polygon(
          points={{-25,44},{-25,7},{35,37},{35,44},{-25,44}},
          fillPattern=FillPattern.Backward,
          fillColor={175,175,175}),
        Polygon(
          points={{-25,-7},{-25,-44},{35,-44},{35,-36},{-25,-7}},
          fillColor={175,175,175},
          fillPattern=FillPattern.Backward)}), Documentation(info="<html>
<p>
MSL <code>Modelica.Fluid.Fittings.SharpEdgedOrifice</code>
（配管内の鋭角オリフィスによる絞り）のアイコンを流用するための <code>partial model</code> です。
</p>
<p>
出典: Modelica.Fluid.Fittings.SharpEdgedOrifice (Modelica Standard Library),
Copyright &copy; 2002-2025, Modelica Association and contributors.
</p>
</html>"));
end SharpEdgedOrifice;
