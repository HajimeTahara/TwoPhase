within EAST.Icons;
partial model OpenTank
  "MSL Modelica.Fluid.Vessels.OpenTank の開放タンクアイコン"
  annotation (Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}, initialScale = 0.2), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}, lineColor = {0, 0, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.VerticalCylinder, pattern = LinePattern.None), Rectangle(extent = {{-100, -100}, {100, 10}}, fillColor = {85, 170, 255}, fillPattern = FillPattern.VerticalCylinder), Line(points = {{-100, 100}, {-100, -100}, {100, -100}, {100, 100}}), Text(extent = {{-150, 110}, {150, 150}}, textColor = {0, 0, 255}, textString = "%name"), Text(origin = {0, 14}, textColor = {0, 0, 255}, extent = {{-139, -114}, {141, -154}}, textString = "%name")}), Documentation(info="<html>
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
end OpenTank;
