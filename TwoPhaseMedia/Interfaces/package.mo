within TwoPhaseMedia;
package Interfaces "媒体インターフェース基底クラス群"
  extends Modelica.Icons.InterfacesPackage;
  annotation (Documentation(info="<html>
<p>
具体的な流体パッケージが実装すべきインターフェースを定義する基底クラス群。
<code>Modelica.Media.Interfaces.PartialTwoPhaseMedium</code> を継承し、
cEAST 独自の拡張（ボイド率計算等）を追加する。
</p>
</html>"));
end Interfaces;
