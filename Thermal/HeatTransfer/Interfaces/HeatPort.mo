within Thermal.HeatTransfer.Interfaces;
connector HeatPort "集中熱ポート"
  Modelica.Units.SI.Temperature T "ポート温度 [K]";
  flow Modelica.Units.SI.HeatFlowRate Q_flow
    "熱流量 [W]（コンポーネントへ流入する向きを正）";
end HeatPort;
