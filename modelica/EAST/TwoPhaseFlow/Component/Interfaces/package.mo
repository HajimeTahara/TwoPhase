within EAST.TwoPhaseFlow.Component;
package Interfaces "コンポーネント用インターフェース（コネクタ定義）"
  extends Modelica.Icons.InterfacesPackage;
  annotation (Documentation(info="<html>
<p>
流体コンポーネント間の接続に使うコネクタを定義する。
</p>
<h4>コネクタ</h4>
<ul>
<li><code>FluidPort</code>   — 二相流体ポート基底（replaceable Medium, p, m_dot, h_outflow）</li>
<li><code>FluidPort_a</code> — 入口ポート（塗りつぶし円）</li>
<li><code>FluidPort_b</code> — 出口ポート（白抜き円）</li>
</ul>
</html>"));
end Interfaces;
