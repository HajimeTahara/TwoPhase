within EAST.TwoPhaseFlow.Examples.Pipes;

model SimplePipeFriction
  extends Modelica.Icons.Example;
  replaceable package medium = EAST.TwoPhaseFlow.Media.LCH;
  parameter Real p_out=101325;
  parameter Real p_init=p_out;
  parameter Real T_in=100;
  parameter Real T_out=T_in;
  
  
  EAST.TwoPhaseFlow.Component.Sources.Boundary_pT boundary_pT(redeclare package Medium = medium, use_T_in = true, use_p_in = true) annotation(
    Placement(transformation(origin = {102, 60}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = p_out) annotation(
    Placement(transformation(origin = {152, 92}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Constant const1(k = T_out) annotation(
    Placement(transformation(origin = {152, 26}, extent = {{10, -10}, {-10, 10}})));
  EAST.TwoPhaseFlow.Component.Sources.MassFlowSource_T massFlowSource_T(redeclare package Medium = medium, T_set = 100, m_flow_set = 0.01, use_T_in = true, use_m_flow_in = true) annotation(
    Placement(transformation(origin = {-94, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const2(k = 0.1) annotation(
    Placement(transformation(origin = {-150, 100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const11(k = T_in) annotation(
    Placement(transformation(origin = {-152, 36}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.StaticPipe staticPipe(redeclare package Medium = medium, p_a_start = p_init, p_b_start = p_init)  annotation(
    Placement(transformation(origin = {-56, 60}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Junction.TeeJunction teeJunction(redeclare package Medium = medium, p_start = p_init)  annotation(
    Placement(transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.StaticPipe staticPipe1(p_a_start = p_init, p_b_start = p_init, redeclare package Medium = medium)  annotation(
    Placement(transformation(origin = {34, 100}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.StaticPipe staticPipe11(p_a_start = p_init, p_b_start = p_init, redeclare package Medium = medium)  annotation(
    Placement(transformation(origin = {42, 60}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Sources.Boundary_pT boundary_pT1(redeclare package Medium = medium, use_T_in = true, use_p_in = true) annotation(
    Placement(transformation(origin = {102, -78}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Constant const3(k = p_out) annotation(
    Placement(transformation(origin = {152, -46}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Constant const12(k = T_out) annotation(
    Placement(transformation(origin = {152, -112}, extent = {{10, -10}, {-10, 10}})));
  EAST.TwoPhaseFlow.Component.Sources.MassFlowSource_T massFlowSource_T1(redeclare package Medium = medium, T_set = 100, m_flow_set = 0.01, use_T_in = true, use_m_flow_in = true) annotation(
    Placement(transformation(origin = {-94, -78}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const21(k = 0.1) annotation(
    Placement(transformation(origin = {-150, -38}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const111(k = T_in) annotation(
    Placement(transformation(origin = {-152, -102}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Junction.TeeJunction teeJunction1(redeclare package Medium = medium, p_start = p_init) annotation(
    Placement(transformation(origin = {0, -78}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.StaticPipe staticPipe12(redeclare package Medium = medium, p_a_start = p_init, p_b_start = p_init) annotation(
    Placement(transformation(origin = {34, -38}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.StaticPipe staticPipe111(redeclare package Medium = medium, p_a_start = p_init, p_b_start = p_init) annotation(
    Placement(transformation(origin = {42, -78}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment dynamicPipeSegment(p_start = p_init, use_HeatTransfer = false, h_start = medium.specificEnthalpy_pT(p_init, T_in), redeclare package Medium = medium)  annotation(
    Placement(transformation(origin = {-48, -78}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(const1.y, boundary_pT.T_in) annotation(
    Line(points = {{141, 26}, {130.5, 26}, {130.5, 54}, {114, 54}}, color = {0, 0, 127}));
  connect(boundary_pT.p_in, const.y) annotation(
    Line(points = {{114, 66}, {132, 66}, {132, 92}, {141, 92}}, color = {0, 0, 127}));
  connect(const2.y, massFlowSource_T.m_flow_in) annotation(
    Line(points = {{-139, 100}, {-127, 100}, {-127, 66}, {-107, 66}}, color = {0, 0, 127}));
  connect(const11.y, massFlowSource_T.T_in) annotation(
    Line(points = {{-141, 36}, {-125, 36}, {-125, 54}, {-107, 54}}, color = {0, 0, 127}));
  connect(massFlowSource_T.port, staticPipe.port_a) annotation(
    Line(points = {{-84, 60}, {-66, 60}}, color = {0, 0, 127}));
  connect(staticPipe.port_b, teeJunction.port_1) annotation(
    Line(points = {{-46, 60}, {-10, 60}}, color = {0, 0, 127}));
  connect(teeJunction.port_3, staticPipe1.port_a) annotation(
    Line(points = {{0, 70}, {0, 100}, {24, 100}}, color = {0, 0, 127}));
  connect(teeJunction.port_2, staticPipe11.port_a) annotation(
    Line(points = {{10, 60}, {32, 60}}, color = {0, 0, 127}));
  connect(staticPipe11.port_b, boundary_pT.port) annotation(
    Line(points = {{52, 60}, {92, 60}}, color = {0, 0, 127}));
  connect(staticPipe1.port_b, boundary_pT.port) annotation(
    Line(points = {{44, 100}, {74, 100}, {74, 60}, {92, 60}}, color = {0, 0, 127}));
  connect(const12.y, boundary_pT1.T_in) annotation(
    Line(points = {{141, -112}, {130.5, -112}, {130.5, -84}, {114, -84}}, color = {0, 0, 127}));
  connect(boundary_pT1.p_in, const3.y) annotation(
    Line(points = {{114, -72}, {132, -72}, {132, -46}, {141, -46}}, color = {0, 0, 127}));
  connect(const21.y, massFlowSource_T1.m_flow_in) annotation(
    Line(points = {{-139, -38}, {-127, -38}, {-127, -72}, {-107, -72}}, color = {0, 0, 127}));
  connect(const111.y, massFlowSource_T1.T_in) annotation(
    Line(points = {{-141, -102}, {-125, -102}, {-125, -84}, {-107, -84}}, color = {0, 0, 127}));
  connect(teeJunction1.port_3, staticPipe12.port_a) annotation(
    Line(points = {{0, -68}, {0, -38}, {24, -38}}, color = {0, 0, 127}));
  connect(teeJunction1.port_2, staticPipe111.port_a) annotation(
    Line(points = {{10, -78}, {32, -78}}, color = {0, 0, 127}));
  connect(staticPipe111.port_b, boundary_pT1.port) annotation(
    Line(points = {{52, -78}, {92, -78}}, color = {0, 0, 127}));
  connect(staticPipe12.port_b, boundary_pT1.port) annotation(
    Line(points = {{44, -38}, {74, -38}, {74, -78}, {92, -78}}, color = {0, 0, 127}));
  connect(massFlowSource_T1.port, dynamicPipeSegment.port_a) annotation(
    Line(points = {{-84, -78}, {-58, -78}}, color = {0, 0, 127}));
  connect(dynamicPipeSegment.port_b, teeJunction1.port_1) annotation(
    Line(points = {{-38, -78}, {-10, -78}}, color = {0, 0, 127}));
  annotation(experiment(StopTime = 2),
    Diagram(coordinateSystem(extent = {{-180, 120}, {180, -140}})));
end SimplePipeFriction;
