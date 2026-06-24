within EAST.TwoPhaseFlow.Component.Pumps;
model Pump "回転数相似則を用いる PQ 特性テーブル式ポンプ"
  extends EAST.Icons.Pump;

  replaceable package Medium =
    EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMedium
    annotation (choicesAllMatching=true);

  parameter Modelica.Units.NonSI.AngularVelocity_rpm nominalSpeed(
    min=Modelica.Constants.small) = 1500
    "PQ 特性テーブルの定格回転数";
  parameter Real nominalPQ[:,2] = [0, 20; 0.01, 15; 0.02, 0]
    "定格回転数における体積流量と揚程のテーブル";
  parameter Modelica.Units.SI.Efficiency efficiency(
    min=Modelica.Constants.small,
    max=1) = 0.8
    "ポンプ効率";
  final parameter Modelica.Units.SI.AngularVelocity angularVelocitySmall = 1e-6
    "軸トルク計算を切り替える角速度";

  Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft
    "ポンプ駆動軸"
    annotation (Placement(
      transformation(extent={{-10,90},{10,110}}),
      iconTransformation(extent={{-10,90},{10,110}})));

  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_a port_a(
    redeclare package Medium = Medium,
    m_flow(min=0))
    "吸込側ポート"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  EAST.TwoPhaseFlow.Component.Interfaces.FluidPort_b port_b(
    redeclare package Medium = Medium,
    m_flow(max=0))
    "吐出側ポート"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  Modelica.Units.SI.Height head
    "回転数相似則から求めた揚程";
  Modelica.Units.SI.Height nominalHead
    "定格回転数換算流量におけるテーブル揚程";
  Modelica.Units.SI.PressureDifference dp
    "ポンプによる圧力上昇";
  Modelica.Units.SI.MassFlowRate m_flow
    "吸込側から吐出側へ流れる質量流量";
  Modelica.Units.SI.VolumeFlowRate volumeFlowRate
    "実回転数における体積流量";
  Modelica.Units.SI.VolumeFlowRate nominalVolumeFlowRate
    "定格回転数へ換算した体積流量";
  Modelica.Units.SI.Angle shaftAngle
    "軸回転角";
  Modelica.Units.SI.AngularVelocity angularVelocity
    "軸角速度";
  Modelica.Units.NonSI.AngularVelocity_rpm speed_rpm
    "軸回転数";
  Real speedRatio(min=0)
    "定格回転数に対する回転数比";
  Modelica.Units.SI.Power power
    "ポンプ消費動力";
  Modelica.Units.SI.Torque shaftTorque
    "ポンプが駆動軸から受け取るトルク";
  Medium.BaseProperties inletProperties
    "吸込側の代表流体状態";

protected
  Modelica.Blocks.Tables.CombiTable1Ds headTable(
    table=nominalPQ,
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    u(unit="m3/s"),
    y(each unit="m"))
    "定格 PQ 特性の線形補間テーブル";

equation
  assert(size(nominalPQ, 1) >= 2,
    "nominalPQ には少なくとも 2 点を設定してください。");
  for i in 1:size(nominalPQ, 1) - 1 loop
    assert(nominalPQ[i + 1, 1] > nominalPQ[i, 1],
      "nominalPQ の体積流量は昇順に設定してください。");
  end for;

  port_a.m_flow + port_b.m_flow = 0;
  m_flow = port_a.m_flow;

  inletProperties.p = port_a.p;
  inletProperties.h = inStream(port_a.h_outflow);

  shaftAngle = shaft.phi;
  angularVelocity = der(shaftAngle);
  speed_rpm = Modelica.Units.Conversions.to_rpm(angularVelocity);
  speedRatio = max(0, speed_rpm/nominalSpeed);
  volumeFlowRate = m_flow/inletProperties.d;
  nominalVolumeFlowRate = noEvent(
    if speedRatio > Modelica.Constants.small then volumeFlowRate/speedRatio
    else 0);
  headTable.u = nominalVolumeFlowRate;
  nominalHead = max(0, headTable.y[1]);
  head = noEvent(
    if speedRatio > Modelica.Constants.small then nominalHead*speedRatio^2
    else 0);

  dp = inletProperties.d*Modelica.Constants.g_n*head;
  port_b.p - port_a.p = dp;
  power = m_flow*Modelica.Constants.g_n*head/efficiency;
  shaftTorque = noEvent(
    if angularVelocity > angularVelocitySmall then power/angularVelocity
    else 0);
  shaft.tau = shaftTorque;

  port_b.h_outflow =
    inStream(port_a.h_outflow) + Modelica.Constants.g_n*head/efficiency;
  port_a.h_outflow = inStream(port_b.h_outflow);

  annotation (
    defaultComponentName="pump",
    Icon(coordinateSystem(preserveAspectRatio=true)),
    Documentation(info="<html>
<p>
定格回転数における PQ 特性をテーブルで与え、駆動軸回転数に対する
ポンプ揚程を相似則から計算する簡易ポンプ。
</p>
<p>
<code>nominalPQ</code> の第 1 列には定格回転数での体積流量、
第 2 列には揚程を昇順で設定する。範囲内は線形補間し、
範囲外では端点の値を保持する。
</p>
<table border="1" cellspacing="0" cellpadding="4">
<tr><th>列</th><th>物理量</th><th>単位</th></tr>
<tr><td>第1列</td><td>定格回転数における体積流量 Q</td><td>m&sup3;/s</td></tr>
<tr><td>第2列</td><td>定格回転数における揚程 H</td><td>m</td></tr>
</table>
<p>
既定値 <code>[0, 20; 0.01, 15; 0.02, 0]</code> は、
体積流量 0、0.01、0.02 m&sup3;/s に対して、
それぞれ揚程 20、15、0 m を表す。
</p>
<p>
<code>shaft</code> は
<code>Modelica.Mechanics.Rotational.Interfaces.Flange_a</code> であり、
モータ、回転慣性、速度源などの回転機械コンポーネントを接続できる。
軸角速度を rpm に換算して PQ 特性に使用し、ポンプ消費動力に対応する
反力トルクをフランジへ返す。
</p>
<pre>
angularVelocity = der(shaft.phi)
speed_rpm = to_rpm(angularVelocity)
speedRatio = speed_rpm / nominalSpeed
nominalVolumeFlowRate = volumeFlowRate / speedRatio
nominalHead = table(nominalVolumeFlowRate)
head = nominalHead * speedRatio^2
dp = inletDensity * g * head
power = m_flow * g * head / efficiency
shaftTorque = power / angularVelocity
h_out = h_in + g * head / efficiency
</pre>
<p>
体積流量は回転数に比例し、揚程は回転数の二乗に比例するポンプ相似則を使用する。
回転数入力がゼロ以下の場合、回転数比と揚程をゼロとする。
流れ方向は吸込側 <code>port_a</code> から吐出側 <code>port_b</code> のみに制限する。
</p>
<h4>制限事項</h4>
<ul>
<li>効率は流量・回転数によらない固定値。</li>
<li>キャビテーションと NPSH は未実装。</li>
<li>内部容積と動的な質量・エネルギー蓄積は持たない。</li>
<li>二相流固有のポンプ性能低下は考慮しない。</li>
</ul>
</html>"));
end Pump;
