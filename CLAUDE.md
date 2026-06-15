# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

**<project_name>** — Modelica 言語で書かれた汎用混相流ライブラリ。

アーキテクチャは OpenModelica Standard Library (MSL) の Media/Fluid 分担に倣う。

| パッケージ    | 担当範囲                                                         |
|---------------|------------------------------------------------------------------|
| `<project_name>.Media` | 状態方程式、熱力学・輸送物性、相平衡計算                         |
| `<project_name>.Fluid` | 圧力損失、外部コンポーネントとの熱・仕事交換、流体コンポーネント |

## ディレクトリ構成

```text
<project_name>/
├── TwoPhaseMedia/          # Modelica ライブラリ本体
│   ├── Interfaces/         # 抽象基底クラス群
│   ├── Common/             # 共通ユーティリティ（将来）
│   ├── LCH/                # 液体メタン (CH4) 実装
│   ├── TwoPhaseComponent/  # 流体コンポーネント（管・熱交換器等）
│   └── Examples/           # 使用例
└── python/                 # CoolProp 物性抽出スクリプト
    ├── coolprop_utils.py   # CoolProp 汎用ラッパー
    ├── methane/            # メタン固有スクリプト
    │   ├── saturation.py   # 飽和曲線データ抽出
    │   ├── properties.py   # 単相・二相物性グリッド抽出
    │   └── export.py       # CSV / Modelica テーブル形式出力
    └── output/             # 生成データ出力先 (git 管理外)
```

## Python 物性抽出パイプライン

**依存ライブラリのインストール:**

```bash
pip install -r python/requirements.txt
```

**実行方法（python/ ディレクトリから）:**

```bash
# 飽和曲線データを CSV に出力
python methane/saturation.py

# 単相物性の動作確認
python methane/properties.py

# CSV + Modelica テーブルスニペットを一括生成
python methane/export.py
```

出力ファイルは `python/output/` に保存される。

## パッケージ構成

### <project_name>.Media

熱物性計算をすべて担う。`Modelica.Media` の構造に倣う。

- **基底クラス** (`Media.Interfaces`) — 具体的な流体が実装すべき物性関数シグネチャを定義する partial モデル群（密度・エンタルピー・エントロピー・輸送物性・相平衡）
- **相平衡** — 泡点/露点計算、二相状態のフラッシュ計算 (PT/PH/PS)、クオリティ `x` およびボイド率 `α`
- **フェーズ別物性** — 液相・気相それぞれの物性レコード（将来の二流体モデル対応を意識した設計）
- **具体的流体** — 水/蒸気、冷媒、混合気体などの実装

MSL との主な相違点: MSL の `PartialMedium` はコネクタを単相または擬似単相で扱う前提がある。真の混相対応には `ThermodynamicState` レコードに相分率情報を持たせる必要がある。

### <project_name>.Fluid

`<project_name>.Media` で定義した流体を使う流動系を担う。`Modelica.Fluid` の構造に倣う。

- **Interfaces** — コネクタ定義（圧力・比エンタルピー・質量流量をフェーズ別に持つポート）
- **圧力損失** — 二相流相関式（Lockhart-Martinelli、Friedel、Chisholm 等）
- **熱伝達** — 沸騰（核沸騰/膜沸騰）・凝縮相関式
- **コンポーネント** — 管、熱交換器、気液分離器、フラッシュタンク、バルブ、ジャンクション

## モデリング深度（未決定事項）

多相流モデルの選択はコネクタと基底クラスの設計に直結する。3 段階がある。

1. **均質平衡モデル (HEM)** — 単一混合流速、局所熱力学的平衡。最もシンプルで MSL Fluid に最も近い。
2. **ドリフトフラックスモデル** — 混合量の運動量方程式 + フェーズ間スリップ相関。中程度の複雑さ。
3. **二流体モデル** — フェーズごとに独立した質量・運動量・エネルギー方程式。最も汎用的だがコネクタがフェーズ別になる。

初期実装は HEM から始め、インターフェースはドリフトフラックスへの拡張で破壊的変更が生じないよう設計する方針。

## TwoPhaseMedia 設計方針

### 抽象基底クラスと具体的流体の役割分担

#### 設計原則: アルゴリズムは基底クラス、値は具体的流体（MSL とは異なる独自方針）

`Interfaces.PartialTwoPhaseMedium` と具体的流体パッケージ（`LCH` 等）の間で、
実装内容を厳密に分担する。

| 担当 | 内容 |
| --- | --- |
| `PartialTwoPhaseMedium` | 型エイリアス、`BaseProperties` の熱力学方程式、**すべての計算ロジック**（`algorithm` セクション）、流体固有データの抽象定数宣言 |
| 具体的流体（`LCH` 等） | **物質定数・物性テーブルの値のみ**（`algorithm` セクションを一切持たない） |

MSL の `replaceable function` / `redeclare function extends` パターンは採用しない。
`redeclare function extends` は基底の `algorithm` セクションを継承した上でさらに追加するため、
「1 つの関数に algorithm セクションが 2 つある」コンパイルエラーを引き起こす。

**具体的流体が提供すべき抽象定数（`PartialTwoPhaseMedium` で値なし宣言）:**

| 定数 | 役割 |
| --- | --- |
| `MM_const` | モル質量 [kg/mol] |
| `sat_n` | 飽和テーブル点数 |
| `sat_p[sat_n]` | 飽和圧力グリッド [Pa] |
| `sat_T[sat_n]` | 飽和温度 [K] |
| `sat_h_bubble[sat_n]` | 飽和液比エンタルピー [J/kg] |
| `sat_h_dew[sat_n]` | 飽和蒸気比エンタルピー [J/kg] |
| `sat_d_bubble[sat_n]` | 飽和液密度 [kg/m³] |
| `sat_d_dew[sat_n]` | 飽和蒸気密度 [kg/m³] |

新しい物性テーブル（例: 単相 2D テーブル）を追加する場合も同じパターンに従う。
抽象定数を `PartialTwoPhaseMedium` に宣言し、補間ロジックも同クラスに実装する。
具体的流体は定数に値を与えるだけでよい。

**`BaseProperties` に記述する普遍的な方程式（`PartialTwoPhaseMedium` 側）:**

- `u = h - p / d` — 比内部エネルギーの熱力学恒等式
- `R_s = Modelica.Constants.R / MM` — 比気体定数

**具体的流体は `BaseProperties` の `redeclare` 不要。** 抽象定数に値を与えるだけでよい。

### MSL 依存方針

- `Modelica.Media.Interfaces` への `extends` は使わない（MSL 非依存設計）
- `Modelica.Units.SI` の型エイリアスおよび `Modelica.Constants.R` は引き続き使用する
- MSL コンポーネントとの接続が必要になった場合は、ラッパーを別途作成する

## セッション記録ルール（グランドルール）

セッション中に設計判断・実装変更・議論があった場合、**必ず以下のファイルに記録する。**

- パス: `docs/claude/YYYY-MM-DD_chat_and_update.md`（当日の日付）
- 同日に複数セッションがあった場合は同じファイルに追記する
- 記録すべき内容: 議題・設計方針の決定・変更ファイルと変更理由・未完了事項

## ファイル構成ルール（グランドルール）

Modelica の `model`、`record`、`connector`、`function`、`block` は **1 エンティティ = 1 ファイル** とする。

- ファイル名はエンティティ名と完全一致させる（例: `TestFluidProperties.mo`）
- `package.mo` にはパッケージ宣言と `annotation` のみを記述し、子エンティティを埋め込まない
- `package.order` にサブパッケージ・エンティティの順序を記述する
- 複数のエンティティを `package.mo` にまとめることは禁止

## 命名規則

MSL の慣習に従う。

- パッケージ名: `UpperCamelCase`
- 変数名: `lowerCamelCase`
- 定数・パラメータ: `lowerCamelCase`（単位アノテーション必須）
- すべての物理量に SI 単位アノテーション (`unit="..."` または `final unit=...`) を付ける
