within EAST.TwoPhaseFlow.Component;
package HeatSources "熱境界条件モデル群（HeatPort 用）"
  extends Modelica.Icons.SourcesPackage;
  annotation (Documentation(info="<html>
<p>
<code>HeatPort</code> を介してコンポーネントへ熱境界条件を与えるモデル群。
</p>
<h4>モデル一覧</h4>
<ul>
<li><code>FixedHeatFlow</code> — 固定熱流量を <code>HeatPort_b</code> へ与える</li>
<li><code>UniformHeatDistributor</code> — 単一 HeatPort の熱流を複数 HeatPort へ均等分配する</li>
</ul>
</html>"));
end HeatSources;
