within ModelicaProjects;

model SpeedProfile
  Modelica.Mechanics.Rotational.Sources.Speed speed(exact = false, f_crit = 5) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.CombiTimeTable rpmTable(columns = {2}, table = [0, 0; 1, 0; 3, 1500; 20, 1500; 25, 3000; 50, 3000]) annotation(
    Placement(transformation(origin = {-72, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Mechanics.Rotational.Sources.ConstantTorque constantTorque(tau_constant = 1) annotation(
    Placement(transformation(origin = {80, 0}, extent = {{10, -10}, {-10, 10}})));
equation
  connect(rpmTable.y[1], speed.w_ref) annotation(
    Line(points = {{-61, 0}, {-12, 0}}, color = {0, 0, 127}));
  connect(speed.flange, constantTorque.flange) annotation(
    Line(points = {{10, 0}, {70, 0}}));
annotation(experiment(StopTime = 100));
end SpeedProfile;
