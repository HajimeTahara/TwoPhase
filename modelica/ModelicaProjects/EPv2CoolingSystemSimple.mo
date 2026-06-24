within ModelicaProjects;

model EPv2CoolingSystemSimple

parameter Real p_system_in=0.55*10^6"Pa";
parameter Real p_system_out=0.1*10^6"Pa";
parameter Real T_system_in=100"K";
parameter Real T_system_out=100"K";

  replaceable package medium = EAST.TwoPhaseFlow.Media.LCH;
  EAST.TwoPhaseFlow.Component.Sources.Boundary_pT boundary_pT(use_p_in = true, use_T_in = true, redeclare package Medium = medium)  annotation(
    Placement(transformation(origin = {-230, 120}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = p_system_in)  annotation(
    Placement(transformation(origin = {-284, 140}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const1(k = T_system_in)  annotation(
    Placement(transformation(origin = {-284, 94}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment dynamicPipeSegment(redeclare package Medium = medium, use_HeatTransfer = false, p_start = p_system_in, h_start = medium.specificEnthalpy_pT(p_system_in, T_system_in))  annotation(
    Placement(transformation(origin = {178, -134}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.TwoPhaseFlow.Component.Valves.ValveLinear valveLinear1(use_opening_in = true, redeclare package Medium = medium) annotation(
    Placement(transformation(origin = {134, -170}, extent = {{-10, -10}, {10, 10}}, rotation = -180)));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment dynamicPipeSegment3(redeclare package Medium = medium, use_HeatTransfer = false, p_start= p_system_in, h_start = medium.specificEnthalpy_pT(p_system_in, T_system_in)) annotation(
    Placement(transformation(origin = {-34, -80}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment dynamicPipeSegment31(redeclare package Medium = medium, use_HeatTransfer = false, p_start = p_system_in, h_start = medium.specificEnthalpy_pT(p_system_in, T_system_in)) annotation(
    Placement(transformation(origin = {-38, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const31(k = 1)  annotation(
    Placement(transformation(origin = {70, -220}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Junction.TeeJunction tee1(redeclare package Medium = medium, p_start = p_system_in) annotation(
    Placement(transformation(origin = {-160, 20}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.TwoPhaseFlow.Component.Junction.TeeJunction tee2(redeclare package Medium = medium, p_start = p_system_in) annotation(
    Placement(transformation(origin = {-160, -80}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.TwoPhaseFlow.Component.Junction.TeeJunction tee3(redeclare package Medium = medium, p_start = p_system_in) annotation(
    Placement(transformation(origin = {74, -170}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.StaticPipe sPipe4(redeclare package Medium = medium, p_a_start = p_system_in) annotation(
    Placement(transformation(origin = {-32, -170}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Junction.TeeJunction tee6(redeclare package Medium = medium, p_start = p_system_in) annotation(
    Placement(transformation(origin = {74, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  EAST.TwoPhaseFlow.Component.Sources.MassFlowSource_T massFlowSource_T(use_m_flow_in = false, use_T_in = false, T_set(displayUnit = "K") = 100, m_flow_set = 0.01, redeclare package Medium = medium)  annotation(
    Placement(transformation(origin = {98, 126}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(const.y, boundary_pT.p_in) annotation(
    Line(points = {{-273, 140}, {-264, 140}, {-264, 126}, {-242, 126}}, color = {0, 0, 127}));
  connect(const1.y, boundary_pT.T_in) annotation(
    Line(points = {{-273, 94}, {-258, 94}, {-258, 114}, {-242, 114}}, color = {0, 0, 127}));
  connect(valveLinear1.port_a, dynamicPipeSegment.port_b) annotation(
    Line(points = {{144, -170}, {178, -170}, {178, -144}}, color = {0, 0, 127}));
  connect(const31.y, valveLinear1.opening_in) annotation(
    Line(points = {{81, -220}, {134, -220}, {134, -182}}, color = {0, 0, 127}));
  connect(tee3.port_2, valveLinear1.port_b) annotation(
    Line(points = {{84, -170}, {124, -170}}, color = {0, 0, 127}));
  connect(sPipe4.port_b, tee3.port_1) annotation(
    Line(points = {{-22, -170}, {64, -170}}, color = {0, 0, 127}));
  connect(tee2.port_2, sPipe4.port_a) annotation(
    Line(points = {{-160, -90}, {-160, -170}, {-42, -170}}, color = {0, 0, 127}));
  connect(tee2.port_3, dynamicPipeSegment3.port_a) annotation(
    Line(points = {{-150, -80}, {-44, -80}}, color = {0, 0, 127}));
  connect(tee1.port_2, tee2.port_1) annotation(
    Line(points = {{-160, 10}, {-160, -70}}, color = {0, 0, 127}));
  connect(tee1.port_3, dynamicPipeSegment31.port_a) annotation(
    Line(points = {{-150, 20}, {-48, 20}}, color = {0, 0, 127}));
  connect(dynamicPipeSegment3.port_b, tee6.port_3) annotation(
    Line(points = {{-24, -80}, {64, -80}}, color = {0, 0, 127}));
  connect(tee6.port_1, tee3.port_3) annotation(
    Line(points = {{74, -90}, {74, -160}}, color = {0, 0, 127}));
  connect(dynamicPipeSegment31.port_b, tee6.port_2) annotation(
    Line(points = {{-28, 20}, {74, 20}, {74, -70}}, color = {0, 0, 127}));
  connect(boundary_pT.port, tee1.port_1) annotation(
    Line(points = {{-220, 120}, {-160, 120}, {-160, 30}}, color = {0, 0, 127}));
  connect(massFlowSource_T.port, dynamicPipeSegment.port_a) annotation(
    Line(points = {{108, 126}, {178, 126}, {178, -124}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-300, 180}, {400, -240}})));
end EPv2CoolingSystemSimple;
