@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RPRIEPPRV Form Agent'
@Metadata.ignorePropagatedAnnotations: true
define view entity /EACM/C_RPRIEPPRV_FORM_A
  as select from /EACM/I_RPRIEPPRV as Summary
  association [0..*] to /EACM/C_RPRIEPPRV_FORM_T as _AgentTotalsByClass
    on  $projection.Bukrs = _AgentTotalsByClass.Bukrs
    and $projection.Fkdat = _AgentTotalsByClass.Fkdat
    and $projection.Zcdaz = _AgentTotalsByClass.Zcdaz
  association [0..*] to /EACM/C_RPRIEPPRV_FORM_C as _Currency
    on  $projection.Bukrs = _Currency.Bukrs
    and $projection.Fkdat = _Currency.Fkdat
    and $projection.Zcdaz = _Currency.Zcdaz
{
  key Summary.Bukrs as Bukrs,
  key Summary.Fkdat as Fkdat,
  key Summary.Zcdaz as Zcdaz,

      cast( Summary.Fkdat as abap.char( 10 ) ) as PeriodFrom,
      cast( Summary.Fkdat as abap.char( 10 ) ) as PeriodTo,

      Summary.Namea as Namea,
      cast( 'Active' as abap.char( 20 ) ) as AgentState,

      cast(
        sum( cast( Summary.Zimpp as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as AgentTotalZimpp,

      cast(
        sum( cast( Summary.Zimco as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as AgentTotalZimco,

      cast(
        sum( cast( Summary.Zimmg as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as AgentTotalZimmg,

      cast(
        sum( cast( Summary.Ziman as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as AgentTotalZiman,

      cast(
        sum( cast( Summary.ImpProvv as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as AgentTotalImpProvv,

      cast(
        sum( cast( Summary.ImpMatur as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as AgentTotalImpMatur,

      cast(
        sum( cast( Summary.ImpDaMat as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as AgentTotalImpDaMat,

      cast(
        sum( cast( Summary.ImpRecup as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as AgentTotalImpRecup,

      _AgentTotalsByClass,
      _Currency
}
group by
  Summary.Bukrs,
  Summary.Fkdat,
  Summary.Zcdaz,
  Summary.Namea
