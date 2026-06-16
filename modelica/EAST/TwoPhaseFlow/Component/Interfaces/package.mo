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
<li><code>HeatPort</code>    — 熱ポート基底（T, Q_flow）。MSL の <code>HeatPort</code> を
    extends せず独立に再実装したもの</li>
<li><code>HeatPort_a</code>  — 熱を受け取る側のポート（塗りつぶし矩形）</li>
<li><code>HeatPort_b</code>  — 熱を供給する側のポート（白抜き矩形）</li>
</ul>
</html>"));
end Interfaces;
