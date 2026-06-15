within EAST.Thermal.HeatTransfer.Interfaces;
connector HeatPort_a "集中熱ポート"
  extends EAST.Thermal.HeatTransfer.Interfaces.HeatPort;

  annotation (
    defaultComponentName="port",
    Icon(coordinateSystem(preserveAspectRatio=true), graphics={
      Rectangle(
        extent={{-100,100},{100,-100}},
        lineColor={191,0,0},
        fillColor={191,0,0},
        fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
熱伝達コンポーネント用の熱ポートです。
</p>
</html>"));
end HeatPort_a;
