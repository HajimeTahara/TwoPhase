within EAST.TwoPhaseFlow.Component.Interfaces;

connector FluidPort_b "流体出口ポート（下流側）"
  extends EAST.TwoPhaseFlow.Component.Interfaces.FluidPort;
  annotation(
    defaultComponentName = "port_b",
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics = {Ellipse(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 2, extent = {{-100, 100}, {100, -100}})}),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics = {Ellipse(extent = {{-40, 40}, {40, -40}}, lineColor = {0, 127, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-150, 110}, {150, 50}}, lineColor = {0, 127, 255}, textString = "%name")}),
    Documentation(info = "<html>
<p>
出口（下流側）の流体ポート。<code>FluidPort</code> を継承し、
白抜き円のアイコンで出口を表す（MSL の <code>FluidPort_b</code> に倣う）。
</p>
</html>"));
end FluidPort_b;
