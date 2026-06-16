within EAST.TwoPhaseFlow.Component.Interfaces;
connector HeatPort "熱ポート基底（1次元熱伝達; TwoPhaseFlow 独自実装、MSL 非依存）"
  Modelica.Units.SI.Temperature T "ポート温度 [K]";
  flow Modelica.Units.SI.HeatFlowRate Q_flow
    "熱流量 [W]（外部からこのポートへ流入する方向を正とする）";
end HeatPort;
