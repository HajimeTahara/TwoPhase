within ModelicaProjects.EPv2Cooling.Study;
model InvertorCoolingTest
  import Modelica.Units.SI;
  extends Modelica.Icons.Example;
  replaceable package medium = EAST.TwoPhaseFlow.Media.LCH_FD;
  parameter SI.Pressure p_init_pipe = 0.55*10^6 annotation(
    Dialog(group = "Initialization"));
  parameter SI.Temperature T_init_pipe = 100 annotation(
    Dialog(group = "Initialization"));
  parameter SI.Temperature T_init_module = 273 annotation(
    Dialog(group = "Initialization"));
  Modelica.Blocks.Sources.Constant constLoss(k = 4000) annotation(
    Placement(transformation(origin = {-96, 58}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Sources.Boundary_pT boundary_pT(redeclare package Medium = medium, p_set = p_init_pipe, T_set = T_init_pipe) annotation(
    Placement(transformation(origin = {110, -40}, extent = {{10, -10}, {-10, 10}})));
  EAST.TwoPhaseFlow.Component.Sources.MassFlowSource_T massFlowSource_T(redeclare package Medium = medium, T_set = T_init_pipe, m_flow_set = 0.04) annotation(
    Placement(transformation(origin = {-92, -42}, extent = {{-10, -10}, {10, 10}})));
  ModelicaProjects.EPv2Cooling.Component.InvertorCoolingModule invertorCoolingModule(redeclare package Medium = medium) annotation(
    Placement(transformation(origin = {-2, 2}, extent = {{-34, -34}, {34, 34}})));
equation
  connect(massFlowSource_T.port, invertorCoolingModule.port_a) annotation(
    Line(points = {{-82, -42}, {-64, -42}, {-64, 2}, {-36, 2}}, color = {0, 0, 127}));
  connect(invertorCoolingModule.port_b, boundary_pT.port) annotation(
    Line(points = {{32, 2}, {72, 2}, {72, -40}, {100, -40}}, color = {0, 0, 127}));
  connect(constLoss.y, invertorCoolingModule.q) annotation(
    Line(points = {{-84, 58}, {-2, 58}, {-2, 32}}, color = {0, 0, 127}));
  annotation(
    experiment(StopTime = 100),
    Icon,
    Diagram(coordinateSystem(extent = {{-240, 120}, {280, -140}})));
end InvertorCoolingTest;
