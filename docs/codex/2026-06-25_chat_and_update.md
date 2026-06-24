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
