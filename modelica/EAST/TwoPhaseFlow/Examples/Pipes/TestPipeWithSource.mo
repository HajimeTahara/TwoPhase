within EAST.TwoPhaseFlow.Examples.Pipes;

model TestPipeWithSource "LCH 加熱管：過冷却液入口 → 二相出口の例題"
  // LCH（液体メタン）を媒体として選択
  package Medium = EAST.TwoPhaseFlow.Media.LCH;
  // -----------------------------------------------------------------
  // コンポーネント
  // -----------------------------------------------------------------
  EAST.TwoPhaseFlow.Component.Sources.Boundary_ph sink(redeclare package Medium = Medium, p_set = 4.9e5, h_set = 1.3e5) "下流境界：圧力 4.9 bar（逆流時エンタルピー = 130 kJ/kg）" annotation(
    Placement(transformation(origin = {0, -54}, extent = {{90, -15}, {60, 15}})));
  Component.Sources.MassFlowSource_T massFlowSource_T(redeclare package Medium = Medium, m_flow_set = 0.1, T_set = 93.15) annotation(
    Placement(transformation(origin = {-126, -56}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Components.Convection convection annotation(
    Placement(transformation(origin = {-18, -10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant const(k = 0.1) annotation(
    Placement(transformation(origin = {24, 98}, extent = {{-10, -10}, {10, 10}})));
  Component.Pipes.PipeSegment pipeSegment(redeclare package Medium = Medium, V = 0.001) annotation(
    Placement(transformation(origin = {-22, -54}, extent = {{-10, -10}, {10, 10}})));
  Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor annotation(
    Placement(transformation(origin = {-64, 72}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow(Q_flow = 300) annotation(
    Placement(transformation(origin = {-134, 76}, extent = {{-10, -10}, {10, 10}})));
equation
  // --- コンポーネント接続 ---
  connect(const.y, convection.Gc) annotation(
    Line(points = {{36, 98}, {52, 98}, {52, -10}, {-8, -10}}, color = {0, 0, 127}));
  connect(convection.fluid, pipeSegment.heatPort) annotation(
    Line(points = {{-18, -20}, {-18, -39.5}, {-22, -39.5}, {-22, -47}}, color = {191, 0, 0}));
  connect(massFlowSource_T.port, pipeSegment.port_a) annotation(
    Line(points = {{-116, -56}, {-32, -56}, {-32, -54}}, color = {0, 127, 255}));
  connect(pipeSegment.port_b, sink.port) annotation(
    Line(points = {{-12, -54}, {60, -54}}, color = {0, 127, 255}));
  connect(fixedHeatFlow.port, heatCapacitor.port_left) annotation(
    Line(points = {{-124, 76}, {-74, 76}, {-74, 72}}, color = {191, 0, 0}));
  connect(heatCapacitor.port_right, convection.solid) annotation(
    Line(points = {{-54, 72}, {-18, 72}, {-18, 0}}, color = {191, 0, 0}));
  annotation(
    experiment(StopTime = 1.0),
    Documentation(info = "<html>
  <h4>概要</h4>
  <p>
  液体メタン（LCH）が加熱管を流れる際の相変化を示す最小構成例。
  </p>
  
  <h4>系の構成</h4>
  <pre>
    MassFlowSource_T  →  PipeUniformHeatTransfer  →  Boundary_ph
    (流量・T 固定)        (一様熱交換)                 (圧力固定)
                                ↑
               FixedTemperature + Convection（HeatPort 経由で入熱）
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
  <code>FixedTemperature</code> と <code>Convection</code> を使って、
  <code>pipe.heatPort</code> へ管全体の代表熱ポート経由で入熱する。
  <code>PipeUniformHeatTransfer</code> はこの熱流を内部の <code>nNodes</code> 個の
  セグメントへ均等分配する。
  </p>
  
  <h4>観測変数</h4>
  <ul>
  <li><code>T_in</code>, <code>d_in</code>, <code>phase_in</code> — 入口の温度・密度・相状態</li>
  <li><code>T_out</code>, <code>d_out</code>, <code>phase_out</code> — 出口の温度・密度・相状態</li>
  <li><code>x_out</code>     — 出口乾き度（≈ 0.10 を期待）</li>
  <li><code>alpha_out</code> — 出口ボイド率（HEM）</li>
  <li><code>pipe.pipe.segment[i].props.T</code> — i 番目セグメントの代表温度</li>
  </ul>
  </html>"));
end TestPipeWithSource;
