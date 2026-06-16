within EAST.TwoPhaseFlow.Component;
package Pipes "管モデル群"
  extends Modelica.Icons.Package;
  annotation (Documentation(info="<html>
<p>管モデル群。</p>
<h4>現在のモデル</h4>
<ul>
<li><code>Pipe</code> — 動的管（<code>nNodes</code> 個の <code>SimplePipeSegment</code> を直列接続し、
    管内流体の移流を近似; セグメントごとの HeatPort を公開）</li>
<li><code>SimplePipeSegment</code> — 比エンタルピー遅れのみを状態として扱う軽量セグメント</li>
<li><code>PipeSegment</code> — 単一 well-mixed 制御容積（<code>Pipe</code> の内部要素; 単体でも利用可能）</li>
<li><code>PipeUniformHeatTransfer</code> — 単一 HeatPort から <code>Pipe</code> の各セグメントへ
    熱流を均等分配するラッパー</li>
</ul>
</html>"));
end Pipes;
