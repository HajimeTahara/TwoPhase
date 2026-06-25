within EAST.Icons;
partial model DynamicPipeSegment
  "MSL Modelica.Fluid.Pipes (PartialStraightPipe / DynamicPipe) のパイプアイコン"
  extends Icons.TwoPortFlowDevice;
  annotation(
    Icon(graphics = {Rectangle(fillColor = {95, 95, 95}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-100, 40}, {100, -40}}), Rectangle(fillColor = {0, 127, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, 44}, {100, -44}}), Ellipse(origin = {62, 0},fillPattern = FillPattern.Solid, extent = {{-72, 10}, {-52, -10}})}),
    Documentation(info = "<html>
<p>
MSL <code>Modelica.Fluid.Pipes.BaseClasses.PartialStraightPipe</code> および
<code>Pipes.DynamicPipe</code> のパイプアイコンを流用するための <code>partial model</code> です。
</p>
<p>
出典: Modelica.Fluid.Pipes (Modelica Standard Library),
Copyright &copy; 2002-2025, Modelica Association and contributors.
</p>
</html>"),
    Diagram(graphics));
end DynamicPipeSegment;
