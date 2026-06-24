within ModelicaProjects;

model EPv2CoolingSystem_simple

parameter Real p_system_in=0.55*10^6"Pa";
parameter Real p_system_out=0.1*10^6"Pa";
parameter Real T_system_in=90"K";
parameter Real T_system_out=90"K";

  replaceable package medium = EAST.TwoPhaseFlow.Media.LCH;
  EAST.TwoPhaseFlow.Component.Sources.Boundary_pT boundary_pT(use_p_in = true, use_T_in = true, redeclare package Medium = medium)  annotation(
    Placement(transformation(origin = {-230, 120}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = p_system_in)  annotation(
    Placement(transformation(origin = {-284, 140}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const1(k = T_system_in)  annotation(
    Placement(transformation(origin = {-284, 94}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Sources.Boundary_pT boundary_pT2(redeclare package Medium = medium, use_T_in = true, use_p_in = true) annotation(
    Placement(transformation(origin = {298, 20}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Constant const2(k = p_system_in) annotation(
    Placement(transformation(origin = {376, 50}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Constant const11(k = T_system_in) annotation(
    Placement(transformation(origin = {378, -12}, extent = {{10, -10}, {-10, 10}})));
equation
  connect(const.y, boundary_pT.p_in) annotation(
    Line(points = {{-273, 140}, {-264, 140}, {-264, 126}, {-242, 126}}, color = {0, 0, 127}));
  connect(const1.y, boundary_pT.T_in) annotation(
    Line(points = {{-273, 94}, {-258, 94}, {-258, 114}, {-242, 114}}, color = {0, 0, 127}));
  connect(boundary_pT2.p_in, const2.y) annotation(
    Line(points = {{310, 26}, {322, 26}, {322, 50}, {365, 50}}, color = {0, 0, 127}));
  connect(boundary_pT2.T_in, const11.y) annotation(
    Line(points = {{310, 14}, {324, 14}, {324, -12}, {367, -12}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-300, 180}, {400, -240}})));
end EPv2CoolingSystem_simple;
