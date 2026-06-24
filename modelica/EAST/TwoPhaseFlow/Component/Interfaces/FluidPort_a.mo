within EAST.TwoPhaseFlow.Component.Interfaces;

connector FluidPort_a "流体入口ポート（上流側）"
extends EAST.Icons.FluidPort_a;
  extends EAST.TwoPhaseFlow.Component.Interfaces.FluidPort;
  annotation(
    defaultComponentName = "port_a",
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics = {Ellipse(lineColor = {0, 0, 127}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, lineThickness = 2, extent = {{-100, 100}, {100, -100}})}),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics = {Ellipse(extent = {{-40, 40}, {40, -40}}, lineColor = {0, 127, 255}, fillColor = {0, 127, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-150, 110}, {150, 50}}, lineColor = {0, 127, 255}, textString = "%name")}),
    Documentation(info = "<html>
<p>
入口（上流側）の流体ポート。<code>FluidPort</code> を継承し、
塗りつぶし円のアイコンで入口を表す（MSL の <code>FluidPort_a</code> に倣う）。
</p>
</html>"));
end FluidPort_a;
