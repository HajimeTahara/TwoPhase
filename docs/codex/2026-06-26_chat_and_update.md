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

## ElementWiseArithmetic ブロックの追加

- MSL には `Math.Sum` / `Math.MultiSum` / `Math.MultiProduct` などの
  Real配列をスカラーへ集約するブロックはあるが、2つのReal配列を要素ごとに
  四則演算してReal配列で出力するブロックは見当たらなかった。
- `EAST.Blocks.Math.ElementWiseArithmetic` を追加した。
- `u1[n]` と `u2[n]` を入力し、演算タイプに応じて
  `y[i] = u1[i] + u2[i]`、`u1[i] - u2[i]`、`u1[i]*u2[i]`、
  `u1[i]/u2[i]` を計算する。
- `EAST.Blocks.Types.ArithmeticOperation` を追加し、`Add`、`Subtract`、
  `Multiply`、`Divide` を選択できるようにした。
- `EAST.Blocks.Math.package.order` と `EAST.Blocks.Types.package.order` に
  新規エンティティを登録した。
- OpenModelica 1.26.1 で単体、および `ConstantArray` 2つを接続した
  確認モデルのモデルチェックに成功した。

## VectorScalarArithmetic ブロックの追加

- `EAST.Blocks.Math.ElementWiseArithmetic` は残したまま、
  Real配列とスカラー入力の乗算・除算用ブロックを追加した。
- `EAST.Blocks.Math.VectorScalarArithmetic` を追加した。
- `u[n]` とスカラー入力 `k` を受け取り、演算タイプに応じて
  `y[i] = u[i]*k` または `y[i] = u[i]/k` を計算する。
- `EAST.Blocks.Types.VectorScalarOperation` を追加し、`Multiply` と
  `Divide` を選択できるようにした。
- `EAST.Blocks.Math.package.order` と `EAST.Blocks.Types.package.order` に
  新規エンティティを登録した。
- OpenModelica 1.26.1 で単体、および `ConstantArray` と
  `Modelica.Blocks.Sources.Constant` を接続した確認モデルの
  モデルチェックに成功した。

## EPv2Cooling MotorCoolingModule の VectorScalarArithmetic 次元修正

- `ModelicaProjects.EPv2Cooling.Component.MotorCoolingModule` の
  `VectorScalarArithmetic` インスタンスに `n = 3` を設定した。
- `VectorScalarArithmetic` の既定 `n` は1であり、`y[1]` を
  `CylindricalThermalConductor.Q_gen_input[3]` に接続しようとして
  connector 型不一致になっていた。
- OpenModelica 1.26.1 で
  `ModelicaProjects.EPv2Cooling.Component.MotorCoolingModule` と
  `ModelicaProjects.EPv2Cooling.Study.MotorCoolingTest` の
  モデルチェックに成功した。

## CylindricalThermalConductor の層温度出力追加

- `EAST.Thermal.HeatTransfer.Components.CylindricalThermalConductor` に
  `RealOutput layerTemperature[nLayers]` を追加した。
- 既存の各層代表温度状態 `T[i]` を `layerTemperature[i]` へ出力する。
- 出力には `quantity="ThermodynamicTemperature"`、`unit="K"`、
  `displayUnit="degC"` を設定した。
- OpenModelica 1.26.1 で
  `EAST.Thermal.HeatTransfer.Components.CylindricalThermalConductor` と
  `ModelicaProjects.EPv2Cooling.Study.MotorCoolingTest` の
  モデルチェックに成功した。

## CylindricalThermalConductor の層温度出力オプション化

- `EAST.Thermal.HeatTransfer.Components.CylindricalThermalConductor` に
  構造パラメータ `use_temperature_output` を追加した。
- `use_temperature_output=true` の場合のみ
  `RealOutput layerTemperature[nLayers]` を有効化する。
- 既定値は `false` とし、既存モデルでは温度出力コネクタを生成しない。
- OpenModelica 1.26.1 で単体、温度出力を有効化して
  `MultiSum` に接続した確認モデル、および
  `ModelicaProjects.EPv2Cooling.Study.MotorCoolingTest` の
  モデルチェックに成功した。

## SegmentedCylindricalThermalConductor の層・ノード温度出力オプション追加

- `EAST.Thermal.HeatTransfer.Components.SegmentedCylindricalThermalConductor` に
  構造パラメータ `use_temperature_output` を追加した。
- `use_temperature_output=true` の場合のみ
  `RealOutput layerTemperature[nLayers, nNode]` を有効化する。
- 既存の各層・各ノード代表温度状態 `T[i, j]` を
  `layerTemperature[i, j]` へ出力する。
- 既定値は `false` とし、既存モデルでは温度出力コネクタを生成しない。
- OpenModelica 1.26.1 で単体、および温度出力を有効化して
  `layerTemperature[1,1]` と `layerTemperature[3,2]` を接続した
  確認モデルのモデルチェックに成功した。

## ExtractScalar ブロックの追加

- MSL には `Modelica.Blocks.Routing.Extractor` があり、
  `IntegerInput index` によってReal配列からスカラーを動的に抽出できる。
- EAST側には、パラメータ `index` で抽出要素を固定指定する
  `EAST.Blocks.Routing.ExtractScalar` を追加した。
- `u[n]` から `u[index]` を取り出し、スカラーReal出力 `y` として出力する。
- `EAST.Blocks.Routing.package.order` を追加し、新規エンティティを登録した。
- OpenModelica 1.26.1 で単体、および `ConstantArray` から2番目の要素を
  抽出する確認モデルのモデルチェックに成功した。

## ElementWiseAdd ブロックの追加と MotorCoolingModule の単位警告対応

- `EAST.Blocks.Math.ElementWiseArithmetic` は四則演算を1つの条件式で切り替えるため、
  温度配列を接続した場合に未使用の乗算・除算分岐まで単位検査され、
  `K2` や `1` が混在する警告が出ていた。
- 温度など単位付き信号の加算・減算用として
  `EAST.Blocks.Math.ElementWiseAdd` を追加した。
- `ElementWiseAdd` は `y[i] = k1*u1[i] + k2*u2[i]` のみを計算し、
  `k2=-1` によって差分計算にも使える。
- `ModelicaProjects.EPv2Cooling.Component.MotorCoolingModule` の温度平均計算で使っていた
  `ElementWiseArithmetic(operation=Add)` を `ElementWiseAdd` に差し替えた。
- OpenModelica 1.26.1 で `ElementWiseAdd`、
  `ModelicaProjects.EPv2Cooling.Component.MotorCoolingModule`、
  `ModelicaProjects.EPv2Cooling.Study.MotorCoolingTest` の
  モデルチェックに成功し、該当の単位警告が出ないことを確認した。

## ElementWiseArithmetic の削除と要素別四則演算ブロックへの分離

- 条件式で四則演算を切り替える `EAST.Blocks.Math.ElementWiseArithmetic` を削除した。
- それに伴い、専用列挙型 `EAST.Blocks.Types.ArithmeticOperation` も削除した。
- 単位検査で未使用分岐の単位混在を避けるため、四則演算を次の個別ブロックに分離した。
  - `EAST.Blocks.Math.ElementWiseAdd`
  - `EAST.Blocks.Math.ElementWiseSubtract`
  - `EAST.Blocks.Math.ElementWiseMultiply`
  - `EAST.Blocks.Math.ElementWiseDivide`
- `ElementWiseSubtract` は `y[i] = k1*u1[i] - k2*u2[i]`、
  `ElementWiseMultiply` は `y[i] = k*u1[i]*u2[i]`、
  `ElementWiseDivide` は `y[i] = k*u1[i]/u2[i]` を計算する。
- `EAST.Blocks.Math.package.order` と `EAST.Blocks.Types.package.order` を更新した。
- OpenModelica 1.26.1 で各ブロック単体、4演算を接続した確認モデル、
  および `ModelicaProjects.EPv2Cooling.Study.MotorCoolingTest` の
  モデルチェックに成功した。

## パラメータ相手のスカラー四則演算ブロック追加

- MSL の `Modelica.Blocks.Math.Division` は2入力の除算ブロックであり、
  片方の演算対象をパラメータ化した1入力ブロックはそのままでは見当たらなかった。
- `EAST.Blocks.Math` に、Real入力1つとパラメータ `k` で四則演算する
  スカラー演算ブロックを追加した。
  - `AddParameter`: `y = u + k`
  - `SubtractParameter`: `y = u - k`
  - `MultiplyParameter`: `y = u*k`
  - `DivideParameter`: `y = u/k`
- 単位検査で未使用分岐が混ざらないよう、四則演算を1つの条件式ブロックにまとめず、
  演算ごとに別ブロックとして追加した。
- `EAST.Blocks.Math.package.order` に新規エンティティを登録した。
- OpenModelica 1.26.1 で4ブロック単体、および4ブロックを直列接続した
  確認モデルのモデルチェックに成功した。

## UnitConvert パッケージと rpm/rad 変換ブロック追加

- `EAST.Blocks.UnitConvert` パッケージを追加した。
- `EAST.Blocks.UnitConvert.RpmToRad` を追加し、rpm（rev/min）から
  rad/s へ変換するようにした。
- `EAST.Blocks.UnitConvert.RadToRpm` を追加し、rad/s から
  rpm（rev/min）へ変換するようにした。
- 変換式は MSL の `Modelica.Units.Conversions.from_rpm` /
  `to_rpm` を使用した。
- `EAST.Blocks.package.order` と `EAST.Blocks.UnitConvert.package.order` を更新した。
- OpenModelica 1.26.1 で2ブロック単体、および rpm→rad/s→rpm の
  往復接続確認モデルのモデルチェックに成功した。

## EPv2Cooling Real3ToArray ブロック追加

- `ModelicaProjects.EPv2Cooling.Real3ToArray` を追加した。
- 3つのReal入力 `u1`、`u2`、`u3` を受け取り、Real配列出力
  `y[3] = {u1, u2, u3}` として出力する。
- `ModelicaProjects.EPv2Cooling.package.order` に新規エンティティを登録した。
- OpenModelica 1.26.1 で単体、および3つの `Constant` と
  `ExtractScalar` を接続した確認モデルのモデルチェックに成功した。
