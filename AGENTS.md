# AGENTS.md

このファイルは、このリポジトリで作業する Codex などの coding agent 向けの作業指針です。

## プロジェクト概要

**<project_name>** は、Modelica で書かれた汎用気液二相流ライブラリです。

アーキテクチャは OpenModelica Standard Library (MSL) の Media/Fluid 分担に倣います。

| パッケージ | 担当範囲 |
| --- | --- |
| `TwoPhaseFlow.Media` | 状態方程式、熱力学・輸送物性、相平衡計算 |
| `TwoPhaseFlow.Component` | 管、ソース、シンク、タンク、バルブなどの流体コンポーネント |

プロジェクト名はまだ未確定です。正式な製品名・プロジェクト名が必要なドキュメントでは `<project_name>` を使ってください。

## リポジトリ構成

```text
modelica/
└── EAST/
    ├── package.mo
    ├── TwoPhaseFlow/
    │   ├── Media/
    │   ├── Component/
    │   └── Examples/
    └── Thermal/
        ├── Material/
        ├── HeatTransfer/
        └── FluidHeatFlow/

python/
├── coolprop_utils.py
├── methane/
└── output/

docs/
├── claude/
└── codex/
```

## 設計ルール

- Modelica の `model`、`record`、`connector`、`function`、`block` は 1 エンティティ = 1 ファイルとします。
- ファイル名はエンティティ名と完全一致させます。
- `package.mo` にはパッケージ宣言と annotation のみを置きます。
- パッケージは原則としてディレクトリと `package.mo` の組で構成します。
- Modelica エンティティの追加・削除・並べ替えを行う場合は、対応する `package.order` も更新します。
- 命名規則は MSL に合わせます。パッケージは `UpperCamelCase`、変数・定数・パラメータは `lowerCamelCase` とします。
- 物理量には SI 単位アノテーションを付けます。

## Thermal パッケージ方針

- `EAST.TwoPhaseFlow` は既存の二相流ライブラリとして扱い、Thermal 系の改造作業では原則として変更しません。
- MSL の `Modelica.Thermal` を参考にしつつ、`EAST.Thermal` パッケージとして管理します。
- Thermal 配下のモデルも 1 model = 1 `.mo` ファイルで管理します。
- 材料物性は `EAST.Thermal.Material` 配下の record として定義し、コンポーネント側は material record をパラメータとして受け取ります。
- MSL 由来の構成・名前を参考にする場合でも、実装はこのリポジトリの指示と設計方針に合わせて追加します。

## 媒体設計

`EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium` が計算ロジックを持ちます。

`EAST.TwoPhaseFlow.Media.LCH` などの具体的媒体パッケージは、物質定数と物性テーブル値だけを提供します。アーキテクチャを意図的に変更する場合を除き、具体的媒体パッケージに `algorithm` セクションを追加しないでください。

新しい物性テーブルを追加する場合は、以下の分担に従います。

- 抽象定数を `PartialTwoPhaseMedium` に宣言する。
- 補間と計算ロジックを `PartialTwoPhaseMedium` に実装する。
- 流体パッケージには具体的な値だけを置く。

## 現在の実装メモ

- 二相域については、密度、温度、乾き度、ボイド率、飽和物性補間が実装済みです。
- 単相域の `densitySinglePhase(p, h)` と `temperatureSinglePhase(p, h)` は現在スタブです。
- 次の有力な作業は、Python/CoolProp パイプラインで単相 2D 物性テーブルを生成し、そのテーブルを `PartialTwoPhaseMedium` に接続することです。

## Python 物性生成パイプライン

依存ライブラリをインストールします。

```bash
pip install -r python/requirements.txt
```

`python/` ディレクトリから実行します。

```bash
python methane/saturation.py
python methane/properties.py
python methane/export.py
```

生成ファイルは `python/output/` に出力されます。

## セッション記録

設計判断、実装変更、未解決事項が発生した場合は、以下に短く追記します。

```text
docs/claude/YYYY-MM-DD_chat_and_update.md
```

記録には、議題、決定事項、変更ファイル、変更理由、残作業を含めます。

Codex が作業する場合は、同じ命名規則で以下に記録します。

```text
docs/codex/YYYY-MM-DD_chat_and_update.md
```
