within EAST.Icons;
partial model Pump
  "MSL Modelica.Fluid.Machines.BaseClasses.PartialPump のポンプアイコン"
  extends EAST.Icons.TwoPortFlowDevice;
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,46},{100,-46}},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Polygon(
          points={{-48,-60},{-72,-100},{72,-100},{48,-60},{-48,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillPattern=FillPattern.VerticalCylinder),
        Ellipse(
          extent={{-80,80},{80,-80}},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Polygon(
          points={{-28,30},{-28,-30},{50,-2},{-28,30}},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255})}), Documentation(info="<html>
<p>
MSL <code>Modelica.Fluid.Machines.BaseClasses.PartialPump</code>（遠心ポンプ）の
アイコンを流用するための <code>partial model</code> です。
</p>
<p>
出典: Modelica.Fluid.Machines (Modelica Standard Library),
Copyright &copy; 2002-2025, Modelica Association and contributors.
</p>
</html>"));
end Pump;
