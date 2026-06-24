within EAST.Icons;
partial model ClosedVolume
  "MSL Modelica.Fluid.Vessels.ClosedVolume の密閉容器アイコン"
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Ellipse(
          extent={{-100,100},{100,-100}},
          fillPattern=FillPattern.Sphere,
          fillColor={170,213,255}),
        Text(
          extent={{-150,110},{150,150}},
          textColor={0,0,255},
          textString="%name")}), Documentation(info="<html>
<p>
MSL <code>Modelica.Fluid.Vessels.ClosedVolume</code>（容積固定の密閉容器）の
アイコンを流用するための <code>partial model</code> です。
</p>
<p>
名前ラベルは継承元の <code>Vessels.BaseClasses.PartialLumpedVessel</code> から
合成しています。容積値を表示する <code>V=%V</code> ラベルは、本クラスが
パラメータ <code>V</code> を持たないため省略しています。
</p>
<p>
出典: Modelica.Fluid.Vessels.ClosedVolume (Modelica Standard Library),
Copyright &copy; 2002-2025, Modelica Association and contributors.
</p>
</html>"));
end ClosedVolume;
