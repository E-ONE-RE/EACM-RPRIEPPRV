@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RPRIEPPRV Form Header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.supportedCapabilities: [ #OUTPUT_FORM_DATA_PROVIDER ]
define root view entity /EACM/C_RPRIEPPRV_FORM_H
  as select from /EACM/I_RPRIEPPRV as Summary
  association [0..*] to /EACM/C_RPRIEPPRV_FORM_A as _Agent
    on  $projection.Bukrs = _Agent.Bukrs
    and $projection.Fkdat = _Agent.Fkdat
  association [0..*] to /EACM/C_RPRIEPPRV_FORM_V as _General
    on  $projection.Bukrs = _General.Bukrs
    and $projection.Fkdat = _General.Fkdat
  association [0..*] to /EACM/C_RPRIEPPRV_FORM_G as _GeneralTotalsByClass
    on  $projection.Bukrs = _GeneralTotalsByClass.Bukrs
    and $projection.Fkdat = _GeneralTotalsByClass.Fkdat
{
  key Summary.Bukrs as Bukrs,
  key Summary.Fkdat as Fkdat,

      cast(
        sum( cast( Summary.Zimpp as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as TotalZimpp,

      cast(
        sum( cast( Summary.Zimco as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as TotalZimco,

      cast(
        sum( cast( Summary.Zimmg as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as TotalZimmg,

      cast(
        sum( cast( Summary.Ziman as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as TotalZiman,

      cast(
        sum( cast( Summary.ImpProvv as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as TotalImpProvv,

      cast(
        sum( cast( Summary.ImpMatur as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as TotalImpMatur,

      cast(
        sum( cast( Summary.ImpDaMat as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as TotalImpDaMat,

      cast(
        sum( cast( Summary.ImpRecup as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as TotalImpRecup,

      _Agent,
      _General,
      _GeneralTotalsByClass
}
group by
  Summary.Bukrs,
  Summary.Fkdat
