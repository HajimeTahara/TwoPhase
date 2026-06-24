within EAST.Thermal.Material;
record MaterialProperties "熱計算用の基本材料物性"
  parameter Modelica.Units.SI.Density density "密度";
  parameter Modelica.Units.SI.SpecificHeatCapacity specificHeatCapacity
    "定圧比熱";
  parameter Modelica.Units.SI.ThermalConductivity thermalConductivity
    "熱伝導率";
end MaterialProperties;
