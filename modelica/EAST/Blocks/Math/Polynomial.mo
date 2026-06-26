within EAST.Blocks.Math;
block Polynomial "一次から三次までの多項式を計算"
  extends Modelica.Blocks.Interfaces.SISO;

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
  y = a0 + u*(a1 +
    (if polynomialType == EAST.Blocks.Types.PolynomialType.Linear then 0
     else u*(a2 +
       (if polynomialType == EAST.Blocks.Types.PolynomialType.Cubic then
          a3*u
        else 0))));

  annotation(
    defaultComponentName="polynomial",
    Icon(graphics={
      Line(
        points={{-80,-60},{-40,-52},{0,-20},{40,28},{80,60}},
        color={0,0,127},
        thickness=0.5),
      Text(
        extent={{-90,70},{90,30}},
        textString="P(u)")}),
    Documentation(info="<html>
<p>
入力 <code>u</code> に対し、選択した多項式タイプに応じて次式を計算します。
</p>
<ul>
<li>一次: <code>y = a0 + a1*u</code></li>
<li>二次: <code>y = a0 + a1*u + a2*u^2</code></li>
<li>三次: <code>y = a0 + a1*u + a2*u^2 + a3*u^3</code></li>
</ul>
</html>"));
end Polynomial;
