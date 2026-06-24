within EAST.TwoPhaseFlow.Component;
package Tanks "タンク・容器モデル群"
  extends Modelica.Icons.Package;
  annotation (Documentation(info="<html>
<p>
MSL の <code>Modelica.Fluid.Vessels</code> に倣ったタンク・容器モデル群。
</p>
<ul>
<li><code>ClosedVolume</code> — well-mixed な固定容積モデル</li>
<li><code>OpenTank</code> — 自由表面を大気圧に固定した開放タンクモデル</li>
<li><code>GasPressuredTank</code> — 気相体積と理想気体式から内圧を計算するガス押しタンクモデル</li>
</ul>
</html>"));
end Tanks;
