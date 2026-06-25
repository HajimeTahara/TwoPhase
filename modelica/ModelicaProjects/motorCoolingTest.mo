within ModelicaProjects;

model motorCoolingTest
  import Modelica.Units.SI;
  extends Modelica.Icons.Example;
  replaceable package medium = EAST.TwoPhaseFlow.Media.LCH_FD;
  parameter SI.Length module_L = 0.06 annotation(
    Dialog(tab = "Geometry", group = "Module"));
  parameter SI.Length module_W = 0.06 annotation(
    Dialog(tab = "Geometry", group = "Module"));
  parameter SI.Length module_H = 0.01 annotation(
    Dialog(tab = "Geometry", group = "Module"));
  parameter SI.HeatFlowRate invertor_loss = 4000 "合計invertor損失" annotation(
    Dialog(group = "Module"));
  parameter SI.ThermalResistance R_pipe_md = 0.047+(1/(16.2*module_S/pipe_thickness)) "pipe-module間熱抵抗" annotation(
    Dialog(group = "Module"));
  //parameter SI.ThermalResistance R_pipe_md = 0.047+(1/(16.2*module_S/pipe_thickness));
  parameter Integer nNode = 5 "node数. デフォルトから変更する場合スケッチも更新" annotation(
    Dialog(group = "Module"));
  parameter SI.Length pipe_thickness = 0.005 annotation(
    Dialog(tab = "Geometry", group = "Module"));
  parameter SI.Length pipe_H = 0.002 annotation(
    Dialog(tab = "Geometry", group = "Module"));
  parameter SI.Pressure p_init_pipe = 0.55*10^6 annotation(
    Dialog(group = "Initialization"));
  parameter SI.Temperature T_init_pipe = 100 annotation(
    Dialog(group = "Initialization"));
  parameter SI.Temperature T_init_module = 273 annotation(
    Dialog(group = "Initialization"));
  parameter EAST.Thermal.Material.MaterialProperties pipe_material = EAST.Thermal.Material.Sus304() annotation(
    Dialog(group = "Material"));
  parameter EAST.Thermal.Material.MaterialProperties module_material = EAST.Thermal.Material.GeneralElecModule() annotation(
    Dialog(group = "Initialization"));
  final parameter SI.HeatFlowRate loss_modules = invertor_loss/nNode;
  final parameter SI.Area module_S = module_L*module_W;
  final parameter SI.Volume module_V = module_L*module_W*module_H;
  final parameter SI.Length total_pipe_Length = module_L*nNode;
  final parameter SI.Length pipe_L = total_pipe_Length/nNode "1ノード当たり冷却管長さ";
  final parameter SI.Volume pipe_massV = pipe_massS*pipe_L;
  final parameter SI.Area pipe_massS = 2*pipe_thickness*(pipe_W_long + pipe_W_short);
  final parameter SI.Length pipe_W_long = module_W;
  final parameter SI.Length pipe_W_short = pipe_H;
  Modelica.Blocks.Sources.Constant constLoss(k = loss_modules) annotation(
    Placement(transformation(origin = {-220, 98}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment pipe(redeclare package Medium = medium, p_start = p_init_pipe, h_start = medium.specificEnthalpy_pT(p_init_pipe, T_init_pipe), geometry = EAST.TwoPhaseFlow.Component.Pipes.PipeGeometry.Rectangular, length = pipe_L, rectangularLongSide = pipe_W_long, rectangularShortSide = pipe_W_short) annotation(
    Placement(transformation(origin = {-96, -92}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Sources.Boundary_pT boundary_pT(redeclare package Medium = medium, p_set = p_init_pipe, T_set = T_init_pipe)  annotation(
    Placement(transformation(origin = {250, -130}, extent = {{10, -10}, {-10, 10}})));
  EAST.TwoPhaseFlow.Component.Sources.MassFlowSource_T massFlowSource_T(redeclare package Medium = medium, T_set = T_init_pipe, m_flow_set = 0.04)  annotation(
    Placement(transformation(origin = {-224, -130}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.CylindricalThermalConductor cylindricalThermalConductor(use_heat_input = true)  annotation(
    Placement(transformation(origin = {-105, 15}, extent = {{-25, -25}, {25, 25}}, rotation = -90)));
equation
  connect(massFlowSource_T.port, pipe.port_a) annotation(
    Line(points = {{-214, -130}, {-192, -130}, {-192, -92}, {-106, -92}}, color = {0, 0, 127}));
  connect(pipe.port_b, boundary_pT.port) annotation(
    Line(points = {{-86, -92}, {240, -92}, {240, -130}}, color = {0, 0, 127}));
  annotation(experiment(StopTime = 100),
    Icon,
  Diagram(coordinateSystem(extent = {{-240, 120}, {280, -140}})));
end motorCoolingTest;
