within EAST.Icons;

partial model TwoPortFlowDevice "MSL Modelica.Fluid.Interfaces.PartialTwoPort の二方ポート流体デバイスアイコン"
  annotation(
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Polygon(lineColor = {0, 128, 255}, fillColor = {0, 128, 255}, fillPattern = FillPattern.Solid, points = {{20, -70}, {60, -85}, {20, -100}, {20, -70}}), Polygon(lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{20, -75}, {50, -85}, {20, -95}, {20, -75}}), Line(points = {{55, -85}, {-60, -85}}, color = {0, 128, 255}), Text(origin = {0, 14}, textColor = {0, 0, 255}, extent = {{-139, -114}, {141, -154}}, textString = "%name")}),
    Documentation(info = "<html>
<p>
MSL <code>Modelica.Fluid.Interfaces.PartialTwoPort</code> が提供する、
二方ポート流体デバイス共通の意匠（設計流れ方向の矢印 + インスタンス名ラベル）を
抜き出した <code>partial model</code> です。
</p>
<p>
管・バルブ・ポンプ・オリフィス等、二方ポートを持つ流体コンポーネントのアイコンの
基底として <code>extends</code> してください。
</p>
<p>
出典: Modelica.Fluid.Interfaces.PartialTwoPort (Modelica Standard Library),
Copyright &copy; 2002-2025, Modelica Association and contributors.
</p>
</html>"));
end TwoPortFlowDevice;
