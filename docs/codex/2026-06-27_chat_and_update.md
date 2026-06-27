# 2026-06-27 chat and update

## Modelica Tips の配列リテラル記法追記

### 議題

- `CombiTable1Ds`などの`table`へ与える2次元テーブル記法について、
  `[0, 0; 1, 1]`と`{0, 0; 1, 1}`の違いを明文化する。

### 決定事項

- 行列リテラルには角括弧`[]`を使用する。
- 波括弧`{}`はベクトルや配列コンストラクタ用であり、
  2次元配列として使う場合は`{{0, 0}, {1, 1}}`のように入れ子で書く。
- `CombiTable1Ds`や`CombiTimeTable`の`table`には、
  MSLの例と同じ`[0, 0; 1, 1; 2, 2]`形式を推奨する。

### 変更ファイル

- `docs/MODELICA_TIPS.md`
- `docs/codex/2026-06-27_chat_and_update.md`

### 変更理由

- Modelicaの行列リテラルと配列コンストラクタの記法差による
  テーブル指定エラーを避けるため。

### 残作業

- なし。

---

## UnitConvert の温度変換ブロック追加

### 議題

- `EAST.Blocks.UnitConvert`にdegCとKの相互変換ブロックを追加する。

### 決定事項

- `DegCToK`を追加し、`Modelica.Units.Conversions.from_degC`でdegCからKへ変換する。
- `KToDegC`を追加し、`Modelica.Units.Conversions.to_degC`でKからdegCへ変換する。
- 既存の`RpmToRad` / `RadToRpm`と同じく、
  `Modelica.Blocks.Interfaces.PartialConversionBlock`を継承する。

### 変更ファイル

- `modelica/EAST/Blocks/UnitConvert/DegCToK.mo`
- `modelica/EAST/Blocks/UnitConvert/KToDegC.mo`
- `modelica/EAST/Blocks/UnitConvert/package.order`
- `docs/codex/2026-06-27_chat_and_update.md`

### 変更理由

- ブロック図上で温度信号をdegC表示系とK内部計算系の間で明示的に変換できるようにするため。

### 残作業

- OpenModelicaでロードおよび変換確認を行う。

---

## DynamicPipeSegment の状態変数スケーリング追加

### 議題

- OpenModelicaの非線形連立収束エラーで、
  `DynamicPipeSegment.h(start=..., nominal=1)`が表示されていた。

### 決定事項

- `DynamicPipeSegment`のCV内圧力`p`へ`nominal = 1.0e5`を追加する。
- CV内比エンタルピー`h`へ`nominal = 1.0e5`を追加する。
- `start`は従来どおり`p_start` / `h_start`を使用する。

### 変更ファイル

- `modelica/EAST/TwoPhaseFlow/Component/Pipes/DynamicPipeSegment.mo`
- `docs/codex/2026-06-27_chat_and_update.md`

### 変更理由

- 圧力と比エンタルピーの代表スケールを数値ソルバへ明示し、
  Newton反復のスケーリングを改善するため。

### 残作業

- OpenModelicaで該当モデルを再シミュレーションし、
  非線形連立の収束状況を確認する。
