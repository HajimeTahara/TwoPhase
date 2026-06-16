within EAST.TwoPhaseFlow.Component.Interfaces;
connector HeatPort_a "熱ポート（塗りつぶし; 熱を受け取る側のコンポーネントに使用）"
  extends EAST.TwoPhaseFlow.Component.Interfaces.HeatPort;
  annotation (
    defaultComponentName="heatPort",
    Icon(
      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={Rectangle(
        extent={{-100,100},{100,-100}},
        lineColor={191,0,0},
        fillColor={191,0,0},
        fillPattern=FillPattern.Solid)}),
    Diagram(
      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-50,50},{50,-50}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,110},{150,50}},
          lineColor={191,0,0},
          textString="%name")}),
    Documentation(info="<html>
<p>
塗りつぶし矩形のアイコンで表す熱ポート。<code>HeatPort</code> を継承する。
<code>Pipe</code> など、外部から熱を受け取る側のコンポーネントで使用する
（MSL の <code>HeatPort_a</code> に倣う命名・配色だが、実装は独立）。
</p>
</html>"));
end HeatPort_a;
