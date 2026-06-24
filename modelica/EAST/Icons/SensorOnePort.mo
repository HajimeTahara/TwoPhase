within EAST.Icons;
partial model SensorOnePort
  "MSL Modelica.Fluid.Sensors.Pressure 等の一方ポートセンサアイコン"
  extends Modelica.Icons.RoundSensor;
  annotation (Icon(graphics={
        Line(points={{70,0},{100,0}}, color={0,0,127}),
        Line(points={{0,-70},{0,-100}}, color={0,127,255}),
        Text(
          extent={{-150,80},{150,120}},
          textColor={0,0,255},
          textString="%name")}), Documentation(info="<html>
<p>
MSL <code>Modelica.Fluid.Sensors.Pressure</code> をはじめとする一方ポート
（<code>Density</code>, <code>SpecificEnthalpy</code>, <code>SpecificEntropy</code>,
<code>MassFractions</code> 等）センサ群が共通して持つアイコン意匠を流用するための
<code>partial model</code> です。これらは計測量を示すテキスト
（<code>p</code>, <code>d</code>, <code>h</code> 等）のみが異なり、
本体アイコンは共通のため代表として <code>Pressure</code> から抽出しました。
</p>
<p>
丸型センサ本体は MSL の汎用アイコン <code>Modelica.Icons.RoundSensor</code> を
そのまま <code>extends</code> しています（流用元と同一のため複製していません）。
計測量を示す固定テキストは省略しています。
</p>
<p>
出典: Modelica.Fluid.Sensors.Pressure (Modelica Standard Library),
Copyright &copy; 2002-2025, Modelica Association and contributors.
</p>
</html>"));
end SensorOnePort;
