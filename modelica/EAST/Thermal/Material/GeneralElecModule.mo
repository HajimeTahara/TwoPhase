within EAST.Thermal.Material;
record GeneralElecModule "汎用電子モジュール"
  extends Thermal.Material.MaterialProperties(
    density = 4000, 
    specificHeatCapacity = 700, 
    thermalConductivity = 30
    );
  annotation(
    Documentation(info = "<html>
<p>
汎用的な電子部品(パワーモジュール系)の物性値
あくまで参考値程度に使用すること
</p>
</html>"));
end GeneralElecModule;
