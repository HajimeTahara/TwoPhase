within EAST.TwoPhaseFlow.Examples.Media;

model TestFluidProperties "LCH 流体の BaseProperties 使用例"
  extends Modelica.Icons.Example;
  replaceable package Medium = EAST.TwoPhaseFlow.Media.LCH;
  parameter Modelica.Units.SI.SpecificEnthalpy h_start = 0 "開始時の比エンタルピー";
  parameter Modelica.Units.SI.SpecificEnthalpy h_end = 600000 "終了時の比エンタルピー";
  parameter Modelica.Units.SI.Time rampDuration(min = Modelica.Constants.eps) = 100.0 "比エンタルピーを線形変化させる時間";
  Medium.BaseProperties props(preferredMediumStates = true);
  Real alpha "ボイド率";
equation
  // 独立変数を外部から与える（p は固定、h は時間で線形変化）
  props.p = 4.9e+5;
  // 圧力 [Pa]
  props.h = h_start + (h_end - h_start)*min(time/rampDuration, 1.0);
  alpha = Medium.voidFraction(props.state);
  // 結果として props.d, props.T, props.u, props.phase が算出される
  annotation(
    experiment(StopTime = 100.0),
    Documentation(info = "<html>
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
