within EAST.Icons;

model StaticPipe
extends EAST.Icons.TwoPortFlowDevice;

annotation(
    Diagram(graphics),
    Icon(graphics = {Polygon(visible = showDesignFlowDirection, lineColor = {0, 128, 255}, fillColor = {0, 128, 255}, fillPattern = FillPattern.Solid, points = {{20, -70}, {60, -85}, {20, -100}, {20, -70}}), Polygon(visible = allowFlowReversal, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{20, -75}, {50, -85}, {20, -95}, {20, -75}}), Line(visible = showDesignFlowDirection, points = {{55, -85}, {-60, -85}}, color = {0, 128, 255}), Rectangle(fillColor = {0, 127, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, 44}, {100, -44}})}));
end StaticPipe;
