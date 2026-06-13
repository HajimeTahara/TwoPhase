within ;
package TwoPhaseMedia "気液二相流体の熱物性ライブラリ (cEAST)"
  extends Modelica.Icons.Package;
  annotation (
    Documentation(info="<html>
<p>
<b>TwoPhaseMedia</b> は気液二相流体の熱力学・輸送物性を提供する Modelica ライブラリです。
</p>
<p>
OpenModelica Standard Library (MSL) の <code>Modelica.Media</code> アーキテクチャに倣い、
<code>Modelica.Media.Interfaces.PartialTwoPhaseMedium</code> を継承した設計になっています。
物性値は Python + CoolProp で生成されたデータに基づきます。
</p>
<h4>パッケージ構成</h4>
<ul>
<li><b>Interfaces</b> — 具体的流体が実装すべき基底クラス群</li>
<li><b>Common</b> — 共通ユーティリティ・型定義</li>
<li><b>LCH</b> — 液体メタン (CH₄) 媒体実装</li>
</ul>
</html>"),
    version="0.1.0");
end TwoPhaseMedia;
