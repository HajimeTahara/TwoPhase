within ModelicaProjects.EPv2Cooling.Study;
model MotorCoolingTest
  import Modelica.Units.SI;
  extends Modelica.Icons.Example;
  replaceable package medium = EAST.TwoPhaseFlow.Media.LCH_FD;
  parameter Integer nNode = 5 "node数. デフォルトから変更する場合スケッチも更新" annotation(
    Dialog(group = "Module"));
  parameter SI.Length D_inner = 0.03 "ステータ内径" annotation(
    Dialog(tab = "Geometry", group = "Motor"));
  parameter SI.Length D_coil = 0.035 "コイル外径" annotation(
    Dialog(tab = "Geometry", group = "Motor"));
  parameter SI.Length D_core = 0.040 "コア外径" annotation(
    Dialog(tab = "Geometry", group = "Motor"));
  parameter SI.Length D_frame = 0.045 "フレーム外径" annotation(
    Dialog(tab = "Geometry", group = "Motor"));
  parameter SI.Length L_motor = 0.06 "モーター長さ" annotation(
    Dialog(tab = "Geometry", group = "Motor"));
  parameter SI.HeatFlowRate loss = 4000 "motor損失" annotation(
    Dialog(group = "Module"));
  parameter SI.Length pipe_H = 0.002 annotation(
    Dialog(tab = "Geometry", group = "Module"));
  parameter SI.Pressure p_init_pipe = 0.55*10^6 annotation(
    Dialog(group = "Initialization"));
  parameter SI.Temperature T_init_pipe = 100 annotation(
    Dialog(group = "Initialization"));
  parameter SI.Temperature T_init_motor = 273 annotation(
    Dialog(group = "Initialization"));
  parameter EAST.Thermal.Material.MaterialProperties core = EAST.Thermal.Material.GeneralMotorCore() annotation(
    Dialog(group = "Material"));
  parameter EAST.Thermal.Material.MaterialProperties coil = EAST.Thermal.Material.GeneralMotorCoil() annotation(
    Dialog(group = "Initialization"));
  parameter EAST.Thermal.Material.MaterialProperties frame = EAST.Thermal.Material.Sus304() annotation(
    Dialog(group = "Initialization"));
  final parameter SI.Length pipe_L = D_frame*Modelica.Constants.pi "1ノード当たり冷却管長さ";
  final parameter SI.Length pipe_W_long = L_motor/nNode;
  final parameter SI.Length pipe_W_short = pipe_H;
  EAST.TwoPhaseFlow.Component.Sources.Boundary_pT boundary_pT(redeclare package Medium = medium, p_set = p_init_pipe, T_set = T_init_pipe) annotation(
    Placement(transformation(origin = {134, -102}, extent = {{10, -10}, {-10, 10}})));
  EAST.TwoPhaseFlow.Component.Sources.MassFlowSource_T massFlowSource_T(redeclare package Medium = medium, T_set = T_init_pipe, m_flow_set = 0.17) annotation(
    Placement(transformation(origin = {-128, -98}, extent = {{-10, -10}, {10, 10}})));
  EAST.Blocks.Sources.ConstantArray constArray(k = {loss/nNode, 0, 0}) annotation(
    Placement(transformation(origin = {134, 100}, extent = {{10, -10}, {-10, 10}})));
  ModelicaProjects.EPv2Cooling.Component.MotorCoolingModule motorCoolingModule(redeclare package Medium = medium) annotation(
    Placement(transformation(origin = {-9, -17}, extent = {{-45, -45}, {45, 45}})));
equation
  connect(massFlowSource_T.port, motorCoolingModule.port_a) annotation(
    Line(points = {{-118, -98}, {-82, -98}, {-82, -16}, {-54, -16}}, color = {0, 0, 127}));
  connect(motorCoolingModule.port_b, boundary_pT.port) annotation(
    Line(points = {{36, -16}, {76, -16}, {76, -102}, {124, -102}}, color = {0, 0, 127}));
  connect(motorCoolingModule.u, constArray.y) annotation(
    Line(points = {{-8, 28}, {-12, 28}, {-12, 100}, {124, 100}}, color = {0, 0, 127}, thickness = 0.5));
  annotation(
    experiment(StopTime = 100),
    Icon,
    Diagram(coordinateSystem(extent = {{-160, 120}, {160, -140}})));
end MotorCoolingTest;
