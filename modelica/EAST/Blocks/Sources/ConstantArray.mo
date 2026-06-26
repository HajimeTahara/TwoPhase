within EAST.Blocks.Sources;
block ConstantArray "Real型の定数配列を出力"
  extends Modelica.Blocks.Icons.Block;

  parameter Real k[:] = {1} "定数出力値";
  Modelica.Blocks.Interfaces.RealOutput y[size(k, 1)]
    "Real型の出力信号配列"
    annotation(Placement(transformation(extent={{100,-10},{120,10}})));

equation
  y = k;

  annotation(
    defaultComponentName="constArray",
    Icon(graphics={
      Line(points={{-80,60},{-80,-70}}, color={192,192,192}),
      Polygon(
        points={{-80,80},{-88,60},{-72,60},{-80,80}},
        lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid),
      Line(points={{-90,-60},{80,-60}}, color={192,192,192}),
      Polygon(
        points={{90,-60},{70,-52},{70,-68},{90,-60}},
        lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid),
      Line(points={{-80,0},{80,0}}),
      Text(
        extent={{-150,-150},{150,-110}},
        textString="k=%k")}),
    Documentation(info="<html>
<p>
パラメータ <code>k</code> に設定した Real 型の配列を、
同じ配列サイズの出力 <code>y</code> から定数信号として出力します。
</p>
</html>"));
end ConstantArray;
