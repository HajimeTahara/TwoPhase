within ModelicaProjects.EPv2Cooling.Component;
model MotorCoolingModule
  import Modelica.Units.SI;
  extends EAST.Icons.CylinderThermalCooling;
  replaceable package Medium = EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium;
  parameter Integer nNode = 3 "node数. デフォルトから変更する場合スケッチも更新" annotation(
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
  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium, p(start = p_init_pipe, nominal = 1.0e5)) annotation(
    Placement(transformation(origin = {-12, -106}, extent = {{-110, -10}, {-90, 10}}), iconTransformation(extent = {{-110, -10}, {-90, 10}})));
  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium, p(start = p_init_pipe, nominal = 1.0e5)) annotation(
    Placement(transformation(origin = {22, -106}, extent = {{90, -10}, {110, 10}}), iconTransformation(extent = {{90, -10}, {110, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment pipe(redeclare package Medium = Medium, p_start = p_init_pipe, h_start = Medium.specificEnthalpy_pT(p_init_pipe, T_init_pipe), geometry = EAST.TwoPhaseFlow.Component.Pipes.PipeGeometry.Rectangular, length = pipe_L, rectangularLongSide = pipe_W_long, rectangularShortSide = pipe_W_short) annotation(
    Placement(transformation(origin = {-56, -106}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.CylindricalThermalConductor cylindricalThermalConductor(use_heat_input = true, nLayers = 3, innerDiameter = D_inner, outerDiameter = {D_coil, D_core, D_frame}, L = L_motor/nNode, material = {coil, core, frame}, T_start = fill(T_init_motor, 3)) annotation(
    Placement(transformation(origin = {-69, 37}, extent = {{-19, -19}, {19, 19}}, rotation = -90)));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment pipe1(redeclare package Medium = Medium, geometry = EAST.TwoPhaseFlow.Component.Pipes.PipeGeometry.Rectangular, h_start = Medium.specificEnthalpy_pT(p_init_pipe, T_init_pipe), length = pipe_L, p_start = p_init_pipe, rectangularLongSide = pipe_W_long, rectangularShortSide = pipe_W_short) annotation(
    Placement(transformation(origin = {-2, -106}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment pipe2(redeclare package Medium = Medium, geometry = EAST.TwoPhaseFlow.Component.Pipes.PipeGeometry.Rectangular, h_start = Medium.specificEnthalpy_pT(p_init_pipe, T_init_pipe), length = pipe_L, p_start = p_init_pipe, rectangularLongSide = pipe_W_long, rectangularShortSide = pipe_W_short) annotation(
    Placement(transformation(origin = {60, -106}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.CylindricalThermalConductor cylindricalThermalConductor1(L = L_motor/nNode, innerDiameter = D_inner, material = {coil, core, frame}, nLayers = 3, outerDiameter = {D_coil, D_core, D_frame}, use_heat_input = true, T_start = fill(T_init_motor, 3)) annotation(
    Placement(transformation(origin = {-3, -13}, extent = {{-19, -19}, {19, 19}}, rotation = -90)));
  EAST.Thermal.HeatTransfer.Components.CylindricalThermalConductor cylindricalThermalConductor11(L = L_motor/nNode, innerDiameter = D_inner, material = {coil, core, frame}, nLayers = 3, outerDiameter = {D_coil, D_core, D_frame}, use_heat_input = true, T_start = fill(T_init_motor, 3)) annotation(
    Placement(transformation(origin = {59, -59}, extent = {{-19, -19}, {19, 19}}, rotation = -90)));
  EAST.Blocks.Interfaces.RealVectorInput u[3] annotation(
    Placement(transformation(origin = {146, 85}, extent = {{-10, -11}, {10, 11}}), iconTransformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(cylindricalThermalConductor.port_outer, pipe.heatPort) annotation(
    Line(points = {{-69, 18}, {-69, -60}, {-56, -60}, {-56, -102}}, color = {191, 0, 0}));
  connect(pipe.port_b, pipe1.port_a) annotation(
    Line(points = {{-46, -106}, {-12, -106}}, color = {0, 0, 127}));
  connect(pipe1.port_b, pipe2.port_a) annotation(
    Line(points = {{8, -106}, {50, -106}}, color = {0, 0, 127}));
  connect(cylindricalThermalConductor11.port_outer, pipe2.heatPort) annotation(
    Line(points = {{59, -78}, {59, -80}, {60, -80}, {60, -102}}, color = {191, 0, 0}));
  connect(cylindricalThermalConductor1.port_outer, pipe1.heatPort) annotation(
    Line(points = {{-3, -32}, {-2, -32}, {-2, -102}}, color = {191, 0, 0}));
  connect(port_a, pipe.port_a) annotation(
    Line(points = {{-112, -106}, {-66, -106}}, color = {0, 127, 255}));
  connect(pipe2.port_b, port_b) annotation(
    Line(points = {{70, -106}, {122, -106}}, color = {0, 0, 127}));
  connect(cylindricalThermalConductor.Q_gen_input, u) annotation(
    Line(points = {{-46, 38}, {-22, 38}, {-22, 86}, {146, 86}}, color = {0, 0, 127}));
  connect(cylindricalThermalConductor1.Q_gen_input, u) annotation(
    Line(points = {{20, -12}, {36, -12}, {36, 86}, {146, 86}}, color = {0, 0, 127}));
  connect(cylindricalThermalConductor11.Q_gen_input, u) annotation(
    Line(points = {{82, -58}, {100, -58}, {100, 86}, {146, 86}}, color = {0, 0, 127}));
  annotation(
    experiment(StopTime = 100),
    Icon,
    Diagram(coordinateSystem(extent = {{-160, 120}, {160, -140}})));
end MotorCoolingModule;
