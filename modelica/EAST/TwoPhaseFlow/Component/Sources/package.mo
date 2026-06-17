within EAST.TwoPhaseFlow.Component;
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
<li><code>MassFlowSource_T</code> — 質量流量・温度固定（圧力は系が決定）</li>
<li><code>Boundary_pT</code>      — 圧力・温度固定（質量流量は系が決定）</li>
</ul>
<p>
<code>_T</code> 系のモデルは <code>Medium.specificEnthalpy_pT</code>（飽和点からの
定積比熱近似）で温度を比エンタルピーに変換する。飽和点から離れた条件では
精度が低い点に注意（詳細は <code>PartialTwoPhaseMedium</code> のドキュメンテーション参照）。
</p>
<p>
各モデルは <code>use_p_in</code>、<code>use_T_in</code>、<code>use_h_in</code>、
<code>use_m_flow_in</code> のうち対応する Boolean パラメータを持ち、
<code>true</code> にすると固定パラメータの代わりに外部入力コネクタから境界条件を与えられる。
</p>
<h4>接続規則</h4>
<p>
両モデルとも <code>FluidPort_b</code> 型の <code>port</code> を持つ。
下流コンポーネントの <code>FluidPort_a</code>（入口ポート）に接続する。
</p>
</html>"));
end Sources;
