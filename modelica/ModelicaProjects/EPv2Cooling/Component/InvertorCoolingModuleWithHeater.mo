within ModelicaProjects.EPv2Cooling.Component;

model InvertorCoolingModuleWithHeater
  extends EAST.Icons.HexPipe;
  import Modelica.Units.SI;
  parameter Integer nNode = 5 "node数. デフォルトから変更する場合スケッチも更新" annotation(
    HideResult = true,
    Dialog(group = "Module"));
  replaceable package Medium = EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium annotation(
    choicesAllMatching = true);
  parameter SI.Length module_L = 0.06 annotation(
    HideResult = true,
    Dialog(tab = "Geometry", group = "Module"));
  parameter SI.Length module_W = 0.06 annotation(
    HideResult = true,
    Dialog(tab = "Geometry", group = "Module"));
  parameter SI.Length module_H = 0.01 annotation(
    HideResult = true,
    Dialog(tab = "Geometry", group = "Module"));
  parameter SI.HeatFlowRate loss = 4000 "合計invertor損失" annotation(
    HideResult = true,
    Dialog(group = "Module"));
  parameter SI.ThermalResistance R_pipe_md = 0.047 + (1/(16.2*module_S/pipe_thickness)) "pipe-module間熱抵抗" annotation(
    Dialog(group = "Module"));
  parameter SI.Length pipe_thickness = 0.005 annotation(
    HideResult = true,
    Dialog(tab = "Geometry", group = "Module"));
  parameter SI.Length pipe_H = 0.003 annotation(
    HideResult = true,
    Dialog(tab = "Geometry", group = "Module"));
  parameter SI.Pressure p_init_pipe = 0.55*10^6 annotation(
    HideResult = true,
    Dialog(group = "Initialization"));
  parameter SI.Temperature T_init_pipe = 100 annotation(
    HideResult = true,
    Dialog(group = "Initialization"));
  parameter SI.Temperature T_init_module = 273 annotation(
    HideResult = true,
    Dialog(group = "Initialization"));
  parameter EAST.Thermal.Material.MaterialProperties pipe_material = EAST.Thermal.Material.Sus304() annotation(
    HideResult = true,
    Dialog(group = "Material"));
  parameter EAST.Thermal.Material.MaterialProperties module_material = EAST.Thermal.Material.GeneralElecModule() annotation(
    HideResult = true,
    Dialog(group = "Initialization"));
  parameter Real heaterTable[:, :] = [0, 0; 1, 0] "デフォルトは発熱0. 1列目は参照温度[K].2列目は発熱量[W]" annotation(
    Dialog(group = "Module"));
  final parameter SI.HeatFlowRate loss_modules = loss/nNode annotation(
    HideResult = true);
  final parameter SI.Area module_S = module_L*module_W annotation(
    HideResult = true);
  final parameter SI.Volume module_V = module_L*module_W*module_H annotation(
    HideResult = true);
  final parameter SI.Length total_pipe_Length = module_L*nNode annotation(
    HideResult = true);
  final parameter SI.Length pipe_L = total_pipe_Length/nNode "1ノード当たり冷却管長さ" annotation(
    HideResult = true);
  final parameter SI.Volume pipe_massV = pipe_massS*pipe_L annotation(
    HideResult = true);
  final parameter SI.Area pipe_massS = 2*pipe_thickness*(pipe_W_long + pipe_W_short) annotation(
    HideResult = true);
  final parameter SI.Length pipe_W_long = module_W annotation(
    HideResult = true);
  final parameter SI.Length pipe_W_short = pipe_H annotation(
    HideResult = true);
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow invertorLossSource annotation(
    HideResult = true,
    Placement(transformation(origin = {-318, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res_pipe_md(R = R_pipe_md) annotation(
    HideResult = true,
    Placement(transformation(origin = {-318, -8}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor module(V = module_V, material = module_material, T_start = T_init_module) annotation(
    Placement(transformation(origin = {-318, 30}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment pipe(redeclare package Medium = Medium, p_start = p_init_pipe, h_start = Medium.specificEnthalpy_pT(p_init_pipe, T_init_pipe), geometry = EAST.TwoPhaseFlow.Component.Pipes.PipeGeometry.Rectangular, length = pipe_L, rectangularLongSide = pipe_W_long, rectangularShortSide = pipe_W_short) annotation(
    Placement(transformation(origin = {-318, -146}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor pipe_mass(material = pipe_material, T_start = T_init_pipe, V = pipe_massV) annotation(
    HideResult = true,
    Placement(transformation(origin = {-318, -106}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.ThermalConductor cond_pipe(A = pipe_massS, L = pipe_L, material = pipe_material) annotation(
    HideResult = true,
    Placement(transformation(origin = {-202, -106}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow invertorLossSource1 annotation(
    HideResult = true,
    Placement(transformation(origin = {-160, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res_pipe_md1(R = R_pipe_md) annotation(
    HideResult = true,
    Placement(transformation(origin = {-160, -8}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor module1(T_start = T_init_module, V = module_V, material = module_material) annotation(
    Placement(transformation(origin = {-160, 30}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment pipe1(redeclare package Medium = Medium, geometry = EAST.TwoPhaseFlow.Component.Pipes.PipeGeometry.Rectangular, h_start = Medium.specificEnthalpy_pT(p_init_pipe, T_init_pipe), length = pipe_L, p_start = p_init_pipe, rectangularLongSide = pipe_W_long, rectangularShortSide = pipe_W_short) annotation(
    Placement(transformation(origin = {-160, -146}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor pipe_mass1(T_start = T_init_pipe, V = pipe_massV, material = pipe_material) annotation(
    HideResult = true,
    Placement(transformation(origin = {-160, -106}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.ThermalConductor cond_pipe1(A = pipe_massS, L = pipe_L, material = pipe_material) annotation(
    HideResult = true,
    Placement(transformation(origin = {-42, -106}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow invertorLossSource2 annotation(
    HideResult = true,
    Placement(transformation(origin = {0, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res_pipe_md2(R = R_pipe_md) annotation(
    HideResult = true,
    Placement(transformation(origin = {0, -8}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor module2(T_start = T_init_module, V = module_V, material = module_material) annotation(
    Placement(transformation(origin = {0, 30}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment pipe2(redeclare package Medium = Medium, geometry = EAST.TwoPhaseFlow.Component.Pipes.PipeGeometry.Rectangular, h_start = Medium.specificEnthalpy_pT(p_init_pipe, T_init_pipe), length = pipe_L, p_start = p_init_pipe, rectangularLongSide = pipe_W_long, rectangularShortSide = pipe_W_short) annotation(
    Placement(transformation(origin = {0, -146}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor pipe_mass2(T_start = T_init_pipe, V = pipe_massV, material = pipe_material) annotation(
    HideResult = true,
    Placement(transformation(origin = {0, -106}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.ThermalConductor cond_pipe2(A = pipe_massS, L = pipe_L, material = pipe_material) annotation(
    HideResult = true,
    Placement(transformation(origin = {90, -106}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow invertorLossSource3 annotation(
    HideResult = true,
    Placement(transformation(origin = {134, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res_pipe_md3(R = R_pipe_md) annotation(
    HideResult = true,
    Placement(transformation(origin = {134, -8}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor module3(T_start = T_init_module, V = module_V, material = module_material) annotation(
    Placement(transformation(origin = {134, 30}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment pipe3(redeclare package Medium = Medium, geometry = EAST.TwoPhaseFlow.Component.Pipes.PipeGeometry.Rectangular, h_start = Medium.specificEnthalpy_pT(p_init_pipe, T_init_pipe), length = pipe_L, p_start = p_init_pipe, rectangularLongSide = pipe_W_long, rectangularShortSide = pipe_W_short) annotation(
    Placement(transformation(origin = {134, -146}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor pipe_mass3(T_start = T_init_pipe, V = pipe_massV, material = pipe_material) annotation(
    HideResult = true,
    Placement(transformation(origin = {134, -106}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.ThermalConductor cond_pipe3(A = pipe_massS, L = pipe_L, material = pipe_material) annotation(
    HideResult = true,
    Placement(transformation(origin = {244, -106}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow invertorLossSource4 annotation(
    HideResult = true,
    Placement(transformation(origin = {282, 72}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res_pipe_md4(R = R_pipe_md) annotation(
    HideResult = true,
    Placement(transformation(origin = {282, -8}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor module4(T_start = T_init_module, V = module_V, material = module_material) annotation(
    Placement(transformation(origin = {282, 32}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment pipe4(redeclare package Medium = Medium, geometry = EAST.TwoPhaseFlow.Component.Pipes.PipeGeometry.Rectangular, h_start = Medium.specificEnthalpy_pT(p_init_pipe, T_init_pipe), length = pipe_L, p_start = p_init_pipe, rectangularLongSide = pipe_W_long, rectangularShortSide = pipe_W_short) annotation(
    Placement(transformation(origin = {282, -146}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor pipe_mass4(T_start = T_init_pipe, V = pipe_massV, material = pipe_material) annotation(
    HideResult = true,
    Placement(transformation(origin = {282, -106}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium, p(start = p_init_pipe, nominal = 1.0e5)) annotation(
    Placement(transformation(origin = {-270, -146}, extent = {{-110, -10}, {-90, 10}}), iconTransformation(extent = {{-110, -10}, {-90, 10}})));
  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium, p(start = p_init_pipe, nominal = 1.0e5)) annotation(
    Placement(transformation(origin = {232, -146}, extent = {{90, -10}, {110, 10}}), iconTransformation(extent = {{90, -10}, {110, 10}})));
  Modelica.Blocks.Interfaces.RealInput lossInput annotation(
    Placement(transformation(origin = {-412, 108}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {0, 90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Division division annotation(
    HideResult = true,
    Placement(transformation(origin = {-348, 102}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = nNode) annotation(
    HideResult = true,
    Placement(transformation(origin = {-410, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaterSource annotation(
    HideResult = true,
    Placement(transformation(origin = {-348, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaterSource1 annotation(
    HideResult = true,
    Placement(transformation(origin = {-190, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaterSource2 annotation(
    HideResult = true,
    Placement(transformation(origin = {-30, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaterSource3 annotation(
    HideResult = true,
    Placement(transformation(origin = {102, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaterSource4 annotation(
    HideResult = true,
    Placement(transformation(origin = {234, 32}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor annotation(
    HideResult = true,
    Placement(transformation(origin = {-290, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(table = heaterTable) annotation(
    HideResult = true,
    Placement(transformation(origin = {-350, -50}, extent = {{10, -10}, {-10, 10}})));
  EAST.Blocks.Routing.ExtractScalar extractScalar annotation(
    HideResult = true,
    Placement(transformation(origin = {-390, -50}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds1(table = heaterTable) annotation(
    HideResult = true,
    Placement(transformation(origin = {-170, -50}, extent = {{10, -10}, {-10, 10}})));
  EAST.Blocks.Routing.ExtractScalar extractScalar1 annotation(
    HideResult = true,
    Placement(transformation(origin = {-210, -50}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor1 annotation(
    HideResult = true,
    Placement(transformation(origin = {-130, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor2 annotation(
    HideResult = true,
    Placement(transformation(origin = {30, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor3 annotation(
    HideResult = true,
    Placement(transformation(origin = {168, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor4 annotation(
    HideResult = true,
    Placement(transformation(origin = {316, 32}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds2(table = heaterTable) annotation(
    HideResult = true,
    Placement(transformation(origin = {-10, -50}, extent = {{10, -10}, {-10, 10}})));
  EAST.Blocks.Routing.ExtractScalar extractScalar2 annotation(
    HideResult = true,
    Placement(transformation(origin = {-50, -50}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds3(table = heaterTable) annotation(
    HideResult = true,
    Placement(transformation(origin = {130, -50}, extent = {{10, -10}, {-10, 10}})));
  EAST.Blocks.Routing.ExtractScalar extractScalar3 annotation(
    HideResult = true,
    Placement(transformation(origin = {90, -50}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds4(table = heaterTable) annotation(
    HideResult = true,
    Placement(transformation(origin = {270, -50}, extent = {{10, -10}, {-10, 10}})));
  EAST.Blocks.Routing.ExtractScalar extractScalar4 annotation(
    HideResult = true,
    Placement(transformation(origin = {230, -50}, extent = {{10, -10}, {-10, 10}})));
  EAST.Blocks.UnitConvert.KToDegC kToDegC annotation(
    HideResult = true,
    Placement(transformation(origin = {-310, -50}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  EAST.Blocks.UnitConvert.KToDegC kToDegC1 annotation(
    HideResult = true,
    Placement(transformation(origin = {-130, -50}, extent = {{10, -10}, {-10, 10}})));
  EAST.Blocks.UnitConvert.KToDegC kToDegC2 annotation(
    HideResult = true,
    Placement(transformation(origin = {30, -50}, extent = {{10, -10}, {-10, 10}})));
  EAST.Blocks.UnitConvert.KToDegC kToDegC3 annotation(
    HideResult = true,
    Placement(transformation(origin = {170, -50}, extent = {{10, -10}, {-10, 10}})));
  EAST.Blocks.UnitConvert.KToDegC kToDegC4 annotation(
    HideResult = true,
    Placement(transformation(origin = {310, -50}, extent = {{10, -10}, {-10, 10}})));
equation
  connect(pipe_mass.port_bottom, pipe.heatPort) annotation(
    Line(points = {{-318, -116}, {-318, -142}}, color = {191, 0, 0}));
  connect(pipe_mass.port_right, cond_pipe.port_a) annotation(
    Line(points = {{-308, -106}, {-212, -106}}, color = {191, 0, 0}));
  connect(res_pipe_md.port_b, pipe_mass.port_top) annotation(
    Line(points = {{-318, -18}, {-318, -96}}, color = {191, 0, 0}));
  connect(module.port_bottom, res_pipe_md.port_a) annotation(
    Line(points = {{-318, 20}, {-318, 2}}, color = {191, 0, 0}));
  connect(invertorLossSource.port, module.port_top) annotation(
    Line(points = {{-318, 60}, {-318, 40}}, color = {191, 0, 0}));
  connect(pipe_mass1.port_bottom, pipe1.heatPort) annotation(
    Line(points = {{-160, -116}, {-160, -142}}, color = {191, 0, 0}));
  connect(pipe_mass1.port_right, cond_pipe1.port_a) annotation(
    Line(points = {{-150, -106}, {-52, -106}}, color = {191, 0, 0}));
  connect(res_pipe_md1.port_b, pipe_mass1.port_top) annotation(
    Line(points = {{-160, -18}, {-160, -96}}, color = {191, 0, 0}));
  connect(module1.port_bottom, res_pipe_md1.port_a) annotation(
    Line(points = {{-160, 20}, {-160, 2}}, color = {191, 0, 0}));
  connect(invertorLossSource1.port, module1.port_top) annotation(
    Line(points = {{-160, 60}, {-160, 40}}, color = {191, 0, 0}));
  connect(pipe_mass2.port_bottom, pipe2.heatPort) annotation(
    Line(points = {{0, -116}, {0, -142}}, color = {191, 0, 0}));
  connect(pipe_mass2.port_right, cond_pipe2.port_a) annotation(
    Line(points = {{10, -106}, {80, -106}}, color = {191, 0, 0}));
  connect(res_pipe_md2.port_b, pipe_mass2.port_top) annotation(
    Line(points = {{0, -18}, {0, -96}}, color = {191, 0, 0}));
  connect(module2.port_bottom, res_pipe_md2.port_a) annotation(
    Line(points = {{0, 20}, {0, 2}}, color = {191, 0, 0}));
  connect(invertorLossSource2.port, module2.port_top) annotation(
    Line(points = {{0, 60}, {0, 40}}, color = {191, 0, 0}));
  connect(pipe_mass3.port_bottom, pipe3.heatPort) annotation(
    Line(points = {{134, -116}, {134, -142}}, color = {191, 0, 0}));
  connect(pipe_mass3.port_right, cond_pipe3.port_a) annotation(
    Line(points = {{144, -106}, {234, -106}}, color = {191, 0, 0}));
  connect(res_pipe_md3.port_b, pipe_mass3.port_top) annotation(
    Line(points = {{134, -18}, {134, -96}}, color = {191, 0, 0}));
  connect(module3.port_bottom, res_pipe_md3.port_a) annotation(
    Line(points = {{134, 20}, {134, 2}}, color = {191, 0, 0}));
  connect(invertorLossSource3.port, module3.port_top) annotation(
    Line(points = {{134, 60}, {134, 40}}, color = {191, 0, 0}));
  connect(pipe_mass4.port_bottom, pipe4.heatPort) annotation(
    Line(points = {{282, -116}, {282, -142}}, color = {191, 0, 0}));
  connect(res_pipe_md4.port_b, pipe_mass4.port_top) annotation(
    Line(points = {{282, -18}, {282, -96}}, color = {191, 0, 0}));
  connect(module4.port_bottom, res_pipe_md4.port_a) annotation(
    Line(points = {{282, 22}, {282, 2}}, color = {191, 0, 0}));
  connect(invertorLossSource4.port, module4.port_top) annotation(
    Line(points = {{282, 62}, {282, 42}}, color = {191, 0, 0}));
  connect(pipe.port_b, pipe1.port_a) annotation(
    Line(points = {{-308, -146}, {-170, -146}}, color = {0, 0, 127}));
  connect(cond_pipe.port_b, pipe_mass1.port_left) annotation(
    Line(points = {{-192, -106}, {-170, -106}}, color = {191, 0, 0}));
  connect(cond_pipe1.port_b, pipe_mass2.port_left) annotation(
    Line(points = {{-32, -106}, {-10, -106}}, color = {191, 0, 0}));
  connect(pipe1.port_b, pipe2.port_a) annotation(
    Line(points = {{-150, -146}, {-10, -146}}, color = {0, 0, 127}));
  connect(pipe2.port_b, pipe3.port_a) annotation(
    Line(points = {{10, -146}, {124, -146}}, color = {0, 0, 127}));
  connect(pipe3.port_b, pipe4.port_a) annotation(
    Line(points = {{144, -146}, {272, -146}}, color = {0, 0, 127}));
  connect(cond_pipe3.port_b, pipe_mass4.port_left) annotation(
    Line(points = {{254, -106}, {272, -106}}, color = {191, 0, 0}));
  connect(cond_pipe2.port_b, pipe_mass3.port_left) annotation(
    Line(points = {{100, -106}, {124, -106}}, color = {191, 0, 0}));
  connect(port_a, pipe.port_a) annotation(
    Line(points = {{-370, -146}, {-328, -146}}, color = {0, 127, 255}));
  connect(port_b, pipe4.port_b) annotation(
    Line(points = {{332, -146}, {292, -146}}, color = {0, 0, 255}));
  connect(const.y, division.u2) annotation(
    Line(points = {{-399, 60}, {-362, 60}, {-362, 96}, {-360, 96}}, color = {0, 0, 127}));
  connect(lossInput, division.u1) annotation(
    Line(points = {{-412, 108}, {-360, 108}}, color = {0, 0, 127}));
  connect(division.y, invertorLossSource.Q_flow) annotation(
    Line(points = {{-337, 102}, {-319, 102}, {-319, 80}}, color = {0, 0, 127}));
  connect(division.y, invertorLossSource1.Q_flow) annotation(
    Line(points = {{-337, 102}, {-161, 102}, {-161, 80}}, color = {0, 0, 127}));
  connect(division.y, invertorLossSource2.Q_flow) annotation(
    Line(points = {{-337, 102}, {-1, 102}, {-1, 80}}, color = {0, 0, 127}));
  connect(division.y, invertorLossSource3.Q_flow) annotation(
    Line(points = {{-337, 102}, {133, 102}, {133, 80}}, color = {0, 0, 127}));
  connect(division.y, invertorLossSource4.Q_flow) annotation(
    Line(points = {{-337, 102}, {281, 102}, {281, 82}}, color = {0, 0, 127}));
  connect(module4.port_left, heaterSource4.port) annotation(
    Line(points = {{272, 32}, {244, 32}}, color = {191, 0, 0}));
  connect(module3.port_left, heaterSource3.port) annotation(
    Line(points = {{124, 30}, {112, 30}}, color = {191, 0, 0}));
  connect(module2.port_left, heaterSource2.port) annotation(
    Line(points = {{-10, 30}, {-20, 30}}, color = {191, 0, 0}));
  connect(module1.port_left, heaterSource1.port) annotation(
    Line(points = {{-170, 30}, {-180, 30}}, color = {191, 0, 0}));
  connect(module.port_left, heaterSource.port) annotation(
    Line(points = {{-328, 30}, {-338, 30}}, color = {191, 0, 0}));
  connect(module.port_right, temperatureSensor.port) annotation(
    Line(points = {{-308, 30}, {-300, 30}}, color = {191, 0, 0}));
  connect(extractScalar.u, combiTable1Ds.y) annotation(
    Line(points = {{-378, -50}, {-361, -50}}, color = {0, 0, 127}, thickness = 0.5));
  connect(extractScalar.y, heaterSource.Q_flow) annotation(
    Line(points = {{-401, -50}, {-420, -50}, {-420, 30}, {-358, 30}}, color = {0, 0, 127}));
  connect(extractScalar1.u, combiTable1Ds1.y) annotation(
    Line(points = {{-198, -50}, {-181, -50}}, color = {0, 0, 127}, thickness = 0.5));
  connect(heaterSource1.Q_flow, extractScalar1.y) annotation(
    Line(points = {{-200, 30}, {-244, 30}, {-244, -50}, {-221, -50}}, color = {0, 0, 127}));
  connect(module1.port_right, temperatureSensor1.port) annotation(
    Line(points = {{-150, 30}, {-140, 30}}, color = {191, 0, 0}));
  connect(extractScalar2.u, combiTable1Ds2.y) annotation(
    Line(points = {{-38, -50}, {-21, -50}}, color = {0, 0, 127}, thickness = 0.5));
  connect(extractScalar3.u, combiTable1Ds3.y) annotation(
    Line(points = {{102, -50}, {119, -50}}, color = {0, 0, 127}, thickness = 0.5));
  connect(extractScalar4.u, combiTable1Ds4.y) annotation(
    Line(points = {{242, -50}, {259, -50}}, color = {0, 0, 127}, thickness = 0.5));
  connect(module4.port_right, temperatureSensor4.port) annotation(
    Line(points = {{292, 32}, {306, 32}}, color = {191, 0, 0}));
  connect(module3.port_right, temperatureSensor3.port) annotation(
    Line(points = {{144, 30}, {158, 30}}, color = {191, 0, 0}));
  connect(module2.port_right, temperatureSensor2.port) annotation(
    Line(points = {{10, 30}, {20, 30}}, color = {191, 0, 0}));
  connect(heaterSource2.Q_flow, extractScalar2.y) annotation(
    Line(points = {{-40, 30}, {-76, 30}, {-76, -50}, {-61, -50}}, color = {0, 0, 127}));
  connect(heaterSource3.Q_flow, extractScalar3.y) annotation(
    Line(points = {{92, 30}, {68, 30}, {68, -50}, {79, -50}}, color = {0, 0, 127}));
  connect(heaterSource4.Q_flow, extractScalar4.y) annotation(
    Line(points = {{224, 32}, {204, 32}, {204, -50}, {219, -50}}, color = {0, 0, 127}));
  connect(temperatureSensor.T, kToDegC.u) annotation(
    Line(points = {{-279, 30}, {-262, 30}, {-262, -50}, {-298, -50}}, color = {0, 0, 127}));
  connect(combiTable1Ds.u, kToDegC.y) annotation(
    Line(points = {{-338, -50}, {-321, -50}}, color = {0, 0, 127}));
  connect(temperatureSensor2.T, kToDegC2.u) annotation(
    Line(points = {{41, 30}, {58, 30}, {58, -50}, {42, -50}}, color = {0, 0, 127}));
  connect(combiTable1Ds2.u, kToDegC2.y) annotation(
    Line(points = {{2, -50}, {20, -50}}, color = {0, 0, 127}));
  connect(combiTable1Ds1.u, kToDegC1.y) annotation(
    Line(points = {{-158, -50}, {-140, -50}}, color = {0, 0, 127}));
  connect(temperatureSensor1.T, kToDegC1.u) annotation(
    Line(points = {{-119, 30}, {-90, 30}, {-90, -50}, {-118, -50}}, color = {0, 0, 127}));
  connect(combiTable1Ds3.u, kToDegC3.y) annotation(
    Line(points = {{142, -50}, {160, -50}}, color = {0, 0, 127}));
  connect(temperatureSensor3.T, kToDegC3.u) annotation(
    Line(points = {{180, 30}, {190, 30}, {190, -50}, {182, -50}}, color = {0, 0, 127}));
  connect(combiTable1Ds4.u, kToDegC4.y) annotation(
    Line(points = {{282, -50}, {300, -50}}, color = {0, 0, 127}));
  connect(temperatureSensor4.T, kToDegC4.u) annotation(
    Line(points = {{327, 32}, {340, 32}, {340, -50}, {322, -50}}, color = {0, 0, 127}));
  annotation(
    experiment(StopTime = 100),
    Icon(graphics = {Text(origin = {-160, 60}, extent = {{-40, 20}, {40, -20}}, textString = "heater")}),
    Diagram(coordinateSystem(extent = {{-440, 140}, {360, -160}})));
end InvertorCoolingModuleWithHeater;
