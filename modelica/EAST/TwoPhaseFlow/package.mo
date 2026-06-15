within EAST;
package TwoPhaseFlow "気液二相流体の熱物性・コンポーネントライブラリ (cEAST)"
  extends Modelica.Icons.Package;
  annotation (
    Documentation(info="<html>
<p>
<b>TwoPhaseFlow</b> は気液二相流体の熱力学・輸送物性および流体コンポーネントを提供する
Modelica ライブラリです。
</p>
<p>
OpenModelica Standard Library (MSL) の <code>Modelica.Media</code> /
<code>Modelica.Fluid</code> アーキテクチャに倣い、媒体とコンポーネントを分離した設計に
なっています。物性値は Python + CoolProp で生成されたデータに基づきます。
</p>
<h4>パッケージ構成</h4>
<ul>
<li><b>Media</b>     — 熱物性パッケージ（基底クラス・具体的流体）</li>
<li><b>Component</b> — 流体コンポーネント（管・タンク・バルブ・ソース）</li>
<li><b>Examples</b>  — 使用例</li>
</ul>
</html>"),
    version="0.1.0");
end TwoPhaseFlow;
