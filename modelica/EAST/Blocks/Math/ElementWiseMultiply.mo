within EAST.Blocks.Math;
block ElementWiseMultiply "Real配列の要素ごとの乗算"
  parameter Integer n(min=1) = 1 "配列サイズ";
  parameter Real k = 1 "出力ゲイン";

  Modelica.Blocks.Interfaces.RealVectorInput u1[n]
    "入力配列1"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealVectorInput u2[n]
    "入力配列2"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealVectorOutput y[n]
    "出力配列"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  for i in 1:n loop
    y[i] = k*u1[i]*u2[i];
  end for;

  annotation(
    defaultComponentName="elementWiseMultiply",
    Icon(graphics={
      Rectangle(
        extent={{-100,100},{100,-100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-86,46},{86,-46}},
        textString="*[:]"),
      Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        textColor={0,0,255})}),
    Documentation(info="<html>
<p>
2つのReal配列入力 <code>u1</code> と <code>u2</code> に対して、
要素ごとに乗算を行い、同じサイズのReal配列 <code>y</code> として出力します。
</p>
<pre>
y[i] = k*u1[i]*u2[i]
</pre>
</html>"));
end ElementWiseMultiply;
