within ;
package EAST "統合熱流体ライブラリ"
  extends Modelica.Icons.Package;

  annotation (
    Documentation(info="<html>
<p>
<b>EAST</b> は熱・流体関連モデルをまとめるトップレベルパッケージです。
</p>
<h4>パッケージ構成</h4>
<ul>
<li><code>TwoPhaseFlow</code> — 気液二相流体の熱物性・コンポーネントライブラリ</li>
<li><code>Thermal</code> — MSL Thermal を参考にした熱系ライブラリ</li>
<li><code>Blocks</code> — MSL Blocks と同じ構造を持つ入出力・制御ブロックライブラリ</li>
<li><code>Icons</code> — MSL アイコンを流用するための icon-only クラス群</li>
</ul>
</html>"),
    version="0.1.0",
  uses(Modelica(version = "4.1.0")));
end EAST;
