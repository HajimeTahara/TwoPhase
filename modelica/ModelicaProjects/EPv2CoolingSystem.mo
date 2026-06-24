within ModelicaProjects;

model EPv2CoolingSystem

parameter Real p_system_in=8.0*10^6"Pa";
parameter Real p_system_out=0.55*10^5"Pa";
parameter Real T_system_in=90"K";
parameter Real T_system_out=90"K";

  replaceable package medium = EAST.TwoPhaseFlow.Media.LCH;
  EAST.TwoPhaseFlow.Component.Sources.Boundary_pT boundary_pT(use_p_in = true, use_T_in = true, redeclare package Medium = medium)  annotation(
    Placement(transformation(origin = {-12, 48}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = p_system_in)  annotation(
    Placement(transformation(origin = {-90, 74}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const1(k = T_system_in)  annotation(
    Placement(transformation(origin = {-84, 28}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Sources.Boundary_pT boundary_pT1(redeclare package Medium = medium, use_T_in = true, use_p_in = true) annotation(
    Placement(transformation(origin = {-72, -66}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const2(k = p_system_out) annotation(
    Placement(transformation(origin = {-112, -30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const11(k = T_system_out) annotation(
    Placement(transformation(origin = {-108, -82}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment dynamicPipeSegment(redeclare package Medium = medium)  annotation(
    Placement(transformation(origin = {12, -22}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(boundary_pT.port, dynamicPipeSegment.port_b) annotation(
    Line(points = {{-2, 48}, {22, 48}, {22, -22}}, color = {0, 0, 127}));
  connect(dynamicPipeSegment.port_a, boundary_pT1.port) annotation(
    Line(points = {{2, -22}, {-62, -22}, {-62, -66}}, color = {0, 0, 127}));
  connect(const2.y, boundary_pT1.p_in) annotation(
    Line(points = {{-100, -30}, {-84, -30}, {-84, -60}}, color = {0, 0, 127}));
  connect(boundary_pT1.T_in, const11.y) annotation(
    Line(points = {{-84, -72}, {-96, -72}, {-96, -82}}, color = {0, 0, 127}));
  connect(const1.y, boundary_pT.T_in) annotation(
    Line(points = {{-73, 28}, {-24, 28}, {-24, 42}}, color = {0, 0, 127}));
  connect(boundary_pT.p_in, const.y) annotation(
    Line(points = {{-24, 54}, {-79, 54}, {-79, 74}}, color = {0, 0, 127}));  end EPv2CoolingSystem;
