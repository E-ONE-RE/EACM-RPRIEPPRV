@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RPRIEPPRV Form General Currency Total'
@Metadata.ignorePropagatedAnnotations: true
define view entity /EACM/C_RPRIEPPRV_FORM_V
  as select from /EACM/I_RPRIEPPRV as Summary
  association [0..*] to /EACM/C_RPRIEPPRV_FORM_G as _GeneralTotalsByClass
    on  $projection.Bukrs = _GeneralTotalsByClass.Bukrs
    and $projection.Fkdat = _GeneralTotalsByClass.Fkdat
    and $projection.Waerk = _GeneralTotalsByClass.Waerk
{
  key Summary.Bukrs as Bukrs,
  key Summary.Fkdat as Fkdat,
  key Summary.Waerk as Waerk,

      Summary.Waerk as CurrencyCode,

      cast(
        sum( cast( Summary.Zimpp as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as GeneralTotalZimpp,

      cast(
        sum( cast( Summary.Zimco as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as GeneralTotalZimco,

      cast(
        sum( cast( Summary.Zimmg as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as GeneralTotalZimmg,

      cast(
        sum( cast( Summary.Ziman as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as GeneralTotalZiman,

      cast(
        sum( cast( Summary.ImpProvv as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as GeneralTotalImpProvv,

      cast(
        sum( cast( Summary.ImpMatur as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as GeneralTotalImpMatur,

      cast(
        sum( cast( Summary.ImpDaMat as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as GeneralTotalImpDaMat,

      cast(
        sum( cast( Summary.ImpRecup as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as GeneralTotalImpRecup,

      _GeneralTotalsByClass
}
group by
  Summary.Bukrs,
  Summary.Fkdat,
  Summary.Waerk
