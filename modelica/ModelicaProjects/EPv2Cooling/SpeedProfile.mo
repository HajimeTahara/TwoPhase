within ModelicaProjects.EPv2Cooling;

model SpeedProfile
  extends Modelica.Icons.Example;
  Modelica.Mechanics.Rotational.Sources.Speed speed(exact = false, f_crit = 5) annotation(
    Placement(transformation(origin = {0, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.CombiTimeTable rpmTable(columns = {2}, table = [0, 0; 1, 0; 3, 1500; 20, 1500; 25, 3000; 50, 3000]) annotation(
    Placement(transformation(origin = {-82, 72}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sources.ConstantTorque constantTorque(tau_constant = 1) annotation(
    Placement(transformation(origin = {80, 70}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.CombiTimeTable batcoolRpmTableLCH(columns = {2}, table = [0.0, 0; 0.5, 0; 0.8, 20000; 1.0, 20000]) annotation(
    Placement(transformation(origin = {-130, -24}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.CombiTimeTable batcoolRpmTableLOX(columns = {2}, table = [0.0, 0; 0.5, 0; 0.8, 20000; 1.0, 20000]) annotation(
    Placement(transformation(origin = {-178, -138}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.CombiTimeTable updownRpmTableLCH(columns = {2}, table = [0.0, 0; 0.5, 0; 0.8, 10000; 1.0, 10000; 2.5, 65000; 63.0, 65000; 64.6, 20000; 124.3, 20000; 125.6, 65000; 180, 65000]) annotation(
    Placement(transformation(origin = {-64, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.CombiTimeTable updownRpmTableLOX(columns = {2}, table = [0.0, 0; 0.5, 0; 0.8, 10000; 1.0, 10000; 2.5, 60000; 63.0, 60000; 64.6, 23700; 124.3, 23700; 125.6, 60000; 180, 60000]) annotation(
    Placement(transformation(origin = {-42, -142}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.CombiTimeTable intervalRpmTableLCH(columns = {2}, table = [0.0, 0; 0.5, 0; 0.8, 10000; 30.0, 10000; 30.1, 20000; 60.0, 20000; 60.1, 30000; 90.0, 30000; 90.1, 40000; 120.0, 40000; 120.1, 50000; 150.0, 50000; 150.1, 60000; 200, 60000]) annotation(
    Placement(transformation(origin = {-188, -24}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.CombiTimeTable intervalRpmTableLOX(columns = {2}, table = [0.0, 0; 0.5, 0; 0.8, 10000; 30.0, 10000; 30.1, 20000; 60.0, 20000; 60.1, 30000; 90.0, 30000; 90.1, 40000; 120.0, 40000; 120.1, 50000; 150.0, 50000; 150.1, 60000; 200, 60000]) annotation(
    Placement(transformation(origin = {-106, -142}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.CombiTimeTable updownRpmTableLOX1(columns = {2}, table = [0.0, 0; 0.5, 0; 0.8, 10000; 1.0, 10000; 2.5, 60000; 63.0, 60000; 64.6, 23700; 124.3, 23700; 125.6, 60000; 180, 60000]) annotation(
    Placement(transformation(origin = {340, -4}, extent = {{10, -10}, {-10, 10}})));
  EAST.Blocks.Routing.ExtractScalar extractScalar annotation(
    Placement(transformation(origin = {300, -4}, extent = {{10, -10}, {-10, 10}})));
  ModelicaProjects.EPv2Cooling.Component.ProfileGenerator profileGenerator annotation(
    Placement(transformation(origin = {218, -4}, extent = {{20, -20}, {-20, 20}})));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(table = [0, 100; 1, 110; 2, 110])  annotation(
    Placement(transformation(origin = {24, -82}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = 0.5)  annotation(
    Placement(transformation(origin = {-40, -82}, extent = {{-10, -10}, {10, 10}})));
  EAST.Blocks.Routing.ExtractScalar extractScalar1 annotation(
    Placement(transformation(origin = {70, -82}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(rpmTable.y[1], speed.w_ref) annotation(
    Line(points = {{-71, 72}, {-41.5, 72}, {-41.5, 70}, {-12, 70}}, color = {0, 0, 127}));
  connect(speed.flange, constantTorque.flange) annotation(
    Line(points = {{10, 70}, {70, 70}}));
  connect(updownRpmTableLOX1.y, extractScalar.u) annotation(
    Line(points = {{329, -4}, {312, -4}}, color = {0, 0, 127}, thickness = 0.5));
  connect(profileGenerator.u, extractScalar.y) annotation(
    Line(points = {{242, -4}, {290, -4}}, color = {0, 0, 127}));
  connect(const.y, combiTable1Ds.u) annotation(
    Line(points = {{-28, -82}, {12, -82}}, color = {0, 0, 127}));
  connect(combiTable1Ds.y, extractScalar1.u) annotation(
    Line(points = {{36, -82}, {58, -82}}, color = {0, 0, 127}, thickness = 0.5));
  annotation(
    experiment(StopTime = 180),
    Diagram(coordinateSystem(extent = {{-220, 100}, {180, -160}}), graphics = {Text(origin = {366, -4}, extent = {{-14, 8}, {14, -8}}, textString = "LOX"), Text(origin = {273, 5}, extent = {{-13, 5}, {13, -5}}, textString = "rpm")}));
end SpeedProfile;
