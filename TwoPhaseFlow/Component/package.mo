within TwoPhaseFlow;
package Component "気液二相流コンポーネントライブラリ"
  extends Modelica.Icons.Package;
  annotation (Documentation(info="<html>
<p>
<b>Component</b> は <code>TwoPhaseFlow.Media</code> の熱物性を使う
流体コンポーネント（管、タンク、バルブ、ソース等）のライブラリ。
</p>
<h4>サブパッケージ</h4>
<ul>
<li><code>Interfaces</code> — コネクタ定義 (<code>FluidPort</code>)</li>
<li><code>Pipes</code>      — 管モデル群</li>
<li><code>Tanks</code>      — タンク・容器モデル群</li>
<li><code>Valves</code>     — バルブモデル群</li>
<li><code>Sources</code>    — ソース・シンクモデル群</li>
</ul>
<p>
流体ポート (<code>FluidPort</code>) は
<code>TwoPhaseFlow.Component.Interfaces.FluidPort</code> を使用する。
</p>
</html>"));
end Component;
