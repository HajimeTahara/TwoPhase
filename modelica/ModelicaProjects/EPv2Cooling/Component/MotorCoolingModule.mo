within ModelicaProjects.EPv2Cooling.Component;
model MotorCoolingModule
  import Modelica.Units.SI;
  extends EAST.Icons.CylinderThermalCooling;
  replaceable package Medium = EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium;
  parameter Integer nNode = 3 "node数. デフォルトから変更する場合スケッチも更新" annotation(
    Dialog(group = "Module"));
  final parameter Integer nLayer = 3 "層数";

  parameter SI.Length D_inner = 0.041 "ステータ内径" annotation(
    Dialog(tab = "Geometry", group = "Motor"));
  parameter SI.Length D_coil = 0.064 "コイル外径" annotation(
    Dialog(tab = "Geometry", group = "Motor"));
  parameter SI.Length D_core = 0.072 "コア外径" annotation(
    Dialog(tab = "Geometry", group = "Motor"));
  parameter SI.Length D_frame = 0.085 "フレーム外径" annotation(
    Dialog(tab = "Geometry", group = "Motor"));
  parameter SI.Length L_motor = 0.1 "モーター長さ" annotation(
    Dialog(tab = "Geometry", group = "Motor"));
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
    Placement(transformation(origin = {-48, -106}, extent = {{-110, -10}, {-90, 10}}), iconTransformation(extent = {{-110, -10}, {-90, 10}})));
  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_b port_b(redeclare package Medium = Medium, p(start = p_init_pipe, nominal = 1.0e5)) annotation(
    Placement(transformation(origin = {-2, -106}, extent = {{90, -10}, {110, 10}}), iconTransformation(extent = {{90, -10}, {110, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment pipe(redeclare package Medium = Medium, p_start = p_init_pipe, h_start = Medium.specificEnthalpy_pT(p_init_pipe, T_init_pipe), geometry = EAST.TwoPhaseFlow.Component.Pipes.PipeGeometry.Rectangular, length = pipe_L, rectangularLongSide = pipe_W_long, rectangularShortSide = pipe_W_short) annotation(
    Placement(transformation(origin = {-92, -106}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.CylindricalThermalConductor stator(use_heat_input = true, nLayers = nLayer, innerDiameter = D_inner, outerDiameter = {D_coil, D_core, D_frame}, L = L_motor/nNode, material = {coil, core, frame}, T_start = fill(T_init_motor, nLayer), use_temperature_output = true) annotation(
    Placement(transformation(origin = {-89, 37}, extent = {{-19, -19}, {19, 19}}, rotation = -90)));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment pipe1(redeclare package Medium = Medium, geometry = EAST.TwoPhaseFlow.Component.Pipes.PipeGeometry.Rectangular, h_start = Medium.specificEnthalpy_pT(p_init_pipe, T_init_pipe), length = pipe_L, p_start = p_init_pipe, rectangularLongSide = pipe_W_long, rectangularShortSide = pipe_W_short) annotation(
    Placement(transformation(origin = {-26, -106}, extent = {{-10, -10}, {10, 10}})));
  EAST.TwoPhaseFlow.Component.Pipes.DynamicPipeSegment pipe2(redeclare package Medium = Medium, geometry = EAST.TwoPhaseFlow.Component.Pipes.PipeGeometry.Rectangular, h_start = Medium.specificEnthalpy_pT(p_init_pipe, T_init_pipe), length = pipe_L, p_start = p_init_pipe, rectangularLongSide = pipe_W_long, rectangularShortSide = pipe_W_short) annotation(
    Placement(transformation(origin = {36, -106}, extent = {{-10, -10}, {10, 10}})));
  EAST.Thermal.HeatTransfer.Components.CylindricalThermalConductor stator1(L = L_motor/nNode, innerDiameter = D_inner, material = {coil, core, frame}, nLayers = nLayer, outerDiameter = {D_coil, D_core, D_frame}, use_heat_input = true, T_start = fill(T_init_motor, nLayer), use_temperature_output = true) annotation(
    Placement(transformation(origin = {-27, -13}, extent = {{-19, -19}, {19, 19}}, rotation = -90)));
  EAST.Thermal.HeatTransfer.Components.CylindricalThermalConductor stator2(L = L_motor/nNode, innerDiameter = D_inner, material = {coil, core, frame}, nLayers = nLayer, outerDiameter = {D_coil, D_core, D_frame}, use_heat_input = true, T_start = fill(T_init_motor, nLayer), use_temperature_output = true) annotation(
    Placement(transformation(origin = {35, -59}, extent = {{-19, -19}, {19, 19}}, rotation = -90)));
  EAST.Blocks.Interfaces.RealVectorInput u[3] annotation(
    Placement(transformation(origin = {126, 105}, extent = {{-10, -11}, {10, 11}}), iconTransformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}})));
  EAST.Blocks.Math.VectorScalarArithmetic vectorScalarArithmetic(n = nNode, operation = EAST.Blocks.Types.VectorScalarOperation.Divide)  annotation(
    HideResult = true,
    Placement(transformation(origin = {98, 76}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = nNode)  annotation(
    HideResult = true,
    Placement(transformation(origin = {96, 36}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput coilTemperature annotation(
    Placement(transformation(origin = {294, -76}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {92, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  EAST.Blocks.Math.ElementWiseAdd elementWiseAdd(n = nLayer) annotation(
    HideResult = true,
    Placement(transformation(origin = {154, -50}, extent = {{-10, -10}, {10, 10}})));
  EAST.Blocks.Math.VectorScalarArithmetic vectorScalarArithmetic1(n = nLayer, operation = EAST.Blocks.Types.VectorScalarOperation.Divide)  annotation(
    HideResult = true,
    Placement(transformation(origin = {208, -76}, extent = {{-10, -10}, {10, 10}})));
  EAST.Blocks.Math.ElementWiseAdd elementWiseAdd1(n = nLayer) annotation(
    HideResult = true,
    Placement(transformation(origin = {112, -18}, extent = {{-10, -10}, {10, 10}})));
  EAST.Blocks.Routing.ExtractScalar extractScalar(n = nLayer, index = 1)  annotation(
    HideResult = true,
    Placement(transformation(origin = {248, -76}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(stator.port_outer, pipe.heatPort) annotation(
    Line(points = {{-89, 18}, {-89, -60}, {-92, -60}, {-92, -102}}, color = {191, 0, 0}));
  connect(pipe.port_b, pipe1.port_a) annotation(
    Line(points = {{-82, -106}, {-36, -106}}, color = {0, 0, 127}));
  connect(pipe1.port_b, pipe2.port_a) annotation(
    Line(points = {{-16, -106}, {26, -106}}, color = {0, 0, 127}));
  connect(stator2.port_outer, pipe2.heatPort) annotation(
    Line(points = {{35, -78}, {35, -80}, {36, -80}, {36, -102}}, color = {191, 0, 0}));
  connect(stator1.port_outer, pipe1.heatPort) annotation(
    Line(points = {{-27, -32}, {-26, -32}, {-26, -102}}, color = {191, 0, 0}));
  connect(port_a, pipe.port_a) annotation(
    Line(points = {{-148, -106}, {-102, -106}}, color = {0, 127, 255}));
  connect(pipe2.port_b, port_b) annotation(
    Line(points = {{46, -106}, {98, -106}}, color = {0, 0, 127}));
  connect(stator.Q_gen_input, vectorScalarArithmetic.y) annotation(
    Line(points = {{-66, 37}, {-24.2, 37}, {-24.2, 75}, {86.8, 75}}, color = {0, 0, 127}, thickness = 0.5));
  connect(stator1.Q_gen_input, vectorScalarArithmetic.y) annotation(
    Line(points = {{-4.2, -13}, {11.8, -13}, {11.8, 75}, {86.8, 75}}, color = {0, 0, 127}, thickness = 0.5));
  connect(stator2.Q_gen_input, vectorScalarArithmetic.y) annotation(
    Line(points = {{57.8, -59}, {69.8, -59}, {69.8, 75}, {87.8, 75}}, color = {0, 0, 127}, thickness = 0.5));
  connect(vectorScalarArithmetic.u, u) annotation(
    Line(points = {{110, 82}, {126, 82}, {126, 106}}, color = {0, 0, 127}, thickness = 0.5));
  connect(const.y, vectorScalarArithmetic.k) annotation(
    Line(points = {{107, 36}, {126, 36}, {126, 70}, {110, 70}}, color = {0, 0, 127}));
  connect(stator.layerTemperature, elementWiseAdd1.u1) annotation(
    Line(points = {{-66, 52}, {41.8, 52}, {41.8, -11.8}, {99.8, -11.8}}, color = {0, 0, 127}, thickness = 0.5));
  connect(stator1.layerTemperature, elementWiseAdd1.u2) annotation(
    Line(points = {{-4.2, 2.2}, {23.8, 2.2}, {23.8, -23.8}, {99.8, -23.8}}, color = {0, 0, 127}, thickness = 0.5));
  connect(stator2.layerTemperature, elementWiseAdd.u2) annotation(
    Line(points = {{57.8, -43.8}, {85.8, -43.8}, {85.8, -55.8}, {141.8, -55.8}}, color = {0, 0, 127}, thickness = 0.5));
  connect(elementWiseAdd1.y, elementWiseAdd.u1) annotation(
    Line(points = {{123, -18}, {131, -18}, {131, -44}, {141, -44}}, color = {0, 0, 127}, thickness = 0.5));
  connect(elementWiseAdd.y, vectorScalarArithmetic1.u) annotation(
    Line(points = {{165, -50}, {173, -50}, {173, -70}, {195, -70}}, color = {0, 0, 127}, thickness = 0.5));
  connect(const.y, vectorScalarArithmetic1.k) annotation(
    Line(points = {{107, 36}, {178, 36}, {178, -82}, {196, -82}}, color = {0, 0, 127}));
  connect(extractScalar.y, coilTemperature) annotation(
    Line(points = {{259, -76}, {294, -76}}, color = {0, 0, 127}));
  connect(vectorScalarArithmetic1.y, extractScalar.u) annotation(
    Line(points = {{219, -76}, {235, -76}}, color = {0, 0, 127}, thickness = 0.5));
  annotation(
    experiment(StopTime = 100),
    Icon,
    Diagram(coordinateSystem(extent = {{-160, 120}, {300, -120}})));
end MotorCoolingModule;
