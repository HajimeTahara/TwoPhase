# 2026-06-17 chat and update

## 議題

`TestFluidProperties.mo` で `props.h` を変更しても `Medium` の温度が変化しない問題の調査。

## 決定事項

- 原因は `PartialTwoPhaseMedium.temperatureSinglePhase(p, h)` が単相域でも `sat.Tsat` を返しており、`h` を使っていなかったこと。
- 現段階では新しい 2D 物性テーブルを追加せず、既存の `specificEnthalpy_pT(p, T)` と整合する代表定圧比熱による線形近似を使う。

## 変更ファイル

- `modelica/EAST/TwoPhaseFlow/Media/Interfaces/PartialTwoPhaseMedium.mo`
  - `temperatureSinglePhase(p, h)` を、飽和液/飽和蒸気エンタルピーからの `cp_liquid_const` / `cp_vapor_const` 線形外挿に変更。
  - `densitySinglePhase(p, h)` が `temperatureSinglePhase(p, h)` の温度を PR EOS に渡すよう変更。
  - ドキュメント内の古い「飽和温度を暫定使用」説明を更新。

## 変更理由

`BaseProperties.T` は `temperature(state)` から計算され、単相域では `temperatureSinglePhase(state.p, state.h)` に委譲される。従来実装では `h` に依存せず飽和温度のみを返していたため、`props.h` を変えても `props.T` が変わらなかった。

## 残作業

- OpenModelica (`omc`) がこの環境の PATH に無かったため、モデルのコンパイル/シミュレーション確認は未実施。
- 今後の精度改善として、CoolProp 由来の単相 2D 物性テーブル、または NASA 多項式 + PR departure 関数による真の `T(p,h)` 実装を検討する。

## 追記: phase が変化しない件

### 議題

`props.h` を上げたときに `props.phase` が単相から二相へ変わらないように見える問題の調査。

### 調査結果

- `phase` の判定は `PartialTwoPhaseMedium.setState_ph(p, h)` にあり、以下の条件で決まる。
  - `h <= sat.h_bubble`: `phase = 1`（単相液）
  - `sat.h_bubble < h < sat.h_dew`: `phase = 2`（気液二相）
  - `h >= sat.h_dew`: `phase = 1`（単相蒸気）
- `TestFluidProperties.mo` の現在値 `p = 4.9e5 Pa` では、飽和テーブル補間により概算で以下になる。
  - `Tsat ≈ 134.985 K`
  - `h_bubble ≈ 84163 J/kg`
  - `h_dew ≈ 543402 J/kg`
- したがって、`h=100` や `h=600000`、`h=1e10` はすべて `phase=1` になる。`phase=2` を確認するには、例えば `h=300000` のように `84163 < h < 543402` の範囲に入れる必要がある。

### 残作業

- OpenModelica 実行環境で `h=300000` を与えた場合に `props.phase=2` になるか確認する。
- もし `h=300000` でも変わらない場合は、OpenModelica 側で `Integer` を含む `ThermodynamicState` レコード関数出力が期待通り評価されているかを追加調査する。

## 追記: TestFluidProperties の h ランプ化

### 議題

`TestFluidProperties.mo` の `props.h = 300000` の固定代入を、時間で線形変化する入力に変更。

### 変更ファイル

- `modelica/EAST/TwoPhaseFlow/Examples/TestFluidProperties.mo`
  - `h_start`, `h_end`, `rampDuration` パラメータを追加。
  - `props.h = h_start + (h_end - h_start) * min(time / rampDuration, 1.0)` に変更。

### 変更理由

`p = 4.9e5 Pa` では二相域がおよそ `84163 < h < 543402 J/kg` なので、既定値を `h_start = 0`, `h_end = 600000` として、単相液、二相、単相蒸気を 1 回のシミュレーションで確認できるようにした。

## 追記: Examples パッケージのフォルダ整理

### 議題

`EAST.TwoPhaseFlow.Examples` 配下で、`Media.mo` / `Pipes.mo` の package 内に model が直接定義されていたため、リポジトリの 1 エンティティ = 1 ファイル規則に合わせて整理した。

### 変更ファイル

- `modelica/EAST/TwoPhaseFlow/Examples/Media/package.mo`
- `modelica/EAST/TwoPhaseFlow/Examples/Media/package.order`
- `modelica/EAST/TwoPhaseFlow/Examples/Media/TestFluidProperties.mo`
- `modelica/EAST/TwoPhaseFlow/Examples/Pipes/package.mo`
- `modelica/EAST/TwoPhaseFlow/Examples/Pipes/package.order`
- `modelica/EAST/TwoPhaseFlow/Examples/Pipes/TestPipeWithSource.mo`
- `modelica/EAST/TwoPhaseFlow/Examples/Pipes/TestPipeSegment.mo`
- `modelica/EAST/TwoPhaseFlow/Examples/package.mo`

### 変更理由

Modelica の package/model をファイル単位に分離し、`package.mo` は package 宣言と annotation のみ、所属順は `package.order` で管理する構成に戻した。

### 残作業

- OpenModelica 環境で `EAST.TwoPhaseFlow.Examples.Media.TestFluidProperties`、`EAST.TwoPhaseFlow.Examples.Pipes.TestPipeWithSource`、`EAST.TwoPhaseFlow.Examples.Pipes.TestPipeSegment` のロードと変換を確認する。

## 追記: Sources 境界条件の外部入力化

### 議題

`EAST.TwoPhaseFlow.Component.Sources` の境界条件モデルで、流量・圧力・温度・比エンタルピーを固定パラメータだけでなく外部入力から与えられるようにした。

### 変更ファイル

- `modelica/EAST/TwoPhaseFlow/Component/Sources/Boundary_ph.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Sources/Boundary_pT.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Sources/MassFlowSource_h.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Sources/MassFlowSource_T.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Sources/package.mo`
- `AGENTS.md`

### 変更理由

MSL の `Modelica.Fluid.Sources` にある `use_*_in` パターンを参考に、既定では従来通り固定パラメータを使い、Boolean スイッチを `true` にした場合のみ `RealInput` コネクタから境界値を与えられるようにした。

### 残作業

- OpenModelica 環境で、外部入力コネクタを有効にした各 Sources モデルのロードと接続テストを確認する。

## 追記: TwoPhaseFlow 配下のバックアップファイル削除

### 議題

`EAST.TwoPhaseFlow` 配下に残っていた `.bak-mo` バックアップファイルを削除した。

### 変更ファイル

- `modelica/EAST/TwoPhaseFlow/Component/Pipes/Examoles.bak-mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pipes/PipeUniformHeatTransfer.bak-mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pipes/SimplePipeSegment.bak-mo`

### 変更理由

実装対象外のバックアップファイルがパッケージ配下に残っていたため、リポジトリ構成を整理した。

### 残作業

- なし。

## 追記: OpenTank モデル追加

### 議題

`EAST.TwoPhaseFlow.Component.Tanks` には `ClosedVolume` のみがあったため、自由表面を持つ開放タンクモデル `OpenTank` を追加した。

### 変更ファイル

- `modelica/EAST/TwoPhaseFlow/Component/Tanks/OpenTank.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Tanks/package.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Tanks/package.order`

### 変更内容

- `OpenTank` を追加。
- 自由表面圧力を `p_ambient` に固定し、各ポート圧力は `p_ambient + props.d * g * max(level - portHeights[i], 0)` とした。
- 状態量はタンク内質量 `M` と代表比エンタルピー `h` とし、`der(M)` と `M * der(h)` の軽量な蓄積式で表現した。
- 液位は `level = M / (props.d * crossArea)` で計算する。
- 熱ポート `heatPort` を持たせ、`heatPort.T = props.T` とした。

### 残作業

- OpenModelica 環境でロード・変換確認を行う。
- 気相空間、ベント、相分離、オーバーフロー流出は未実装。

## 追記: ValveLinear の開度外部入力化

### 議題

`EAST.TwoPhaseFlow.Component.Valves.ValveLinear` の開度 `opening` を固定パラメータだけでなく外部入力から与えられるようにした。

### 変更ファイル

- `modelica/EAST/TwoPhaseFlow/Component/Valves/ValveLinear.mo`

### 変更内容

- `use_opening_in` Boolean パラメータを追加。
- `use_opening_in = true` の場合に表示される `opening_in` 入力コネクタを追加。
- 固定開度パラメータを `opening_set` とし、`use_opening_in = false` の場合に使用するよう変更。
- 実際にバルブ式へ用いる `opening` は `max(0, min(1, opening_internal))` で `0..1` に制限する。

### 残作業

- OpenModelica 環境で条件付き入力コネクタのロード・接続確認を行う。

## 追記: GasPressuredTank モデル追加

### 議題

`OpenTank` の `p_ambient` は固定の自由表面圧力であり、ガス押しによる圧力変化を表現できないため、気相質量と気相体積から理想気体式で内圧を計算する `GasPressuredTank` を追加した。

### 変更ファイル

- `modelica/EAST/TwoPhaseFlow/Component/Tanks/GasPressuredTank.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Tanks/package.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Tanks/package.order`

### 変更内容

- `GasPressuredTank` を追加。
- `mGas_flow_in` 入力コネクタから押しガス質量流量を与え、`der(M_gas) = mGas_flow_in` で気相質量を更新する。
- 液相質量 `M_liquid` と液相密度 `props.d` から `V_liquid` を計算し、`V_gas = V_total - V_liquid` とした。
- 気相圧力を `p_gas = M_gas * R_gas * T_gas / V_gas` で計算する等温理想気体モデルとした。
- 液相ポート圧力は `p_gas + props.d * g * max(level - portHeights[i], 0)` とした。

### 残作業

- OpenModelica 環境でロード・変換確認を行う。
- 気相エネルギー方程式、蒸発・凝縮、液相/気相間の物質移動は未実装。
