# 2026-06-16 セッション記録

## 議題: Pipe への HeatPort 追加（外部入熱モデル化）

### 要求

- `Pipe` に入熱を模擬するための `HeatPort` を追加したい。
- `HeatPort` は MSL（`Modelica.Thermal.HeatTransfer.Interfaces`）を `extends` せず、
  `TwoPhaseFlow` の Interfaces に独自に再実装してから継承する。
- `Pipe` に `HeatPort` を実装する際は、流体温度を port の温度として使用する。

### 注意事項（ツール使用上のミス）

作業中、`Q_flow`/`Pipe` をキーワードに `Grep` した結果に
`modelica/EAST/Thermal/HeatTransfer/Interfaces/HeatPort.mo`（担当除外ディレクトリ）が
ファイル名のみヒットし、その後の確認コマンドで誤って同ファイルの1行目
（`within EAST.Thermal.HeatTransfer.Interfaces;` という名前空間宣言のみ）を出力してしまった。
実装内容は見ておらず、参照もしていない。以後 `modelica/EAST/Thermal/` 配下には触れない。

### 設計・実装内容

**新規コネクタ（`Component/Interfaces/`）**

- `HeatPort.mo` — 熱ポート基底 (`Temperature T`, `flow HeatFlowRate Q_flow`)。MSL 非依存。
- `HeatPort_a.mo` — `HeatPort` を継承、塗りつぶし矩形アイコン。熱を受け取る側（`Pipe` 等）に使用。
- `HeatPort_b.mo` — `HeatPort` を継承、白抜き矩形アイコン。熱を供給する側（`FixedHeatFlow` 等）に使用。
- `package.mo` / `package.order` を更新し、上記3エンティティを追加。

**新規パッケージ `Component/HeatSources/`**

- `FixedHeatFlow.mo` — 固定熱流量源。`port.Q_flow = -Q_flow_set` で `HeatPort_b` へ一定入熱を与える。
  `HeatPort` 単体では熱源を作れないため、テスト例を動かす目的も兼ねて追加。
- `package.mo` / `package.order` を新規作成。
- `Component/package.mo` のサブパッケージ一覧に `HeatSources` を追記。

**`Component/Pipes/Pipe.mo`**

- パラメータ `Q_flow`（固定入熱量）を削除。
- `HeatPort_a heatPort` を追加（Placement: 管アイコン上部）。
- 新規変数 `T_fluid`（入口・出口温度の平均）を追加し、`heatPort.T = T_fluid` で束縛。
  — 「流体温度を port の温度として使用する」という要求に対応。1 ノード集中系モデルのため、
  入口・出口温度の単純平均を代表流体温度とした。
- エネルギー保存式の `Q_flow` を `heatPort.Q_flow` に置き換え:
  `m_flow * h_out = m_flow * h_in + heatPort.Q_flow`
- Documentation を更新し、`heatPort.T` が平均近似であることや、将来 `HeatTransfer` 相関式へ
  置き換え可能な拡張ポイントである旨を明記。

**`Examples/TestPipeWithSource.mo`**

- `pipe` の `Q_flow = 50000.0` パラメータ指定を削除。
- 新規 `EAST.TwoPhaseFlow.Component.HeatSources.FixedHeatFlow heater(Q_flow_set = 50000.0)` を追加し、
  `connect(heater.port, pipe.heatPort)` で接続。物理的な入熱量（50 kW）は変更せず、
  供給経路だけパラメータ直接指定から `HeatPort` 経由に変更した。
- ドキュメントの系統図・エネルギー収支説明を `heater` 経由の入熱に合わせて更新。

### 未完了（次のステップ）

- `HeatPort` を介した実際の熱伝達相関式（沸騰・凝縮）モデルは未実装。現状は `FixedHeatFlow` の
  固定値、または将来別チーム（`EAST.Thermal`）のモデルと接続する想定。
- `Pipe` の代表流体温度は入口・出口平均という粗い近似。空間分割（複数ノード化）は将来課題。
- 別チーム所有の `EAST.Thermal.HeatTransfer` 側 `HeatPort` との接続可否（コネクタクラスが異なるため
  単純な `connect()` はできない可能性が高い）は未検討。必要になった時点でアダプタモデルを検討する。

## 議題: Pipe の動的化（管内容積を考慮した質量・エネルギー蓄積）

### 背景

ユーザーが `TestPipeWithSource.mo` を IDE 上で変更（`MassFlowSource_T` への変更、
MSL `FixedTemperature` → `Convection` → `pipe.heatPort` という入熱経路への変更）した結果、
液体だったメタンが蒸発する過渡が観測できないことに気づき、
「Pipe 要素が管内流体容積を考慮していないのが原因ではないか。流体の温度変化も追跡できるように
容積を考慮した式に更新してほしい」という要望があった。

### 設計判断

- `Pipe` を**定常の代数バランス**から**単一 CV（well-mixed 制御容積）の動的バランス**に変更。
  - 容積 `V = L · π/4 · D²` を既存のジオメトリパラメータ `L`, `D` から算出（従来コメント
    「将来の圧損・熱伝達相関式で参照」を実際に利用する形になった）。
  - CV の代表状態を新規の状態変数 `p`, `h`（圧力・比エンタルピー）で表現し、
    `Medium.BaseProperties props` に束縛して `d`, `T`, `u`, `phase`, `sat` を取得。
  - 質量蓄積: `M = props.d·V`, `der(M) = port_a.m_flow + port_b.m_flow`。
  - エネルギー蓄積: `U = M·props.u`,
    `der(U) = port_a.m_flow·actualStream(port_a.h_outflow) + port_b.m_flow·actualStream(port_b.h_outflow) + heatPort.Q_flow`。
    `actualStream()` を使うことで逆流時のエンタルピー輸送も自動的に正しく扱われる
    （従来の「逆流時はパススルー近似」という制限を解消）。
  - 圧力: `port_a.p = p`（CV と入口側は等圧）、`port_b.p = p - dp`（損失は出口側に集中させる
    単純化、従来の `port_b.p = port_a.p - dp` という関係を保ったまま CV 状態を導入）。
  - Stream 変数: `port_a.h_outflow = h`, `port_b.h_outflow = h`（well-mixed 近似、CV は 1 ノード）。
  - `heatPort.T = props.T` — CV の動的温度を直接使用するようになり、従来の
    「入口・出口温度の単純平均」という近似を解消。これがユーザーの
    「流体の温度変化も追跡できるようにしたい」という要求への直接の対応。
  - 初期条件パラメータ `p_start`（既定 1e5 Pa）, `h_start`（既定:
    `Medium.bubbleEnthalpy(Medium.setSat_p(p_start))`、つまり `p_start` における飽和液）を追加。
    Medium 非依存（`PartialTwoPhaseMedium` の共通関数のみ使用）の既定値。
  - `m_flow`, `h_in`, `h_out` の旧変数は廃止（CV 導入により「定常な単一スルー流量」という概念が
    成立しなくなったため）。`props_a`／`props_b`（診断用）は維持しつつ、新たに CV 自身の
    `props` を追加。

### 技術的な留意点（未検証）

この動的バランスは `M(p,h)`, `U(p,h)` を時間微分する陰関数 DAE であり、
`Medium.density`／`BaseProperties.u` の自動微分（ダミー微分・指標低減）に対応した
Modelica ツールが必要（一般的な機能だが、本環境には `omc` 等のコンパイラがなく未検証）。
`Pipe.mo` の Documentation にもこの前提を明記した。

### 未完了（次のステップ）

- 1 CV（0次元集中系）のため、管軸方向の空間分布（液→気の境界位置など）は表現できない。
  将来的に複数 CV への分割が必要になる可能性がある。
- `TestPipeWithSource.mo` は今回変更していない（ユーザーが IDE で編集中のため）。
  `experiment(StopTime=1.0)` や `convection` の `Gc`（`const.k = 0.001`）が、過渡的な
  蒸発が観測できるだけの時間・伝熱量になっているかは未確認。
- 実機（`omc`/OMEdit/Dymola 等）でのコンパイル・シミュレーション確認が必要。

## 議題: Pipe の移流（プラグフロー近似）への対応

### 要求

単一 CV 化した直後の `Pipe` では `port_a.h_outflow` と `port_b.h_outflow` が常に同じ値
（CV の代表エンタルピー `h`）になってしまい、「入口境界の流体が初期配管内の流体を
押し出す」という移流（プラグフロー的）挙動を再現できないという指摘があった。
複数の方針案（多段 CV 分割／`spatialDistribution` 演算子による厳密輸送／`delay()` 近似）を
提示し、ユーザーは **多段 CV 分割（推奨案）** を選択。

### 設計・実装内容

- 新規 `PipeSegment.mo` — 旧 `Pipe`（単一 CV）の物理をそのまま移したモデル。
  パラメータは `V`（セグメント容積; 親の `Pipe` が `L`, `D`, `nNodes` から計算して渡す）、
  `dp`（セグメント内圧損）、`p_start`/`h_start`。`props_a`/`props_b` の入口・出口診断は
  セグメント単体では持たず、`props`（自身の CV 状態）のみ公開（N 個に増えると
  BaseProperties インスタンスが急増するため診断用は最小限にした）。
- `Pipe.mo` を「`nNodes` 個の `PipeSegment` を直列接続するコンテナ」に再設計:
  - `segment[nNodes]`（配列）を `each` 修飾子で一括パラメータ化
    （`each V = V/nNodes`, `each dp = dp/nNodes`, `each p_start`, `each h_start`）。
  - `connect(port_a, segment[1].port_a)` → `for` ループで `segment[i].port_b — segment[i+1].port_a`
    を直列接続 → `connect(segment[nNodes].port_b, port_b)`。
    `FluidPort` の `connect()` が `m_flow`/`h_outflow`（stream 変数）を正しく伝播するため、
    セグメント i の CV エンタルピーが下流セグメントへ流れ込み、結果として
    「入口側の新しい流体が下流へ向かって既存の流体を時間をかけて置き換える」移流が
    自然に再現される。
  - `nNodes = 1` のときは旧来の単一 CV モデルと等価になる（後方互換）。
  - `heatPort` は外部インターフェースとしてはスカラーのまま維持（`TestPipeWithSource.mo` の
    `connect(convection.fluid, pipe.heatPort)` を変更せずに済む）。内部では
    `segment[i].heatPort.Q_flow = heatPort.Q_flow / nNodes`（均等分配）、
    `heatPort.T = mean(segment[i].heatPort.T)`（各セグメント温度の単純平均）として
    `connect()` を使わず直接代入で配分。
    — `connect()` で 1 つの heatPort を N 個のセグメント heatPort に直接繋ぐと、
    potential 変数（`T`）の等値制約が全セグメントに及んでしまい温度分布が消えてしまうため、
    意図的に `connect()` を使わず明示的な配分方程式とした。
  - セグメントごとに異なる熱流（空間的に変化する入熱）を与える経路は未対応。将来、
    `heatPort` を配列化する拡張が必要になった場合は別途検討する
    （その場合 `TestPipeWithSource.mo` 側の接続も変更が必要になる）。
- `Component/Pipes/package.mo`, `package.order` に `PipeSegment` を追加。

### 未完了（次のステップ）

- `nNodes` の既定値は 3。数値拡散とプラグフロー近似精度のトレードオフがあるため、
  実際にシミュレーションして妥当な値を確認する必要がある（未検証、`omc` 等が本環境にない）。
- セグメント単位の `props_a`/`props_b` 診断（入口・出口の詳細）を削ったため、必要であれば
  個別セグメントの `props` を直接参照する形になる。
- `heatPort` の配列化（セグメント別入熱）は要望が出た時点で再検討。

### 追記: コンパイルエラーの修正（過剰決定システム）

ユーザーが実際に `TestPipeWithSource` をコンパイルしたところ、以下のエラーが発生した。

```
Too many equations, over-determined system. The model has 324 equation(s) and 314 variable(s).
[EAST.TwoPhaseFlow.Component.Pipes.Pipe: 42:5-42:56]:
  pipe.segment[2].heatPort.Q_flow = 0.1 * pipe.heatPort.Q_flow が解けない。
  既に解かれている式: pipe.segment[2].heatPort.Q_flow = 0.0（自動生成）
```

**原因**: `segment[i].heatPort` を一度も `connect()` で結線せず、`for` ループ内で
直接代入の式（`segment[i].heatPort.Q_flow = heatPort.Q_flow/nNodes;`）だけを書いていた。
Modelica の仕様では、モデル全体を通じて一度も `connect()` に登場しないコネクタの
`flow` 変数には自動的に `= 0` の式が課される。直接代入の式を書いても、この自動生成は
回避されない（コネクタが「未接続」と判定される基準は `connect()` に現れたかどうかであり、
他の式で参照されているかどうかではない）。結果として `segment[i].heatPort.Q_flow` に対して
2つの式（自分の代入式 + 自動生成の `=0`）が同時に存在し、セグメント数分（`nNodes` 個）
過剰決定となった。

旧（単一CV）版の `Pipe` で `heatPort.T = T_fluid;` のような直接代入が問題なく動いていたのは、
その `heatPort` 自体が `TestPipeWithSource.mo` 側で `connect(convection.fluid, pipe.heatPort)`
として外部から結線されており、モデル全体としては「未接続」ではなかったため。

**修正方針**: 1つの `heatPort` を複数セグメントへ直接 `connect()` する案は、
`connect()` が同一コネクタを介して全て同じ接続集合にまとめてしまうため、
セグメント間で温度（potential 変数）が全て等値になってしまい不採用。
代わりに `heatDistributionPort[nNodes]`（`HeatPort_b` 型の配列）を新設し、
`for i in 1:nNodes loop connect(heatDistributionPort[i], segment[i].heatPort); end for;` で
セグメントごとに独立した 1 対 1 の接続ペアを作り、各ペア内で
`heatDistributionPort[i].Q_flow = -heatPort.Q_flow/nNodes;` として分配量を与えるよう変更。
これにより各セグメントの `heatPort` が「（個別に）接続済み」と判定され、自動 `=0` が
課されなくなる。`Pipe.mo` の Documentation にもこの背景を追記した。
