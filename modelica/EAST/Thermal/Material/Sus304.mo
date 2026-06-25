within EAST.Thermal.Material;
record Sus304 "SUS304 ステンレス鋼の代表物性値"
  extends EAST.Thermal.Material.MaterialProperties(
    density = 7930,
    specificHeatCapacity = 500,
    thermalConductivity = 16.2);

  annotation (Documentation(info="<html>
<p>
SUS304 ステンレス鋼の室温付近の物性値
</p>
</html>"));
end Sus304;
