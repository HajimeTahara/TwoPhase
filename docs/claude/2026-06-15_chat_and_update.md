# 2026-06-15 セッション記録

## 議題・作業内容

### 1. コンパイルエラーの修正

**エラー内容:**

```text
[TwoPhaseMedia.LCH: 179:13-188:15]: Function setSat_p has more than one algorithm section or external declaration.
```

**原因:**
`redeclare function extends` は基底クラスの `algorithm` セクションを継承した上でさらに追加するため、
1 つの関数に `algorithm` セクションが 2 つ存在するエラーが発生した。

### 2. アーキテクチャ設計方針の確立と実装

#### 方針（グランドルールとして CLAUDE.md に記録）

| 担当 | 内容 |
| --- | --- |
| `PartialTwoPhaseMedium` | すべての計算ロジック（`algorithm` セクション） + 抽象定数の宣言 |
| 具体的流体（`LCH` 等） | 物質定数・物性テーブルの値のみ（`algorithm` セクションなし） |

MSL の `replaceable function` / `redeclare function extends` パターンは採用しない。
代わりに、基底クラスで抽象定数（`replaceable constant`、値なし）を宣言し、
補間ロジックも基底クラスに実装する。具体的流体は `redeclare constant` で値を提供するだけでよい。

#### 変更ファイル一覧

**`TwoPhaseMedia/Interfaces/PartialTwoPhaseMedium.mo`**

- `MolarMass MM_const`、`T_critical`、`p_critical`、`d_critical`、`T_triple`、`p_triple`、`T_normal_boiling` を `replaceable constant`（値なし）として宣言追加
- `sat_n`、`sat_p`、`sat_T`、`sat_h_bubble`、`sat_h_dew`、`sat_d_bubble`、`sat_d_dew` を `replaceable constant`（値なし）として宣言追加
- `setSat_p` を `replaceable function` から通常 `function` に変更し、`interpolate1D` を使う補間ロジックを実装
- `molarMass` を `replaceable function` から通常 `function` に変更し、`MM_const` を返す実装に変更
- `densitySinglePhase`、`temperatureSinglePhase` から `replaceable` を削除（スタブのまま、2D テーブル実装待ち）
- `partial model BaseProperties` → `model BaseProperties`（LCH で利用可能にするため）

**`TwoPhaseMedia/LCH/package.mo`**

- `redeclare function extends molarMass` および `redeclare function extends setSat_p` を削除（ロジックは基底クラスへ移動）
- `partial package LCH` → `package LCH`（すべての抽象定数に値が与えられたため）
- 各定数に `redeclare constant` プレフィックスを追加（基底クラスの `replaceable constant` へ値を束縛）

**`CLAUDE.md`**

- アーキテクチャ設計方針（アルゴリズムと値の分離）をグランドルールとして記載
- `docs/claude/` への記録ルールを追記

---

## 追記: TwoPhaseComponent パッケージの新規作成

### 作成ファイル

**`TwoPhaseMedia/TwoPhaseComponent/package.mo`**

#### `FluidPort` コネクタ

```modelica
connector FluidPort
  AbsolutePressure p;
  flow MassFlowRate m_dot;            // 流入正
  stream SpecificEnthalpy h_outflow;  // 流出時エンタルピー
end FluidPort;
```

#### `Pipe` モデル（定常、パラメータ直接指定）

- `dp` [Pa]: 圧力損失（port_a → port_b 方向）
- `Q_flow` [W]: 入熱量（正: 加熱）
- `L`, `D`: 管長・内径（将来の相関式用）

主要方程式:

```text
port_a.m_dot + port_b.m_dot = 0         // 質量保存
port_b.p = port_a.p - dp                // 圧力損失
m_dot * h_out = m_dot * h_in + Q_flow  // エネルギー保存（積形式）
```

エネルギー保存を積形式（`m_dot * Δh = Q_flow`）にすることで `m_dot = 0` の特異点を回避。

`props_a`, `props_b`（`Medium.BaseProperties`）経由で入口・出口の温度・密度・相・飽和物性を参照可能。

逆流時は `port_a.h_outflow = inStream(port_b.h_outflow)` のパススルー近似（簡略化）。

---

## 追記: パッケージ再構成（TwoPhaseComponent → Component）

### 変更内容

**削除:**

- `TwoPhaseMedia/TwoPhaseComponent/package.mo`（ディレクトリごと削除）

**新規作成:**

- `TwoPhaseMedia/Interfaces/FluidPort.mo` — コネクタを Interfaces へ移動
- `TwoPhaseMedia/Component/package.mo` — トップレベルコンポーネントパッケージ
- `TwoPhaseMedia/Component/Pipes/package.mo` — 旧 `Pipe` モデルを移動、ポート参照を `TwoPhaseMedia.Interfaces.FluidPort` に変更
- `TwoPhaseMedia/Component/Tanks/package.mo` — スタブ
- `TwoPhaseMedia/Component/Valves/package.mo` — スタブ
- `TwoPhaseMedia/Component/Sources/package.mo` — スタブ

**更新:**

- `TwoPhaseMedia/Interfaces/package.mo` — FluidPort の説明を追記
- `TwoPhaseMedia/package.mo` — Component パッケージを構成一覧に追記

### 設計方針

MSL の `Modelica.Fluid` に倣い、コネクタ (`FluidPort`) は `Interfaces` にまとめ、
コンポーネント実装は機能別サブパッケージ (`Pipes`, `Tanks`, `Valves`, `Sources`) に分離する。

---

## 追記: パッケージ全体再構成（TwoPhaseMedia → TwoPhaseFlow）

### 再構成内容

トップレベルパッケージ名を `TwoPhaseMedia` → `TwoPhaseFlow` に改名し、
MSL の Media/Fluid 分担に合わせてパッケージ階層を再編。

**ディレクトリ構成（変更後）:**

```text
TwoPhaseFlow/
├── package.mo
├── Media/
│   ├── package.mo
│   ├── Interfaces/
│   │   ├── package.mo
│   │   └── PartialTwoPhaseMedium.mo
│   ├── Common/
│   │   └── package.mo
│   └── LCH/
│       └── package.mo
├── Component/
│   ├── package.mo
│   ├── Interfaces/
│   │   ├── package.mo
│   │   └── FluidPort.mo
│   ├── Pipes/
│   │   └── package.mo
│   ├── Tanks/
│   │   └── package.mo
│   ├── Valves/
│   │   └── package.mo
│   └── Sources/
│       └── package.mo
└── Examples/
    └── package.mo
```

**主な変更点:**

- トップレベルディレクトリ: `TwoPhaseMedia/` → `TwoPhaseFlow/`
- 旧 `Interfaces/` を解体し Media 系・Component 系に分離
  - `PartialTwoPhaseMedium` → `TwoPhaseFlow.Media.Interfaces`
  - `FluidPort` → `TwoPhaseFlow.Component.Interfaces`
- `Common`、`LCH` を `TwoPhaseFlow.Media` 配下に移動
- 全ファイルの `within` 句・絶対パス参照を新パス体系に更新

---

---

## 追記: Examples の分割（1 エンティティ = 1 ファイル方針）

**新規作成:**

- `TwoPhaseFlow/Examples/TestFluidProperties.mo` — `TestFluidProperties` モデルを独立ファイルへ
- `TwoPhaseFlow/Examples/TestVoidFraction.mo` — `TestVoidFraction` モデルを独立ファイルへ

**更新:**

- `TwoPhaseFlow/Examples/package.mo` — モデル定義を削除し、パッケージ宣言と annotation のみに縮小
- `CLAUDE.md` — 「ファイル構成ルール」セクションを追加（1 エンティティ = 1 ファイル）

### 設計方針（グランドルール化）

`model`、`record`、`connector`、`function`、`block` は 1 ファイルに 1 エンティティのみ記述する。
`package.mo` にはパッケージ宣言と annotation のみを置き、子エンティティを埋め込まない。
`package.order` でサブパッケージ・エンティティの順序を管理する。

---

---

## 追記: FluidPort の Medium パラメータ化と FluidPort_a/b の追加

### 背景

Tank 等の他コンポーネントとの接続時に媒体型の整合性チェックができるよう、
MSL の `Modelica.Fluid` に倣って `FluidPort` を `replaceable package Medium` でパラメータ化した。

### 変更ファイル

**更新:**

- `TwoPhaseFlow/Component/Interfaces/FluidPort.mo` — `replaceable package Medium` を追加
- `TwoPhaseFlow/Component/Interfaces/package.mo` — コネクタ一覧を更新
- `TwoPhaseFlow/Component/Pipes/package.mo` — `Pipe` モデルを削除（独立ファイルへ移動）

**新規作成:**

- `TwoPhaseFlow/Component/Interfaces/FluidPort_a.mo` — 入口ポート（塗りつぶし円アイコン）
- `TwoPhaseFlow/Component/Interfaces/FluidPort_b.mo` — 出口ポート（白抜き円アイコン）
- `TwoPhaseFlow/Component/Interfaces/package.order`
- `TwoPhaseFlow/Component/Pipes/Pipe.mo` — `Pipe` モデルを独立ファイルに分離、ポートを `FluidPort_a`/`FluidPort_b` に変更
- `TwoPhaseFlow/Component/Pipes/package.order`

### コネクタ設計方針

- `FluidPort` に `replaceable package Medium = PartialTwoPhaseMedium` を追加し、コネクタが媒体型情報を持つようにした
- コンポーネント（`Pipe` 等）はポート宣言時に `redeclare package Medium = Medium` で媒体型を束縛する
- `FluidPort_a`（塗りつぶし円）= 入口ポート、`FluidPort_b`（白抜き円）= 出口ポート（MSL の慣習と同じ）
- 同じ `Medium` を宣言するコンポーネント同士のみ接続可能（型チェックが機能する）

---

---

## 追記: Sources パッケージ実装（MassFlowSource_h, Boundary_ph）

### 新規作成ファイル

- `TwoPhaseFlow/Component/Sources/MassFlowSource_h.mo` — 質量流量・比エンタルピー固定ソース
- `TwoPhaseFlow/Component/Sources/Boundary_ph.mo` — 圧力・比エンタルピー固定境界
- `TwoPhaseFlow/Component/Sources/package.order`
- `TwoPhaseFlow/Examples/TestPipeWithSource.mo` — ソース→管→境界の接続テスト

**更新:**

- `TwoPhaseFlow/Component/Sources/package.mo` — モデル一覧を追記
- `TwoPhaseFlow/Examples/package.mo`, `package.order` — TestPipeWithSource を追加

### コネクタ接続の設計

| モデル | ポート型 | 接続先 |
| --- | --- | --- |
| `MassFlowSource_h` | `FluidPort_b port` | 下流コンポーネントの `FluidPort_a`（入口） |
| `Boundary_ph` | `FluidPort_b port` | 上流コンポーネントの `FluidPort_a` または下流の `FluidPort_b` |

- MSL と同様にソース・境界モデルは `FluidPort_b` を使う（`FluidPort_a` との接続も `FluidPort_b` 同士の接続も Modelica 的に有効）
- `MassFlowSource_h` は `port.m_dot = -m_dot_set`（流入正規約のため負符号）
- `Boundary_ph` は `port.p = p_set` のみ固定し、質量流量はシステムが決定（ソース/シンク両用）

---

---

## 追記: TestPipeWithSource を物理例題として更新

### 更新ファイル

- `TwoPhaseFlow/Examples/TestPipeWithSource.mo` を全面更新

### 例題の物理設定

| 項目 | 入口 | 出口 |
| --- | --- | --- |
| 圧力 [bar] | 5.0 | 4.9 |
| 比エンタルピー [kJ/kg] | 30 | 130 |
| 相 | 単相（過冷却液） | 二相 |
| 温度 [K] | ≈ 128 | ≈ 135（飽和温度） |
| 乾き度 | — | ≈ 0.10 |

- `source`: m_flow_set = 0.5 kg/s, h_set = 30 kJ/kg（過冷却液入口）
- `pipe`: dp = 10 kPa, Q_flow = 50 kW → Δh = 100 kJ/kg → h_out = 130 kJ/kg（二相域）
- `sink`: p_set = 4.9 bar（下流圧力固定）

観測変数として `T_in`, `d_in`, `phase_in`, `T_out`, `d_out`, `phase_out`, `x_out`, `alpha_out` を宣言し、`BaseProperties` および `Medium` 関数から取得。

---

## 現在の実装状況

### 完了

- 二相域の全演算（密度・温度・乾き度・ボイド率）
- 飽和物性テーブル補間（100 点、対数圧力グリッド）
- `BaseProperties`（p, h → d, T, u, R_s, phase）
- `Examples.TestFluidProperties`、`Examples.TestVoidFraction`
- `Component.Pipes.Pipe` モデル（定常管）
- `Component.Interfaces.FluidPort` コネクタ

### 未完了（次のステップ）

- 単相物性 2D テーブルの生成（`python/methane/export.py` を拡張）
- `densitySinglePhase(p, h)` および `temperatureSinglePhase(p, h)` の実装
  - 実装パターン: 単相 (p, h) グリッドの抽象定数を基底クラスに宣言 → 補間ロジックも基底クラスに実装 → LCH はデータのみ提供

---

## 追記: Markdown 内の旧プロジェクト名表記を置換

### 変更ファイル

- `CLAUDE.md`

### 変更内容

- 未確定の旧プロジェクト名を `<project_name>` に置換
- 対象は Markdown ファイルのみ

---

## 追記: Codex 用ひな型の作成

### 作成ファイル

- `AGENTS.md`
- `.codex/README.md`
- `.codex/config.example.toml`

### 変更内容

- Codex などの coding agent 向けに、プロジェクト概要・Modelica ファイル構成ルール・媒体設計方針・Python 物性生成パイプライン・セッション記録ルールを `AGENTS.md` に整理
- `.codex/` 配下に、将来の Codex 固有メモや設定例を置くためのひな型を追加

---

## 追記: AGENTS.md の日本語化

### 変更ファイル

- `AGENTS.md`

### 変更内容

- Codex などの coding agent 向け作業指針を英語から日本語へ変換
- 内容構成は維持し、プロジェクト概要・設計ルール・媒体設計・物性生成パイプライン・セッション記録ルールを日本語で記述

---

## 追記（2026-06-16）: Icon View へのポート配置と Thermal 担当除外ルール

### 1. Icon View ポート配置の修正

**背景:** `Pipe`、`MassFlowSource_h`、`Boundary_ph` の Icon View にポートが表示されていなかった。
Modelica の GUI ツールはポート変数宣言に `Placement` アノテーションがないとアイコン上にポートを描画しない。

**変更ファイル:**

- `modelica/EAST/TwoPhaseFlow/Component/Pipes/Pipe.mo`
  - `port_a`（FluidPort_a）: 左端 `extent={{-110,-10},{-90,10}}` に Placement 追加
  - `port_b`（FluidPort_b）: 右端 `extent={{90,-10},{110,10}}` に Placement 追加

- `modelica/EAST/TwoPhaseFlow/Component/Sources/MassFlowSource_h.mo`
  - `port`（FluidPort_b）: 右端 `extent={{90,-10},{110,10}}` に Placement 追加

- `modelica/EAST/TwoPhaseFlow/Component/Sources/Boundary_ph.mo`
  - `port`（FluidPort_b）: 右端 `extent={{90,-10},{110,10}}` に Placement 追加

### 2. Thermal パッケージの担当除外ルール（CLAUDE.md 追記）

**内容:** `modelica/EAST/Thermal/` は別チームが担当するため、Claude Code は読み書き禁止。
`CLAUDE.md` の「担当範囲の制限」セクションとしてグランドルールに追記。

---

## 追記（2026-06-16）: TestPipeWithSource を Diagram View で操作可能に

### 変更内容

`modelica/EAST/TwoPhaseFlow/Examples/TestPipeWithSource.mo`

**背景:** コンポーネントインスタンスに `Placement` アノテーションがないため Diagram View に表示されず、GUI からパラメータを設定できなかった。

**変更 1: コンポーネントへの Placement 追加**

| コンポーネント | extent | 備考 |
| --- | --- | --- |
| `source` (MassFlowSource_h) | `{{-90,-15},{-60,15}}` | 左側、中心 (-75, 0) |
| `pipe` (Pipe) | `{{-30,-15},{30,15}}` | 中央、中心 (0, 0) |
| `sink` (Boundary_ph) | `{{90,-15},{60,15}}` | 右側、水平ミラー配置 |

`sink` を x1 > x2 の extent（水平ミラー）にすることで、`port`（FluidPort_b）が視覚的に左側に向き、`pipe.port_b` と正面で接続されるレイアウトにした。

**変更 2: connect に Line アノテーション追加**

- `source.port → pipe.port_a`: `points={{-60,0},{-30,0}}`, blue, thickness=0.5
- `pipe.port_b → sink.port`: `points={{30,0},{60,0}}`, blue, thickness=0.5

---

## 追記（2026-06-16）: densitySinglePhase / temperatureSinglePhase の 0 除算バグ修正

### 現象

`TestPipeWithSource` 実行時に初期化で 0 除算エラー。

```
division by zero at time 0, (a=500000) / (b=0), where divisor b expression is: pipe.props_a.d
```

### 原因

入口条件 (p=5 bar, h=30 kJ/kg) は飽和液比エンタルピー (≈51.8 kJ/kg) より低く、過冷却液（単相）。
`density()` は単相時に `densitySinglePhase(p, h)` を呼ぶが、スタブ実装が `d := 0` を返していた。
`BaseProperties` の `u = h - p / d` で p/0 が発生。

### 修正

`modelica/EAST/TwoPhaseFlow/Media/Interfaces/PartialTwoPhaseMedium.mo`

`densitySinglePhase` と `temperatureSinglePhase` を、飽和テーブルを使う暫定実装に変更：

- `densitySinglePhase`: `h < h_bubble` → `sat.d_bubble`（飽和液密度）、それ以外 → `sat.d_dew`（飽和蒸気密度）
- `temperatureSinglePhase`: `sat.Tsat`（飽和温度）を返す

どちらも `setSat_p(p)` を内部で呼ぶ。値は近似だが非ゼロであり、2D テーブル実装前の暫定として機能する。

---

## 追記（2026-06-16）: PR EOS による densitySinglePhase 実装

### 方針決定

- 単相物性の計算方法として **Peng-Robinson (PR) EOS + NASA 多項式** の方針を採用
- 2D テーブル引きは流体ごとに生成が必要で汎用性が低いため極力使わない
- 段階的に実装: まず PR 密度 → 次に T(p,h) Newton 反復 → 将来 Péneloux 体積補正

### 今回の実装

**`PartialTwoPhaseMedium.mo`**

1. 抽象定数 `omega_const`（離心因子）を追加
2. 関数 `prSolveZ(A, B, liquid)` を追加
   - PR 3次方程式 `Z³-(1-B)Z²+(A-3B²-2B)Z-(AB-B²-B³)=0` の実数根を求める
   - 判別式 D ≥ 0: Cardano 公式（実根1つ）
   - 判別式 D < 0: 三角関数法 `t = m·cos(φ)`（実根3つ）、液相/気相フラグで最小/最大根を選択
3. 関数 `prDensity(p, T, liquid)` を追加: κ → α(T) → a, b → A, B → Z → d
4. `densitySinglePhase(p, h)` を `prDensity(p, sat.Tsat, h < h_bubble)` で実装

**`LCH/package.mo`**

- `omega_const = 0.01142` を追加（NIST WebBook 値）

### 現状の制限

`densitySinglePhase` は T = T_sat（飽和温度）を暫定で使用しているため、実際の T(p,h) を使った値ではない。
PR の機械は完成しているが、T(p,h) Newton 反復を実装するまでは精度面での改善は限定的。
精度改善の順序: ① T(p,h) Newton 反復 → ② NASA 多項式 cp°(T) → ③ Péneloux 体積補正

### 未完了（次のステップ）

- `temperatureSinglePhase`: 現在は sat.Tsat を返す暫定実装
- T(p,h) 反復に必要な h(p, T) 計算: 理想気体項（NASA 7係数多項式）+ PR 離脱関数

---

## 追記（2026-06-16）: CoolProp 物質定数抽出 + PR-EOS ドキュメント整備

### 方針確認

ユーザー指示: 「現段階では単相の密度算出は PR-EOS のみの実装にとどめる。PR-EOS の特徴・物理式・
流体ごとに必要な変数は `PartialTwoPhaseMedium` のドキュメンテーションに記載する」。
NASA 多項式・Péneloux 補正は依然未着手のまま（既定方針通り）。

### 変更ファイル

**`python/coolprop_utils.py`**

- `get_fluid_constants(fluid)` を追加: PR EOS が必要とする `T_critical`, `p_critical`, `MM`, `omega`
  に加え `d_critical`, `T_triple`, `p_triple`, `T_normal_boiling` を一括取得する
- **既存バグ修正**: `get_critical_point` 内の `PropsSI("Rhomass_critical", fluid)` が
  大文字小文字の違いで `ValueError` になっていた（CoolProp の正しいキーは小文字 `rhomass_critical`）。
  動作確認のため実行して発覚、`get_fluid_constants` 側も含めて修正。

**`python/methane/constants.py`**（新規）

- `get_fluid_constants("Methane")` の結果から `LCH/package.mo` 用の `redeclare constant` スニペットを
  生成して `python/output/lch_constants.mo_snippet` に出力するスクリプト
- 実行して動作確認済み（`py methane/constants.py`）。既存の手入力値（`omega_const = 0.01142` 等）は
  CoolProp 取得値と一致することを確認（クロスチェック完了）
- Windows コンソール（cp932）での `kg/m³` 等の出力に備え `sys.stdout.reconfigure(encoding="utf-8")` を追加

**`modelica/EAST/TwoPhaseFlow/Media/Interfaces/PartialTwoPhaseMedium.mo`**

- `Documentation` ブロックに「単相密度モデル: Peng-Robinson (PR) 状態方程式」セクションを追加
  - 状態方程式・a(T)/b/α(T)/κ の式、PR 普遍定数（流体非依存）と流体固有定数（Tc, pc, ω, MM）の区別
  - 圧縮因子 Z の3次方程式と根の選択方法（Cardano / 三角関数法）
  - 精度の既知の限界（液相密度誤差 10～30%、T は暫定的に T_sat を使用している点）を明記
  - 古くなっていた「2次元物性テーブル生成後に追加する」という記述を削除し、PR EOS 実装済みである旨に更新

**`modelica/EAST/TwoPhaseFlow/Media/LCH/package.mo`**

- 同様に、ドキュメント内の「2D テーブル生成後に追加する」という記述を PR EOS 方式に合わせて更新

### 未完了（次のステップ）

- `temperatureSinglePhase` の T(p,h) Newton 反復実装（NASA 多項式 + PR 離脱関数が前提）
- Péneloux 体積補正（液相密度精度改善）
- 実装は引き続き「ひとつずつ変更を追う」方針で進める
