within EAST.Icons;
partial model MultiPort
  "MSL Modelica.Fluid.Fittings.MultiPort の多分岐ジャンクションアイコン"
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-40,-100},{40,100}}), graphics={
        Line(points={{-40,0},{40,0}}, color={0,128,255}, thickness=1),
        Line(points={{-40,0},{40,26}}, color={0,128,255}, thickness=1),
        Line(points={{-40,0},{40,-26}}, color={0,128,255}, thickness=1),
        Text(
          extent={{-150,100},{150,60}},
          textColor={0,0,255},
          textString="%name")}), Documentation(info="<html>
<p>
MSL <code>Modelica.Fluid.Fittings.MultiPort</code>（1つのポートを複数に
分岐させるジャンクション）のアイコンを流用するための <code>partial model</code> です。
</p>
<p>
出典: Modelica.Fluid.Fittings.MultiPort (Modelica Standard Library),
Copyright &copy; 2002-2025, Modelica Association and contributors.
</p>
</html>"));
end MultiPort;
