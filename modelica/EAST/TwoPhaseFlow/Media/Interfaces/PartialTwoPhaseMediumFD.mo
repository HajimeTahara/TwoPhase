within EAST.TwoPhaseFlow.Media.Interfaces;
partial package PartialTwoPhaseMediumFD
  "単相密度を固定値として扱う気液二相媒体の抽象基底クラス"
  extends PartialTwoPhaseMedium;

  constant AbsolutePressure p_singlePhaseDensityReference = 101325
    "単相固定密度を取得する基準圧力";
  constant Density d_singlePhase_const =
    interpolate1D(sat_p, sat_d_bubble, p_singlePhaseDensityReference)
    "単相域で使用する固定密度";

  redeclare function densitySinglePhase
    "基準圧力における飽和液密度を返す単相密度関数"
    input AbsolutePressure p;
    input SpecificEnthalpy h;
    output Density d;
  algorithm
    d := d_singlePhase_const;
  end densitySinglePhase;

  annotation (Documentation(info="<html>
<p>
<code>PartialTwoPhaseMedium</code> から派生し、単相域の密度を固定値として扱う媒体基底クラス。
</p>
<p>
固定密度 <code>d_singlePhase_const</code> は、飽和物性表
<code>sat_p</code> / <code>sat_d_bubble</code> を標準大気圧
<code>p_singlePhaseDensityReference = 101325 Pa</code> で補間して求める。
圧力・比エンタルピーには依存しない。
</p>
<p>
二相域の密度計算は <code>PartialTwoPhaseMedium</code> の実装をそのまま使用する。
</p>
</html>"));
end PartialTwoPhaseMediumFD;
