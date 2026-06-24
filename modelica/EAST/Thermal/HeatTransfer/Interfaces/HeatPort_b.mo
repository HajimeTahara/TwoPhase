within EAST.Thermal.HeatTransfer.Interfaces;
connector HeatPort_b "集中熱ポート"
  extends EAST.Thermal.HeatTransfer.Interfaces.HeatPort;
  extends EAST.Icons.HeatPort_b;
  annotation (
    defaultComponentName="port",
    Documentation(info="<html>
<p>
熱伝達コンポーネント用の熱ポートです。
</p>
</html>"));
end HeatPort_b;
