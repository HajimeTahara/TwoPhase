within Thermal.HeatTransfer.Components;
model ThermalConductor "材料物性と形状から熱コンダクタンスを計算する熱伝導要素"
  parameter Modelica.Units.SI.Area A = 1e-4 "伝熱面積 [m2]";
  parameter Modelica.Units.SI.Length L = 1e-3 "伝熱長さ [m]";
  parameter Thermal.Material.MaterialProperties material =
    Thermal.Material.Sus304() "材料物性";

  final parameter Modelica.Units.SI.ThermalConductance G =
    material.thermalConductivity * A / L "熱コンダクタンス [W/K]";

  Thermal.HeatTransfer.Interfaces.HeatPort_a port_a "熱ポート a"
    annotation (Placement(
      transformation(extent={{-110,-10},{-90,10}}),
      iconTransformation(extent={{-110,-10},{-90,10}})));
  Thermal.HeatTransfer.Interfaces.HeatPort_b port_b "熱ポート b"
    annotation (Placement(
      transformation(extent={{90,-10},{110,10}}),
      iconTransformation(extent={{90,-10},{110,10}})));

equation
  port_a.Q_flow + port_b.Q_flow = 0;
  port_a.Q_flow = G * (port_a.T - port_b.T);

  annotation (Icon(coordinateSystem(preserveAspectRatio=true), graphics={
      Rectangle(
        extent={{-60,20},{60,-20}},
        lineColor={191,0,0},
        fillColor={255,170,170},
        fillPattern=FillPattern.Solid),
      Line(
        points={{-100,0},{-60,0}},
        color={191,0,0}),
      Line(
        points={{60,0},{100,0}},
        color={191,0,0}),
      Text(
        extent={{-100,72},{100,48}},
        textString="%name",
        lineColor={0,0,0}),
      Text(
        extent={{-100,-48},{100,-72}},
        textString="G=%G",
        lineColor={0,0,0})}),
    Documentation(info="<html>
<p>
MSL の ThermalConductor と同じ集中熱伝導モデルですが、熱コンダクタンス
<code>G</code> を直接指定する代わりに、材料の熱伝導率と形状から自動計算します。
</p>
<p>
熱コンダクタンスは <code>G = material.thermalConductivity * A / L</code> です。
</p>
</html>"));
end ThermalConductor;
