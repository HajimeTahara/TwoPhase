within EAST.TwoPhaseFlow.Media;
package LCH_FD "単相密度を固定化した液体メタン (CH4) 媒体パッケージ"
  extends Modelica.Icons.VariantsPackage;
  extends EAST.TwoPhaseFlow.Media.Interfaces.PartialTwoPhaseMediumFD(
    mediumName = "Liquid Methane (CH4), fixed single-phase density",
    singleState = false,
    redeclare constant MolarMass MM_const = Common.LCHData.MM_const,
    redeclare constant Temperature T_critical = Common.LCHData.T_critical,
    redeclare constant AbsolutePressure p_critical = Common.LCHData.p_critical,
    redeclare constant Density d_critical = Common.LCHData.d_critical,
    redeclare constant Temperature T_triple = Common.LCHData.T_triple,
    redeclare constant AbsolutePressure p_triple = Common.LCHData.p_triple,
    redeclare constant Temperature T_min = Common.LCHData.T_min,
    redeclare constant Temperature T_max = Common.LCHData.T_max,
    redeclare constant Temperature T_normal_boiling =
      Common.LCHData.T_normal_boiling,
    redeclare constant Real omega_const = Common.LCHData.omega_const,
    redeclare constant SpecificHeatCapacity cp_liquid_const =
      Common.LCHData.cp_liquid_const,
    redeclare constant SpecificHeatCapacity cp_vapor_const =
      Common.LCHData.cp_vapor_const,
    redeclare constant ViscosityCoefficient mu_const =
      Common.LCHData.mu_const,
    redeclare constant ThermalConductivity lambda_const =
      Common.LCHData.lambda_const,
    redeclare constant Integer sat_n = Common.LCHData.sat_n,
    redeclare constant Real sat_p[sat_n](each unit="Pa") =
      Common.LCHData.sat_p,
    redeclare constant Real sat_T[sat_n](each unit="K") =
      Common.LCHData.sat_T,
    redeclare constant Real sat_h_bubble[sat_n](each unit="J/kg") =
      Common.LCHData.sat_h_bubble,
    redeclare constant Real sat_h_dew[sat_n](each unit="J/kg") =
      Common.LCHData.sat_h_dew,
    redeclare constant Real sat_d_bubble[sat_n](each unit="kg/m3") =
      Common.LCHData.sat_d_bubble,
    redeclare constant Real sat_d_dew[sat_n](each unit="kg/m3") =
      Common.LCHData.sat_d_dew);

  annotation (Documentation(info="<html>
<p>
<code>Common.LCHData</code> の物質定数と飽和物性表を使用し、
<code>PartialTwoPhaseMediumFD</code> の固定単相密度モデルを適用する液体メタン媒体。
</p>
<p>
単相密度は標準大気圧における飽和液密度を飽和表から補間した一定値である。
二相域の密度は従来の均質平衡モデルで計算する。
</p>
</html>"));
end LCH_FD;
