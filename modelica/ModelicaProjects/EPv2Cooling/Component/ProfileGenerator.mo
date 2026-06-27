within ModelicaProjects.EPv2Cooling.Component;

model ProfileGenerator
  parameter Real power_factor = 0.7071;
  parameter Real eff_invertor = 0.95;
  parameter Real torque_const = 0.05374012;
  parameter Real coil_resist = 0.015;
  parameter Real dq_inductance = 0.00005;
  parameter Real rpm_to_torque_a2 = 0.3092;//0.287
  parameter Real rpm_to_torque_a1 = -7e-15;//7e-15
  parameter Real eff_motor = 0.95;
  
  Modelica.Units.SI.Torque indicated_torque;
  Modelica.Units.SI.Voltage indicated_invertorV;
  Modelica.Units.SI.Current indicated_invertorI;  
  Modelica.Units.SI.Power pump_power;
  
  EAST.Blocks.Math.DivideParameter divideParameter1(k = 10000) annotation(
    HideResult = true,
    Placement(transformation(origin = {270, 112}, extent = {{10, -10}, {-10, 10}})));
  EAST.Blocks.Math.Polynomial pnTorque(a0 = 0, a1 = rpm_to_torque_a1, a2 = rpm_to_torque_a2, polynomialType = EAST.Blocks.Types.PolynomialType.Quadratic) annotation(
    HideResult = true,
    Placement(transformation(origin = {222, 112}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Math.Product product1 annotation(
    HideResult = true,
    Placement(transformation(origin = {142, 106}, extent = {{10, -10}, {-10, 10}})));
  EAST.Blocks.UnitConvert.RpmToRad rpmToRad1 annotation(
    HideResult = true,
    Placement(transformation(origin = {246, 74}, extent = {{10, -10}, {-10, 10}})));
  EAST.Blocks.Math.DivideParameter divideParameter2(k = torque_const) annotation(
    HideResult = true,
    Placement(transformation(origin = {172, 22}, extent = {{10, -10}, {-10, 10}})));
  EAST.Blocks.Math.DivideParameter divideParameter21(k = power_factor) annotation(
    HideResult = true,
    Placement(transformation(origin = {36, 6}, extent = {{10, -10}, {-10, 10}})));
  EAST.Blocks.Math.MultiplyParameter multiplyParameter(k = coil_resist) annotation(
    HideResult = true,
    Placement(transformation(origin = {-14, 6}, extent = {{10, -10}, {-10, 10}})));
  EAST.Blocks.Math.MultiplyParameter multiplyParameter1(k = sqrt(3)/sqrt(2)) annotation(
    HideResult = true,
    Placement(transformation(origin = {-60, 6}, extent = {{10, -10}, {-10, 10}})));
  EAST.Blocks.Math.MultiplyParameter multiplyParameter11(k = sqrt(3)/sqrt(2)) annotation(
    HideResult = true,
    Placement(transformation(origin = {-62, -98}, extent = {{10, -10}, {-10, 10}})));
  EAST.Blocks.Math.MultiplyParameter multiplyParameter2(k = dq_inductance) annotation(
    HideResult = true,
    Placement(transformation(origin = {-16, -98}, extent = {{10, -10}, {-10, 10}})));
  EAST.Blocks.Math.MultiplyParameter multiplyParameter12(k = torque_const) annotation(
    HideResult = true,
    Placement(transformation(origin = {-16, 58}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Math.Product product111 annotation(
    HideResult = true,
    Placement(transformation(origin = {-150, -92}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Math.Add add annotation(
    HideResult = true,
    Placement(transformation(origin = {-174, 28}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Math.Add add1 annotation(
    HideResult = true,
    Placement(transformation(origin = {-210, -10}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Interfaces.RealInput u annotation(
    HideResult = true,
    Placement(transformation(origin = {358, 112}, extent = {{20, -20}, {-20, 20}}), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput invertorLoss annotation(
    HideResult = true,
    Placement(transformation(origin = {-288, 124}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {110, 42}, extent = {{-10, -10}, {10, 10}})));
  EAST.Blocks.Math.DivideParameter divideParameter211(k = eff_invertor) annotation(
    HideResult = true,
    Placement(transformation(origin = {-92, 106}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Math.Add add11(k1 = -1) annotation(
    HideResult = true,
    Placement(transformation(origin = {-214, 124}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput motorLoss annotation(
    HideResult = true,
    Placement(transformation(origin = {-292, 186}, extent = {{10, -10}, {-10, 10}}), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}})));
  EAST.Blocks.Math.MultiplyParameter multiplyParameter121(k = 1 - eff_motor) annotation(
    HideResult = true,
    Placement(transformation(origin = {-98, 186}, extent = {{10, -10}, {-10, 10}})));
  EAST.Blocks.Math.DivideParameter divideParameter2111(k = eff_motor) annotation(
    HideResult = true,
    Placement(transformation(origin = {44, 106}, extent = {{10, -10}, {-10, 10}})));
equation
  indicated_torque = pnTorque.y;
  pump_power = product1.y;
  indicated_invertorI=divideParameter2.y;
  indicated_invertorV=add1.y;
  
  connect(pnTorque.u, divideParameter1.y) annotation(
    Line(points = {{234, 112}, {259, 112}}, color = {0, 0, 127}));
  connect(product1.u1, pnTorque.y) annotation(
    Line(points = {{154, 112}, {212, 112}}, color = {0, 0, 127}));
  connect(product1.u2, rpmToRad1.y) annotation(
    Line(points = {{154, 100}, {186, 100}, {186, 74}, {236, 74}}, color = {0, 0, 127}));
  connect(divideParameter2.u, pnTorque.y) annotation(
    Line(points = {{184, 22}, {198, 22}, {198, 112}, {212, 112}}, color = {0, 0, 127}));
  connect(divideParameter21.u, divideParameter2.y) annotation(
    Line(points = {{48, 6}, {142.5, 6}, {142.5, 22}, {161, 22}}, color = {0, 0, 127}));
  connect(multiplyParameter.u, divideParameter21.y) annotation(
    Line(points = {{-2, 6}, {25, 6}}, color = {0, 0, 127}));
  connect(multiplyParameter11.u, multiplyParameter2.y) annotation(
    Line(points = {{-50, -98}, {-26, -98}}, color = {0, 0, 127}));
  connect(multiplyParameter1.u, multiplyParameter.y) annotation(
    Line(points = {{-48, 6}, {-24, 6}}, color = {0, 0, 127}));
  connect(multiplyParameter2.u, divideParameter21.y) annotation(
    Line(points = {{-4, -98}, {12, -98}, {12, 6}, {25, 6}}, color = {0, 0, 127}));
  connect(product111.u2, multiplyParameter11.y) annotation(
    Line(points = {{-138, -98}, {-72, -98}}, color = {0, 0, 127}));
  connect(add.u2, multiplyParameter1.y) annotation(
    Line(points = {{-162, 22}, {-132, 22}, {-132, 6}, {-71, 6}}, color = {0, 0, 127}));
  connect(add.y, add1.u1) annotation(
    Line(points = {{-185, 28}, {-191, 28}, {-191, -4}, {-199, -4}}, color = {0, 0, 127}));
  connect(add1.u2, product111.y) annotation(
    Line(points = {{-198, -16}, {-186, -16}, {-186, -92}, {-161, -92}}, color = {0, 0, 127}));
  connect(add.u1, multiplyParameter12.y) annotation(
    Line(points = {{-162, 34}, {-62, 34}, {-62, 58}, {-27, 58}}, color = {0, 0, 127}));
  connect(multiplyParameter12.u, rpmToRad1.y) annotation(
    Line(points = {{-4, 58}, {212, 58}, {212, 74}, {236, 74}}, color = {0, 0, 127}));
  connect(product111.u1, rpmToRad1.y) annotation(
    Line(points = {{-138, -86}, {-118, -86}, {-118, 74}, {236, 74}}, color = {0, 0, 127}));
  connect(divideParameter1.u, u) annotation(
    Line(points = {{282, 112}, {358, 112}}, color = {0, 0, 127}));
  connect(rpmToRad1.u, u) annotation(
    Line(points = {{258, 74}, {304, 74}, {304, 112}, {358, 112}}, color = {0, 0, 127}));
  connect(add11.u2, divideParameter211.y) annotation(
    Line(points = {{-202, 118}, {-192, 118}, {-192, 106}, {-102, 106}}, color = {0, 0, 127}));
  connect(invertorLoss, add11.y) annotation(
    Line(points = {{-288, 124}, {-224, 124}}, color = {0, 0, 127}));
  connect(motorLoss, multiplyParameter121.y) annotation(
    Line(points = {{-292, 186}, {-108, 186}}, color = {0, 0, 127}));
  connect(add11.u1, divideParameter2111.y) annotation(
    Line(points = {{-202, 130}, {-32, 130}, {-32, 106}, {34, 106}}, color = {0, 0, 127}));
  connect(divideParameter211.u, divideParameter2111.y) annotation(
    Line(points = {{-80, 106}, {34, 106}}, color = {0, 0, 127}));
  connect(multiplyParameter121.u, divideParameter2111.y) annotation(
    Line(points = {{-86, 186}, {0, 186}, {0, 106}, {34, 106}}, color = {0, 0, 127}));
  connect(divideParameter2111.u, product1.y) annotation(
    Line(points = {{56, 106}, {132, 106}}, color = {0, 0, 127}));
  annotation(
    Diagram(graphics = {Text(origin = {319, 121}, extent = {{-13, 5}, {13, -5}}, textString = "rpm"), Text(origin = {182, 123}, extent = {{-20, 5}, {20, -5}}, textString = "torque"), Text(origin = {97, 113}, extent = {{-27, 5}, {27, -5}}, textString = "pump power"), Text(origin = {195, 5}, extent = {{-49, 5}, {49, -5}}, textString = "torque constant (Nm/Arms)"), Text(origin = {100, 13}, extent = {{-34, 5}, {34, -5}}, textString = "invertor current"), Text(origin = {38, -11}, extent = {{-20, 1}, {20, -1}}, textString = "power_factor"), Text(origin = {-9, -11}, extent = {{-19, 1}, {19, -1}}, textString = "coil_resist"), Text(origin = {-13, -119}, extent = {{-19, 1}, {19, -1}}, textString = "dqインダクタンス定常値"), Text(origin = {28, 41}, extent = {{-66, 5}, {66, -5}}, textString = "torque constant (Nm/Arms)"), Text(origin = {-150, 108}, extent = {{-22, 14}, {22, -14}}, textString = "invertor input 
= battery output"), Text(origin = {-344, 128}, extent = {{-30, 8}, {30, -8}}, textString = "invertor loss"), Text(origin = {-266, -4}, extent = {{-30, 8}, {30, -8}}, textString = "invertor Voltage"), Text(origin = {-332, 186}, extent = {{-30, 8}, {30, -8}}, textString = "motor loss")}, coordinateSystem(extent = {{-380, 200}, {380, -120}})),
    Icon(graphics = {Text(origin = {-191, 0}, extent = {{-49, 20}, {49, -20}}, textString = "rpm"), Rectangle(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {14, 49}, extent = {{-80, 31}, {80, -31}}, textString = "invertorLoss"), Text(origin = {16, -34}, extent = {{-80, 20}, {80, -20}}, textString = "motorLoss")}));
end ProfileGenerator;
