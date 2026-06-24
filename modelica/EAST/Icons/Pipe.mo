within EAST.Icons;
partial model Pipe
  "MSL Modelica.Fluid.Pipes (PartialStraightPipe / DynamicPipe) のパイプアイコン"
  extends EAST.Icons.TwoPortFlowDevice;
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,40},{100,-40}},
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95},
          pattern=LinePattern.None),
        Rectangle(
          extent={{-100,44},{100,-44}},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Ellipse(
          extent={{-72,10},{-52,-10}},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{50,10},{70,-10}},
          fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>
MSL <code>Modelica.Fluid.Pipes.BaseClasses.PartialStraightPipe</code> および
<code>Pipes.DynamicPipe</code> のパイプアイコンを流用するための <code>partial model</code> です。
</p>
<p>
出典: Modelica.Fluid.Pipes (Modelica Standard Library),
Copyright &copy; 2002-2025, Modelica Association and contributors.
</p>
</html>"));
end Pipe;
