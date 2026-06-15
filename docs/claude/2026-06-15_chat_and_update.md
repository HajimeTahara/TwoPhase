# 2026-06-15 セッション記録

## 議題・作業内容

### 1. コンパイルエラーの修正

**エラー内容:**
```
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

## 現在の実装状況

### 完了
- 二相域の全演算（密度・温度・乾き度・ボイド率）
- 飽和物性テーブル補間（100 点、対数圧力グリッド）
- `BaseProperties`（p, h → d, T, u, R_s, phase）
- `Examples.TestFluidProperties`、`Examples.TestVoidFraction`

### 未完了（次のステップ）
- 単相物性 2D テーブルの生成（`python/methane/export.py` を拡張）
- `densitySinglePhase(p, h)` および `temperatureSinglePhase(p, h)` の実装
  - 実装パターン: 単相 (p, h) グリッドの抽象定数を基底クラスに宣言 → 補間ロジックも基底クラスに実装 → LCH はデータのみ提供
