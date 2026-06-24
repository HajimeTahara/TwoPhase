within EAST.Thermal.HeatTransfer.Interfaces;
connector HeatPort_a "集中熱ポート"
  extends EAST.Thermal.HeatTransfer.Interfaces.HeatPort;
  extends EAST.Icons.HeatPort_a;
  annotation (
    defaultComponentName="port",
    Documentation(info="<html>
<p>
熱伝達コンポーネント用の熱ポートです。
</p>
</html>"));
end HeatPort_a;
