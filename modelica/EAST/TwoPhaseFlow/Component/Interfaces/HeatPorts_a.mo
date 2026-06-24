within EAST.TwoPhaseFlow.Component.Interfaces;

connector HeatPorts_a
  "HeatPort 配列用ポート（塗りつぶし; ベクトル HeatPort の公開に使用）"
  extends EAST.TwoPhaseFlow.Component.Interfaces.HeatPort;
  annotation(
    defaultComponentName = "heatPorts",
    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-200, -50}, {200, 50}}, initialScale = 0.2), graphics = {
      Rectangle(extent = {{-200, 50}, {200, -50}}, lineColor = {191, 0, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid),
      Rectangle(extent = {{-170, 44}, {-82, -44}}, lineColor = {191, 0, 0}, fillColor = {191, 0, 0}, fillPattern = FillPattern.Solid),
      Rectangle(extent = {{-44, 44}, {44, -44}}, lineColor = {191, 0, 0}, fillColor = {191, 0, 0}, fillPattern = FillPattern.Solid),
      Rectangle(extent = {{82, 44}, {170, -44}}, lineColor = {191, 0, 0}, fillColor = {191, 0, 0}, fillPattern = FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-200, -50}, {200, 50}}), graphics = {
      Rectangle(extent = {{-200, 50}, {200, -50}}, lineColor = {191, 0, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid),
      Rectangle(extent = {{-170, 44}, {-82, -44}}, lineColor = {191, 0, 0}, fillColor = {191, 0, 0}, fillPattern = FillPattern.Solid),
      Rectangle(extent = {{-44, 44}, {44, -44}}, lineColor = {191, 0, 0}, fillColor = {191, 0, 0}, fillPattern = FillPattern.Solid),
      Rectangle(extent = {{82, 44}, {170, -44}}, lineColor = {191, 0, 0}, fillColor = {191, 0, 0}, fillPattern = FillPattern.Solid),
      Text(extent = {{-200, 100}, {200, 55}}, lineColor = {191, 0, 0}, textString = "%name")}),
    Documentation(info = "<html>
<p>
HeatPort 配列を公開するためのコネクタです。MSL の
<code>Modelica.Fluid.Interfaces.HeatPorts_a</code> と同様に、ドラッグ後に
配列次元を付けて使うことを想定した横長アイコンを持ちます。
</p>
<p>
物理的な変数は <code>HeatPort_a</code> と同じく <code>HeatPort</code> を継承した
<code>T</code> と <code>Q_flow</code> です。
</p>
</html>"));
end HeatPorts_a;
