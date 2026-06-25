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
