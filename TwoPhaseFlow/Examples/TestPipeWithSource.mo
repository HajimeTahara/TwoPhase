within TwoPhaseFlow.Examples;
model TestPipeWithSource
  "LCH 加熱管：過冷却液入口 → 二相出口の例題"

  // LCH（液体メタン）を媒体として選択
  package Medium = TwoPhaseFlow.Media.LCH;

  // -----------------------------------------------------------------
  // コンポーネント
  // -----------------------------------------------------------------

  TwoPhaseFlow.Component.Sources.MassFlowSource_h source(
    redeclare package Medium = Medium,
    m_flow_set = 0.5,
    h_set      = 30000.0)
    "上流境界：流量 0.5 kg/s, h = 30 kJ/kg（5 bar 過冷却液 ≈ 128 K）";

  TwoPhaseFlow.Component.Pipes.Pipe pipe(
    redeclare package Medium = Medium,
    L      = 5.0,
    D      = 0.025,
    dp     = 10000.0,
    Q_flow = 50000.0)
    "加熱管：管長 5 m, 内径 25 mm, 圧損 10 kPa, 入熱 50 kW";

  TwoPhaseFlow.Component.Sources.Boundary_ph sink(
    redeclare package Medium = Medium,
    p_set = 4.9e5,
    h_set = 1.3e5)
    "下流境界：圧力 4.9 bar（逆流時エンタルピー = 130 kJ/kg）";

  // -----------------------------------------------------------------
  // 観測変数（入口）
  // -----------------------------------------------------------------
  Modelica.Units.SI.Temperature      T_in    "入口温度 [K]";
  Modelica.Units.SI.Density          d_in    "入口密度 [kg/m³]";
  Integer                            phase_in "入口相状態 (1=単相, 2=二相)";

  // -----------------------------------------------------------------
  // 観測変数（出口）
  // -----------------------------------------------------------------
  Modelica.Units.SI.Temperature      T_out    "出口温度 [K]（二相では飽和温度）";
  Modelica.Units.SI.Density          d_out    "出口密度 [kg/m³]（HEM 混合密度）";
  Integer                            phase_out "出口相状態 (1=単相, 2=二相)";
  Real                               x_out    "出口乾き度 [-]（0=飽和液, 1=飽和蒸気）";
  Real                               alpha_out "出口ボイド率 [-]（HEM）";

equation
  // --- コンポーネント接続 ---
  connect(source.port, pipe.port_a);
  connect(pipe.port_b,  sink.port);

  // --- 入口物性（BaseProperties から取得）---
  T_in     = pipe.props_a.T;
  d_in     = pipe.props_a.d;
  phase_in = pipe.props_a.phase;

  // --- 出口物性（BaseProperties + Medium 関数から取得）---
  T_out     = pipe.props_b.T;
  d_out     = pipe.props_b.d;
  phase_out = pipe.props_b.phase;
  x_out     = Medium.vapourQuality(pipe.props_b.state);
  alpha_out = Medium.voidFraction(pipe.props_b.state);

  annotation (
    experiment(StopTime=1.0),
    Documentation(info="<html>
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
