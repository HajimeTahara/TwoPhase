within ModelicaProjects;

model InvertorCoolingModule
  extends EAST.Icons.HexPipe;
  import Modelica.Units.SI;
  replaceable package Medium = EAST.TwoPhaseFlow.Media.LCH_FD
    annotation(choicesAllMatching = true);
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
  parameter SI.Length pipe_H = 0.003 annotation(
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
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow invertorLossSource annotation(
    Placement(transformation(origin = {-158, 66}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant constLoss(k = loss_modules) annotation(
    Placement(transformation(origin = {-216, 110}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res_pipe_md(R = R_pipe_md) annotation(
    Placement(transformation(origin = {-158, -20}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor module(V = module_V, material = module_material, T_start = T_init_module) annotation(
    Placement(transformation(origin = {-158, 26}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment pipe(redeclare package Medium = Medium, p_start = p_init_pipe, h_start = Medium.specificEnthalpy_pT(p_init_pipe, T_init_pipe), geometry = EAST.TwoPhaseFlow.Component.Pipes.PipeGeometry.Rectangular, length = pipe_L, rectangularLongSide = pipe_W_long, rectangularShortSide = pipe_W_short) annotation(
    Placement(transformation(origin = {-158, -94}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor pipe_mass(material = pipe_material, T_start = T_init_pipe, V = pipe_massV) annotation(
    Placement(transformation(origin = {-158, -54}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.ThermalConductor cond_pipe(A = pipe_massS, L = pipe_L, material = pipe_material) annotation(
    Placement(transformation(origin = {-120, -54}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow invertorLossSource1 annotation(
    Placement(transformation(origin = {-78, 66}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res_pipe_md1(R = R_pipe_md) annotation(
    Placement(transformation(origin = {-78, -22}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor module1(T_start = T_init_module, V = module_V, material = module_material) annotation(
    Placement(transformation(origin = {-78, 26}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment pipe1(redeclare package Medium = Medium, geometry = EAST.TwoPhaseFlow.Component.Pipes.PipeGeometry.Rectangular, h_start = Medium.specificEnthalpy_pT(p_init_pipe, T_init_pipe), length = pipe_L, p_start = p_init_pipe, rectangularLongSide = pipe_W_long, rectangularShortSide = pipe_W_short) annotation(
    Placement(transformation(origin = {-78, -94}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor pipe_mass1(T_start = T_init_pipe, V = pipe_massV, material = pipe_material) annotation(
    Placement(transformation(origin = {-78, -54}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.ThermalConductor cond_pipe1(A = pipe_massS, L = pipe_L, material = pipe_material) annotation(
    Placement(transformation(origin = {-36, -54}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow invertorLossSource2 annotation(
    Placement(transformation(origin = {6, 58}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res_pipe_md2(R = R_pipe_md) annotation(
    Placement(transformation(origin = {6, -22}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor module2(T_start = T_init_module, V = module_V, material = module_material) annotation(
    Placement(transformation(origin = {6, 18}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment pipe2(redeclare package Medium = Medium, geometry = EAST.TwoPhaseFlow.Component.Pipes.PipeGeometry.Rectangular, h_start = Medium.specificEnthalpy_pT(p_init_pipe, T_init_pipe), length = pipe_L, p_start = p_init_pipe, rectangularLongSide = pipe_W_long, rectangularShortSide = pipe_W_short) annotation(
    Placement(transformation(origin = {6, -94}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor pipe_mass2(T_start = T_init_pipe, V = pipe_massV, material = pipe_material) annotation(
    Placement(transformation(origin = {6, -54}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.ThermalConductor cond_pipe2(A = pipe_massS, L = pipe_L, material = pipe_material) annotation(
    Placement(transformation(origin = {52, -54}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow invertorLossSource3 annotation(
    Placement(transformation(origin = {96, 58}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res_pipe_md3(R = R_pipe_md) annotation(
    Placement(transformation(origin = {96, -22}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor module3(T_start = T_init_module, V = module_V, material = module_material) annotation(
    Placement(transformation(origin = {96, 20}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment pipe3(redeclare package Medium = Medium, geometry = EAST.TwoPhaseFlow.Component.Pipes.PipeGeometry.Rectangular, h_start = Medium.specificEnthalpy_pT(p_init_pipe, T_init_pipe), length = pipe_L, p_start = p_init_pipe, rectangularLongSide = pipe_W_long, rectangularShortSide = pipe_W_short) annotation(
    Placement(transformation(origin = {96, -94}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor pipe_mass3(T_start = T_init_pipe, V = pipe_massV, material = pipe_material) annotation(
    Placement(transformation(origin = {96, -54}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.ThermalConductor cond_pipe3(A = pipe_massS, L = pipe_L, material = pipe_material) annotation(
    Placement(transformation(origin = {142, -54}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow invertorLossSource4 annotation(
    Placement(transformation(origin = {180, 58}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res_pipe_md4(R = R_pipe_md) annotation(
    Placement(transformation(origin = {180, -22}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor module4(T_start = T_init_module, V = module_V, material = module_material) annotation(
    Placement(transformation(origin = {180, 18}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment pipe4(redeclare package Medium = Medium, geometry = EAST.TwoPhaseFlow.Component.Pipes.PipeGeometry.Rectangular, h_start = Medium.specificEnthalpy_pT(p_init_pipe, T_init_pipe), length = pipe_L, p_start = p_init_pipe, rectangularLongSide = pipe_W_long, rectangularShortSide = pipe_W_short) annotation(
    Placement(transformation(origin = {180, -94}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor pipe_mass4(T_start = T_init_pipe, V = pipe_massV, material = pipe_material) annotation(
    Placement(transformation(origin = {180, -54}, extent = {{-10, -10}, {10, 10}})));
  
  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_a port_a(
    redeclare package Medium = Medium,
    p(start=p_init_pipe, nominal=1.0e5))
    annotation (Placement(transformation(origin = {-120, -94}, extent = {{-110, -10}, {-90, 10}}), iconTransformation(extent = {{-110, -10}, {-90, 10}})));
  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_b port_b(
    redeclare package Medium = Medium,
    p(start=p_init_pipe, nominal=1.0e5))
    annotation (Placement(transformation(origin = {138, -94}, extent = {{90, -10}, {110, 10}}), iconTransformation(extent = {{90, -10}, {110, 10}})));
    
equation
  connect(pipe_mass.port_bottom, pipe.heatPort) annotation(
    Line(points = {{-158, -64}, {-158, -90}}, color = {191, 0, 0}));
  connect(pipe_mass.port_right, cond_pipe.port_a) annotation(
    Line(points = {{-148, -54}, {-130, -54}}, color = {191, 0, 0}));
  connect(res_pipe_md.port_b, pipe_mass.port_top) annotation(
    Line(points = {{-158, -30}, {-158, -44}}, color = {191, 0, 0}));
  connect(module.port_bottom, res_pipe_md.port_a) annotation(
    Line(points = {{-158, 16}, {-158, -10}}, color = {191, 0, 0}));
  connect(invertorLossSource.port, module.port_top) annotation(
    Line(points = {{-158, 56}, {-158, 36}}, color = {191, 0, 0}));
  connect(pipe_mass1.port_bottom, pipe1.heatPort) annotation(
    Line(points = {{-78, -64}, {-78, -90}}, color = {191, 0, 0}));
  connect(pipe_mass1.port_right, cond_pipe1.port_a) annotation(
    Line(points = {{-68, -54}, {-46, -54}}, color = {191, 0, 0}));
  connect(res_pipe_md1.port_b, pipe_mass1.port_top) annotation(
    Line(points = {{-78, -32}, {-78, -44}}, color = {191, 0, 0}));
  connect(module1.port_bottom, res_pipe_md1.port_a) annotation(
    Line(points = {{-78, 16}, {-78, -12}}, color = {191, 0, 0}));
  connect(invertorLossSource1.port, module1.port_top) annotation(
    Line(points = {{-78, 56}, {-78, 36}}, color = {191, 0, 0}));
  connect(pipe_mass2.port_bottom, pipe2.heatPort) annotation(
    Line(points = {{6, -64}, {6, -90}}, color = {191, 0, 0}));
  connect(pipe_mass2.port_right, cond_pipe2.port_a) annotation(
    Line(points = {{16, -54}, {42, -54}}, color = {191, 0, 0}));
  connect(res_pipe_md2.port_b, pipe_mass2.port_top) annotation(
    Line(points = {{6, -32}, {6, -44}}, color = {191, 0, 0}));
  connect(module2.port_bottom, res_pipe_md2.port_a) annotation(
    Line(points = {{6, 8}, {6, -12}}, color = {191, 0, 0}));
  connect(invertorLossSource2.port, module2.port_top) annotation(
    Line(points = {{6, 48}, {6, 28}}, color = {191, 0, 0}));
  connect(pipe_mass3.port_bottom, pipe3.heatPort) annotation(
    Line(points = {{96, -64}, {96, -90}}, color = {191, 0, 0}));
  connect(pipe_mass3.port_right, cond_pipe3.port_a) annotation(
    Line(points = {{106, -54}, {132, -54}}, color = {191, 0, 0}));
  connect(res_pipe_md3.port_b, pipe_mass3.port_top) annotation(
    Line(points = {{96, -32}, {96, -44}}, color = {191, 0, 0}));
  connect(module3.port_bottom, res_pipe_md3.port_a) annotation(
    Line(points = {{96, 10}, {96, -12}}, color = {191, 0, 0}));
  connect(invertorLossSource3.port, module3.port_top) annotation(
    Line(points = {{96, 48}, {96, 30}}, color = {191, 0, 0}));
  connect(pipe_mass4.port_bottom, pipe4.heatPort) annotation(
    Line(points = {{180, -64}, {180, -90}}, color = {191, 0, 0}));
  connect(res_pipe_md4.port_b, pipe_mass4.port_top) annotation(
    Line(points = {{180, -32}, {180, -44}}, color = {191, 0, 0}));
  connect(module4.port_bottom, res_pipe_md4.port_a) annotation(
    Line(points = {{180, 8}, {180, -12}}, color = {191, 0, 0}));
  connect(invertorLossSource4.port, module4.port_top) annotation(
    Line(points = {{180, 48}, {180, 28}}, color = {191, 0, 0}));
  connect(pipe.port_b, pipe1.port_a) annotation(
    Line(points = {{-148, -94}, {-88, -94}}, color = {0, 0, 127}));
  connect(cond_pipe.port_b, pipe_mass1.port_left) annotation(
    Line(points = {{-110, -54}, {-88, -54}}, color = {191, 0, 0}));
  connect(cond_pipe1.port_b, pipe_mass2.port_left) annotation(
    Line(points = {{-26, -54}, {-4, -54}}, color = {191, 0, 0}));
  connect(pipe1.port_b, pipe2.port_a) annotation(
    Line(points = {{-68, -94}, {-4, -94}}, color = {0, 0, 127}));
  connect(pipe2.port_b, pipe3.port_a) annotation(
    Line(points = {{16, -94}, {86, -94}}, color = {0, 0, 127}));
  connect(pipe3.port_b, pipe4.port_a) annotation(
    Line(points = {{106, -94}, {170, -94}}, color = {0, 0, 127}));
  connect(cond_pipe3.port_b, pipe_mass4.port_left) annotation(
    Line(points = {{152, -54}, {170, -54}}, color = {191, 0, 0}));
  connect(cond_pipe2.port_b, pipe_mass3.port_left) annotation(
    Line(points = {{62, -54}, {86, -54}}, color = {191, 0, 0}));
  connect(constLoss.y, invertorLossSource4.Q_flow) annotation(
    Line(points = {{-205, 110}, {179, 110}, {179, 68}}, color = {0, 0, 127}));
  connect(constLoss.y, invertorLossSource3.Q_flow) annotation(
    Line(points = {{-205, 110}, {95, 110}, {95, 68}}, color = {0, 0, 127}));
  connect(constLoss.y, invertorLossSource2.Q_flow) annotation(
    Line(points = {{-205, 110}, {5, 110}, {5, 68}}, color = {0, 0, 127}));
  connect(constLoss.y, invertorLossSource1.Q_flow) annotation(
    Line(points = {{-205, 110}, {-79, 110}, {-79, 76}}, color = {0, 0, 127}));
  connect(constLoss.y, invertorLossSource.Q_flow) annotation(
    Line(points = {{-205, 110}, {-159, 110}, {-159, 76}}, color = {0, 0, 127}));
  connect(port_a, pipe.port_a) annotation(
    Line(points = {{-220, -94}, {-168, -94}}, color = {0, 127, 255}));
  connect(port_b, pipe4.port_b) annotation(
    Line(points = {{238, -94}, {190, -94}}, color = {0, 0, 255}));
  annotation(experiment(StopTime = 100),
    Icon,
  Diagram(coordinateSystem(extent = {{-260, 120}, {260, -120}})));
end InvertorCoolingModule;
