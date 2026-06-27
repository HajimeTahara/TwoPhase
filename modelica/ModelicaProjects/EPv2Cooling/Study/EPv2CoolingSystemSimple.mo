within ModelicaProjects.EPv2Cooling.Study;

model EPv2CoolingSystemSimple
  extends Modelica.Icons.Example;
  import Modelica.Units.SI;
  replaceable package medium = EAST.TwoPhaseFlow.Media.LCH_FD;
  parameter SI.Pressure p_out = 0.55*10^6 annotation(HideResult = true);
  parameter SI.Temperature T_in = 100 annotation(HideResult = true);
  parameter SI.Pressure p_init_pipe = p_out annotation(HideResult = true);
  parameter SI.Temperature T_init_pipe = T_in annotation(HideResult = true);
  parameter SI.Temperature T_init_motor = T_in annotation(HideResult = true);
  parameter SI.Temperature T_init_module = 20 + 273.15 annotation(HideResult = true);
  final parameter SI.Temperature T_out = T_in annotation(HideResult = true);
  final parameter SI.Temperature T_init = T_in annotation(HideResult = true);
  final parameter SI.Pressure p_init = p_out annotation(HideResult = true);
  EAST.TwoPhaseFlow.Component.Sources.Boundary_pT boundary_pT(use_p_in = true, use_T_in = true, redeclare package Medium = medium) annotation(
    Placement(transformation(origin = {-250, -54}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = p_out) annotation(
    HideResult = true,
    Placement(transformation(origin = {-304, -34}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const1(k = T_out) annotation(
        HideResult = true,
    Placement(transformation(origin = {-304, -80}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Junction.TeeJunction teePipe(redeclare package Medium = medium, p_start = p_init_pipe) annotation(
    Placement(transformation(origin = {40, -104}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  EAST.TwoPhaseFlow.Component.Sources.MassFlowSource_T massFlowSource_T(use_m_flow_in = true, use_T_in = true, T_set = 100, m_flow_set = 0.01, redeclare package Medium = medium) annotation(
    Placement(transformation(origin = {318, -270}, extent = {{-10, 10}, {10, -10}}, rotation = -180)));
  Modelica.Blocks.Sources.Constant const21(k = T_in) annotation(
        HideResult = true,
    Placement(transformation(origin = {384, -276}, extent = {{10, -10}, {-10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.StaticPipe staticPipe(redeclare package Medium = medium, p_a_start = p_init_pipe, p_b_start = p_init_pipe) annotation(
    Placement(transformation(origin = {40, -150}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));
  ModelicaProjects.EPv2Cooling.Component.InvertorCoolingModuleWithHeater invertorCoolerLCH(p_init_pipe = p_init_pipe, redeclare package Medium = medium, T_init_pipe = T_init_pipe, T_init_module = T_init_module, heaterTable = [-20, 700; 0, 400; 20, 100; 40, 50; 60, 0], R_pipe_md = 0.2) annotation(
    Placement(transformation(origin = {-74, -98}, extent = {{20, -20}, {-20, 20}})));
  ModelicaProjects.EPv2Cooling.Component.InvertorCoolingModuleWithHeater invertorCoolerLOX(redeclare package Medium = medium, p_init_pipe = p_init_pipe, T_init_pipe = T_init_pipe, T_init_module = T_init_module, heaterTable = [-20, 700; 0, 400; 20, 100; 40, 50; 60, 0], R_pipe_md = 0.2) annotation(
    Placement(transformation(origin = {-75, -3}, extent = {{19, -19}, {-19, 19}})));
  Component.MotorCoolingModule motorCoolingModule(redeclare package Medium = medium, p_init_pipe = p_init_pipe, T_init_pipe = T_init_pipe, T_init_motor = T_init_motor) annotation(
    Placement(transformation(origin = {218, -270}, extent = {{30, -30}, {-30, 30}})));
  Modelica.Blocks.Sources.CombiTimeTable updownRpmTableLOX(columns = {2}, table = [0.0, 0; 0.5, 0; 0.8, 10000; 1.0, 10000; 2.5, 60000; 63.0, 60000; 64.6, 23700; 124.3, 23700; 125.6, 60000; 180, 60000]) annotation(
    Placement(transformation(origin = {592, -38}, extent = {{10, -10}, {-10, 10}})));
  EAST.Blocks.Routing.ExtractScalar extractScalar annotation(
    Placement(transformation(origin = {552, -38}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.CombiTimeTable updownRpmTableLCH(columns = {2}, table = [0.0, 0; 0.5, 0; 0.8, 10000; 1.0, 10000; 2.5, 65000; 63.0, 65000; 64.6, 20000; 124.3, 20000; 125.6, 65000; 180, 65000]) annotation(
    Placement(transformation(origin = {-382, -206}, extent = {{-10, -10}, {10, 10}})));
  EAST.Blocks.Routing.ExtractScalar extractScalar1 annotation(
        HideResult = true,
    Placement(transformation(origin = {-334, -206}, extent = {{-10, -10}, {10, 10}})));
  Component.ProfileGenerator LOXprofile annotation(
    Placement(transformation(origin = {470, -38}, extent = {{20, -20}, {-20, 20}})));
  ModelicaProjects.EPv2Cooling.Component.ProfileGenerator LCHprofile(rpm_to_torque_a2 = 0.287, rpm_to_torque_a1 = 7e-15) annotation(
    Placement(transformation(origin = {-258, -206}, extent = {{-20, -20}, {20, 20}})));
  EAST.Blocks.Math.MultiplyParameter multiplyParameter(k = 0.4) annotation(
   HideResult = true,
    Placement(transformation(origin = {344, -46}, extent = {{10, -10}, {-10, 10}})));
  EAST.Blocks.Math.MultiplyParameter multiplyParameter1(k = 0.6) annotation(
     HideResult = true,
    Placement(transformation(origin = {396, -96}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Math.Add add annotation(
     HideResult = true,
    Placement(transformation(origin = {296, -86}, extent = {{10, -10}, {-10, 10}})));
  Component.Real3ToArray real3ToArray annotation(
     HideResult = true,
    Placement(transformation(origin = {256, -180}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Constant const22(k = 0) annotation(
     HideResult = true,
    Placement(transformation(origin = {310, -188}, extent = {{10, -10}, {-10, 10}})));
  EAST.Blocks.Math.DivideParameter divideParameter1(k = 10000) annotation(
     HideResult = true,
    Placement(transformation(origin = {-268, -316}, extent = {{-10, -10}, {10, 10}})));
  EAST.Blocks.Math.Polynomial pnLCHflow(a0 = 0, a1 = 0.0009, a2 = 3E-11, polynomialType = EAST.Blocks.Types.PolynomialType.Quadratic) annotation(
         HideResult = true,
    Placement(transformation(origin = {-216, -316}, extent = {{-10, -10}, {10, 10}})));
  EAST.Blocks.Math.MultiplyParameter multiplyParameter21(k = 420*0.06) annotation(
         HideResult = true,
    Placement(transformation(origin = {-158, -316}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax = 1e+10, uMin = 0.03) annotation(
         HideResult = true,
    Placement(transformation(origin = {-102, -316}, extent = {{-10, -10}, {10, 10}})));
  Component.CoilTCR coilTCR(min_T(displayUnit = "K") = 200)  annotation(
         HideResult = true,
    Placement(transformation(origin = {354, -120}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
equation
  connect(const.y, boundary_pT.p_in) annotation(
    Line(points = {{-293, -34}, {-284, -34}, {-284, -48}, {-262, -48}}, color = {0, 0, 127}));
  connect(const1.y, boundary_pT.T_in) annotation(
    Line(points = {{-293, -80}, {-278, -80}, {-278, -60}, {-262, -60}}, color = {0, 0, 127}));
  connect(massFlowSource_T.T_in, const21.y) annotation(
    Line(points = {{330, -276}, {373, -276}}, color = {0, 0, 127}));
  connect(teePipe.port_1, staticPipe.port_b) annotation(
    Line(points = {{40, -114}, {40, -140}}, color = {0, 0, 127}));
  connect(invertorCoolerLOX.port_a, teePipe.port_2) annotation(
    Line(points = {{-56, -3}, {38, -3}, {38, -94}, {40, -94}}, color = {0, 0, 127}));
  connect(invertorCoolerLCH.port_a, teePipe.port_3) annotation(
    Line(points = {{-54, -98}, {-54, -104}, {30, -104}}, color = {0, 0, 127}));
  connect(boundary_pT.port, invertorCoolerLOX.port_b) annotation(
    Line(points = {{-240, -54}, {-166, -54}, {-166, -3}, {-94, -3}}, color = {0, 0, 127}));
  connect(boundary_pT.port, invertorCoolerLCH.port_b) annotation(
    Line(points = {{-240, -54}, {-166, -54}, {-166, -98}, {-94, -98}}, color = {0, 0, 127}));
  connect(staticPipe.port_a, motorCoolingModule.port_b) annotation(
    Line(points = {{40, -160}, {42, -160}, {42, -270}, {188, -270}}, color = {0, 0, 127}));
  connect(motorCoolingModule.port_a, massFlowSource_T.port) annotation(
    Line(points = {{248, -270}, {308, -270}}, color = {0, 0, 127}));
  connect(updownRpmTableLOX.y, extractScalar.u) annotation(
    Line(points = {{581, -38}, {564, -38}}, color = {0, 0, 127}, thickness = 0.5));
  connect(extractScalar1.u, updownRpmTableLCH.y) annotation(
    Line(points = {{-346, -206}, {-371, -206}}, color = {0, 0, 127}, thickness = 0.5));
  connect(LOXprofile.u, extractScalar.y) annotation(
    Line(points = {{494, -38}, {542, -38}}, color = {0, 0, 127}));
  connect(LCHprofile.u, extractScalar1.y) annotation(
    Line(points = {{-282, -206}, {-323, -206}}, color = {0, 0, 127}));
  connect(add.u1, multiplyParameter.y) annotation(
    Line(points = {{308, -80}, {322, -80}, {322, -46}, {334, -46}}, color = {0, 0, 127}));
  connect(multiplyParameter.u, LOXprofile.motorLoss) annotation(
    Line(points = {{356, -46}, {448, -46}}, color = {0, 0, 127}));
  connect(multiplyParameter1.u, LOXprofile.motorLoss) annotation(
    Line(points = {{408, -96}, {426, -96}, {426, -46}, {448, -46}}, color = {0, 0, 127}));
  connect(motorCoolingModule.u, real3ToArray.y) annotation(
    Line(points = {{218, -240}, {218, -180}, {245, -180}}, color = {0, 0, 127}, thickness = 0.5));
  connect(real3ToArray.u2, const22.y) annotation(
    Line(points = {{268, -180}, {282, -180}, {282, -188}, {300, -188}}, color = {0, 0, 127}));
  connect(real3ToArray.u3, const22.y) annotation(
    Line(points = {{268, -188}, {300, -188}}, color = {0, 0, 127}));
  connect(real3ToArray.u1, add.y) annotation(
    Line(points = {{268, -172}, {284, -172}, {284, -86}, {285, -86}}, color = {0, 0, 127}));
  connect(pnLCHflow.u, divideParameter1.y) annotation(
    Line(points = {{-228, -316}, {-257, -316}}, color = {0, 0, 127}));
  connect(extractScalar1.y, divideParameter1.u) annotation(
    Line(points = {{-323, -206}, {-315, -206}, {-315, -316}, {-280, -316}}, color = {0, 0, 127}));
  connect(pnLCHflow.y, multiplyParameter21.u) annotation(
    Line(points = {{-205, -316}, {-170, -316}}, color = {0, 0, 127}));
  connect(multiplyParameter21.y, limiter1.u) annotation(
    Line(points = {{-147, -316}, {-115, -316}}, color = {0, 0, 127}));
  connect(limiter1.y, massFlowSource_T.m_flow_in) annotation(
    Line(points = {{-91, -316}, {348, -316}, {348, -264}, {330, -264}}, color = {0, 0, 127}));
  connect(coilTCR.baseResist, multiplyParameter1.y) annotation(
    Line(points = {{366.2, -126}, {380.2, -126}, {380.2, -96}, {385.2, -96}}, color = {0, 0, 127}));
  connect(add.u2, coilTCR.resist) annotation(
    Line(points = {{308, -92}, {316, -92}, {316, -120}, {342, -120}}, color = {0, 0, 127}));
  connect(coilTCR.temperature, motorCoolingModule.coilTemperature) annotation(
    Line(points = {{366, -114}, {410, -114}, {410, -216}, {190, -216}, {190, -246}}, color = {0, 0, 127}));
  connect(LCHprofile.invertorLoss, invertorCoolerLCH.lossInput) annotation(
    Line(points = {{-236, -198}, {-18, -198}, {-18, -66}, {-74, -66}, {-74, -80}}, color = {0, 0, 127}));
  connect(invertorCoolerLOX.lossInput, LOXprofile.invertorLoss) annotation(
    Line(points = {{-74, 14}, {-84, 14}, {-84, 46}, {384, 46}, {384, -30}, {448, -30}}, color = {0, 0, 127}));
  annotation(
    experiment(StopTime = 180),
    Diagram(coordinateSystem(extent = {{-320, 100}, {700, -320}}), graphics = {Text(origin = {590, -6}, extent = {{-14, 8}, {14, -8}}, textString = "LOX"), Text(origin = {-386, -174}, extent = {{-14, 8}, {14, -8}}, textString = "LCH"), Text(origin = {525, -29}, extent = {{-13, 5}, {13, -5}}, textString = "rpm"), Text(origin = {-333, -221}, extent = {{-13, 5}, {13, -5}}, textString = "rpm"), Text(origin = {-226, -287}, extent = {{-28, 5}, {28, -5}}, textString = "rpm to
flowrate(m3/s)"), Text(origin = {-158, -335}, extent = {{-28, 5}, {28, -5}}, textString = "flowrate(kg/s)"), Text(origin = {-106, -293}, extent = {{-28, 5}, {28, -5}}, textString = "lim min")}));
end EPv2CoolingSystemSimple;
