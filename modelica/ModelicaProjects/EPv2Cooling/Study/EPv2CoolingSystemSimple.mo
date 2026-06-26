within ModelicaProjects.EPv2Cooling.Study;

model EPv2CoolingSystemSimple
  extends Modelica.Icons.Example;
  import Modelica.Units.SI;
  replaceable package medium = EAST.TwoPhaseFlow.Media.LCH_FD;
  parameter SI.Pressure p_out = 0.55*10^6;
  parameter SI.Temperature T_in = 100;
  parameter SI.Pressure p_init_pipe = p_out;
  parameter SI.Temperature T_init_pipe = T_in;
  parameter SI.Temperature T_init_motor = T_in;
  parameter SI.Temperature T_init_module = 20+273.15;
  final parameter SI.Temperature T_out = T_in;
  final parameter SI.Temperature T_init = T_in;
  final parameter SI.Pressure p_init = p_out;
  EAST.TwoPhaseFlow.Component.Sources.Boundary_pT boundary_pT(use_p_in = true, use_T_in = true, redeclare package Medium = medium) annotation(
    Placement(transformation(origin = {-250, -54}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = p_out) annotation(
    Placement(transformation(origin = {-304, -34}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const1(k = T_out) annotation(
    Placement(transformation(origin = {-304, -80}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Junction.TeeJunction tee6(redeclare package Medium = medium, p_start = p_init_pipe) annotation(
    Placement(transformation(origin = {40, -104}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  EAST.TwoPhaseFlow.Component.Sources.MassFlowSource_T massFlowSource_T(use_m_flow_in = true, use_T_in = true, T_set = 100, m_flow_set = 0.01, redeclare package Medium = medium) annotation(
    Placement(transformation(origin = {318, -270}, extent = {{-10, 10}, {10, -10}}, rotation = -180)));
  Modelica.Blocks.Sources.Constant const21(k = T_in) annotation(
    Placement(transformation(origin = {376, -292}, extent = {{10, -10}, {-10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.StaticPipe sPipe422(redeclare package Medium = medium, p_a_start = p_init_pipe, p_b_start = p_init_pipe) annotation(
    Placement(transformation(origin = {40, -150}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));
  ModelicaProjects.EPv2Cooling.Component.InvertorCoolingModule LCHpumpInvertor(p_init_pipe = p_init_pipe, redeclare package Medium = medium, T_init_pipe = T_init_pipe, T_init_module = T_init_module) annotation(
    Placement(transformation(origin = {-74, -98}, extent = {{20, -20}, {-20, 20}})));
  ModelicaProjects.EPv2Cooling.Component.InvertorCoolingModule LOXpumpInvertor(redeclare package Medium = medium, p_init_pipe = p_init_pipe, T_init_pipe = T_init_pipe, T_init_module = T_init_module) annotation(
    Placement(transformation(origin = {-75, -3}, extent = {{19, -19}, {-19, 19}})));
  Component.MotorCoolingModule motorCoolingModule(redeclare package Medium = medium, p_init_pipe = p_init_pipe, T_init_pipe = T_init_pipe, T_init_motor = T_init_motor) annotation(
    Placement(transformation(origin = {218, -270}, extent = {{30, -30}, {-30, 30}})));
  Modelica.Blocks.Sources.CombiTimeTable updownRpmTableLOX(columns = {2}, table = [0.0, 0; 0.5, 0; 0.8, 10000; 1.0, 10000; 2.5, 60000; 63.0, 60000; 64.6, 23700; 124.3, 23700; 125.6, 60000; 180, 60000]) annotation(
    Placement(transformation(origin = {606, 88}, extent = {{10, -10}, {-10, 10}})));
  EAST.Blocks.Routing.ExtractScalar extractScalar annotation(
    Placement(transformation(origin = {566, 88}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.CombiTimeTable updownRpmTableLCH(columns = {2}, table = [0.0, 0; 0.5, 0; 0.8, 10000; 1.0, 10000; 2.5, 65000; 63.0, 65000; 64.6, 20000; 124.3, 20000; 125.6, 65000; 180, 65000]) annotation(
    Placement(transformation(origin = {-382, -206}, extent = {{-10, -10}, {10, 10}})));
  EAST.Blocks.Routing.ExtractScalar extractScalar1 annotation(
    Placement(transformation(origin = {-334, -206}, extent = {{-10, -10}, {10, 10}})));
  Component.ProfileGenerator profileGenerator annotation(
    Placement(transformation(origin = {484, 88}, extent = {{20, -20}, {-20, 20}})));
  ModelicaProjects.EPv2Cooling.Component.ProfileGenerator profileGenerator1(rpm_to_torque_a2 = 0.287, rpm_to_torque_a1 = 7e-15) annotation(
    Placement(transformation(origin = {-258, -206}, extent = {{-20, -20}, {20, 20}})));
  EAST.Blocks.Math.MultiplyParameter multiplyParameter(k = 0.4) annotation(
    Placement(transformation(origin = {356, 26}, extent = {{10, -10}, {-10, 10}})));
  EAST.Blocks.Math.MultiplyParameter multiplyParameter1(k = 0.6) annotation(
    Placement(transformation(origin = {414, -12}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Math.Add add annotation(
    Placement(transformation(origin = {316, 6}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Math.Add add1(k2 = -1) annotation(
    Placement(transformation(origin = {582, -74}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Math.Product product annotation(
    Placement(transformation(origin = {358, -18}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Constant const3(k = 293.15) annotation(
    Placement(transformation(origin = {658, -80}, extent = {{10, -10}, {-10, 10}})));
  EAST.Blocks.Math.MultiplyParameter multiplyParameter2(k = 0.0038) annotation(
    Placement(transformation(origin = {462, -74}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Constant const31(k = 1) annotation(
    Placement(transformation(origin = {522, 0}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Math.Add add11 annotation(
    Placement(transformation(origin = {418, -44}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = 1e+10, uMin = 200 - 293.15) annotation(
    Placement(transformation(origin = {514, -74}, extent = {{10, -10}, {-10, 10}})));
  Component.Real3ToArray real3ToArray annotation(
    Placement(transformation(origin = {256, -180}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Constant const22(k = 0) annotation(
    Placement(transformation(origin = {310, -188}, extent = {{10, -10}, {-10, 10}})));
  EAST.Blocks.Math.DivideParameter divideParameter1(k = 10000) annotation(
    Placement(transformation(origin = {-290, -278}, extent = {{-10, -10}, {10, 10}})));
  EAST.Blocks.Math.Polynomial pnLOXtorque(a0 = 0, a1 = 0.0009, a2 = 3E-11, polynomialType = EAST.Blocks.Types.PolynomialType.Quadratic) annotation(
    Placement(transformation(origin = {-238, -332}, extent = {{-10, -10}, {10, 10}})));
  EAST.Blocks.Math.MultiplyParameter multiplyParameter21(k = 420*0.06) annotation(
    Placement(transformation(origin = {-180, -332}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax = 1e+10, uMin = 0.01) annotation(
    Placement(transformation(origin = {-124, -332}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(const.y, boundary_pT.p_in) annotation(
    Line(points = {{-293, -34}, {-284, -34}, {-284, -48}, {-262, -48}}, color = {0, 0, 127}));
  connect(const1.y, boundary_pT.T_in) annotation(
    Line(points = {{-293, -80}, {-278, -80}, {-278, -60}, {-262, -60}}, color = {0, 0, 127}));
  connect(massFlowSource_T.T_in, const21.y) annotation(
    Line(points = {{330, -276}, {348, -276}, {348, -292}, {365, -292}}, color = {0, 0, 127}));
  connect(tee6.port_1, sPipe422.port_b) annotation(
    Line(points = {{40, -114}, {40, -140}}, color = {0, 0, 127}));
  connect(LOXpumpInvertor.port_a, tee6.port_2) annotation(
    Line(points = {{-56, -3}, {38, -3}, {38, -94}, {40, -94}}, color = {0, 0, 127}));
  connect(LCHpumpInvertor.port_a, tee6.port_3) annotation(
    Line(points = {{-54, -98}, {-54, -104}, {30, -104}}, color = {0, 0, 127}));
  connect(boundary_pT.port, LOXpumpInvertor.port_b) annotation(
    Line(points = {{-240, -54}, {-166, -54}, {-166, -3}, {-94, -3}}, color = {0, 0, 127}));
  connect(boundary_pT.port, LCHpumpInvertor.port_b) annotation(
    Line(points = {{-240, -54}, {-166, -54}, {-166, -98}, {-94, -98}}, color = {0, 0, 127}));
  connect(sPipe422.port_a, motorCoolingModule.port_b) annotation(
    Line(points = {{40, -160}, {42, -160}, {42, -270}, {188, -270}}, color = {0, 0, 127}));
  connect(motorCoolingModule.port_a, massFlowSource_T.port) annotation(
    Line(points = {{248, -270}, {308, -270}}, color = {0, 0, 127}));
  connect(updownRpmTableLOX.y, extractScalar.u) annotation(
    Line(points = {{595, 88}, {578, 88}}, color = {0, 0, 127}, thickness = 0.5));
  connect(extractScalar1.u, updownRpmTableLCH.y) annotation(
    Line(points = {{-346, -206}, {-371, -206}}, color = {0, 0, 127}, thickness = 0.5));
  connect(profileGenerator.u, extractScalar.y) annotation(
    Line(points = {{508, 88}, {556, 88}}, color = {0, 0, 127}));
  connect(profileGenerator1.u, extractScalar1.y) annotation(
    Line(points = {{-282, -206}, {-323, -206}}, color = {0, 0, 127}));
  connect(LOXpumpInvertor.q, profileGenerator.invertorLoss) annotation(
    Line(points = {{-75, 14.1}, {-75, 96.1}, {461, 96.1}}, color = {0, 0, 127}));
  connect(profileGenerator1.invertorLoss, LCHpumpInvertor.q) annotation(
    Line(points = {{-236, -198}, {-122, -198}, {-122, -65.6}, {-74, -65.6}, {-74, -79.6}}, color = {0, 0, 127}));
  connect(add.u1, multiplyParameter.y) annotation(
    Line(points = {{328, 12}, {334, 12}, {334, 26}, {346, 26}}, color = {0, 0, 127}));
  connect(add1.u2, const3.y) annotation(
    Line(points = {{594, -80}, {647, -80}}, color = {0, 0, 127}));
  connect(add11.u2, multiplyParameter2.y) annotation(
    Line(points = {{430, -50}, {442, -50}, {442, -74}, {452, -74}}, color = {0, 0, 127}));
  connect(add11.u1, const31.y) annotation(
    Line(points = {{430, -38}, {467, -38}, {467, 0}, {511, 0}}, color = {0, 0, 127}));
  connect(add.u2, product.y) annotation(
    Line(points = {{328, 0}, {334, 0}, {334, -18}, {347, -18}}, color = {0, 0, 127}));
  connect(product.u1, multiplyParameter1.y) annotation(
    Line(points = {{370, -12}, {404, -12}}, color = {0, 0, 127}));
  connect(product.u2, add11.y) annotation(
    Line(points = {{370, -24}, {390, -24}, {390, -44}, {408, -44}}, color = {0, 0, 127}));
  connect(multiplyParameter2.u, limiter.y) annotation(
    Line(points = {{474, -74}, {504, -74}}, color = {0, 0, 127}));
  connect(limiter.u, add1.y) annotation(
    Line(points = {{526, -74}, {572, -74}}, color = {0, 0, 127}));
  connect(multiplyParameter.u, profileGenerator.motorLoss) annotation(
    Line(points = {{368, 26}, {420, 26}, {420, 80}, {462, 80}}, color = {0, 0, 127}));
  connect(multiplyParameter1.u, profileGenerator.motorLoss) annotation(
    Line(points = {{426, -12}, {440, -12}, {440, 80}, {462, 80}}, color = {0, 0, 127}));
  connect(motorCoolingModule.u, real3ToArray.y) annotation(
    Line(points = {{218, -240}, {218, -180}, {245, -180}}, color = {0, 0, 127}, thickness = 0.5));
  connect(real3ToArray.u2, const22.y) annotation(
    Line(points = {{268, -180}, {282, -180}, {282, -188}, {300, -188}}, color = {0, 0, 127}));
  connect(real3ToArray.u3, const22.y) annotation(
    Line(points = {{268, -188}, {300, -188}}, color = {0, 0, 127}));
  connect(motorCoolingModule.coilTemperature, add1.u1) annotation(
    Line(points = {{190.4, -246}, {190.4, -144}, {614.4, -144}, {614.4, -68}, {594.4, -68}}, color = {0, 0, 127}));
  connect(real3ToArray.u1, add.y) annotation(
    Line(points = {{268, -172}, {284, -172}, {284, 6}, {306, 6}}, color = {0, 0, 127}));
  connect(pnLOXtorque.u, divideParameter1.y) annotation(
    Line(points = {{-250, -332}, {-262.5, -332}, {-262.5, -278}, {-279, -278}}, color = {0, 0, 127}));
  connect(extractScalar1.y, divideParameter1.u) annotation(
    Line(points = {{-323, -206}, {-315, -206}, {-315, -278}, {-303, -278}}, color = {0, 0, 127}));
  connect(pnLOXtorque.y, multiplyParameter21.u) annotation(
    Line(points = {{-227, -332}, {-192, -332}}, color = {0, 0, 127}));
  connect(multiplyParameter21.y, limiter1.u) annotation(
    Line(points = {{-169, -332}, {-137, -332}}, color = {0, 0, 127}));
  connect(limiter1.y, massFlowSource_T.m_flow_in) annotation(
    Line(points = {{-113, -332}, {406, -332}, {406, -264}, {330, -264}}, color = {0, 0, 127}));
  annotation(
    experiment(StopTime = 1000),
    Diagram(coordinateSystem(extent = {{-320, 100}, {700, -320}}), graphics = {Text(origin = {632, 88}, extent = {{-14, 8}, {14, -8}}, textString = "LOX"), Text(origin = {-282, -146}, extent = {{-14, 8}, {14, -8}}, textString = "LCH"), Text(origin = {539, 97}, extent = {{-13, 5}, {13, -5}}, textString = "rpm"), Text(origin = {-333, -221}, extent = {{-13, 5}, {13, -5}}, textString = "rpm"), Text(origin = {516, -52}, extent = {{-14, 6}, {14, -6}}, textString = "200K以下でsaturation"), Text(origin = {661, -106}, extent = {{-29, 6}, {29, -6}}, textString = "基準温度(20degC)")}));
end EPv2CoolingSystemSimple;
