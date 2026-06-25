within ModelicaProjects;

model EPv2CoolingSystemSimple
  extends Modelica.Icons.Example;
  import Modelica.Units.SI;
  
  
  replaceable package medium = EAST.TwoPhaseFlow.Media.LCH_FD;

  parameter SI.Pressure p_out=0.55*10^6;
  parameter SI.Temperature T_in=100;
  

  final parameter SI.Temperature T_out=T_in;
  final parameter SI.Temperature T_init=T_in;
  final parameter SI.Pressure p_init=p_out;

  EAST.TwoPhaseFlow.Component.Sources.Boundary_pT boundary_pT(use_p_in = true, use_T_in = true, redeclare package Medium = medium)  annotation(
    Placement(transformation(origin = {-230, 120}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = p_out)  annotation(
    Placement(transformation(origin = {-284, 140}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const1(k = T_out)  annotation(
    Placement(transformation(origin = {-284, 94}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment dynamicPipeSegment(redeclare package Medium = medium, use_HeatTransfer = false, p_start = p_init, h_start = medium.specificEnthalpy_pT(p_init, T_init))  annotation(
    Placement(transformation(origin = {180, -112}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant const31(k = 0.9)  annotation(
    Placement(transformation(origin = {-36, -206}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Junction.TeeJunction tee1(redeclare package Medium = medium, p_start = p_init) annotation(
    Placement(transformation(origin = {-160, 20}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.TwoPhaseFlow.Component.Junction.TeeJunction tee2(redeclare package Medium = medium, p_start = p_init) annotation(
    Placement(transformation(origin = {-160, -80}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.TwoPhaseFlow.Component.Junction.TeeJunction tee3(redeclare package Medium = medium, p_start = p_init) annotation(
    Placement(transformation(origin = {74, -170}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.StaticPipe sPipe4(redeclare package Medium = medium, p_a_start = p_init, p_b_start = p_init) annotation(
    Placement(transformation(origin = {-76, -170}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  EAST.TwoPhaseFlow.Component.Junction.TeeJunction tee6(redeclare package Medium = medium, p_start = p_init) annotation(
    Placement(transformation(origin = {74, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  EAST.TwoPhaseFlow.Component.Sources.MassFlowSource_T massFlowSource_T(use_m_flow_in = true, use_T_in = true, T_set= 100, m_flow_set = 0.01, redeclare package Medium = medium)  annotation(
    Placement(transformation(origin = {214, 60}, extent = {{-10, 10}, {10, -10}}, rotation = -180)));
  Modelica.Blocks.Sources.Constant const2(k = 0.157) annotation(
    Placement(transformation(origin = {274, 90}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Constant const21(k = T_in) annotation(
    Placement(transformation(origin = {272, 38}, extent = {{10, -10}, {-10, 10}})));
  EAST.TwoPhaseFlow.Component.Valves.ValveLinear valveLinear1(redeclare package Medium = medium, use_opening_in = true) annotation(
    Placement(transformation(origin = {0, -170}, extent = {{-10, -10}, {10, 10}}, rotation = -180)));
  EAST.TwoPhaseFlow.Component.Pipes.StaticPipe sPipe42(redeclare package Medium = medium, p_a_start = p_init, p_b_start = p_init, length = 0.1, diameter = 0.1) annotation(
    Placement(transformation(origin = {-160, -38}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));
  EAST.TwoPhaseFlow.Component.Pipes.StaticPipe sPipe421(redeclare package Medium = medium, p_a_start = p_init, p_b_start = p_init) annotation(
    Placement(transformation(origin = {-160, 70}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));
  EAST.TwoPhaseFlow.Component.Pipes.StaticPipe sPipe422(redeclare package Medium = medium, p_a_start = p_init, p_b_start = p_init) annotation(
    Placement(transformation(origin = {74, -126}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));
  InvertorCoolingModule LCHpumpInvertor(p_init_pipe = p_init, redeclare package Medium = medium, T_init_pipe = T_init, T_init_module = T_init)  annotation(
    Placement(transformation(origin = {-42, -80}, extent = {{10, -10}, {-10, 10}})));
  InvertorCoolingModule LOXpumpInvertor(redeclare package Medium = medium, p_init_pipe = p_init, T_init_pipe = T_init, T_init_module = T_init, invertor_loss = 10000)  annotation(
    Placement(transformation(origin = {-44, 20}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
equation
  connect(const.y, boundary_pT.p_in) annotation(
    Line(points = {{-273, 140}, {-264, 140}, {-264, 126}, {-242, 126}}, color = {0, 0, 127}));
  connect(const1.y, boundary_pT.T_in) annotation(
    Line(points = {{-273, 94}, {-258, 94}, {-258, 114}, {-242, 114}}, color = {0, 0, 127}));
  connect(const2.y, massFlowSource_T.m_flow_in) annotation(
    Line(points = {{263, 90}, {236, 90}, {236, 66}, {226, 66}}, color = {0, 0, 127}));
  connect(massFlowSource_T.T_in, const21.y) annotation(
    Line(points = {{226, 54}, {244, 54}, {244, 38}, {261, 38}}, color = {0, 0, 127}));
  connect(dynamicPipeSegment.port_a, massFlowSource_T.port) annotation(
    Line(points = {{180, -102}, {180, 60}, {204, 60}}, color = {0, 0, 127}));
  connect(valveLinear1.port_a, tee3.port_1) annotation(
    Line(points = {{10, -170}, {64, -170}}, color = {0, 0, 127}));
  connect(const31.y, valveLinear1.opening_in) annotation(
    Line(points = {{-25, -206}, {0, -206}, {0, -182}}, color = {0, 0, 127}));
  connect(tee3.port_2, dynamicPipeSegment.port_b) annotation(
    Line(points = {{84, -170}, {180, -170}, {180, -122}}, color = {0, 0, 127}));
  connect(tee2.port_2, sPipe4.port_b) annotation(
    Line(points = {{-160, -90}, {-160, -170}, {-86, -170}}, color = {0, 0, 127}));
  connect(sPipe4.port_a, valveLinear1.port_b) annotation(
    Line(points = {{-66, -170}, {-10, -170}}, color = {0, 0, 127}));
  connect(sPipe42.port_a, tee2.port_1) annotation(
    Line(points = {{-160, -48}, {-160, -70}}, color = {0, 0, 127}));
  connect(sPipe42.port_b, tee1.port_2) annotation(
    Line(points = {{-160, -28}, {-160, 10}}, color = {0, 0, 127}));
  connect(sPipe421.port_a, tee1.port_1) annotation(
    Line(points = {{-160, 60}, {-160, 30}}, color = {0, 0, 127}));
  connect(boundary_pT.port, sPipe421.port_b) annotation(
    Line(points = {{-220, 120}, {-160, 120}, {-160, 80}}, color = {0, 0, 127}));
  connect(tee6.port_1, sPipe422.port_b) annotation(
    Line(points = {{74, -90}, {74, -116}}, color = {0, 0, 127}));
  connect(sPipe422.port_a, tee3.port_3) annotation(
    Line(points = {{74, -136}, {74, -160}}, color = {0, 0, 127}));
  connect(tee1.port_3, LOXpumpInvertor.port_b) annotation(
    Line(points = {{-150, 20}, {-54, 20}}, color = {0, 0, 127}));
  connect(LOXpumpInvertor.port_a, tee6.port_2) annotation(
    Line(points = {{-34, 20}, {74, 20}, {74, -70}}, color = {0, 0, 127}));
  connect(tee2.port_3, LCHpumpInvertor.port_b) annotation(
    Line(points = {{-150, -80}, {-52, -80}}, color = {0, 0, 127}));
  connect(LCHpumpInvertor.port_a, tee6.port_3) annotation(
    Line(points = {{-32, -80}, {64, -80}}, color = {0, 0, 127}));
  annotation(experiment(StopTime = 1000),
    Diagram(coordinateSystem(extent = {{-300, 180}, {400, -240}})));
end EPv2CoolingSystemSimple;
