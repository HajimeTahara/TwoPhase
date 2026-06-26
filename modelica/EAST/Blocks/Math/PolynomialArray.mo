within EAST.Blocks.Math;
block PolynomialArray "配列入力の各要素に多項式を適用"
  extends Modelica.Blocks.Interfaces.MIMOs;

  parameter EAST.Blocks.Types.PolynomialType polynomialType =
    EAST.Blocks.Types.PolynomialType.Linear "多項式タイプ";
  parameter Real a0 = 0 "定数項の係数";
  parameter Real a1 = 1 "一次項の係数";
  parameter Real a2 = 0 "二次項の係数"
    annotation(Dialog(enable=polynomialType <>
      EAST.Blocks.Types.PolynomialType.Linear));
  parameter Real a3 = 0 "三次項の係数"
    annotation(Dialog(enable=polynomialType ==
      EAST.Blocks.Types.PolynomialType.Cubic));

equation
  for i in 1:n loop
    y[i] = a0 + u[i]*(a1 +
      (if polynomialType == EAST.Blocks.Types.PolynomialType.Linear then 0
       else u[i]*(a2 +
         (if polynomialType == EAST.Blocks.Types.PolynomialType.Cubic then
            a3*u[i]
          else 0))));
  end for;

  annotation(
    defaultComponentName="polynomialArray",
    Icon(graphics={
      Line(
        points={{-80,-60},{-40,-52},{0,-20},{40,28},{80,60}},
        color={0,0,127},
        thickness=0.5),
      Line(
        points={{-80,-45},{-40,-37},{0,-5},{40,43},{80,75}},
        color={0,0,127}),
      Text(
        extent={{-90,70},{90,30}},
        textString="P(u[:])")}),
    Documentation(info="<html>
<p>
配列入力 <code>u</code> の各要素に同じ多項式を適用し、
同じサイズの配列 <code>y</code> として出力します。
</p>
<ul>
<li>一次: <code>y[i] = a0 + a1*u[i]</code></li>
<li>二次: <code>y[i] = a0 + a1*u[i] + a2*u[i]^2</code></li>
<li>三次: <code>y[i] = a0 + a1*u[i] + a2*u[i]^2 + a3*u[i]^3</code></li>
</ul>
</html>"));
end PolynomialArray;
