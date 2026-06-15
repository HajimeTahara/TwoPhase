within TwoPhaseFlow.Examples;
model TestFluidProperties
  "LCH 流体の BaseProperties 使用例"
  package Medium = TwoPhaseFlow.Media.LCH;

  Medium.BaseProperties props(preferredMediumStates=true);

equation
  // 独立変数を外部から与える（2 bar、液相域）
  props.p = 200000.0;   // 圧力 [Pa]
  props.h = 400000.0;   // 比エンタルピー [J/kg]

  // 結果として props.d, props.T, props.u, props.phase が算出される

  annotation(
    experiment(StopTime=1.0),
    Documentation(info="<html>
<p>
LCH（液体メタン）パッケージを使った最小構成の使用例。
</p>
<p>
<code>props.p</code> と <code>props.h</code> を与えると、
<code>BaseProperties</code> の方程式により以下が自動的に算出される。
</p>
<ul>
<li><code>props.d</code>   — 密度 [kg/m³]</li>
<li><code>props.T</code>   — 温度 [K]</li>
<li><code>props.u</code>   — 比内部エネルギー [J/kg]（u = h - p/d）</li>
<li><code>props.R_s</code> — 比気体定数 [J/(kg·K)]（R_s = R/MM）</li>
<li><code>props.phase</code> — 相状態 (1=単相, 2=二相)</li>
</ul>
<p><b>注:</b> <code>python/methane/export.py</code> で物性テーブルを生成後にシミュレーション可能になる。</p>
</html>"));
end TestFluidProperties;
