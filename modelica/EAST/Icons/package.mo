within EAST;
package Icons "アイコン専用パッケージ（MSL アイコンの流用元）"
  extends Modelica.Icons.IconsPackage;
  annotation (Documentation(info="<html>
<p>
<b>Icons</b> は、Modelica Standard Library (MSL) のモデル・パッケージが持つ
アイコン定義（<code>annotation(Icon(...))</code>）のみを抜き出した
<code>partial</code> クラス群です。
</p>
<p>
EAST 配下のモデル・パッケージは、独自のアイコンを描く代わりに
このパッケージのクラスを <code>extends</code> することで、
MSL と見た目の一貫したアイコンを流用できます。
</p>
<p>
各クラスは元になった MSL クラスの <code>Icon</code> annotation のみを保持し、
方程式や変数は一切持ちません。継承元クラスのアイコンと合成して初めて完成する
見た目（例: 名前ラベルが基底クラス由来）の場合は、本パッケージのクラス単体で
完結する形に合成しています。また、シミュレーション変数に依存する動的表示
（<code>DynamicSelect</code> や <code>visible=&lt;parameter&gt;</code>）は、
icon-only クラスがそれらの変数・パラメータを持たないため、代表的な静的表示に
置き換えるか省略しています。
</p>
<h4>パッケージ構成（Modelica.Fluid 由来）</h4>
<ul>
<li><code>FluidPackage</code> — Modelica.Fluid パッケージ自体のアイコン</li>
<li><code>TwoPortFlowDevice</code> — 二方ポート流体デバイス共通アイコン（流れ方向矢印+名前）</li>
<li><code>Pipe</code>, <code>Pump</code>, <code>SweptVolume</code> — 配管・回転機械</li>
<li><code>Valve</code>, <code>Orifice</code>, <code>SharpEdgedOrifice</code>, <code>Adaptor</code>,
    <code>MultiPort</code> — バルブ・継手</li>
<li><code>ClosedVolume</code>, <code>OpenTank</code> — 容器・タンク</li>
<li><code>Source</code>, <code>MassFlowSource</code> — 境界条件ソース</li>
<li><code>SensorOnePort</code>, <code>Thermometer</code> — センサ</li>
<li><code>FluidPort_a</code>, <code>FluidPort_b</code> — 流体コネクタ</li>
</ul>
<h4>パッケージ構成（Modelica.Thermal 由来）</h4>
<ul>
<li><code>ThermalPackage</code> — Modelica.Thermal パッケージ自体のアイコン</li>
<li><code>HeatTransferPackage</code> — Modelica.Thermal.HeatTransfer パッケージ自体のアイコン</li>
<li><code>HeatPort_a</code>, <code>HeatPort_b</code> — 熱コネクタ</li>
<li><code>FixedTemperature</code>, <code>PrescribedTemperature</code>, <code>FixedHeatFlow</code> — 境界条件ソース</li>
<li><code>ThermalConductor</code>, <code>ThermalResistor</code>, <code>HeatCapacitor</code>,
    <code>Convection</code>, <code>BodyRadiation</code> — 熱伝達要素</li>
<li><code>TemperatureSensor</code>, <code>HeatFlowSensor</code> — センサ</li>
</ul>
<p>
なお Modelica.Thermal.FluidHeatFlow（簡易流体熱流ライブラリ）の配管・バルブ・ポンプ・
タンク等は、Modelica.Fluid 側で抽出済みの同役割のアイコン
（<code>Pipe</code>, <code>Valve</code>, <code>Pump</code>, <code>OpenTank</code> 等）と
概念的に重複するため、抽出対象から除外した。
</p>
</html>"));
end Icons;
