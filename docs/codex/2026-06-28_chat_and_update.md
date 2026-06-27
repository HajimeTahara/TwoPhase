# 2026-06-28 Chat and Update

## temperature(state) の smooth blend 化

- 議題: 単相/二相境界で `temperature(state)` も `density(state)` と同様に滑らかに接続したい。
- 決定事項:
  - `PartialTwoPhaseMedium.temperature(state)` で、飽和温度 `sat.Tsat` と単相温度 `temperatureSinglePhase` を `smoothStep` でブレンドする。
  - ブレンド幅は既存の `phaseBoundaryDensityBlendFraction` / `phaseBoundaryDensityBlendMinWidth` を共用する。
  - 変更前の `temperature(state)` 実装はコメントとして残す。
- 変更ファイル:
  - `modelica/EAST/TwoPhaseFlow/Media/Interfaces/PartialTwoPhaseMedium.mo`
- 変更理由:
  - `density(state)` の境界 smooth 化後も、`props.T` と熱流計算側に単相/二相境界の不連続または折れが残る可能性があるため。
- 残作業:
  - OpenModelica で再変換・再計算し、`invertorCoolerLCH.pipe3/pipe4` 周辺の収束性と `props.T` の変化を確認する。

## smooth blend のフラグ切り替え

- 議題: smooth 化前の式と smooth 化後の式をフラグで切り替えられるようにしたい。
- 決定事項:
  - `PartialTwoPhaseMedium` に `usePhaseBoundarySmoothBlend` を追加する。
  - `true` の場合は単相/二相境界で `density(state)` と `temperature(state)` を smooth blend する。
  - `false` の場合は smooth 化前の `state.phase` に基づく分岐式を使う。
- 変更ファイル:
  - `modelica/EAST/TwoPhaseFlow/Media/Interfaces/PartialTwoPhaseMedium.mo`
- 変更理由:
  - 収束性や物性の連続性を比較しながら、原因切り分けをしやすくするため。
- 残作業:
  - `usePhaseBoundarySmoothBlend=true/false` の両方で OpenModelica の変換と計算を比較する。
