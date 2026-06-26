within ModelicaProjects.EPv2Cooling.Study;
model MotorCoolingTest
  import Modelica.Units.SI;
  extends Modelica.Icons.Example;
  
  replaceable package medium = EAST.TwoPhaseFlow.Media.LCH_FD;
  
  parameter Integer nNode = 5 "node数. デフォルトから変更する場合スケッチも更新" annotation(
    Dialog(group = "Module"));
  parameter SI.HeatFlowRate loss = 4000 "motor損失" annotation(
    Dialog(group = "Module"));
  parameter SI.Pressure p_init_pipe = 0.55*10^6 annotation(
    Dialog(group = "Initialization"));
  parameter SI.Temperature T_init_pipe = 100 annotation(
    Dialog(group = "Initialization"));
  parameter SI.Temperature T_init_motor = 273 annotation(
    Dialog(group = "Initialization"));
  
  EAST.TwoPhaseFlow.Component.Sources.Boundary_pT boundary_pT(redeclare package Medium = medium, p_set = p_init_pipe, T_set = T_init_pipe) annotation(
    Placement(transformation(origin = {134, -102}, extent = {{10, -10}, {-10, 10}})));
  EAST.TwoPhaseFlow.Component.Sources.MassFlowSource_T massFlowSource_T(redeclare package Medium = medium, T_set = T_init_pipe, m_flow_set = 0.17) annotation(
    Placement(transformation(origin = {-128, -98}, extent = {{-10, -10}, {10, 10}})));
  EAST.Blocks.Sources.ConstantArray constArray(k = {loss, 0, 0}) annotation(
    Placement(transformation(origin = {134, 100}, extent = {{10, -10}, {-10, 10}})));
  ModelicaProjects.EPv2Cooling.Component.MotorCoolingModule motorCoolingModule(redeclare package Medium = medium, p_init_pipe = p_init_pipe, T_init_pipe = T_init_pipe, T_init_motor = T_init_motor) annotation(
    Placement(transformation(origin = {-7, -17}, extent = {{-45, -45}, {45, 45}})));
  Modelica.Blocks.Interaction.Show.RealValue realValue annotation(
    Placement(transformation(origin = {82, 40}, extent = {{-22, -18}, {22, 18}})));
equation
  
  connect(massFlowSource_T.port, motorCoolingModule.port_a) annotation(
    Line(points = {{-118, -98}, {-82, -98}, {-82, -17}, {-52, -17}}, color = {0, 0, 127}));
  connect(motorCoolingModule.port_b, boundary_pT.port) annotation(
    Line(points = {{38, -17}, {76, -17}, {76, -102}, {124, -102}}, color = {0, 0, 127}));
  connect(motorCoolingModule.u, constArray.y) annotation(
    Line(points = {{-7, 28}, {-12, 28}, {-12, 100}, {124, 100}}, color = {0, 0, 127}, thickness = 0.5));
  connect(motorCoolingModule.coilTemperature, realValue.numberPort) annotation(
    Line(points = {{34, 20}, {36, 20}, {36, 40}, {57, 40}}, color = {0, 0, 127}));
  annotation(
    experiment(StopTime = 100),
    Icon,
    Diagram(coordinateSystem(extent = {{-160, 120}, {160, -140}})));
end MotorCoolingTest;
