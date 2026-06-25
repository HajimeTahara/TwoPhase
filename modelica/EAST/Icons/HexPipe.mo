within EAST.Icons;

model HexPipe
equation

annotation(
    Diagram(graphics),
    Icon(graphics = {Polygon(lineColor = {0, 128, 255}, fillColor = {0, 128, 255}, fillPattern = FillPattern.Solid, points = {{20, -70}, {60, -85}, {20, -100}, {20, -70}}), Polygon(lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{20, -75}, {50, -85}, {20, -95}, {20, -75}}), Line(points = {{55, -85}, {-60, -85}}, color = {0, 128, 255}), Text(origin = {0, 14}, textColor = {0, 0, 255}, extent = {{-139, -114}, {141, -154}}, textString = "%name"), Rectangle(origin = {0, -22},fillColor = {0, 127, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, 22}, {100, -22}}), Rectangle(origin = {0, 30}, fillColor = {170, 0, 0}, fillPattern = FillPattern.Forward, extent = {{-60, 30}, {60, -30}}), Line(origin = {-42, -20}, points = {{0, 20}, {0, 6}}, color = {170, 0, 0}, thickness = 2, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {-20, -20}, points = {{0, 20}, {0, 6}}, color = {170, 0, 0}, thickness = 2, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {2, -20}, points = {{0, 20}, {0, 6}}, color = {170, 0, 0}, thickness = 2, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {22, -20}, points = {{0, 20}, {0, 6}}, color = {170, 0, 0}, thickness = 2, arrow = {Arrow.None, Arrow.Filled}), Line(origin = {44, -20}, points = {{0, 20}, {0, 6}}, color = {170, 0, 0}, thickness = 2, arrow = {Arrow.None, Arrow.Filled})}));
end HexPipe;
