within EAST.TwoPhaseFlow.Component.Interfaces;

connector FluidPorts_b "流体ポート配列用ポート（白抜き; ベクトル FluidPort の公開に使用）"
  extends EAST.TwoPhaseFlow.Component.Interfaces.FluidPort;
  annotation(
    defaultComponentName = "ports_b",
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-50, -200}, {50, 200}}, initialScale = 0.2), graphics = {Rectangle(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-50, 200}, {50, -200}}), Ellipse(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-50, 180}, {50, 80}}), Ellipse(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-50, 50}, {50, -50}}), Ellipse(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 1.5, extent = {{-50, -80}, {50, -180}})}),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-50, -200}, {50, 200}}, initialScale = 0.2), graphics = {Text(extent = {{-75, 130}, {75, 100}}, lineColor = {0, 127, 255}, textString = "%name"), Rectangle(extent = {{-25, 100}, {25, -100}}, lineColor = {0, 127, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Ellipse(extent = {{-25, 90}, {25, 40}}, lineColor = {0, 127, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Ellipse(extent = {{-25, 25}, {25, -25}}, lineColor = {0, 127, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Ellipse(extent = {{-25, -40}, {25, -90}}, lineColor = {0, 127, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid)}),
    Documentation(info = "<html>
<p>
FluidPort 配列を公開するためのコネクタです。MSL の
<code>Modelica.Fluid.Interfaces.FluidPorts_b</code> と同様に、ドラッグ後に
配列次元を付けて使うことを想定した縦長アイコンを持ちます。
</p>
<p>
物理的な変数は <code>FluidPort_b</code> と同じく <code>FluidPort</code> を継承した
<code>p</code>, <code>m_flow</code>, <code>h_outflow</code> です。
</p>
</html>"));
end FluidPorts_b;
