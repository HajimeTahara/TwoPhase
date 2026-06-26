within EAST.Blocks.Routing;
block ExtractScalar "Real配列から指定した1要素をスカラー出力"
  parameter Integer n(min=1) = 1 "入力配列サイズ";
  parameter Integer index(min=1, max=n) = 1 "抽出する要素番号";

  Modelica.Blocks.Interfaces.RealVectorInput u[n]
    "入力配列"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y
    "抽出したスカラー出力"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  y = u[index];

  annotation(
    defaultComponentName="extractScalar",
    Icon(graphics={
      Rectangle(
        extent={{-100,100},{100,-100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-80,40},{80,-40}},
        textString="u[%index]"),
      Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        textColor={0,0,255})}),
    Documentation(info="<html>
<p>
Real配列入力 <code>u[n]</code> から、パラメータ <code>index</code> で指定した
1要素を取り出し、スカラーReal出力 <code>y</code> として出力します。
</p>
<pre>
y = u[index]
</pre>
<p>
<code>index</code> は 1 以上 <code>n</code> 以下の範囲で指定します。
</p>
</html>"));
end ExtractScalar;
