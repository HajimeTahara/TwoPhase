within EAST.Icons;
partial model Orifice
  "MSL Modelica.Fluid.Fittings.SimpleGenericOrifice の抽象オリフィスアイコン"
  extends EAST.Icons.TwoPortFlowDevice;
  annotation (Icon(graphics={
        Line(points={{-60,-50},{-60,50},{60,-50},{60,50}}, thickness=0.5),
        Line(points={{-60,0},{-100,0}}, color={0,127,255}),
        Line(points={{60,0},{100,0}}, color={0,127,255})}), Documentation(info="<html>
<p>
MSL <code>Modelica.Fluid.Fittings.SimpleGenericOrifice</code>（損失係数 <code>zeta</code>
で定義される抽象オリフィス）のアイコンを流用するための <code>partial model</code> です。
</p>
<p>
出典: Modelica.Fluid.Fittings.SimpleGenericOrifice (Modelica Standard Library),
Copyright &copy; 2002-2025, Modelica Association and contributors.
</p>
</html>"));
end Orifice;
