within EAST.Icons;

model CylinderThermal
equation

annotation(
    Diagram(graphics),
    Icon(graphics = {Ellipse(lineColor = {191, 0, 0}, fillColor = {170, 0, 0}, fillPattern = FillPattern.Solid, extent = {{-60, 60}, {60, -60}}), Ellipse(lineColor = {191, 0, 0}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Cross, extent = {{-38, 38}, {38, -38}}), Ellipse(lineColor = {191, 0, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-18, 18}, {18, -18}}), Line(points = {{-100, 0}, {-22, 0}}, color = {170, 0, 0}, thickness = 1.5, arrowSize = 7), Line(points = {{62, 0}, {100, 0}}, color = {191, 0, 0}, thickness = 1.5), Rectangle(origin = {58, 0}, lineColor = {170, 0, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-4, 4}, {4, -4}}), Rectangle(origin = {-18, 0}, lineColor = {170, 0, 0}, fillColor = {170, 0, 0}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-4, 4}, {4, -4}})}));
end CylinderThermal;
