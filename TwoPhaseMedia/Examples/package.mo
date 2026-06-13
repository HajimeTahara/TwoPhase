within TwoPhaseMedia;
package Examples "TwoPhaseMedia ライブラリの使用例"

  model TestFluidProperties
    "LCH 流体の BaseProperties 使用例"
    package Medium = TwoPhaseMedia.LCH;

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

  model TestVoidFraction
    "LCH 流体のボイド率計算例"
    package Medium = TwoPhaseMedia.LCH;

    Medium.BaseProperties props;
    Real alpha "ボイド率";

  equation
    props.p = 200000.0;
    props.h = 500000.0;   // 二相域を想定

    alpha = Medium.voidFraction(props.state);

    annotation(
      experiment(StopTime=1.0),
      Documentation(info="<html>
<p>
HEM（均質平衡モデル）に基づくボイド率計算例。
<code>voidFraction</code> は <code>PartialTwoPhaseMedium</code> に共通実装されており、
各流体固有の飽和密度関数（<code>bubbleDensity</code>, <code>dewDensity</code>）を呼び出す。
</p>
</html>"));
  end TestVoidFraction;

  annotation (Documentation(info="<html>
<p>
<em>TwoPhaseMedia</em> ライブラリの使用例パッケージ。
</p>
<h4>使用例一覧</h4>
<ul>
<li><code>TestFluidProperties</code> — BaseProperties の基本的な使い方</li>
<li><code>TestVoidFraction</code> — ボイド率計算</li>
</ul>
</html>"));
end Examples;
