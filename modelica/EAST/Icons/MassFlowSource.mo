within EAST.Icons;

partial model MassFlowSource "MSL Modelica.Fluid.Sources.MassFlowSource_T の質量流量ソースアイコン"
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(fillColor = {0, 127, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{35, 45}, {100, -45}}), Ellipse(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 80}, {60, -80}}), Polygon(lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, points = {{-60, 70}, {60, 0}, {-60, -68}, {-60, 70}}), Text(textColor = {255, 0, 0}, extent = {{-54, 32}, {16, -30}}, textString = "m"), Text(origin = {-10, -270}, textColor = {0, 0, 255}, extent = {{-150, 130}, {150, 170}}, textString = "%name"), Ellipse(lineColor = {255, 0, 0}, fillColor = {255, 0, 0}, fillPattern = FillPattern.Solid, extent = {{-26, 30}, {-18, 22}})}),
    Documentation(info = "<html>
<p>
MSL <code>Modelica.Fluid.Sources.MassFlowSource_T</code>（質量流量指定の
境界条件ソース）のアイコンを流用するための <code>partial model</code> です。
</p>
<p>
入力有効化フラグ（<code>use_T_in</code> 等）に応じて表示が変わる入力ラベルは、
本クラスがそれらのパラメータを持たないため省略しています。
</p>
<p>
出典: Modelica.Fluid.Sources.MassFlowSource_T (Modelica Standard Library),
Copyright &copy; 2002-2025, Modelica Association and contributors.
</p>
</html>"));
end MassFlowSource;
