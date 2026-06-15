within TwoPhaseFlow.Component;
package Sources "ソース・シンク境界条件モデル群"
  extends Modelica.Icons.Package;
  annotation (Documentation(info="<html>
<p>
流体システムの境界条件を与えるソース・シンクモデル群。
MSL の <code>Modelica.Fluid.Sources</code> に相当する。
</p>
<h4>モデル一覧</h4>
<ul>
<li><code>MassFlowSource_h</code> — 質量流量・比エンタルピー固定（圧力は系が決定）</li>
<li><code>Boundary_ph</code>      — 圧力・比エンタルピー固定（質量流量は系が決定）</li>
</ul>
<h4>接続規則</h4>
<p>
両モデルとも <code>FluidPort_b</code> 型の <code>port</code> を持つ。
下流コンポーネントの <code>FluidPort_a</code>（入口ポート）に接続する。
</p>
</html>"));
end Sources;
