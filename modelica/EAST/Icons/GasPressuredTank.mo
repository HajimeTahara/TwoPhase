within EAST.Icons;

partial model GasPressuredTank "MSL Modelica.Fluid.Vessels.OpenTank の開放タンクアイコン"
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}, initialScale = 0.2), graphics = {Rectangle(origin = {0, 55}, fillColor = {170, 170, 0}, pattern = LinePattern.None, fillPattern = FillPattern.VerticalCylinder, extent = {{-100, 45}, {100, -45}}), Rectangle(fillColor = {85, 170, 255}, fillPattern = FillPattern.VerticalCylinder, extent = {{-100, -100}, {100, 10}}), Line(points = {{-100, 100}, {-100, -100}, {100, -100}, {100, 100}}), Text(origin = {0, 14}, textColor = {0, 0, 255}, extent = {{-139, -114}, {141, -154}}, textString = "%name"), Line(origin = {-79, 35}, points = {{1, 1}, {1, -23}}, color = {255, 255, 255}, thickness = 2, arrow = {Arrow.None, Arrow.Filled}, smooth = Smooth.Bezier), Line(origin = {-59, 35}, points = {{1, 1}, {1, -23}}, color = {255, 255, 255}, thickness = 2, arrow = {Arrow.None, Arrow.Filled}, smooth = Smooth.Bezier), Text(origin = {-69, 147}, textColor = {255, 255, 255}, extent = {{-26, -77}, {27, -104}}, textString = "p")}),
    Documentation(info = "<html>
<p>
MSL <code>Modelica.Fluid.Vessels.OpenTank</code>（自由表面を持つ開放タンク）の
アイコンを流用するための <code>partial model</code> です。
</p>
<p>
元のアイコンは液面レベル変数 <code>level</code> に応じて液面位置や
レベル値の表示テキストが <code>DynamicSelect</code> で変化しますが、
本クラスはパラメータ・変数を持たないため、液面を固定の静的表示とし、
レベル値テキストは省略しています。名前ラベルは継承元の
<code>Vessels.BaseClasses.PartialLumpedVessel</code> から合成しています。
</p>
<p>
出典: Modelica.Fluid.Vessels.OpenTank (Modelica Standard Library),
Copyright &copy; 2002-2025, Modelica Association and contributors.
</p>
</html>"),
    Diagram(graphics));
end GasPressuredTank;
