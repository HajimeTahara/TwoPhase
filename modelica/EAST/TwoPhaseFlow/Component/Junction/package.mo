within EAST.TwoPhaseFlow.Component;
package Junction "分岐・継手モデル群"
  extends Modelica.Icons.Package;
  annotation (Documentation(info="<html>
<p>
分岐、断面変化、曲がり部を表す簡易継手モデル群。
</p>
<ul>
<li><code>TeeJunction</code> — 圧力損失を持たない理想三方分岐・合流</li>
<li><code>Expansion</code> — 急拡大部の局所圧力損失</li>
<li><code>Elbo</code> — エルボ部の局所圧力損失</li>
</ul>
</html>"));
end Junction;
