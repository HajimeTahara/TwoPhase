within EAST.Icons;
partial model SourceBoundary
  "MSL Modelica.Fluid.Sources.FixedBoundary の境界条件ソースアイコン"
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Ellipse(
          extent={{-100,100},{100,-100}},
          fillPattern=FillPattern.Sphere,
          fillColor={0,127,255}),
        Text(
          origin = {-10, -250},
          textColor={0,0,255},extent={{-150,110},{150,150}},
          textString="%name")}), Documentation(info="<html>
<p>
MSL <code>Modelica.Fluid.Sources.FixedBoundary</code>（固定境界条件ソース）の
アイコンを流用するための <code>partial model</code> です。
</p>
<p>
出典: Modelica.Fluid.Sources.FixedBoundary (Modelica Standard Library),
Copyright &copy; 2002-2025, Modelica Association and contributors.
</p>
</html>"));
end SourceBoundary;
