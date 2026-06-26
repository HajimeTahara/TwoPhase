within EAST.Icons;

model CylinderThermalCooling
equation

annotation(
    Diagram(graphics),
    Icon(graphics = {Ellipse(lineColor = {255, 255, 255}, fillColor = {0, 85, 255}, fillPattern = FillPattern.Solid, lineThickness = 0.75, extent = {{-80, 80}, {80, -80}}),Ellipse(lineColor = {191, 0, 0}, fillColor = {170, 0, 0}, fillPattern = FillPattern.Solid, extent = {{-60, 60}, {60, -60}}), Ellipse(lineColor = {191, 0, 0}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Cross, extent = {{-38, 38}, {38, -38}}), Ellipse(lineColor = {191, 0, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-18, 18}, {18, -18}})}));
end CylinderThermalCooling;
