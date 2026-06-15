within Thermal.Material;
record MaterialProperties "熱計算用の基本材料物性"
  parameter Modelica.Units.SI.Density density "密度 [kg/m3]";
  parameter Modelica.Units.SI.SpecificHeatCapacity specificHeatCapacity
    "定圧比熱 [J/(kg.K)]";
  parameter Modelica.Units.SI.ThermalConductivity thermalConductivity
    "熱伝導率 [W/(m.K)]";
end MaterialProperties;
