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
