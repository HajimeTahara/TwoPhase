within EAST.TwoPhaseFlow.Examples.Pipes;

model TestPipeSegment
  package Medium = EAST.TwoPhaseFlow.Media.LCH;
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor s annotation(
    Placement(transformation(origin = {-10, 62}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow(Q_flow = 300) annotation(
    Placement(transformation(origin = {-98, 62}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.PipeSegment pipeSegment(redeclare package Medium = Medium, V = 0.01) annotation(
    Placement(transformation(origin = {-14, -24}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Components.Convection convection annotation(
    Placement(transformation(origin = {-6, 16}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.TwoPhaseFlow.Component.Sources.MassFlowSource_T massFlowSource_T(redeclare package Medium = Medium, T_set = 93.15, m_flow_set = 0.1) annotation(
    Placement(transformation(origin = {-128, -28}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = 1) annotation(
    Placement(transformation(origin = {42, 40}, extent = {{-10, -10}, {10, 10}})));
  Component.Sources.Boundary_pT boundary_pT(p_set(displayUnit = "Pa") = 4.9e5, T_set = 93.15, redeclare package Medium = Medium)  annotation(
    Placement(transformation(origin = {86, -54}, extent = {{10, -10}, {-10, 10}})));
equation
  connect(fixedHeatFlow.port, s.port_left) annotation(
    Line(points = {{-88, 62}, {-20, 62}}, color = {191, 0, 0}));
  connect(s.port_bottom, convection.solid) annotation(
    Line(points = {{-10, 52}, {-6, 52}, {-6, 26}}, color = {191, 0, 0}));
  connect(convection.fluid, pipeSegment.heatPort) annotation(
    Line(points = {{-6, 6}, {-14, 6}, {-14, -16}}, color = {191, 0, 0}));
  connect(const.y, convection.Gc) annotation(
    Line(points = {{53, 40}, {69, 40}, {69, 16}, {3, 16}}, color = {0, 0, 127}));
  connect(massFlowSource_T.port, pipeSegment.port_a) annotation(
    Line(points = {{-118, -28}, {-24, -28}, {-24, -24}}, color = {0, 127, 255}));
  connect(pipeSegment.port_b, boundary_pT.port) annotation(
    Line(points = {{-4, -24}, {40, -24}, {40, -54}, {76, -54}}, color = {0, 127, 255}));
  annotation(experiment(StopTime = 100));
end TestPipeSegment;
