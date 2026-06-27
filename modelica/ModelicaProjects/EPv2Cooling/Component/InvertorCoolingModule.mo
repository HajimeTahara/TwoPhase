within ModelicaProjects.EPv2Cooling.Component;

model InvertorCoolingModule
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
    Placement(transformation(origin = {-158, 68}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res_pipe_md(R = R_pipe_md) annotation(
    HideResult = true,
    Placement(transformation(origin = {-158, -10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor module(V = module_V, material = module_material, T_start = T_init_module) annotation(
    Placement(transformation(origin = {-158, 30}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment pipe(redeclare package Medium = Medium, p_start = p_init_pipe, h_start = Medium.specificEnthalpy_pT(p_init_pipe, T_init_pipe), geometry = EAST.TwoPhaseFlow.Component.Pipes.PipeGeometry.Rectangular, length = pipe_L, rectangularLongSide = pipe_W_long, rectangularShortSide = pipe_W_short) annotation(
    Placement(transformation(origin = {-158, -148}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor pipe_mass(material = pipe_material, T_start = T_init_pipe, V = pipe_massV) annotation(
    HideResult = true,
    Placement(transformation(origin = {-158, -108}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.ThermalConductor cond_pipe(A = pipe_massS, L = pipe_L, material = pipe_material) annotation(
    HideResult = true,
    Placement(transformation(origin = {-90, -108}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow invertorLossSource1 annotation(
    HideResult = true,
    Placement(transformation(origin = {-48, 68}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res_pipe_md1(R = R_pipe_md) annotation(
    HideResult = true,
    Placement(transformation(origin = {-48, -10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor module1(T_start = T_init_module, V = module_V, material = module_material) annotation(
    Placement(transformation(origin = {-48, 30}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment pipe1(redeclare package Medium = Medium, geometry = EAST.TwoPhaseFlow.Component.Pipes.PipeGeometry.Rectangular, h_start = Medium.specificEnthalpy_pT(p_init_pipe, T_init_pipe), length = pipe_L, p_start = p_init_pipe, rectangularLongSide = pipe_W_long, rectangularShortSide = pipe_W_short) annotation(
    Placement(transformation(origin = {-48, -148}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor pipe_mass1(T_start = T_init_pipe, V = pipe_massV, material = pipe_material) annotation(
    HideResult = true,
    Placement(transformation(origin = {-48, -108}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.ThermalConductor cond_pipe1(A = pipe_massS, L = pipe_L, material = pipe_material) annotation(
    HideResult = true,
    Placement(transformation(origin = {-6, -108}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow invertorLossSource2 annotation(
    HideResult = true,
    Placement(transformation(origin = {36, 68}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res_pipe_md2(R = R_pipe_md) annotation(
    HideResult = true,
    Placement(transformation(origin = {36, -10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor module2(T_start = T_init_module, V = module_V, material = module_material) annotation(
    Placement(transformation(origin = {36, 30}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment pipe2(redeclare package Medium = Medium, geometry = EAST.TwoPhaseFlow.Component.Pipes.PipeGeometry.Rectangular, h_start = Medium.specificEnthalpy_pT(p_init_pipe, T_init_pipe), length = pipe_L, p_start = p_init_pipe, rectangularLongSide = pipe_W_long, rectangularShortSide = pipe_W_short) annotation(
    Placement(transformation(origin = {36, -148}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor pipe_mass2(T_start = T_init_pipe, V = pipe_massV, material = pipe_material) annotation(
    HideResult = true,
    Placement(transformation(origin = {36, -108}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.ThermalConductor cond_pipe2(A = pipe_massS, L = pipe_L, material = pipe_material) annotation(
    HideResult = true,
    Placement(transformation(origin = {82, -108}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow invertorLossSource3 annotation(
    HideResult = true,
    Placement(transformation(origin = {126, 68}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res_pipe_md3(R = R_pipe_md) annotation(
    HideResult = true,
    Placement(transformation(origin = {126, -10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor module3(T_start = T_init_module, V = module_V, material = module_material) annotation(
    Placement(transformation(origin = {126, 30}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment pipe3(redeclare package Medium = Medium, geometry = EAST.TwoPhaseFlow.Component.Pipes.PipeGeometry.Rectangular, h_start = Medium.specificEnthalpy_pT(p_init_pipe, T_init_pipe), length = pipe_L, p_start = p_init_pipe, rectangularLongSide = pipe_W_long, rectangularShortSide = pipe_W_short) annotation(
    Placement(transformation(origin = {126, -148}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor pipe_mass3(T_start = T_init_pipe, V = pipe_massV, material = pipe_material) annotation(
    HideResult = true,
    Placement(transformation(origin = {126, -108}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.ThermalConductor cond_pipe3(A = pipe_massS, L = pipe_L, material = pipe_material) annotation(
    HideResult = true,
    Placement(transformation(origin = {172, -108}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow invertorLossSource4 annotation(
    HideResult = true,
    Placement(transformation(origin = {210, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res_pipe_md4(R = R_pipe_md) annotation(
    HideResult = true,
    Placement(transformation(origin = {210, -10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor module4(T_start = T_init_module, V = module_V, material = module_material) annotation(
    Placement(transformation(origin = {210, 30}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment pipe4(redeclare package Medium = Medium, geometry = EAST.TwoPhaseFlow.Component.Pipes.PipeGeometry.Rectangular, h_start = Medium.specificEnthalpy_pT(p_init_pipe, T_init_pipe), length = pipe_L, p_start = p_init_pipe, rectangularLongSide = pipe_W_long, rectangularShortSide = pipe_W_short) annotation(
    Placement(transformation(origin = {210, -148}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor pipe_mass4(T_start = T_init_pipe, V = pipe_massV, material = pipe_material) annotation(
    HideResult = true,
    Placement(transformation(origin = {210, -108}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_a port_a(redeclare package Medium = Medium, p(start = p_init_pipe, nominal = 1.0e5)) annotation(
    Placement(transformation(origin = {-110, -148}, extent = {{-110, -10}, {-90, 10}}), iconTransformation(extent = {{-110, -10}, {-90, 10}})));
  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium, p(start = p_init_pipe, nominal = 1.0e5)) annotation(
    Placement(transformation(origin = {160, -148}, extent = {{90, -10}, {110, 10}}), iconTransformation(extent = {{90, -10}, {110, 10}})));
  Modelica.Blocks.Interfaces.RealInput lossInput annotation(
    Placement(transformation(origin = {-252, 106}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {0, 90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Division division annotation(
    HideResult = true,
    Placement(transformation(origin = {-188, 100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = nNode) annotation(
    HideResult = true,
    Placement(transformation(origin = {-296, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaterSource annotation(
    HideResult = true,
    Placement(transformation(origin = {-190, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaterSource1 annotation(
    HideResult = true,
    Placement(transformation(origin = {-78, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaterSource2 annotation(
    HideResult = true,
    Placement(transformation(origin = {0, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaterSource3 annotation(
    HideResult = true,
    Placement(transformation(origin = {80, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaterSource4 annotation(
    HideResult = true,
    Placement(transformation(origin = {180, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Division division1 annotation(
    HideResult = true,
    Placement(transformation(origin = {-242, -22}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput heaterInput annotation(
    Placement(transformation(origin = {-312, -6}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-90, 50}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(pipe_mass.port_bottom, pipe.heatPort) annotation(
    Line(points = {{-158, -118}, {-158, -144}}, color = {191, 0, 0}));
  connect(pipe_mass.port_right, cond_pipe.port_a) annotation(
    Line(points = {{-148, -108}, {-100, -108}}, color = {191, 0, 0}));
  connect(res_pipe_md.port_b, pipe_mass.port_top) annotation(
    Line(points = {{-158, -20}, {-158, -98}}, color = {191, 0, 0}));
  connect(module.port_bottom, res_pipe_md.port_a) annotation(
    Line(points = {{-158, 20}, {-158, 0}}, color = {191, 0, 0}));
  connect(invertorLossSource.port, module.port_top) annotation(
    Line(points = {{-158, 58}, {-158, 40}}, color = {191, 0, 0}));
  connect(pipe_mass1.port_bottom, pipe1.heatPort) annotation(
    Line(points = {{-48, -118}, {-48, -144}}, color = {191, 0, 0}));
  connect(pipe_mass1.port_right, cond_pipe1.port_a) annotation(
    Line(points = {{-38, -108}, {-16, -108}}, color = {191, 0, 0}));
  connect(res_pipe_md1.port_b, pipe_mass1.port_top) annotation(
    Line(points = {{-48, -20}, {-48, -98}}, color = {191, 0, 0}));
  connect(module1.port_bottom, res_pipe_md1.port_a) annotation(
    Line(points = {{-48, 20}, {-48, 0}}, color = {191, 0, 0}));
  connect(invertorLossSource1.port, module1.port_top) annotation(
    Line(points = {{-48, 58}, {-48, 40}}, color = {191, 0, 0}));
  connect(pipe_mass2.port_bottom, pipe2.heatPort) annotation(
    Line(points = {{36, -118}, {36, -144}}, color = {191, 0, 0}));
  connect(pipe_mass2.port_right, cond_pipe2.port_a) annotation(
    Line(points = {{46, -108}, {72, -108}}, color = {191, 0, 0}));
  connect(res_pipe_md2.port_b, pipe_mass2.port_top) annotation(
    Line(points = {{36, -20}, {36, -98}}, color = {191, 0, 0}));
  connect(module2.port_bottom, res_pipe_md2.port_a) annotation(
    Line(points = {{36, 20}, {36, 0}}, color = {191, 0, 0}));
  connect(invertorLossSource2.port, module2.port_top) annotation(
    Line(points = {{36, 58}, {36, 40}}, color = {191, 0, 0}));
  connect(pipe_mass3.port_bottom, pipe3.heatPort) annotation(
    Line(points = {{126, -118}, {126, -144}}, color = {191, 0, 0}));
  connect(pipe_mass3.port_right, cond_pipe3.port_a) annotation(
    Line(points = {{136, -108}, {162, -108}}, color = {191, 0, 0}));
  connect(res_pipe_md3.port_b, pipe_mass3.port_top) annotation(
    Line(points = {{126, -20}, {126, -98}}, color = {191, 0, 0}));
  connect(module3.port_bottom, res_pipe_md3.port_a) annotation(
    Line(points = {{126, 20}, {126, 0}}, color = {191, 0, 0}));
  connect(invertorLossSource3.port, module3.port_top) annotation(
    Line(points = {{126, 58}, {126, 40}}, color = {191, 0, 0}));
  connect(pipe_mass4.port_bottom, pipe4.heatPort) annotation(
    Line(points = {{210, -118}, {210, -144}}, color = {191, 0, 0}));
  connect(res_pipe_md4.port_b, pipe_mass4.port_top) annotation(
    Line(points = {{210, -20}, {210, -98}}, color = {191, 0, 0}));
  connect(module4.port_bottom, res_pipe_md4.port_a) annotation(
    Line(points = {{210, 20}, {210, 0}}, color = {191, 0, 0}));
  connect(invertorLossSource4.port, module4.port_top) annotation(
    Line(points = {{210, 60}, {210, 40}}, color = {191, 0, 0}));
  connect(pipe.port_b, pipe1.port_a) annotation(
    Line(points = {{-148, -148}, {-58, -148}}, color = {0, 0, 127}));
  connect(cond_pipe.port_b, pipe_mass1.port_left) annotation(
    Line(points = {{-80, -108}, {-58, -108}}, color = {191, 0, 0}));
  connect(cond_pipe1.port_b, pipe_mass2.port_left) annotation(
    Line(points = {{4, -108}, {26, -108}}, color = {191, 0, 0}));
  connect(pipe1.port_b, pipe2.port_a) annotation(
    Line(points = {{-38, -148}, {26, -148}}, color = {0, 0, 127}));
  connect(pipe2.port_b, pipe3.port_a) annotation(
    Line(points = {{46, -148}, {116, -148}}, color = {0, 0, 127}));
  connect(pipe3.port_b, pipe4.port_a) annotation(
    Line(points = {{136, -148}, {200, -148}}, color = {0, 0, 127}));
  connect(cond_pipe3.port_b, pipe_mass4.port_left) annotation(
    Line(points = {{182, -108}, {200, -108}}, color = {191, 0, 0}));
  connect(cond_pipe2.port_b, pipe_mass3.port_left) annotation(
    Line(points = {{92, -108}, {116, -108}}, color = {191, 0, 0}));
  connect(port_a, pipe.port_a) annotation(
    Line(points = {{-210, -148}, {-168, -148}}, color = {0, 127, 255}));
  connect(port_b, pipe4.port_b) annotation(
    Line(points = {{260, -148}, {220, -148}}, color = {0, 0, 255}));
  connect(const.y, division.u2) annotation(
    Line(points = {{-285, 50}, {-202, 50}, {-202, 94}, {-200, 94}}, color = {0, 0, 127}));
  connect(lossInput, division.u1) annotation(
    Line(points = {{-252, 106}, {-200, 106}}, color = {0, 0, 127}));
  connect(division.y, invertorLossSource.Q_flow) annotation(
    Line(points = {{-176, 100}, {-158, 100}, {-158, 78}}, color = {0, 0, 127}));
  connect(division.y, invertorLossSource1.Q_flow) annotation(
    Line(points = {{-176, 100}, {-48, 100}, {-48, 78}}, color = {0, 0, 127}));
  connect(division.y, invertorLossSource2.Q_flow) annotation(
    Line(points = {{-176, 100}, {36, 100}, {36, 78}}, color = {0, 0, 127}));
  connect(division.y, invertorLossSource3.Q_flow) annotation(
    Line(points = {{-176, 100}, {126, 100}, {126, 78}}, color = {0, 0, 127}));
  connect(division.y, invertorLossSource4.Q_flow) annotation(
    Line(points = {{-176, 100}, {210, 100}, {210, 80}}, color = {0, 0, 127}));
  connect(module4.port_left, heaterSource4.port) annotation(
    Line(points = {{200, 30}, {180, 30}, {180, 22}}, color = {191, 0, 0}));
  connect(module3.port_left, heaterSource3.port) annotation(
    Line(points = {{116, 30}, {80, 30}, {80, 20}}, color = {191, 0, 0}));
  connect(module2.port_left, heaterSource2.port) annotation(
    Line(points = {{26, 30}, {0, 30}, {0, 20}}, color = {191, 0, 0}));
  connect(module1.port_left, heaterSource1.port) annotation(
    Line(points = {{-58, 30}, {-78, 30}, {-78, 20}}, color = {191, 0, 0}));
  connect(module.port_left, heaterSource.port) annotation(
    Line(points = {{-168, 30}, {-190, 30}, {-190, 18}}, color = {191, 0, 0}));
  connect(const.y, division1.u2) annotation(
    Line(points = {{-284, 50}, {-276, 50}, {-276, -28}, {-254, -28}}, color = {0, 0, 127}));
  connect(heaterInput, division1.u1) annotation(
    Line(points = {{-312, -6}, {-254, -6}, {-254, -16}}, color = {0, 0, 127}));
  connect(division1.y, heaterSource.Q_flow) annotation(
    Line(points = {{-230, -22}, {-190, -22}, {-190, -2}}, color = {0, 0, 127}));
  connect(division1.y, heaterSource1.Q_flow) annotation(
    Line(points = {{-230, -22}, {-78, -22}, {-78, 0}}, color = {0, 0, 127}));
  connect(division1.y, heaterSource2.Q_flow) annotation(
    Line(points = {{-230, -22}, {0, -22}, {0, 0}}, color = {0, 0, 127}));
  connect(division1.y, heaterSource3.Q_flow) annotation(
    Line(points = {{-230, -22}, {80, -22}, {80, 0}}, color = {0, 0, 127}));
  connect(division1.y, heaterSource4.Q_flow) annotation(
    Line(points = {{-230, -22}, {180, -22}, {180, 2}}, color = {0, 0, 127}));
  annotation(
    experiment(StopTime = 100),
    Icon(graphics = {Text(origin = {-160, 60}, extent = {{-40, 20}, {40, -20}}, textString = "heater")}),
    Diagram(coordinateSystem(extent = {{-260, 120}, {260, -120}})));
end InvertorCoolingModule;
