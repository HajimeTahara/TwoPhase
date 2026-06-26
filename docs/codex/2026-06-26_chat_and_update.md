# 2026-06-26 chat and update

## InvertorCoolingModule の単体モデルチェック修正

- `InvertorCoolingModule` の既定媒体が抽象パッケージ
  `PartialTwoPhaseMedium` だったため、単体チェック時に `T_min` などの
  抽象定数が未設定となっていた。
- 上位モデルから `LCH_FD` を再宣言した場合は正常に具体化されるため、
  エラーはコンポーネント単体の既定媒体でのみ発生していた。
- 既定媒体を `EAST.TwoPhaseFlow.Media.LCH_FD` へ変更し、
  `choicesAllMatching=true` を追加した。
- 子エンティティを持たない `LCH` と `LCH_FD` の `package.order` に
  定数名が列挙されていたため、不要な警告を避けるため両ファイルを削除した。
- OpenModelica 1.26.1で `InvertorCoolingModule` の単体チェックに成功した。
  結果は388方程式・388変数。
- `LCH_FD` を再宣言した確認モデルも388方程式・388変数で成功した。
- 上位モデル `EPv2CoolingSystemSimple` も1157方程式・1157変数で
  モデルチェックに成功した。

## ConstantArray ブロックの追加

- `EAST.Blocks.Sources.ConstantArray` を追加した。
- Real 型の配列パラメータ `k[:]` を受け取り、同じサイズの
  `RealOutput y[size(k, 1)]` へ定数配列として出力する。
- 配列長は `k` から自動決定し、別の次元パラメータを不要とした。
- `EAST.Blocks.Sources.package.order` を追加し、`ConstantArray` を登録した。
- OpenModelica 1.26.1 でモデルチェックに成功した。

## Polynomial ブロックの追加

- `EAST.Blocks.Math.Polynomial` を追加した。
- Real 入力 `u` に対し、定数項から三次項までの係数
  `a0`、`a1`、`a2`、`a3` を用いて Real 出力 `y` を計算する。
- `EAST.Blocks.Types.PolynomialType` を追加し、一次、二次、三次を
  列挙型パラメータで選択できるようにした。
- 選択した次数で使用しない高次係数はパラメータ設定画面で無効化する。
- `Math` と `Types` の `package.order` を追加し、新規エンティティを登録した。
- OpenModelica 1.26.1 で `Polynomial` 単体、および三次係数を設定した
  接続確認モデルのモデルチェックに成功した。

## PolynomialArray ブロックの追加

- `EAST.Blocks.Math.PolynomialArray` を追加した。
- 構造パラメータ `n` と同じサイズの `RealInput u[n]` および
  `RealOutput y[n]` を持ち、入力配列の各要素へ同じ多項式を適用する。
- 多項式タイプと係数は `Polynomial` と同じ
  `polynomialType`、`a0`、`a1`、`a2`、`a3` を使用する。
- `EAST.Blocks.Math.package.order` に `PolynomialArray` を登録した。
- OpenModelica 1.26.1 で単体、および `ConstantArray` の3要素出力を
  三次多項式へ接続した確認モデルのモデルチェックに成功した。

## RealVectorInput コネクタの追加

- `EAST.Blocks.Interfaces.RealVectorInput` を追加した。
- MSL の `Modelica.Blocks.Interfaces.RealVectorInput` と同じく、
  `RealVectorInput u[n]` と宣言して Real 入力コネクタ配列に使用する。
- 通常の `Modelica.Blocks.Interfaces.RealInput` の配列と直接接続できる
  スカラーコネクタ型とし、配列用途を示す円形アイコンを設定した。
- `EAST.Blocks.Interfaces.package.order` を追加して登録した。
- OpenModelica 1.26.1 で3要素の `RealOutput` 配列との接続確認モデルが
  モデルチェックに成功した。

## 汎用モーター材料物性の追加

- `EAST.Thermal.Material.GeneralMotorCore` を追加した。
- 無方向性電磁鋼板の代表値として、密度 7650 kg/m3、比熱容量
  460 J/(kg.K)、熱伝導率 25 W/(m.K) を設定した。
- `EAST.Thermal.Material.GeneralMotorCoil` を追加した。
- 銅導体の代表値として、密度 8960 kg/m3、比熱容量
  385 J/(kg.K)、熱伝導率 400 W/(m.K) を設定した。
- コアの積層方向およびコイルの巻線間方向では実効熱伝導率が異なるため、
  詳細計算では対象構造に応じた実効物性へ置き換える注意事項を記載した。
- `EAST.Thermal.Material.package.order` に両レコードを登録した。
- OpenModelica 1.26.1 で、両材料を既存の `HeatCapacitor` に設定した
  確認モデルのモデルチェックに成功した。

## PartialTwoPhaseMedium の抽象定数への仮値設定

- `EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium` の媒体定数に
  コンパイル用の仮値を設定した。
- `replaceable package Medium =
  EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium` のまま
  コンポーネントをチェックした場合に、`T_min` などの未束縛定数で
  翻訳エラーになる問題を避けるため。
- 具体媒体の `EAST.TwoPhaseFlow.Media.LCH` / `LCH_FD` では、従来通り
  `redeclare constant ... = Common.LCHData...` によって実媒体値を上書きする。
- OpenModelica 1.26.1 で `EAST.TwoPhaseFlow.Component.Pipes.DynamicPipe` と
  `EAST.TwoPhaseFlow.Media.LCH.BaseProperties` のモデルチェックに成功した。

## InvertorCoolingTest の媒体 redeclare 修正

- `ModelicaProjects.InvertorCoolingTest` の `InvertorCoolingModule` インスタンスに
  `redeclare package Medium = medium` を追加した。
- `InvertorCoolingModule` の既定媒体は
  `EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMediumFD` であり partial class のため、
  テストモデル側で具体媒体 `EAST.TwoPhaseFlow.Media.LCH_FD` に置き換える必要があった。
- OpenModelica 1.26.1 で `ModelicaProjects.InvertorCoolingTest` の
  モデルチェックに成功した。

## MotorCoolingTest の媒体 redeclare 修正

- `ModelicaProjects.MotorCoolingTest` の `MotorCoolingModule` インスタンスに
  `redeclare package Medium = medium` を追加した。
- `MotorCoolingModule` の既定媒体も
  `EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMediumFD` であり partial class のため、
  テストモデル側で具体媒体 `EAST.TwoPhaseFlow.Media.LCH_FD` に置き換える必要があった。
- OpenModelica 1.26.1 で `ModelicaProjects.MotorCoolingTest` の
  モデルチェックに成功した。
