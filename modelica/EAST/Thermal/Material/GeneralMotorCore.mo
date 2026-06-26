within EAST.Thermal.Material;
record GeneralMotorCore "汎用モーターコア"
  extends EAST.Thermal.Material.MaterialProperties(
    density=7650,
    specificHeatCapacity=460,
    thermalConductivity=25);

  annotation(Documentation(info="<html>
<p>
モーターコアに用いる無方向性電磁鋼板を想定した代表物性値です。
初期検討や概略熱計算の参考値として使用します。
</p>
<p>
実際の熱伝導率は鋼板の材質、積層率、絶縁皮膜および熱流方向によって異なります。
特に積層方向の熱伝導を扱う詳細計算では、対象コアの実効物性値へ置き換えてください。
</p>
</html>"));
end GeneralMotorCore;
