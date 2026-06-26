within ModelicaProjects.EPv2Cooling.Study;
model EPv2CoolingSystemSimple
  extends Modelica.Icons.Example;
  import Modelica.Units.SI;
  replaceable package medium = EAST.TwoPhaseFlow.Media.LCH_FD;
  parameter SI.Pressure p_out = 0.55*10^6;
  parameter SI.Temperature T_in = 100;
  final parameter SI.Temperature T_out = T_in;
  final parameter SI.Temperature T_init = T_in;
  final parameter SI.Pressure p_init = p_out;
  EAST.TwoPhaseFlow.Component.Sources.Boundary_pT boundary_pT(use_p_in = true, use_T_in = true, redeclare package Medium = medium) annotation(
    Placement(transformation(origin = {-220, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = p_out) annotation(
    Placement(transformation(origin = {-274, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const1(k = T_out) annotation(
    Placement(transformation(origin = {-274, -6}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment dynamicPipeSegment(redeclare package Medium = medium, use_HeatTransfer = false, p_start = p_init, h_start = medium.specificEnthalpy_pT(p_init, T_init)) annotation(
    Placement(transformation(origin = {180, -112}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.TwoPhaseFlow.Component.Junction.TeeJunction tee3(redeclare package Medium = medium, p_start = p_init) annotation(
    Placement(transformation(origin = {74, -170}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Junction.TeeJunction tee6(redeclare package Medium = medium, p_start = p_init) annotation(
    Placement(transformation(origin = {74, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  EAST.TwoPhaseFlow.Component.Sources.MassFlowSource_T massFlowSource_T(use_m_flow_in = true, use_T_in = true, T_set = 100, m_flow_set = 0.01, redeclare package Medium = medium) annotation(
    Placement(transformation(origin = {214, 60}, extent = {{-10, 10}, {10, -10}}, rotation = -180)));
  Modelica.Blocks.Sources.Constant const2(k = 0.157) annotation(
    Placement(transformation(origin = {274, 90}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Constant const21(k = T_in) annotation(
    Placement(transformation(origin = {272, 38}, extent = {{10, -10}, {-10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.StaticPipe sPipe422(redeclare package Medium = medium, p_a_start = p_init, p_b_start = p_init) annotation(
    Placement(transformation(origin = {74, -126}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));
  ModelicaProjects.EPv2Cooling.Component.InvertorCoolingModule LCHpumpInvertor(p_init_pipe = p_init, redeclare package Medium = medium, T_init_pipe = T_init, T_init_module = T_init) annotation(
    Placement(transformation(origin = {-42, -80}, extent = {{10, -10}, {-10, 10}})));
  ModelicaProjects.EPv2Cooling.Component.InvertorCoolingModule LOXpumpInvertor(redeclare package Medium = medium, p_init_pipe = p_init, T_init_pipe = T_init, T_init_module = T_init) annotation(
    Placement(transformation(origin = {-44, 20}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  EAST.TwoPhaseFlow.Component.Sources.Boundary_pT boundary_pT1(redeclare package Medium = medium, use_T_in = true, use_p_in = true) annotation(
    Placement(transformation(origin = {-54, -170}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const3(k = p_out) annotation(
    Placement(transformation(origin = {-108, -150}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const11(k = T_out) annotation(
    Placement(transformation(origin = {-108, -196}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(const.y, boundary_pT.p_in) annotation(
    Line(points = {{-263, 40}, {-254, 40}, {-254, 26}, {-232, 26}}, color = {0, 0, 127}));
  connect(const1.y, boundary_pT.T_in) annotation(
    Line(points = {{-263, -6}, {-248, -6}, {-248, 14}, {-232, 14}}, color = {0, 0, 127}));
  connect(const2.y, massFlowSource_T.m_flow_in) annotation(
    Line(points = {{263, 90}, {236, 90}, {236, 66}, {226, 66}}, color = {0, 0, 127}));
  connect(massFlowSource_T.T_in, const21.y) annotation(
    Line(points = {{226, 54}, {244, 54}, {244, 38}, {261, 38}}, color = {0, 0, 127}));
  connect(dynamicPipeSegment.port_a, massFlowSource_T.port) annotation(
    Line(points = {{180, -102}, {180, 60}, {204, 60}}, color = {0, 0, 127}));
  connect(tee3.port_2, dynamicPipeSegment.port_b) annotation(
    Line(points = {{84, -170}, {180, -170}, {180, -122}}, color = {0, 0, 127}));
  connect(tee6.port_1, sPipe422.port_b) annotation(
    Line(points = {{74, -90}, {74, -116}}, color = {0, 0, 127}));
  connect(sPipe422.port_a, tee3.port_3) annotation(
    Line(points = {{74, -136}, {74, -160}}, color = {0, 0, 127}));
  connect(LOXpumpInvertor.port_a, tee6.port_2) annotation(
    Line(points = {{-34, 20}, {74, 20}, {74, -70}}, color = {0, 0, 127}));
  connect(LCHpumpInvertor.port_a, tee6.port_3) annotation(
    Line(points = {{-32, -80}, {64, -80}}, color = {0, 0, 127}));
  connect(boundary_pT.port, LOXpumpInvertor.port_b) annotation(
    Line(points = {{-210, 20}, {-54, 20}}, color = {0, 0, 127}));
  connect(boundary_pT.port, LCHpumpInvertor.port_b) annotation(
    Line(points = {{-210, 20}, {-164, 20}, {-164, -80}, {-52, -80}}, color = {0, 0, 127}));
  connect(const3.y, boundary_pT1.p_in) annotation(
    Line(points = {{-97, -150}, {-88, -150}, {-88, -164}, {-66, -164}}, color = {0, 0, 127}));
  connect(const11.y, boundary_pT1.T_in) annotation(
    Line(points = {{-97, -196}, {-82, -196}, {-82, -176}, {-66, -176}}, color = {0, 0, 127}));
  connect(boundary_pT1.port, tee3.port_1) annotation(
    Line(points = {{-44, -170}, {64, -170}}, color = {0, 0, 127}));
  annotation(
    experiment(StopTime = 1000),
    Diagram(coordinateSystem(extent = {{-300, 180}, {400, -240}})));
end EPv2CoolingSystemSimple;
