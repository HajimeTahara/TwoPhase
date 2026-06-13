# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

**cEAST** — Modelica 言語で書かれた汎用混相流ライブラリ。

アーキテクチャは OpenModelica Standard Library (MSL) の Media/Fluid 分担に倣う。

| パッケージ    | 担当範囲                                                         |
|---------------|------------------------------------------------------------------|
| `cEAST.Media` | 状態方程式、熱力学・輸送物性、相平衡計算                         |
| `cEAST.Fluid` | 圧力損失、外部コンポーネントとの熱・仕事交換、流体コンポーネント |

## ディレクトリ構成

```text
cEAST/
├── TwoPhaseMedia/          # Modelica ライブラリ本体
│   ├── Interfaces/         # 抽象基底クラス群
│   ├── Common/             # 共通ユーティリティ（将来）
│   └── LCH/                # 液体メタン (CH4) 実装
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

### cEAST.Media

熱物性計算をすべて担う。`Modelica.Media` の構造に倣う。

- **基底クラス** (`Media.Interfaces`) — 具体的な流体が実装すべき物性関数シグネチャを定義する partial モデル群（密度・エンタルピー・エントロピー・輸送物性・相平衡）
- **相平衡** — 泡点/露点計算、二相状態のフラッシュ計算 (PT/PH/PS)、クオリティ `x` およびボイド率 `α`
- **フェーズ別物性** — 液相・気相それぞれの物性レコード（将来の二流体モデル対応を意識した設計）
- **具体的流体** — 水/蒸気、冷媒、混合気体などの実装

MSL との主な相違点: MSL の `PartialMedium` はコネクタを単相または擬似単相で扱う前提がある。真の混相対応には `ThermodynamicState` レコードに相分率情報を持たせる必要がある。

### cEAST.Fluid

`cEAST.Media` で定義した流体を使う流動系を担う。`Modelica.Fluid` の構造に倣う。

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

`Interfaces.PartialTwoPhaseMedium` と具体的流体パッケージ（`LCH` 等）の間で、
実装内容を明確に分担する。

| 担当 | 内容 |
| --- | --- |
| `PartialTwoPhaseMedium` | 型エイリアス、`BaseProperties` の普遍的な熱力学方程式、`replaceable` 関数のインターフェース定義 |
| 具体的流体（`LCH` 等） | 物質定数、物性テーブル、`replaceable` 関数の実装のみ |

**`BaseProperties` に記述する普遍的な方程式（`PartialTwoPhaseMedium` 側）:**

- `u = h - p / d` — 比内部エネルギーの熱力学恒等式
- `R_s = Modelica.Constants.R / MM` — 比気体定数

**具体的流体が実装すべき `replaceable` 関数:**

| 関数 | 役割 |
| --- | --- |
| `setState_ph(p, h)` | p, h → 熱力学状態（主要ルックアップ、物性テーブル使用） |
| `density(state)` | state → 密度 |
| `temperature(state)` | state → 温度 |
| `phaseOf(state)` | state → 相状態 (1=単相, 2=二相) |
| `molarMass(state)` | state → モル質量（純物質では定数） |
| `pressure(state)` | state → 圧力（通常は state.p を返すだけ） |
| `vapourQuality(state)` | state → 乾き度 x |
| `setSat_p(p)` | p → 飽和物性（飽和曲線テーブル使用） |
| `bubbleDensity/dewDensity(sat)` | sat → 飽和密度 |
| `bubbleEnthalpy/dewEnthalpy(sat)` | sat → 飽和エンタルピー |

**具体的流体は `BaseProperties` の `redeclare` 不要。** `replaceable` 関数を実装するだけでよい。

### MSL 依存方針

- `Modelica.Media.Interfaces` への `extends` は使わない（MSL 非依存設計）
- `Modelica.Units.SI` の型エイリアスおよび `Modelica.Constants.R` は引き続き使用する
- MSL コンポーネントとの接続が必要になった場合は、ラッパーを別途作成する

## 命名規則

MSL の慣習に従う。

- パッケージ名: `UpperCamelCase`
- 変数名: `lowerCamelCase`
- 定数・パラメータ: `lowerCamelCase`（単位アノテーション必須）
- すべての物理量に SI 単位アノテーション (`unit="..."` または `final unit=...`) を付ける
