@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RPRIEPPRV Form Currency'
@Metadata.ignorePropagatedAnnotations: true
define view entity /EACM/C_RPRIEPPRV_FORM_C
  as select from /EACM/I_RPRIEPPRV as Summary
  association [0..*] to /EACM/C_RPRIEPPRV_FORM_U as _Customer
    on  $projection.Bukrs = _Customer.Bukrs
    and $projection.Fkdat = _Customer.Fkdat
    and $projection.Zcdaz = _Customer.Zcdaz
    and $projection.Waerk = _Customer.Waerk
{
  key Summary.Bukrs as Bukrs,
  key Summary.Fkdat as Fkdat,
  key Summary.zcdaz as Zcdaz,
  key Summary.Waerk as Waerk,

      cast(
        sum( cast( Summary.Zimpp as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as CurrencyTotalZimpp,

      cast(
        sum( cast( Summary.Zimco as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as CurrencyTotalZimco,

      cast(
        sum( cast( Summary.Zimmg as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as CurrencyTotalZimmg,

      cast(
        sum( cast( Summary.Ziman as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as CurrencyTotalZiman,

      cast(
        sum( cast( Summary.ImpProvv as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as CurrencyTotalImpProvv,

      cast(
        sum( cast( Summary.ImpMatur as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as CurrencyTotalImpMatur,

      cast(
        sum( cast( Summary.ImpDaMat as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as CurrencyTotalImpDaMat,

      cast(
        sum( cast( Summary.ImpRecup as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as CurrencyTotalImpRecup,

      _Customer
}
group by
  Summary.Bukrs,
  Summary.Fkdat,
  Summary.zcdaz,
  Summary.Waerk
