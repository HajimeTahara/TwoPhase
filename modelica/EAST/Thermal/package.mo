within EAST;
package Thermal "MSL Thermal を参考にした熱系ライブラリ"
  extends Modelica.Icons.Package;

  annotation (Documentation(info="<html>
<p>
<b>Thermal</b> は Modelica Standard Library の
<code>Modelica.Thermal</code> の構成を参考にした熱系パッケージです。
</p>
<p>
既存の <code>TwoPhaseFlow</code> パッケージとは独立したトップレベルパッケージとして管理します。
</p>
<h4>パッケージ構成</h4>
<ul>
<li><code>Material</code> — 材料物性レコード</li>
<li><code>HeatTransfer</code> — 集中定数系の熱伝達コンポーネント</li>
<li><code>FluidHeatFlow</code> — 簡易流体熱流コンポーネント</li>
</ul>
</html>"));
end Thermal;
