within EAST.TwoPhaseFlow.Component.Pipes;

function pipeNusseltNumber
  "管内強制対流の Reynolds 数と Prandtl 数から Nusselt 数を返す"
  input Modelica.Units.SI.ReynoldsNumber Re "Reynolds 数";
  input Modelica.Units.SI.PrandtlNumber Pr "Prandtl 数";
  input Modelica.Units.SI.ReynoldsNumber ReynoldsTransition = 2300
    "層流から乱流へ切り替える Reynolds 数";
  input Real turbulentPrandtlExponent(min = 0) = 0.4
    "乱流相関式の Prandtl 数指数";
  output Modelica.Units.SI.NusseltNumber Nu "Nusselt 数";
algorithm
  assert(Pr > 0, "Prandtl 数は 0 より大きい必要があります。");
  Nu := if Re < ReynoldsTransition then 3.66
    else 0.023*Re^0.8*Pr^turbulentPrandtlExponent;
end pipeNusseltNumber;
