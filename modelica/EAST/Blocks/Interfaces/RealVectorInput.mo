within EAST.Blocks.Interfaces;

connector RealVectorInput = input Real "Real型入力コネクタの配列に使用するコネクタ" annotation(
  defaultComponentName = "u",
  Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.2), graphics = {Ellipse(extent = {{-100, 100}, {100, -100}}, lineColor = {0, 0, 127}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid)}),
  Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false, initialScale = 0.2), graphics = {Text(textColor = {0, 0, 127}, extent = {{-10, 85}, {-10, 60}}, textString = "%name"), Ellipse(lineColor = {0, 0, 127}, fillColor = {0, 0, 127}, fillPattern = FillPattern.Solid, extent = {{-50, 50}, {50, -50}})}),
  Documentation(info = "<html>
<p>
Real 型入力コネクタの配列に使用するコネクタです。
例えば、配列長 <code>n</code> の入力は
<code>RealVectorInput u[n]</code> と宣言します。
</p>
<p>
<code>Modelica.Blocks.Interfaces.RealVectorInput</code> と同じ接続形式を持ち、
<code>RealInput</code> の配列と直接接続できます。
</p>
</html>"));
