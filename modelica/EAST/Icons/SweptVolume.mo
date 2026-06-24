within EAST.Icons;
partial model SweptVolume
  "MSL Modelica.Fluid.Machines.SweptVolume のピストン・シリンダアイコン"
  extends EAST.Icons.TwoPortFlowDevice;
  annotation (Icon(graphics={
        Rectangle(
          extent={{-50,36},{50,-90}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          lineThickness=1,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-52,62},{-48,62},{-48,-30},{-52,-30},{-52,62}},
          lineColor={95,95,95},
          fillColor={135,135,135},
          fillPattern=FillPattern.Backward),
        Polygon(
          points={{48,60},{52,60},{52,-34},{48,-34},{48,60}},
          lineColor={95,95,95},
          fillColor={135,135,135},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-48,40},{48,30}},
          lineColor={95,95,95},
          fillColor={135,135,135},
          fillPattern=FillPattern.Forward),
        Rectangle(
          extent={{-6,92},{6,40}},
          lineColor={95,95,95},
          fillColor={135,135,135},
          fillPattern=FillPattern.Forward),
        Polygon(
          points={{-48,-90},{48,-90},{48,70},{52,70},{52,-94},{-52,-94},{-52,70},{-48,70},{-48,-90}},
          lineColor={95,95,95},
          fillColor={135,135,135},
          fillPattern=FillPattern.Backward),
        Line(
          points={{-40,0},{40,0}},
          color={95,127,95},
          origin={-70,32},
          rotation=90),
        Polygon(
          points={{15,0},{-15,10},{-15,-10},{15,0}},
          lineColor={95,127,95},
          fillColor={95,127,95},
          fillPattern=FillPattern.Solid,
          origin={-70,84},
          rotation=90)}), Documentation(info="<html>
<p>
MSL <code>Modelica.Fluid.Machines.SweptVolume</code>（ピストン位置に応じて
容積が変化するシリンダ）のアイコンを流用するための <code>partial model</code> です。
</p>
<p>
出典: Modelica.Fluid.Machines.SweptVolume (Modelica Standard Library),
Copyright &copy; 2002-2025, Modelica Association and contributors.
</p>
</html>"));
end SweptVolume;
