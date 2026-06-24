within EAST.TwoPhaseFlow;
package Component "気液二相流コンポーネントライブラリ"
  extends Modelica.Icons.Package;
  annotation (Documentation(info="<html>
<p>
<b>Component</b> は <code>EAST.TwoPhaseFlow.Media</code> の熱物性を使う
流体コンポーネント（管、タンク、バルブ、ソース等）のライブラリ。
</p>
<h4>サブパッケージ</h4>
<ul>
<li><code>Interfaces</code>   — コネクタ定義 (<code>FluidPort</code>, <code>HeatPort</code>)</li>
<li><code>Pipes</code>        — 管モデル群</li>
<li><code>Pumps</code>        — ポンプモデル群</li>
<li><code>Tanks</code>        — タンク・容器モデル群</li>
<li><code>Valves</code>       — バルブモデル群</li>
<li><code>Sources</code>      — 流体ソース・シンクモデル群</li>
<li><code>HeatSources</code>  — 熱境界条件モデル群（<code>HeatPort</code> 用）</li>
</ul>
<p>
流体ポート (<code>FluidPort</code>) は
<code>EAST.TwoPhaseFlow.Component.Interfaces.FluidPort</code> を使用する。
熱ポート (<code>HeatPort</code>) は MSL に依存せず
<code>EAST.TwoPhaseFlow.Component.Interfaces.HeatPort</code> として独自に実装する。
</p>
</html>"));
end Component;
