within EAST.TwoPhaseFlow.Examples.Pipes;

model SimpleTwoPhaseCooler
  replaceable package medium = EAST.TwoPhaseFlow.Media.LCH;
  extends Modelica.Icons.Example;
  parameter Real p_out=101325;
  parameter Real T_in=110;

  parameter Real T_out=T_in;
  parameter Real p_init=p_out;
  parameter Real T_init=T_in;

  EAST.TwoPhaseFlow.Component.Sources.Boundary_pT boundary_pT(
    redeclare package Medium = medium, use_T_in = true, use_p_in = true) annotation(
    Placement(transformation(origin = {70, 0}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Modelica.Blocks.Sources.Constant const(k = p_out) annotation(
    Placement(transformation(origin = {130, 20}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Constant const1(k = T_out) annotation(
    Placement(transformation(origin = {130, -20}, extent = {{10, -10}, {-10, 10}})));
  EAST.TwoPhaseFlow.Component.Sources.MassFlowSource_T massFlowSource_T(
    redeclare package Medium = medium, 
    T_set= 100, m_flow_set = 0.01, 
    use_T_in = true, use_m_flow_in = true) annotation(
    Placement(transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment dynamicPipeSegment(
    redeclare package Medium = medium, 
    p_start = p_init, 
    h_start = medium.specificEnthalpy_pT(p_init, T_init))  annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const2(k = 0.1) annotation(
    Placement(transformation(origin = {-130, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const11(k = T_in) annotation(
    Placement(transformation(origin = {-128, -24}, extent = {{-10, -10}, {10, 10}}, rotation = -0)));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(
    V = 0.1*0.1*0.1, 
    material = EAST.Thermal.Material.Sus304(), T_start = T_init)  annotation(
    Placement(transformation(origin = {0, 82}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow(Q_flow = 10000)  annotation(
    Placement(transformation(origin = {-50, 82}, extent = {{-10, -10}, {10, 10}})));

equation
  connect(const1.y, boundary_pT.T_in) annotation(
    Line(points = {{119, -20}, {98.5, -20}, {98.5, -6}, {82, -6}}, color = {0, 0, 127}));
  connect(massFlowSource_T.port, dynamicPipeSegment.port_a) annotation(
    Line(points = {{-60, 0}, {-10, 0}}, color = {0, 0, 127}));
  connect(dynamicPipeSegment.port_b, boundary_pT.port) annotation(
    Line(points = {{10, 0}, {60, 0}}, color = {0, 0, 127}));
  connect(boundary_pT.p_in, const.y) annotation(
    Line(points = {{82, 6}, {100, 6}, {100, 20}, {119, 20}}, color = {0, 0, 127}));
  connect(const2.y, massFlowSource_T.m_flow_in) annotation(
    Line(points = {{-119, 20}, {-102, 20}, {-102, 6}, {-82, 6}}, color = {0, 0, 127}));
  connect(const11.y, massFlowSource_T.T_in) annotation(
    Line(points = {{-116, -24}, {-100, -24}, {-100, -6}, {-82, -6}}, color = {0, 0, 127}));
  connect(fixedHeatFlow.port, heatCapacitor.port_left) annotation(
    Line(points = {{-40, 82}, {-10, 82}}, color = {191, 0, 0}));
  connect(heatCapacitor.port_bottom, dynamicPipeSegment.heatPort) annotation(
    Line(points = {{0, 72}, {0, 4}}, color = {191, 0, 0}));

annotation(experiment(StopTime = 100),
  Diagram(coordinateSystem(extent = {{-140, 100}, {140, -40}})));
end SimpleTwoPhaseCooler;
