within EAST.Thermal.Material;
record GeneralMotorCoil "汎用モーターコイル"
  extends EAST.Thermal.Material.MaterialProperties(
    density=8960,
    specificHeatCapacity=385,
    thermalConductivity=400);

  annotation(Documentation(info="<html>
<p>
モーターコイルの銅導体を想定した代表物性値です。
初期検討や概略熱計算の参考値として使用します。
</p>
<p>
この値は銅単体の物性を表し、導体間の絶縁皮膜、含浸樹脂、空隙および
巻線占積率の影響を含みません。巻線間方向の熱伝導を扱う詳細計算では、
巻線構造に応じた実効物性値へ置き換えてください。
</p>
</html>"));
end GeneralMotorCoil;
