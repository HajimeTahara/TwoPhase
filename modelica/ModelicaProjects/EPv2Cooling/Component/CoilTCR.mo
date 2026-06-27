within ModelicaProjects.EPv2Cooling.Component;

model CoilTCR
  parameter Modelica.Units.SI.Temperature ref_T = 293.15;
  parameter Modelica.Units.SI.Temperature min_T = 0;
  parameter Modelica.Units.SI.Temperature max_T = 1e+10;
  parameter Real tcr = 0.0038 "Temperature Coefficient of Resistance";
  Modelica.Blocks.Interfaces.RealInput temperature annotation(
    Placement(transformation(origin = {118, 26}, extent = {{20, -20}, {-20, 20}}), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput baseResist annotation(
    Placement(transformation(origin = {-44, 34}, extent = {{20, -20}, {-20, 20}}), iconTransformation(origin = {-122, -60}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput resist annotation(
    Placement(transformation(origin = {-212, 28}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {120, 0}, extent = {{-20, -20}, {20, 20}})));
  EAST.Blocks.Math.MultiplyParameter multiplyParameter1(k = 0.6) annotation(
    Placement(transformation(origin = {-106, 34}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Math.Add add1(k2 = -1) annotation(
    Placement(transformation(origin = {62, -28}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Math.Product product annotation(
    Placement(transformation(origin = {-162, 28}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Constant const3(k = ref_T) annotation(
    Placement(transformation(origin = {138, -34}, extent = {{10, -10}, {-10, 10}})));
  EAST.Blocks.Math.MultiplyParameter multiplyParameter2(k = tcr) annotation(
    Placement(transformation(origin = {-58, -28}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = max_T - ref_T, uMin = min_T - ref_T) annotation(
    Placement(transformation(origin = {-6, -28}, extent = {{10, -10}, {-10, 10}})));
  EAST.Blocks.Math.AddParameter addParameter(k = 1) annotation(
    Placement(transformation(origin = {-102, -28}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
equation
  connect(add1.u2, const3.y) annotation(
    Line(points = {{74, -34}, {127, -34}}, color = {0, 0, 127}));
  connect(product.u1, multiplyParameter1.y) annotation(
    Line(points = {{-150, 34}, {-116, 34}}, color = {0, 0, 127}));
  connect(multiplyParameter2.u, limiter.y) annotation(
    Line(points = {{-46, -28}, {-16, -28}}, color = {0, 0, 127}));
  connect(limiter.u, add1.y) annotation(
    Line(points = {{6, -28}, {52, -28}}, color = {0, 0, 127}));
  connect(temperature, add1.u1) annotation(
    Line(points = {{118, 26}, {92, 26}, {92, -22}, {74, -22}}, color = {0, 0, 127}));
  connect(multiplyParameter1.u, baseResist) annotation(
    Line(points = {{-94, 34}, {-44, 34}}, color = {0, 0, 127}));
  connect(addParameter.u, multiplyParameter2.y) annotation(
    Line(points = {{-90, -28}, {-68, -28}}, color = {0, 0, 127}));
  connect(product.u2, addParameter.y) annotation(
    Line(points = {{-150, 22}, {-134, 22}, {-134, -28}, {-112, -28}}, color = {0, 0, 127}));
  connect(resist, product.y) annotation(
    Line(points = {{-212, 28}, {-172, 28}}, color = {0, 0, 127}));
  annotation(
    Diagram(graphics = {Text(origin = {-4, -6}, extent = {{-14, 6}, {14, -6}}, textString = "min/max外でsaturation"), Text(origin = {141, -60}, extent = {{-29, 6}, {29, -6}}, textString = "reference temperature")}, coordinateSystem(extent = {{-220, 60}, {180, -80}})),
    Icon(graphics = {Rectangle(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-200, 60}, extent = {{-58, 20}, {58, -20}}, textString = "temperature"), Text(origin = {-202, -60}, extent = {{-58, 20}, {58, -20}}, textString = "base resist"), Text(origin = {200, -2}, extent = {{-58, 20}, {58, -20}}, textString = "resist")}));
end CoilTCR;
