within EAST.TwoPhaseFlow.Examples;
model TestVoidFraction
  "LCH 流体のボイド率計算例"
  package Medium = EAST.TwoPhaseFlow.Media.LCH;

  Medium.BaseProperties props;
  Real alpha "ボイド率";

equation
  props.p = 200000.0;
  props.h = 500000.0;   // 二相域を想定

  alpha = Medium.voidFraction(props.state);

  annotation(
    experiment(StopTime=1.0),
    Documentation(info="<html>
<p>
HEM（均質平衡モデル）に基づくボイド率計算例。
<code>voidFraction</code> は <code>PartialTwoPhaseMedium</code> に共通実装されており、
各流体固有の飽和密度関数（<code>bubbleDensity</code>, <code>dewDensity</code>）を呼び出す。
</p>
</html>"));
end TestVoidFraction;
