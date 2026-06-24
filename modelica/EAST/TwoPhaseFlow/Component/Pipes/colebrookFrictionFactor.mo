within EAST.TwoPhaseFlow.Component.Pipes;

function colebrookFrictionFactor
  "Colebrook-White 式から Darcy 摩擦係数を反復計算する"
  input Modelica.Units.SI.ReynoldsNumber Re "Reynolds 数";
  input Real relativeRoughness(unit = "1", min = 0) "相対粗さ ε/D";
  output Real frictionFactor(unit = "1") "Darcy 摩擦係数";
protected
  Real inverseSqrtF;
algorithm
  assert(Re > 0, "Colebrook 式では Re > 0 が必要です。");
  inverseSqrtF := 1/sqrt(0.02);
  for i in 1:10 loop
    inverseSqrtF := -2*Modelica.Math.log10(
      relativeRoughness/3.7 + 2.51*inverseSqrtF/Re);
  end for;
  frictionFactor := 1/inverseSqrtF^2;
end colebrookFrictionFactor;
