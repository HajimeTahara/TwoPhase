within ModelicaProjects;

model InvertorCoolingTest
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
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow invertorLossSource annotation(
    Placement(transformation(origin = {-162, 54}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant constLoss(k = loss_modules) annotation(
    Placement(transformation(origin = {-220, 98}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res_pipe_md(R = R_pipe_md) annotation(
    Placement(transformation(origin = {-162, -32}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor module(V = module_V, material = module_material, T_start = T_init_module) annotation(
    Placement(transformation(origin = {-162, 14}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment pipe(redeclare package Medium = medium, p_start = p_init_pipe, h_start = medium.specificEnthalpy_pT(p_init_pipe, T_init_pipe), geometry = EAST.TwoPhaseFlow.Component.Pipes.PipeGeometry.Rectangular, length = pipe_L, rectangularLongSide = pipe_W_long, rectangularShortSide = pipe_W_short) annotation(
    Placement(transformation(origin = {-162, -106}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor pipe_mass(material = pipe_material, T_start = T_init_pipe, V = pipe_massV) annotation(
    Placement(transformation(origin = {-162, -66}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.ThermalConductor cond_pipe(A = pipe_massS, L = pipe_L, material = pipe_material) annotation(
    Placement(transformation(origin = {-124, -66}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow invertorLossSource1 annotation(
    Placement(transformation(origin = {-82, 54}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res_pipe_md1(R = R_pipe_md) annotation(
    Placement(transformation(origin = {-82, -34}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor module1(T_start = T_init_module, V = module_V, material = module_material) annotation(
    Placement(transformation(origin = {-82, 14}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment pipe1(redeclare package Medium = medium, geometry = EAST.TwoPhaseFlow.Component.Pipes.PipeGeometry.Rectangular, h_start = medium.specificEnthalpy_pT(p_init_pipe, T_init_pipe), length = pipe_L, p_start = p_init_pipe, rectangularLongSide = pipe_W_long, rectangularShortSide = pipe_W_short) annotation(
    Placement(transformation(origin = {-82, -106}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor pipe_mass1(T_start = T_init_pipe, V = pipe_massV, material = pipe_material) annotation(
    Placement(transformation(origin = {-82, -66}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.ThermalConductor cond_pipe1(A = pipe_massS, L = pipe_L, material = pipe_material) annotation(
    Placement(transformation(origin = {-40, -66}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow invertorLossSource2 annotation(
    Placement(transformation(origin = {2, 46}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res_pipe_md2(R = R_pipe_md) annotation(
    Placement(transformation(origin = {2, -34}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor module2(T_start = T_init_module, V = module_V, material = module_material) annotation(
    Placement(transformation(origin = {2, 6}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment pipe2(redeclare package Medium = medium, geometry = EAST.TwoPhaseFlow.Component.Pipes.PipeGeometry.Rectangular, h_start = medium.specificEnthalpy_pT(p_init_pipe, T_init_pipe), length = pipe_L, p_start = p_init_pipe, rectangularLongSide = pipe_W_long, rectangularShortSide = pipe_W_short) annotation(
    Placement(transformation(origin = {2, -106}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor pipe_mass2(T_start = T_init_pipe, V = pipe_massV, material = pipe_material) annotation(
    Placement(transformation(origin = {2, -66}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.ThermalConductor cond_pipe2(A = pipe_massS, L = pipe_L, material = pipe_material) annotation(
    Placement(transformation(origin = {48, -66}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow invertorLossSource3 annotation(
    Placement(transformation(origin = {92, 46}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res_pipe_md3(R = R_pipe_md) annotation(
    Placement(transformation(origin = {92, -34}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor module3(T_start = T_init_module, V = module_V, material = module_material) annotation(
    Placement(transformation(origin = {92, 8}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment pipe3(redeclare package Medium = medium, geometry = EAST.TwoPhaseFlow.Component.Pipes.PipeGeometry.Rectangular, h_start = medium.specificEnthalpy_pT(p_init_pipe, T_init_pipe), length = pipe_L, p_start = p_init_pipe, rectangularLongSide = pipe_W_long, rectangularShortSide = pipe_W_short) annotation(
    Placement(transformation(origin = {92, -106}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor pipe_mass3(T_start = T_init_pipe, V = pipe_massV, material = pipe_material) annotation(
    Placement(transformation(origin = {92, -66}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.ThermalConductor cond_pipe3(A = pipe_massS, L = pipe_L, material = pipe_material) annotation(
    Placement(transformation(origin = {138, -66}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow invertorLossSource4 annotation(
    Placement(transformation(origin = {176, 46}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res_pipe_md4(R = R_pipe_md) annotation(
    Placement(transformation(origin = {176, -34}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor module4(T_start = T_init_module, V = module_V, material = module_material) annotation(
    Placement(transformation(origin = {176, 6}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment pipe4(redeclare package Medium = medium, geometry = EAST.TwoPhaseFlow.Component.Pipes.PipeGeometry.Rectangular, h_start = medium.specificEnthalpy_pT(p_init_pipe, T_init_pipe), length = pipe_L, p_start = p_init_pipe, rectangularLongSide = pipe_W_long, rectangularShortSide = pipe_W_short) annotation(
    Placement(transformation(origin = {176, -106}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.HeatCapacitor pipe_mass4(T_start = T_init_pipe, V = pipe_massV, material = pipe_material) annotation(
    Placement(transformation(origin = {176, -66}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Sources.Boundary_pT boundary_pT(redeclare package Medium = medium, p_set = p_init_pipe, T_set = T_init_pipe)  annotation(
    Placement(transformation(origin = {250, -130}, extent = {{10, -10}, {-10, 10}})));
  EAST.TwoPhaseFlow.Component.Sources.MassFlowSource_T massFlowSource_T(redeclare package Medium = medium, T_set = T_init_pipe, m_flow_set = 0.04)  annotation(
    Placement(transformation(origin = {-224, -130}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(pipe_mass.port_bottom, pipe.heatPort) annotation(
    Line(points = {{-162, -76}, {-162, -102}}, color = {191, 0, 0}));
  connect(pipe_mass.port_right, cond_pipe.port_a) annotation(
    Line(points = {{-152, -66}, {-134, -66}}, color = {191, 0, 0}));
  connect(res_pipe_md.port_b, pipe_mass.port_top) annotation(
    Line(points = {{-162, -42}, {-162, -56}}, color = {191, 0, 0}));
  connect(module.port_bottom, res_pipe_md.port_a) annotation(
    Line(points = {{-162, 4}, {-162, -22}}, color = {191, 0, 0}));
  connect(invertorLossSource.port, module.port_top) annotation(
    Line(points = {{-162, 44}, {-162, 24}}, color = {191, 0, 0}));
  connect(pipe_mass1.port_bottom, pipe1.heatPort) annotation(
    Line(points = {{-82, -76}, {-82, -102}}, color = {191, 0, 0}));
  connect(pipe_mass1.port_right, cond_pipe1.port_a) annotation(
    Line(points = {{-72, -66}, {-50, -66}}, color = {191, 0, 0}));
  connect(res_pipe_md1.port_b, pipe_mass1.port_top) annotation(
    Line(points = {{-82, -44}, {-82, -56}}, color = {191, 0, 0}));
  connect(module1.port_bottom, res_pipe_md1.port_a) annotation(
    Line(points = {{-82, 4}, {-82, -24}}, color = {191, 0, 0}));
  connect(invertorLossSource1.port, module1.port_top) annotation(
    Line(points = {{-82, 44}, {-82, 24}}, color = {191, 0, 0}));
  connect(pipe_mass2.port_bottom, pipe2.heatPort) annotation(
    Line(points = {{2, -76}, {2, -102}}, color = {191, 0, 0}));
  connect(pipe_mass2.port_right, cond_pipe2.port_a) annotation(
    Line(points = {{12, -66}, {38, -66}}, color = {191, 0, 0}));
  connect(res_pipe_md2.port_b, pipe_mass2.port_top) annotation(
    Line(points = {{2, -44}, {2, -56}}, color = {191, 0, 0}));
  connect(module2.port_bottom, res_pipe_md2.port_a) annotation(
    Line(points = {{2, -4}, {2, -24}}, color = {191, 0, 0}));
  connect(invertorLossSource2.port, module2.port_top) annotation(
    Line(points = {{2, 36}, {2, 16}}, color = {191, 0, 0}));
  connect(pipe_mass3.port_bottom, pipe3.heatPort) annotation(
    Line(points = {{92, -76}, {92, -102}}, color = {191, 0, 0}));
  connect(pipe_mass3.port_right, cond_pipe3.port_a) annotation(
    Line(points = {{102, -66}, {128, -66}}, color = {191, 0, 0}));
  connect(res_pipe_md3.port_b, pipe_mass3.port_top) annotation(
    Line(points = {{92, -44}, {92, -56}}, color = {191, 0, 0}));
  connect(module3.port_bottom, res_pipe_md3.port_a) annotation(
    Line(points = {{92, -2}, {92, -24}}, color = {191, 0, 0}));
  connect(invertorLossSource3.port, module3.port_top) annotation(
    Line(points = {{92, 36}, {92, 18}}, color = {191, 0, 0}));
  connect(pipe_mass4.port_bottom, pipe4.heatPort) annotation(
    Line(points = {{176, -76}, {176, -102}}, color = {191, 0, 0}));
  connect(res_pipe_md4.port_b, pipe_mass4.port_top) annotation(
    Line(points = {{176, -44}, {176, -56}}, color = {191, 0, 0}));
  connect(module4.port_bottom, res_pipe_md4.port_a) annotation(
    Line(points = {{176, -4}, {176, -24}}, color = {191, 0, 0}));
  connect(invertorLossSource4.port, module4.port_top) annotation(
    Line(points = {{176, 36}, {176, 16}}, color = {191, 0, 0}));
  connect(pipe.port_b, pipe1.port_a) annotation(
    Line(points = {{-152, -106}, {-92, -106}}, color = {0, 0, 127}));
  connect(cond_pipe.port_b, pipe_mass1.port_left) annotation(
    Line(points = {{-114, -66}, {-92, -66}}, color = {191, 0, 0}));
  connect(cond_pipe1.port_b, pipe_mass2.port_left) annotation(
    Line(points = {{-30, -66}, {-8, -66}}, color = {191, 0, 0}));
  connect(pipe1.port_b, pipe2.port_a) annotation(
    Line(points = {{-72, -106}, {-8, -106}}, color = {0, 0, 127}));
  connect(pipe2.port_b, pipe3.port_a) annotation(
    Line(points = {{12, -106}, {82, -106}}, color = {0, 0, 127}));
  connect(pipe3.port_b, pipe4.port_a) annotation(
    Line(points = {{102, -106}, {166, -106}}, color = {0, 0, 127}));
  connect(cond_pipe3.port_b, pipe_mass4.port_left) annotation(
    Line(points = {{148, -66}, {166, -66}}, color = {191, 0, 0}));
  connect(cond_pipe2.port_b, pipe_mass3.port_left) annotation(
    Line(points = {{58, -66}, {82, -66}}, color = {191, 0, 0}));
  connect(constLoss.y, invertorLossSource4.Q_flow) annotation(
    Line(points = {{-209, 98}, {175, 98}, {175, 56}}, color = {0, 0, 127}));
  connect(constLoss.y, invertorLossSource3.Q_flow) annotation(
    Line(points = {{-209, 98}, {91, 98}, {91, 56}}, color = {0, 0, 127}));
  connect(constLoss.y, invertorLossSource2.Q_flow) annotation(
    Line(points = {{-209, 98}, {1, 98}, {1, 56}}, color = {0, 0, 127}));
  connect(constLoss.y, invertorLossSource1.Q_flow) annotation(
    Line(points = {{-209, 98}, {-83, 98}, {-83, 64}}, color = {0, 0, 127}));
  connect(constLoss.y, invertorLossSource.Q_flow) annotation(
    Line(points = {{-209, 98}, {-163, 98}, {-163, 64}}, color = {0, 0, 127}));
  connect(massFlowSource_T.port, pipe.port_a) annotation(
    Line(points = {{-214, -130}, {-192, -130}, {-192, -106}, {-172, -106}}, color = {0, 0, 127}));
  connect(pipe4.port_b, boundary_pT.port) annotation(
    Line(points = {{186, -106}, {208, -106}, {208, -130}, {240, -130}}, color = {0, 0, 127}));
  annotation(experiment(StopTime = 100),
    Icon,
  Diagram(coordinateSystem(extent = {{-240, 120}, {280, -140}})));
end InvertorCoolingTest;
