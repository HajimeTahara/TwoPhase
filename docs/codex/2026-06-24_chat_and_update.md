# 2026-06-24 chat and update

## 議題

- `EAST.TwoPhaseFlow.Component.Pipes.DynamicPipe` と
  `DynamicPipeSegment` の HeatPort を On/Off 可能にする。

## 決定事項

- MSL の命名に合わせ、Boolean パラメータ名を `use_HeatTransfer` とした。
- 既存モデルとの互換性を保つため、既定値は `true` とした。
- `false` の場合は条件付きコネクタによって HeatPort を除去し、外部熱流を 0 W とする。
- `DynamicPipe` の設定を内部の全 `DynamicPipeSegment` へ伝播する。

## 変更ファイル

- `modelica/EAST/TwoPhaseFlow/Component/Pipes/DynamicPipe.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pipes/DynamicPipeSegment.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pipes/package.mo`
- `docs/codex/2026-06-24_chat_and_update.md`

## 変更理由

- 断熱管として使用する場合に、未使用の HeatPort をモデル上から明示的に除去できるようにするため。
- 従来の HeatPort 有効状態を既定動作として維持し、既存利用への影響を抑えるため。

## 残作業

- OpenModelica (`omc`) がこの環境で見つからなかったため、実機環境でモデルのロード・変換確認を行う。

---

## 追記: DynamicPipeSegment の断面形状パラメータ

### 議題

- `DynamicPipeSegment` で配管形状を選択し、形状ごとの寸法から断面積と等価直径を決定できるようにする。

### 決定事項

- `PipeGeometry` 列挙型に `Rectangular`、`Circular`、`Annular` を定義した。
- 「円環」は通常の円管、「中空円環」は同心二重円管の環状流路として実装した。
- 矩形管は長辺・短辺、円管は内径、環状流路は外側内径・内側外径を入力する。
- 断面積、濡れ縁長さ、等価直径（水力直径）、セグメント容積を形状寸法から自動計算する。
- `DynamicPipe` の内部セグメントは、従来の `L` と `D` を用いた円管として構成する。

### 変更ファイル

- `modelica/EAST/TwoPhaseFlow/Component/Pipes/PipeGeometry.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pipes/DynamicPipeSegment.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pipes/DynamicPipe.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pipes/package.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pipes/package.order`
- `modelica/EAST/TwoPhaseFlow/Examples/Pipes/TestPipeWithSource.mo`
- `docs/codex/2026-06-24_chat_and_update.md`

### 変更理由

- 圧力損失や熱伝達相関式で必要となる流路断面積と代表直径を、実際の断面形状から一貫して得るため。

### 残作業

- OpenModelica で列挙型に応じた Dialog の有効化、モデルのロード・変換を確認する。

---

## 追記: DynamicPipeSegment の管摩擦圧力損失

### 議題

- 流速、Reynolds 数、層流/乱流判定、Blasius 式を用いて圧力損失を内部計算する。

### 決定事項

- 固定パラメータだった `dp` を計算結果へ変更した。
- 断面平均流速は質量流量、代表密度、流路断面積から計算する。
- Reynolds 数は等価直径と代表粘性係数から計算する。
- `Re < ReynoldsTransition` では Darcy 摩擦係数 `64/Re`、それ以上では
  Blasius 式 `0.3164/Re^0.25` を使用する。
- Darcy-Weisbach 式で圧力損失を計算し、逆流時には符号を反転する。
- 媒体側に粘性係数 API が未実装のため、代表粘性係数は `mu` パラメータで与え、
  動粘性係数 `nu = mu/rho` を内部計算する。
- `DynamicPipe` は全内部セグメントへ粘度と遷移 Reynolds 数を渡し、
  管全体の `dp` を両端圧力差として公開する。

### 変更ファイル

- `modelica/EAST/TwoPhaseFlow/Component/Pipes/DynamicPipeSegment.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pipes/DynamicPipe.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pipes/package.mo`
- `docs/codex/2026-06-24_chat_and_update.md`

### 制限事項・残作業

- Blasius 式は滑らかな単相管内流を想定しており、粗さおよび二相流圧損補正は未実装。
- `modelica/ModelicaProjects/EPv2CoolingSystem.mo` には旧 `V`・固定 `dp` 修飾が残る。
  意図する形状・流動条件を確認してから移行する。
- OpenModelica でロード・変換とゼロ流量付近の数値挙動を確認する。

---

## 追記: 粘性係数と動粘性係数の命名統一

### 議題

- EAST パッケージ内で、粘性に関する呼称、記号、単位を統一する。

### 決定事項

- Pa·s 単位の物理量を「粘性係数」、記号・識別子を `mu`（μ）とする。
- m²/s 単位の物理量を「動粘性係数」、記号・識別子を `nu`（ν）とする。
- 動粘性係数は `nu = mu/rho` として管理する。
- Reynolds 数は `Re = |velocity| * characteristicLength / nu` で表記する。

### 変更ファイル

- `modelica/EAST/TwoPhaseFlow/Media/Interfaces/PartialTwoPhaseMedium.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pipes/DynamicPipeSegment.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pipes/DynamicPipe.mo`
- `modelica/EAST/Thermal/HeatTransfer/Components/Convection.mo`
- `docs/codex/2026-06-24_chat_and_update.md`

### 変更理由

- 「動的粘度」と「動粘度」の混同を避け、プロジェクト内の日本語呼称と記号を明確にするため。

### 残作業

- OpenModelica で型、単位、モデル変換を確認する。

---

## 追記: Colebrook-White 圧損相関式

### 議題

- `DynamicPipeSegment` の乱流摩擦係数として Colebrook-White 式を選択可能にする。

### 決定事項

- `FrictionCorrelation` 列挙型に `Blasius` と `Colebrook` を定義した。
- 既定値は従来互換の `Blasius` とした。
- 層流域は選択にかかわらず Darcy 摩擦係数 `64/Re` を使用する。
- Colebrook 選択時は絶対粗さ `roughness` と等価直径から相対粗さを計算する。
- Colebrook-White の陰関数は固定点反復を 10 回行う純関数
  `colebrookFrictionFactor` で解く。
- `DynamicPipe` から全内部セグメントへ相関式と粗さを伝播する。

### 変更ファイル

- `modelica/EAST/TwoPhaseFlow/Component/Pipes/FrictionCorrelation.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pipes/colebrookFrictionFactor.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pipes/DynamicPipeSegment.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pipes/DynamicPipe.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pipes/package.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pipes/package.order`
- `docs/codex/2026-06-24_chat_and_update.md`

### 残作業

- OpenModelica で列挙型 Dialog、関数評価、モデル変換を確認する。

---

## 追記: 媒体の固定代表粘性係数

### 議題

- 媒体パッケージで代表粘性係数を固定値として設定し、配管モデルの既定値に使用する。

### 決定事項

- `PartialTwoPhaseMedium` に抽象定数 `mu_const` を追加した。
- `BaseProperties` に `mu = mu_const` と `nu = mu/d` を追加した。
- LCH の `mu_const` は 101325 Pa の飽和液メタンを基準とする代表値
  `1.17e-4 Pa·s` とした。
- `DynamicPipe` と `DynamicPipeSegment` の `mu` 既定値を `Medium.mu_const` とした。
- Python CoolProp パイプラインで `mu_liquid` を定数スニペットへ出力できるようにした。
- `coolprop_utils.py` の CoolProp 識別子 `V` の説明を「粘性係数」へ修正した。

### 変更ファイル

- `modelica/EAST/TwoPhaseFlow/Media/Interfaces/PartialTwoPhaseMedium.mo`
- `modelica/EAST/TwoPhaseFlow/Media/LCH/package.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pipes/DynamicPipe.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pipes/DynamicPipeSegment.mo`
- `py/coolprop_utils.py`
- `py/methane/constants.py`
- `docs/codex/2026-06-24_chat_and_update.md`

### 残作業

- Python/CoolProp が利用可能な環境で代表値を再生成し、桁数を確認する。
- OpenModelica で媒体定数の再宣言とモデル変換を確認する。

---

## 追記: パラメータ説明文の単位表記削除

### 議題

- パラメータ設定 UI の単位欄と説明文で単位表示が重複する問題を解消する。

### 決定事項

- `EAST` パッケージ全体の `parameter` / `constant` 宣言を精査した。
- 説明文字列中の `[m]`、`[Pa]`、`[J/kg]` などの単位部分だけを削除した。
- SI 型、`unit` / `displayUnit` アノテーション、配列次元、Documentation 内の単位説明は維持した。
- 基準条件を表す `(101325 Pa)` などは単位欄の重複ではないため維持した。
- 今後もパラメータ・定数の説明文字列には単位を記載しないルールを
  `AGENTS.md` と `CLAUDE.md` に追加した。

### 変更ファイル

- `modelica/EAST/` 配下の該当 Modelica ファイル 19 件
- `py/methane/constants.py`
- `py/methane/saturation_table.py`
- `AGENTS.md`
- `CLAUDE.md`
- `docs/codex/2026-06-24_chat_and_update.md`

### 残作業

- OpenModelica のパラメータ設定 UI で、説明文と単位欄が重複しないことを確認する。

---

## 追記: DynamicPipeSegment の内部熱伝達計算

### 議題

- HeatPort の `Q_flow` を外部から直接受け取るのではなく、HeatPort 温度と流体温度から計算する。

### 決定事項

- `heatTransferCoefficient` と `heatTransferArea` を追加した。
- `heatTransferArea` の既定値は `wettedPerimeter * length` とした。
- 熱流量は
  `Q_flow = heatTransferCoefficient * heatTransferArea * (heatPort.T - props.T)`
  で計算する。
- 正の `Q_flow` は HeatPort から流体への加熱を表す。
- 従来の `heatPort.T = props.T` は温度差をゼロにするため削除した。
- `DynamicPipe` では管全体の伝熱面積を各セグメントへ均等分配する。

### 変更ファイル

- `modelica/EAST/TwoPhaseFlow/Component/Pipes/DynamicPipeSegment.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pipes/DynamicPipe.mo`
- `docs/codex/2026-06-24_chat_and_update.md`

### 残作業

- OpenModelica で HeatPort 接続時の符号、モデル変換、シミュレーションを確認する。

---

## 追記: Reynolds 数からの熱伝達率計算

### 議題

- 固定熱伝達率ではなく、Reynolds 数と Nusselt 数相関式から熱伝達率を計算する。

### 決定事項

- `pipeNusseltNumber` 関数を追加した。
- 層流域では `Nu = 3.66` を使用する。
- 乱流域では Dittus-Boelter 式 `Nu = 0.023 Re^0.8 Pr^n` を使用する。
- Prandtl 数は `Pr = cp*mu/lambda` で計算する。
- 熱伝達率は `alpha = Nu*lambda/equivalentDiameter` で計算する。
- 代表定圧比熱 `cp`、代表熱伝導率 `lambda`、乱流式の指数 `n` を
  上書き可能なパラメータとして追加した。
- 固定パラメータ `heatTransferCoefficient` は削除した。

### 変更ファイル

- `modelica/EAST/TwoPhaseFlow/Component/Pipes/pipeNusseltNumber.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pipes/DynamicPipeSegment.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pipes/DynamicPipe.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pipes/package.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pipes/package.order`
- `docs/codex/2026-06-24_chat_and_update.md`

### 残作業

- OpenModelica で関数評価、単位整合、モデル変換を確認する。

---

## 追記: DynamicPipe のジオメトリ同期

### 議題

- `DynamicPipe` を更新後の `DynamicPipeSegment` と同じジオメトリ体系へ揃える。
- `ReynoldsTransition` をパラメータ UI に表示しない。

### 決定事項

- `DynamicPipeSegment.ReynoldsTransition` を `final parameter = 2300` とした。
- `DynamicPipe` の旧 `L` / `D` パラメータを廃止した。
- `DynamicPipe` に `geometry`、`length` と形状別断面寸法を追加した。
- 断面積、濡れ縁長さ、等価直径、管内総容積を
  `DynamicPipeSegment` と同じ式で計算する。
- 全内部セグメントで断面形状・寸法を共通化し、長さだけ
  `length/nNodes` に分割する。
- 伝熱面積の既定値を `wettedPerimeter*length` とした。

### 変更ファイル

- `modelica/EAST/TwoPhaseFlow/Component/Pipes/DynamicPipeSegment.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pipes/DynamicPipe.mo`
- `docs/codex/2026-06-24_chat_and_update.md`

### 残作業

- OpenModelica で形状別 Dialog 表示、final parameter の非表示、モデル変換を確認する。

---

## 追記: 代表熱伝導率の媒体定数化

### 議題

- 熱伝達計算用の代表比熱と代表熱伝導率を配管モデルのパラメータ UI から外し、媒体側で管理する。

### 決定事項

- 代表定圧比熱は既存の `cp_liquid_const` を使用する。
- `PartialTwoPhaseMedium` に固定代表値 `lambda_const` を追加した。
- `BaseProperties` から `cp` と `lambda` を参照できるようにした。
- LCH の `lambda_const` は、101325 Pa の飽和液メタンの代表値として `0.187` を設定した。
- `DynamicPipe` と `DynamicPipeSegment` から `cp` / `lambda` パラメータを削除した。
- Nusselt 数と熱伝達率の計算では `Medium.cp_liquid_const` と
  `Medium.lambda_const` を直接使用する。
- CoolProp 定数生成処理にも `lambda_const` の出力を追加した。

### 変更ファイル

- `modelica/EAST/TwoPhaseFlow/Media/Interfaces/PartialTwoPhaseMedium.mo`
- `modelica/EAST/TwoPhaseFlow/Media/LCH/package.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pipes/DynamicPipeSegment.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pipes/DynamicPipe.mo`
- `py/coolprop_utils.py`
- `py/methane/constants.py`
- `docs/codex/2026-06-24_chat_and_update.md`

### 残作業

- OpenModelica でモデル変換とパラメータ UI を確認する。

---

## 追記: ValveLinear の Cv パラメータ化

### 議題

- `ValveLinear` の容量を公称流量・公称圧力差ではなく Cv 流量係数で指定する。

### 決定事項

- `m_flow_nominal`、`dp_nominal`、旧線形係数 `Kv` を削除した。
- 米国式 Cv 流量係数を入力するパラメータ `Cv` を追加した。
- 内部 SI 流量係数は `Av = Cv*24.0e-6` で換算する。
- 質量流量は `opening*Av*sqrt(rho_upstream*abs(dp))*sign(dp)` で計算する。
- 上流密度は圧力差の符号に応じて入口側または出口側の媒体状態から取得する。
- 開度に対する流量係数の変化は従来どおり線形とする。

### 変更ファイル

- `modelica/EAST/TwoPhaseFlow/Component/Valves/ValveLinear.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Valves/package.mo`
- `docs/codex/2026-06-24_chat_and_update.md`

### 残作業

- OpenModelica でモデル変換と正流・逆流時の挙動を確認する。

---

## 追記: Pumps パッケージと簡易 Pump モデル

### 議題

- `EAST.TwoPhaseFlow.Component` 配下にポンプモデルを追加する。

### 決定事項

- `Component.Pumps` パッケージを新設した。
- `Pump` は固定値または外部入力で揚程を指定する簡易モデルとした。
- 圧力上昇は `dp = inletDensity*g*head` で計算する。
- 一定効率を仮定し、消費動力を `m_flow*g*head/efficiency` で計算する。
- 吐出比エンタルピーにはポンプ比仕事 `g*head/efficiency` を加える。
- 流れ方向は吸込側から吐出側のみに制限する。
- 詳細な流量―揚程曲線、回転数、NPSH、二相流性能補正は初期実装の対象外とした。

### 変更ファイル

- `modelica/EAST/TwoPhaseFlow/Component/Pumps/package.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pumps/package.order`
- `modelica/EAST/TwoPhaseFlow/Component/Pumps/Pump.mo`
- `modelica/EAST/TwoPhaseFlow/Component/package.mo`
- `modelica/EAST/TwoPhaseFlow/Component/package.order`
- `docs/codex/2026-06-24_chat_and_update.md`

### 残作業

- OpenModelica でモデル変換、揚程入力切替、エネルギー収支を確認する。

---

## 追記: Pump の定格 PQ 特性と回転数相似則

### 議題

- 定格回転数での PQ 特性をテーブル入力し、任意回転数での揚程を相似則から計算する。

### 決定事項

- 固定揚程および揚程入力を削除した。
- 定格回転数 `nominalSpeed` と定格 PQ テーブル `nominalPQ` を追加した。
- `nominalPQ` の第 1 列を体積流量、第 2 列を揚程とした。
- 回転数は `speed_rpm` 入力コネクタから与える。
- 実体積流量を `volumeFlowRate/speedRatio` により定格回転数相当へ換算する。
- 定格揚程を線形補間し、`head = nominalHead*speedRatio^2` で実揚程へ換算する。
- テーブル範囲外では端点値を保持する。
- 回転数がゼロ以下の場合は揚程をゼロとする。

### 変更ファイル

- `modelica/EAST/TwoPhaseFlow/Component/Pumps/Pump.mo`
- `modelica/EAST/TwoPhaseFlow/Component/Pumps/package.mo`
- `docs/codex/2026-06-24_chat_and_update.md`

### 残作業

- OpenModelica でテーブル補間、回転数入力、相似則計算を確認する。

---

## 追記: Pump の回転軸フランジ対応

### 議題

- 回転数の RealInput を回転機械フランジへ変更し、`Modelica.Mechanics` と接続可能にする。

### 決定事項

- `speed_rpm` の `RealInput` コネクタを削除した。
- `Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft` を追加した。
- `der(shaft.phi)` から軸角速度を求め、rpm へ換算して相似則に使用する。
- 消費動力と角速度から軸トルクを計算し、`shaft.tau` へ返す。
- 停止時および逆回転時は揚程と軸トルクをゼロとする。

### 変更ファイル

- `modelica/EAST/TwoPhaseFlow/Component/Pumps/Pump.mo`
- `docs/codex/2026-06-24_chat_and_update.md`

### 残作業

- OpenModelica で回転速度源・慣性・モータとの接続とトルク符号を確認する。

---

## 追記: Pump PQ テーブルの列定義

- `Pump` のDocumentationに `nominalPQ` の列定義と単位を追記した。
- 第1列は定格回転数における体積流量 Q（m³/s）、第2列は揚程 H（m）とした。
- 既定テーブルの読み方を具体例として記載した。
