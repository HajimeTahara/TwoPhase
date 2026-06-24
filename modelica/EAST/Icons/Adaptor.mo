within EAST.Icons;
partial model Adaptor
  "MSL Modelica.Fluid.Fittings.AbruptAdaptor の異径アダプタアイコン"
  extends EAST.Icons.TwoPortFlowDevice;
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,22},{0,-22}},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{0,60},{100,-60}},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255})}), Documentation(info="<html>
<p>
MSL <code>Modelica.Fluid.Fittings.AbruptAdaptor</code>（急な拡大・縮小による
異径配管の接続要素）のアイコンを流用するための <code>partial model</code> です。
</p>
<p>
元のアイコンは <code>diameter_a</code>/<code>diameter_b</code> に応じて
配管太さが <code>DynamicSelect</code> で変化しますが、本クラスはパラメータを
持たないため、その既定（静的）表示形状で固定しています。
</p>
<p>
出典: Modelica.Fluid.Fittings.AbruptAdaptor (Modelica Standard Library),
Copyright &copy; 2002-2025, Modelica Association and contributors.
</p>
</html>"));
end Adaptor;
