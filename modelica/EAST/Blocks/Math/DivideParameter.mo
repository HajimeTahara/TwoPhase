within EAST.Blocks.Math;
block DivideParameter "Real入力をパラメータで除算"
  extends Modelica.Blocks.Interfaces.SISO;

  parameter Real k = 1 "除算する値";

equation
  y = u/k;

  annotation(
    defaultComponentName="divideParameter",
    Icon(graphics={
      Rectangle(
        extent={{-100,100},{100,-100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-86,46},{86,-46}},
        textString="/ k"),
      Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        textColor={0,0,255})}),
    Documentation(info="<html>
<p>
Real入力 <code>u</code> をパラメータ <code>k</code> で除算し、
Real出力 <code>y</code> として出力します。
</p>
<pre>
y = u/k
</pre>
</html>"));
end DivideParameter;
