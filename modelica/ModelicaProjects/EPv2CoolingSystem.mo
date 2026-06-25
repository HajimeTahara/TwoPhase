within ModelicaProjects;

model EPv2CoolingSystem
extends Modelica.Icons.Example;
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
  EAST.TwoPhaseFlow.Component.Pumps.Pump pump(redeclare package Medium = medium)  annotation(
    Placement(transformation(origin = {92, 120}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Valves.ValveLinear valveLinear(use_opening_in = true, redeclare package Medium = medium)  annotation(
    Placement(transformation(origin = {178, -84}, extent = {{10, 10}, {-10, -10}}, rotation = 90)));
  EAST.TwoPhaseFlow.Component.Sources.Boundary_pT boundary_pT2(redeclare package Medium = medium, use_T_in = true, use_p_in = true) annotation(
    Placement(transformation(origin = {298, 20}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Constant const2(k = p_system_in) annotation(
    Placement(transformation(origin = {376, 50}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Constant const11(k = T_system_in) annotation(
    Placement(transformation(origin = {378, -12}, extent = {{10, -10}, {-10, 10}})));
  EAST.TwoPhaseFlow.Component.Valves.ValveLinear valveLinear1(use_opening_in = true, redeclare package Medium = medium) annotation(
    Placement(transformation(origin = {134, -170}, extent = {{-10, -10}, {10, 10}}, rotation = -180)));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment dynamicPipeSegment3(redeclare package Medium = medium, use_HeatTransfer = false, p_start= p_system_in, h_start = medium.specificEnthalpy_pT(p_system_in, T_system_in)) annotation(
    Placement(transformation(origin = {-34, -80}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment dynamicPipeSegment31(redeclare package Medium = medium, use_HeatTransfer = false, p_start= p_system_in, h_start = medium.specificEnthalpy_pT(p_system_in, T_system_in)) annotation(
    Placement(transformation(origin = {-38, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const3(k = 1)  annotation(
    Placement(transformation(origin = {234, -84}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Constant const31(k = 1)  annotation(
    Placement(transformation(origin = {70, -220}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Junction.TeeJunction tee1(redeclare package Medium = medium) annotation(
    Placement(transformation(origin = {-160, 20}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.TwoPhaseFlow.Component.Junction.TeeJunction tee2(redeclare package Medium = medium) annotation(
    Placement(transformation(origin = {-160, -80}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.TwoPhaseFlow.Component.Junction.TeeJunction tee3(redeclare package Medium = medium) annotation(
    Placement(transformation(origin = {74, -170}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Junction.TeeJunction tee4(redeclare package Medium = medium)  annotation(
    Placement(transformation(origin = {178, 20}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.TwoPhaseFlow.Component.Junction.TeeJunction tee5(redeclare package Medium = medium)  annotation(
    Placement(transformation(origin = {-160, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  EAST.TwoPhaseFlow.Component.Pipes.StaticPipe sPipe1(redeclare package Medium = medium, frictionCorrelation = EAST.TwoPhaseFlow.Component.Pipes.FrictionCorrelation.Blasius, p_a_start = p_system_in)  annotation(
    Placement(transformation(origin = {-48, 120}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.StaticPipe sPipe2(redeclare package Medium = medium, p_a_start = p_system_in)  annotation(
    Placement(transformation(origin = {178, 74}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.TwoPhaseFlow.Component.Pipes.StaticPipe sPipe3(redeclare package Medium = medium, p_a_start = p_system_in)  annotation(
    Placement(transformation(origin = {178, -38}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.TwoPhaseFlow.Component.Pipes.StaticPipe sPipe4(redeclare package Medium = medium, p_a_start = p_system_in) annotation(
    Placement(transformation(origin = {-32, -170}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Junction.TeeJunction tee6(redeclare package Medium = medium) annotation(
    Placement(transformation(origin = {74, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Mechanics.Rotational.Sources.ConstantSpeed constantSpeed(w_fixed(displayUnit = "rpm") = 157.07963267948966)  annotation(
    Placement(transformation(origin = {64, 160}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(const.y, boundary_pT.p_in) annotation(
    Line(points = {{-273, 140}, {-264, 140}, {-264, 126}, {-242, 126}}, color = {0, 0, 127}));
  connect(const1.y, boundary_pT.T_in) annotation(
    Line(points = {{-273, 94}, {-258, 94}, {-258, 114}, {-242, 114}}, color = {0, 0, 127}));
  connect(boundary_pT2.p_in, const2.y) annotation(
    Line(points = {{310, 26}, {322, 26}, {322, 50}, {365, 50}}, color = {0, 0, 127}));
  connect(boundary_pT2.T_in, const11.y) annotation(
    Line(points = {{310, 14}, {324, 14}, {324, -12}, {367, -12}}, color = {0, 0, 127}));
  connect(valveLinear.port_b, dynamicPipeSegment.port_a) annotation(
    Line(points = {{178, -94}, {178, -124}}, color = {0, 0, 127}));
  connect(valveLinear1.port_a, dynamicPipeSegment.port_b) annotation(
    Line(points = {{144, -170}, {178, -170}, {178, -144}}, color = {0, 0, 127}));
  connect(const3.y, valveLinear.opening_in) annotation(
    Line(points = {{223, -84}, {190, -84}}, color = {0, 0, 127}));
  connect(const31.y, valveLinear1.opening_in) annotation(
    Line(points = {{81, -220}, {134, -220}, {134, -182}}, color = {0, 0, 127}));
  connect(boundary_pT.port, tee5.port_2) annotation(
    Line(points = {{-220, 120}, {-170, 120}}, color = {0, 0, 127}));
  connect(tee5.port_1, sPipe1.port_a) annotation(
    Line(points = {{-150, 120}, {-58, 120}}, color = {0, 0, 127}));
  connect(sPipe1.port_b, pump.port_a) annotation(
    Line(points = {{-38, 120}, {82, 120}}, color = {0, 0, 127}));
  connect(pump.port_b, sPipe2.port_a) annotation(
    Line(points = {{102, 120}, {178, 120}, {178, 84}}, color = {0, 0, 127}));
  connect(sPipe2.port_b, tee4.port_1) annotation(
    Line(points = {{178, 64}, {178, 30}}, color = {0, 0, 127}));
  connect(tee4.port_3, boundary_pT2.port) annotation(
    Line(points = {{188, 20}, {288, 20}}, color = {0, 0, 127}));
  connect(tee4.port_2, sPipe3.port_a) annotation(
    Line(points = {{178, 10}, {178, -28}}, color = {0, 0, 127}));
  connect(sPipe3.port_b, valveLinear.port_a) annotation(
    Line(points = {{178, -48}, {178, -74}}, color = {0, 0, 127}));
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
  connect(tee5.port_3, tee1.port_1) annotation(
    Line(points = {{-160, 110}, {-160, 30}}, color = {0, 0, 127}));
  connect(dynamicPipeSegment3.port_b, tee6.port_3) annotation(
    Line(points = {{-24, -80}, {64, -80}}, color = {0, 0, 127}));
  connect(tee6.port_1, tee3.port_3) annotation(
    Line(points = {{74, -90}, {74, -160}}, color = {0, 0, 127}));
  connect(dynamicPipeSegment31.port_b, tee6.port_2) annotation(
    Line(points = {{-28, 20}, {74, 20}, {74, -70}}, color = {0, 0, 127}));
  connect(constantSpeed.flange, pump.shaft) annotation(
    Line(points = {{74, 160}, {92, 160}, {92, 130}}));
  annotation(
    Diagram(coordinateSystem(extent = {{-300, 180}, {400, -240}})));
end EPv2CoolingSystem;
