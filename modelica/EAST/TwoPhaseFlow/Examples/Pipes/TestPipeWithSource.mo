within EAST.TwoPhaseFlow.Examples.Pipes;

model TestPipeWithSource "LCH 加熱管：過冷却液入口 → 二相出口の例題"
extends Modelica.Icons.Example;
  // LCH（液体メタン）を媒体として選択
  package Medium = EAST.TwoPhaseFlow.Media.LCH;
  // -----------------------------------------------------------------
  // コンポーネント
  // -----------------------------------------------------------------
  Component.Sources.MassFlowSource_T massFlowSource_T(redeclare package Medium = Medium, m_flow_set = 0.1, T_set = 93.15, use_m_flow_in = true, use_T_in = true) annotation(
    Placement(transformation(origin = {-72, -36}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Components.Convection convection annotation(
    Placement(transformation(origin = {-4, 38}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant const(k = 0.1) annotation(
    Placement(transformation(origin = {34, 38}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Component.Pipes.DynamicPipeSegment dynamicPipeSegment(
    redeclare package Medium = Medium,
    geometry = Component.Pipes.PipeGeometry.Circular,
    length = 1,
    diameter = sqrt(4*0.001/Modelica.Constants.pi)) annotation(
    Placement(transformation(origin = {-4, -6}, extent = {{-10, -10}, {10, 10}})));
  Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor annotation(
    Placement(transformation(origin = {-4, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow(Q_flow = 300) annotation(
    Placement(transformation(origin = {-50, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const1(k = 101325)  annotation(
    Placement(transformation(origin = {122, -10}, extent = {{10, -10}, {-10, 10}})));
  Component.Sources.Boundary_pT boundary_pT(use_p_in = true, use_T_in = true, redeclare package Medium = Medium)  annotation(
    Placement(transformation(origin = {74, -34}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Modelica.Blocks.Sources.Constant const11(k = 90) annotation(
    Placement(transformation(origin = {120, -56}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.Constant const12(k = 0.1) annotation(
    Placement(transformation(origin = {-114, -6}, extent = {{-10, -10}, {10, 10}}, rotation = -0)));
  Modelica.Blocks.Sources.Constant const121(k = 90) annotation(
    Placement(transformation(origin = {-116, -54}, extent = {{-10, -10}, {10, 10}})));
equation
// --- コンポーネント接続 ---
  connect(const.y, convection.Gc) annotation(
    Line(points = {{23, 38}, {6, 38}}, color = {0, 0, 127}));
  connect(convection.fluid, dynamicPipeSegment.heatPort) annotation(
    Line(points = {{-4, 28}, {-4, -2}}, color = {191, 0, 0}));
  connect(fixedHeatFlow.port, heatCapacitor.port_left) annotation(
    Line(points = {{-40, 70}, {-14, 70}}, color = {191, 0, 0}));
  connect(massFlowSource_T.port, dynamicPipeSegment.port_a) annotation(
    Line(points = {{-62, -36}, {-36, -36}, {-36, -6}, {-14, -6}}, color = {0, 0, 127}));
  connect(heatCapacitor.port_bottom, convection.solid) annotation(
    Line(points = {{-4, 60}, {-4, 48}}, color = {191, 0, 0}));
  connect(dynamicPipeSegment.port_b, boundary_pT.port) annotation(
    Line(points = {{6, -6}, {26, -6}, {26, -34}, {64, -34}}, color = {0, 0, 127}));
  connect(boundary_pT.p_in, const1.y) annotation(
    Line(points = {{86, -28}, {104, -28}, {104, -10}, {112, -10}}, color = {0, 0, 127}));
  connect(boundary_pT.T_in, const11.y) annotation(
    Line(points = {{86, -40}, {94, -40}, {94, -56}, {110, -56}}, color = {0, 0, 127}));
  connect(const12.y, massFlowSource_T.m_flow_in) annotation(
    Line(points = {{-102, -6}, {-92, -6}, {-92, -30}, {-84, -30}}, color = {0, 0, 127}));
  connect(const121.y, massFlowSource_T.T_in) annotation(
    Line(points = {{-105, -54}, {-92, -54}, {-92, -42}, {-84, -42}}, color = {0, 0, 127}));
  annotation(
    experiment(StopTime = 1.0),
    Documentation(info = "<html>
  <h4>概要</h4>
  <p>
  液体メタン（LCH）が加熱管を流れる際の相変化を示す最小構成例。
  </p>
  
  <h4>系の構成</h4>
  <pre>
    MassFlowSource_T  →  DynamicPipeSegment  →  Boundary_ph
    (流量・T 固定)        (加熱対象 CV)          (圧力固定)
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
  <code>dynamicPipeSegment.heatPort</code> へ HeatPort 経由で入熱する。
  </p>
  
  <h4>観測変数</h4>
  <ul>
  <li><code>T_in</code>, <code>d_in</code>, <code>phase_in</code> — 入口の温度・密度・相状態</li>
  <li><code>T_out</code>, <code>d_out</code>, <code>phase_out</code> — 出口の温度・密度・相状態</li>
  <li><code>x_out</code>     — 出口乾き度（≈ 0.10 を期待）</li>
  <li><code>alpha_out</code> — 出口ボイド率（HEM）</li>
  <li><code>dynamicPipeSegment.props.T</code> — セグメントの代表温度</li>
  </ul>
  </html>"));
end TestPipeWithSource;
