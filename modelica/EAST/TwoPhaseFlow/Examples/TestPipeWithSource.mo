within EAST.TwoPhaseFlow.Examples;

model TestPipeWithSource "LCH 加熱管：過冷却液入口 → 二相出口の例題"
  // LCH（液体メタン）を媒体として選択
  package Medium = EAST.TwoPhaseFlow.Media.LCH;
  // -----------------------------------------------------------------
  // コンポーネント
  // -----------------------------------------------------------------
  EAST.TwoPhaseFlow.Component.Sources.MassFlowSource_h source(redeclare package Medium = Medium, m_flow_set = 0.5, h_set = 30000.0) "上流境界：流量 0.5 kg/s, h = 30 kJ/kg（5 bar 過冷却液 ≈ 128 K）" annotation(
    Placement(transformation(extent = {{-90, -15}, {-60, 15}})));
  EAST.TwoPhaseFlow.Component.Pipes.Pipe pipe(redeclare package Medium = Medium, L = 5.0, D = 0.025, dp = 10000.0, Q_flow = 50000.0) "加熱管：管長 5 m, 内径 25 mm, 圧損 10 kPa, 入熱 50 kW" annotation(
    Placement(transformation(origin = {-8, 21}, extent = {{-20, -16}, {20, 16}})));
  EAST.TwoPhaseFlow.Component.Sources.Boundary_ph sink(redeclare package Medium = Medium, p_set = 4.9e5, h_set = 1.3e5) "下流境界：圧力 4.9 bar（逆流時エンタルピー = 130 kJ/kg）" annotation(
    Placement(transformation(extent = {{90, -15}, {60, 15}})));
equation
// --- コンポーネント接続 ---
  connect(source.port, pipe.port_a) annotation(
    Line(points = {{-60, 0}, {-45, 0}, {-45, 21}, {-28, 21}}, color = {0, 127, 255}, thickness = 0.5));
  connect(pipe.port_b, sink.port) annotation(
    Line(points = {{12, 21}, {45, 21}, {45, 0}, {60, 0}}, color = {0, 127, 255}, thickness = 0.5));
  annotation(
    experiment(StopTime = 1.0),
    Documentation(info = "<html>
<h4>概要</h4>
<p>
液体メタン（LCH）が加熱管を流れる際の相変化を示す最小構成例。
</p>

<h4>系の構成</h4>
<pre>
  MassFlowSource_h  →  Pipe  →  Boundary_ph
  (流量・h 固定)      (加熱)     (圧力固定)
</pre>

<h4>設計点（定常解の見込み）</h4>
<table border=\"1\" cellspacing=\"0\">
<tr><th>項目</th><th>入口</th><th>出口</th></tr>
<tr><td>圧力 [bar]</td><td>5.0</td><td>4.9</td></tr>
<tr><td>比エンタルピー [kJ/kg]</td><td>30</td><td>130</td></tr>
<tr><td>相</td><td>単相（過冷却液）</td><td>二相</td></tr>
<tr><td>温度 [K]</td><td>≈ 128</td><td>≈ 135（飽和温度）</td></tr>
<tr><td>乾き度 [-]</td><td>—</td><td>≈ 0.10</td></tr>
</table>

<h4>エネルギー収支</h4>
<p>
入熱 Q_flow = 50 kW, 流量 0.5 kg/s のとき比エンタルピー上昇は<br/>
Δh = Q_flow / ṁ = 50000 / 0.5 = 100 kJ/kg<br/>
h_out = 30 + 100 = 130 kJ/kg。
5 bar での h_bubble ≈ 85 kJ/kg なので出口は二相域に入る。
</p>

<h4>観測変数</h4>
<ul>
<li><code>T_in</code>, <code>d_in</code>, <code>phase_in</code> — 入口の温度・密度・相状態</li>
<li><code>T_out</code>, <code>d_out</code>, <code>phase_out</code> — 出口の温度・密度・相状態</li>
<li><code>x_out</code>     — 出口乾き度（≈ 0.10 を期待）</li>
<li><code>alpha_out</code> — 出口ボイド率（HEM）</li>
</ul>
</html>"));
end TestPipeWithSource;
