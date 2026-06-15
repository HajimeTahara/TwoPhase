within Thermal.Material;
record Sus304 "SUS304 ステンレス鋼の代表物性値"
  extends Thermal.Material.MaterialProperties(
    density = 7930,
    specificHeatCapacity = 500,
    thermalConductivity = 16.2);

  annotation (Documentation(info="<html>
<p>
SUS304 ステンレス鋼の代表的な室温付近の物性値です。
</p>
<ul>
<li>密度: 7930 kg/m3</li>
<li>比熱: 500 J/(kg.K)</li>
<li>熱伝導率: 16.2 W/(m.K)</li>
</ul>
</html>"));
end Sus304;
