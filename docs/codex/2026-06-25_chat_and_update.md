# 2026-06-25 chat and update

## Junction パッケージの追加

### 議題

- `EAST.TwoPhaseFlow.Component` に分岐・継手モデルを追加する。

### 決定事項

- `Component.Junction` パッケージを追加した。
- `TeeJunction` は圧力損失を持たない理想三方接続とした。
- `Expansion` は円管急拡大の Borda-Carnot 型局所損失を計算する。
- `Elbo` は指定した局所損失係数によるエルボ圧力損失を計算する。
- `Expansion` と `Elbo` は流れ方向上流側の媒体密度を使用し、双方向流れに対応する。
- 二ポート継手は断熱・等エンタルピーとした。

### 変更ファイル

- `modelica/EAST/TwoPhaseFlow/Component/Junction/package.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Junction/package.order`
- `modelica/EAST/TwoPhaseFlow/Component/Junction/TeeJunction.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Junction/Expansion.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Junction/Elbo.mo`
- `modelica/EAST/TwoPhaseFlow/Component/package.mo`
- `modelica/EAST/TwoPhaseFlow/Component/package.order`

### 残作業

- OpenModelica でモデル変換、T字混合、正流・逆流時の圧力損失を確認する。

---

## Syntax Error の修正

- `Expansion`、`Elbo`、`Pump` のDocumentation内にあるHTMLテーブル属性で、
  Modelica文字列と競合する二重引用符を使用していた。
- HTML属性を単一引用符へ変更し、Modelica文字列が途中で終了しないよう修正した。

---

## StaticPipe の追加

### 議題

- `DynamicPipeSegment` から制御容積と流体蓄積を除いた静的管抵抗を追加する。

### 決定事項

- `Component.Pipes.StaticPipe` を追加した。
- 断面形状、断面積、濡れ縁長さ、等価直径は `DynamicPipeSegment` と同じ計算式を使用する。
- Reynolds数、層流判定、Blasius式、Colebrook-White式、Darcy-Weisbach式を使用する。
- 流れ方向上流側の媒体密度を使い、正流・逆流に対応する。
- 内部制御容積、状態変数、初期条件、HeatPortは持たない。
- 流体通過は断熱・等エンタルピーとした。

### 変更ファイル

- `modelica/EAST/TwoPhaseFlow/Component/Pipes/StaticPipe.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pipes/package.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pipes/package.order`

### 残作業

- OpenModelicaでモデル変換と正流・逆流時の圧力損失を確認する。

---

## StaticPipe の上流粘性係数参照

- `StaticPipe` の `mu` パラメータを削除した。
- 流れ方向上流側の `Medium.BaseProperties.mu` を取得し、Reynolds数計算に使用するよう変更した。
- `StaticPipe` 自身は初期圧力を持たず、接続系の圧力条件と圧損式から圧力が代数的に決まることをDocumentationへ追記した。

---

## StaticPipe のポート圧力初期値

- `p_a_start` と `p_b_start` を追加した。
- 各値を `port_a.p` と `port_b.p` の `start` 属性へ設定した。
- 圧力スケーリング用に両ポートの `nominal` を `1.0e5` とした。
- これらは圧力境界ではなく、初期化ソルバーへ与える推定値として扱う。

---

## TeeJunction の共通圧力初期値

- `p_start` パラメータを追加した。
- 3ポートすべての圧力 `start` 属性へ `p_start` を設定した。
- 圧力スケーリング用に各ポートの `nominal` を `1.0e5` とした。
- `p_start` は圧力境界ではなく、初期化ソルバーへ与える推定値として扱う。

---

## 媒体モデルの温度適用範囲

- `PartialTwoPhaseMedium` に抽象定数 `T_min` と `T_max` を追加した。
- `BaseProperties`、`prDensity`、`temperatureSinglePhase`、
  `specificEnthalpy_pT` で温度適用範囲を検査するassertionを追加した。
- LCHでは下限を三重点温度、上限を臨界温度に設定した。
- Newton反復が異常な状態を試した場合も、Peng-Robinson式の`sqrt(Tr)`より前に
  適用範囲外温度を明示する。

### 追記

- Newton反復中の試行値によって初期化が即時停止しないよう、追加した温度範囲の
  assertionをすべて`AssertionLevel.warning`へ変更した。

---

## DynamicPipe系の粘性係数参照

- `DynamicPipeSegment` と `DynamicPipe` から `mu` パラメータを削除した。
- `DynamicPipeSegment` のReynolds数計算では媒体状態の `props.mu` を使用する。
- Prandtl数計算でも `props.mu` を使用する。
- `DynamicPipe` から各セグメントへの `mu` パラメータ受け渡しを削除した。

---

## SegmentedThermalConductor の方程式構造修正

- 内部の `HeatCapacitor segment[]` を廃止した。
- 各セグメント温度 `T[i]` を状態変数として、熱容量と熱流のエネルギー収支を直接記述した。
- 境界熱流とセグメント間熱流の定義は従来どおり維持した。
- `nSegments=1` の場合は両境界熱流を単一熱容量へ加える専用式とした。
- 未接続HeatPortへ暗黙に追加されるゼロ流量式と内部代入式の競合を解消した。

---

## CylindricalThermalConductor の方程式構造修正

- 内部の `HeatCapacitor layer[]` を廃止した。
- 各層の熱容量 `C[i]` を材料密度、比熱、体積から直接計算するようにした。
- 各層温度 `T[i]` を状態変数として、内部発熱と半径方向熱流の収支を直接記述した。
- `nLayers=1` の場合は内外境界熱流と内部発熱を単一層へ加える専用式とした。
- 未接続HeatPortへ暗黙に追加されるゼロ流量式との競合を解消した。

### 追記

- `Modelica.Math.sqrt` は現在のMSLに存在しないため、Modelica組み込みの
  `sqrt` へ変更した。
- 同じ記述があった `SegmentedCylindricalThermalConductor` も併せて修正した。

---

## Modelica Tips と内部発熱UIの明確化

- トップ階層に `MODELICA_TIPS.md` を追加し、`sqrt`などの組み込み関数と
  `Modelica.Math`に属する関数の使い分けを記載した。
- 円筒熱伝導モデルの`use_heat_input`説明を、true時は外部入力、
  false時は固定値`Q_gen`を使用することが分かる表現へ変更した。
- 固定値`Q_gen`は`use_heat_input=false`のときだけ編集可能とした。
- 外部コネクタ`Q_gen_input`は従来どおり`use_heat_input=true`のときだけ存在する。

---

## 単相密度固定媒体の追加

- `PartialTwoPhaseMedium` の既存計算ロジックは変更せず、
  `densitySinglePhase` を派生媒体で再宣言可能にした。
- `PartialTwoPhaseMediumFD` を追加し、単相密度を標準大気圧における
  飽和液密度へ固定した。
- 固定密度は `sat_p` と `sat_d_bubble` を 101325 Pa で補間して取得する。
- `LCH_FD` を追加し、`LCH` の物質定数・飽和物性表を参照しながら
  `PartialTwoPhaseMediumFD` を継承する構成とした。
- LCH の飽和表による固定密度は約 422.36 kg/m3。
- `Media`、`Interfaces`、`LCH_FD` の `package.order` とパッケージ文書を更新した。

### LCH_FD の媒体展開エラー修正

- 具体媒体 `LCH` の継承済み定数を `LCH_FD` から直接参照すると、
  OpenModelica のクラス展開時に `LCH.sat_d_dew` などを解決できなかった。
- LCH の物質定数と飽和物性表を、計算ロジックを持たない
  `Common.LCHData` へ分離した。
- `LCH` と `LCH_FD` はともに `Common.LCHData` を参照し、
  通常密度基底と固定密度基底だけを切り替える構成にした。
- `densitySinglePhase` は、既存アルゴリズムを持つ関数へ
  `redeclare function extends` していたため二重 algorithm になっていた。
  `PartialTwoPhaseMediumFD` で関数全体を再宣言する形へ修正した。
- OpenModelica 1.26.1 で `LCH`、`LCH_FD`、
  および `LCH_FD` を指定した `DynamicPipeSegment` の `checkModel` 成功を確認した。

---

## DynamicPipeSegment の流速・熱抵抗計算

- 質量流量と媒体密度から `volumeFlowRate` を計算し、
  流路断面積から断面平均流速 `velocity` を求める形に整理した。
- Reynolds数とPrandtl数から求めた熱伝達率 `alpha` と伝熱面積から、
  流体側対流熱コンダクタンス `thermalConductance` を計算するようにした。
- 流体側対流熱抵抗 `thermalResistance = 1 / thermalConductance` を追加した。
- 熱流量は `Q_flow = thermalConductance * (heatPort.T - props.T)` とした。
- `use_HeatTransfer=false` の場合は、熱コンダクタンスを0、
  熱抵抗を無限大、熱流量を0として扱う。
- OpenModelica 1.26.1で、HeatPort有効時は48方程式・48変数、
  無効時は44方程式・44変数で `checkModel` 成功を確認した。
