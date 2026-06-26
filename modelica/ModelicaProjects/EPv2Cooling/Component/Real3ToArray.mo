within ModelicaProjects.EPv2Cooling.Component;

block Real3ToArray "3つのReal入力をReal配列にまとめる"
  Modelica.Blocks.Interfaces.RealInput u1 "入力1" annotation(
    Placement(transformation(extent = {{-140, 60}, {-100, 100}})));
  Modelica.Blocks.Interfaces.RealInput u2 "入力2" annotation(
    Placement(transformation(extent = {{-140, -20}, {-100, 20}})));
  Modelica.Blocks.Interfaces.RealInput u3 "入力3" annotation(
    Placement(transformation(extent = {{-140, -100}, {-100, -60}})));
  Modelica.Blocks.Interfaces.RealOutput y[3] "出力配列" annotation(
    Placement(transformation(extent = {{100, -10}, {120, 10}})));
equation
  y = {u1, u2, u3};
  annotation(
    defaultComponentName = "real3ToArray",
    Icon(graphics = {Rectangle(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(extent = {{-82, 42}, {82, -42}}, textString = "{u1,u2,u3}"), Text(textColor = {0, 0, 255}, extent = {{-150, 150}, {150, 110}}, textString = "%name"), Text(origin = {-160, 79}, extent = {{-22, 21}, {22, -21}}, textString = "u1"), Text(origin = {-160, 1}, extent = {{-22, 21}, {22, -21}}, textString = "u2"), Text(origin = {-160, -79}, extent = {{-22, 21}, {22, -21}}, textString = "u3")}),
    Documentation(info = "<html>
<p>
3つのReal入力 <code>u1</code>、<code>u2</code>、<code>u3</code> を
Real配列出力 <code>y[3]</code> にまとめます。
</p>
<pre>
y = {u1, u2, u3}
</pre>
</html>"),
    Diagram(graphics));
end Real3ToArray;
