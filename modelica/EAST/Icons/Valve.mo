within EAST.Icons;
partial model Valve
  "MSL Modelica.Fluid.Valves.ValveLinear のバルブアイコン（全開状態の静的表示）"
  extends EAST.Icons.TwoPortFlowDevice;
  annotation (Icon(graphics={
        Line(points={{0,50},{0,0}}),
        Rectangle(extent={{-20,60},{20,50}}, fillPattern=FillPattern.Solid),
        Polygon(
          points={{-100,50},{100,-50},{100,50},{0,0},{-100,-50},{-100,50}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-100,50},{100,-50},{100,50},{0,0},{-100,-50},{-100,50}},
          lineColor={255,255,255},
          fillColor={0,255,0},
          fillPattern=FillPattern.Solid),
        Polygon(points={{-100,50},{100,-50},{100,50},{0,0},{-100,-50},{-100,50}})}),
      Documentation(info="<html>
<p>
MSL <code>Modelica.Fluid.Valves.ValveLinear</code> のバルブアイコンを流用するための
<code>partial model</code> です。
</p>
<p>
元のアイコンは弁開度パラメータ <code>opening</code> に応じて緑色の楔形が
<code>DynamicSelect</code> で変化しますが、本クラスはパラメータを持たない
icon-only クラスのため、全開状態相当の静的な楔形として固定しています。
</p>
<p>
出典: Modelica.Fluid.Valves.ValveLinear (Modelica Standard Library),
Copyright &copy; 2002-2025, Modelica Association and contributors.
</p>
</html>"));
end Valve;
