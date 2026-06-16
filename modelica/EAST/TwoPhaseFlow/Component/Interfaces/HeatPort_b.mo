within EAST.TwoPhaseFlow.Component.Interfaces;
connector HeatPort_b "熱ポート（白抜き; 熱を供給する側のコンポーネントに使用）"
  extends EAST.TwoPhaseFlow.Component.Interfaces.HeatPort;
  annotation (
    defaultComponentName="port",
    Icon(
      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={Rectangle(
        extent={{-100,100},{100,-100}},
        lineColor={191,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}),
    Diagram(
      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-50,50},{50,-50}},
          lineColor={191,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,110},{150,50}},
          lineColor={191,0,0},
          textString="%name")}),
    Documentation(info="<html>
<p>
白抜き矩形のアイコンで表す熱ポート。<code>HeatPort</code> を継承する。
<code>FixedHeatFlow</code> など、熱を供給する側のコンポーネントで使用する
（MSL の <code>HeatPort_b</code> に倣う命名・配色だが、実装は独立）。
</p>
</html>"));
end HeatPort_b;
