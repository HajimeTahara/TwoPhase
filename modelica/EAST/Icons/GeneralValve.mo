within EAST.Icons;

model GeneralValve
equation

annotation(
    Icon(graphics = {Polygon(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{-100, 50}, {100, -50}, {100, 50}, {0, 0}, {-100, -50}, {-100, 50}}), Polygon(lineColor = {0, 128, 255}, fillColor = {0, 128, 255}, fillPattern = FillPattern.Solid, points = {{20, -70}, {60, -85}, {20, -100}, {20, -70}}), Polygon( lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{20, -75}, {50, -85}, {20, -95}, {20, -75}}), Line(points = {{55, -85}, {-60, -85}}, color = {0, 128, 255}), Line(points = {{0, 52}, {0, 0}}), Rectangle(fillPattern = FillPattern.Solid, extent = {{-20, 60}, {20, 52}}), Text(origin = {-1, 14},textColor = {0, 0, 255}, extent = {{-140, -114}, {142, -154}}, textString = "%name")}),
    Diagram(graphics));
end GeneralValve;
