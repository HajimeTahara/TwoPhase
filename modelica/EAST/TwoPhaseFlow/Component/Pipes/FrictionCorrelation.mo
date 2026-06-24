within EAST.TwoPhaseFlow.Component.Pipes;

type FrictionCorrelation = enumeration(
    Blasius "Blasius 式（滑らかな管）",
    Colebrook "Colebrook-White 式（管粗さを考慮）")
  "乱流域の Darcy 摩擦係数相関式";
