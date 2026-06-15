within TwoPhaseFlow.Component.Interfaces;
connector FluidPort "流体ポート基底（二相媒体対応）"
  replaceable package Medium = TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium
    annotation (choicesAllMatching=true);

  Modelica.Units.SI.AbsolutePressure  p         "圧力 [Pa]";
  flow Modelica.Units.SI.MassFlowRate m_flow     "質量流量 [kg/s]（流入正）";
  stream Modelica.Units.SI.SpecificEnthalpy h_outflow
    "流出時の比エンタルピー [J/kg]";
end FluidPort;
