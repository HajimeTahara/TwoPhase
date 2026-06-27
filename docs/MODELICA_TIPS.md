# Modelica Tips

## `sqrt` は組み込み関数

平方根はModelica言語の組み込み関数として、パッケージ名を付けずに使用します。

```modelica
y = sqrt(x);
```

現在使用しているMSLには、次の関数は存在しません。

```modelica
y = Modelica.Math.sqrt(x);
```

`abs`、`sign`、`min`、`max`、`ceil`、`floor`なども組み込み関数です。

```modelica
y1 = abs(x);
y2 = max(x1, x2);
```

三角関数、指数関数、対数関数などは、通常`Modelica.Math`から使用します。

```modelica
y1 = Modelica.Math.sin(x);
y2 = Modelica.Math.exp(x);
y3 = Modelica.Math.log(x);
y4 = Modelica.Math.log10(x);
```

使用中のMSLで関数の所属が不明な場合は、MSLソース内の宣言を確認してください。

## 配列リテラルの `[]` と `{}`

Modelicaでは、行列リテラルには角括弧 `[]` を使用します。

```modelica
parameter Real table[:, :] = [0, 0; 1, 1; 2, 2];
```

波括弧 `{}` は主にベクトルや配列コンストラクタに使用します。

```modelica
parameter Real vector[3] = {1, 2, 3};
```

そのため、次のように `{}` の中で行をセミコロン区切りにした記法は、
2次元テーブルとしては使用しません。

```modelica
parameter Real table[:, :] = {0, 0; 1, 1; 2, 2}; // NG
```

`{}` で2次元配列を表す場合は、行ごとに入れ子の配列として書きます。

```modelica
parameter Real table[3, 2] = {{0, 0}, {1, 1}, {2, 2}};
```

`Modelica.Blocks.Tables.CombiTable1Ds`や
`Modelica.Blocks.Sources.CombiTimeTable`の`table`には、
MSLの例と同じく`[0, 0; 1, 1; 2, 2]`形式を使うと読みやすくなります。
