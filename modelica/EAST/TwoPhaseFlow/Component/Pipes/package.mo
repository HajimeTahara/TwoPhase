within EAST.TwoPhaseFlow.Component;
package Pipes "管モデル群"
  extends Modelica.Icons.Package;
  annotation (Documentation(info="<html>
<p>管モデル群。</p>
<h4>現在のモデル</h4>
<ul>
<li><code>PipeGeometry</code> — 矩形管、円管、中空円環を選択する断面形状の列挙型</li>
<li><code>FrictionCorrelation</code> — 乱流域の Blasius / Colebrook-White 相関式を選択する列挙型</li>
<li><code>pipeNusseltNumber</code> — 管内強制対流の Reynolds 数・Prandtl 数から Nusselt 数を計算する関数</li>
<li><code>DynamicPipe</code> — 動的管（<code>nNodes</code> 個の <code>DynamicPipeSegment</code> を直列接続し、
    管内流体の移流を近似; <code>use_HeatTransfer</code> によりセグメントごとの HeatPort を切替可能）</li>
<li><code>DynamicPipeSegment</code> — 単一 well-mixed 制御容積（<code>DynamicPipe</code> の内部要素;
    単体でも利用可能、断面形状、管摩擦圧損、HeatPort を設定可能）</li>
<li><code>PipeUniformHeatTransfer</code> — 単一 HeatPort から <code>DynamicPipe</code> の各セグメントへ
    熱流を均等分配するラッパー</li>
</ul>
</html>"));
end Pipes;
