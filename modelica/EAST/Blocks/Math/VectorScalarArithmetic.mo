within EAST.Blocks.Math;
block VectorScalarArithmetic "Real配列とスカラーの要素ごとの乗除算"
  parameter Integer n(min=1) = 1 "配列サイズ";
  parameter EAST.Blocks.Types.VectorScalarOperation operation =
    EAST.Blocks.Types.VectorScalarOperation.Multiply "演算タイプ";

  Modelica.Blocks.Interfaces.RealVectorInput u[n]
    "入力配列"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput k
    "スカラー入力"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealVectorOutput y[n]
    "出力配列"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  for i in 1:n loop
    y[i] =
      if operation == EAST.Blocks.Types.VectorScalarOperation.Multiply then
        u[i]*k
      else
        u[i]/k;
  end for;

  annotation(
    defaultComponentName="vectorScalarArithmetic",
    Icon(graphics={
      Rectangle(
        extent={{-100,100},{100,-100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-86,48},{86,-48}},
        textString="[:] op k"),
      Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        textColor={0,0,255})}),
    Documentation(info="<html>
<p>
Real配列入力 <code>u</code> とスカラー入力 <code>k</code> に対して、
指定した乗算または除算を要素ごとに行い、同じサイズのReal配列
<code>y</code> として出力します。
</p>
<ul>
<li>Multiply: <code>y[i] = u[i] * k</code></li>
<li>Divide: <code>y[i] = u[i] / k</code></li>
</ul>
</html>"));
end VectorScalarArithmetic;
