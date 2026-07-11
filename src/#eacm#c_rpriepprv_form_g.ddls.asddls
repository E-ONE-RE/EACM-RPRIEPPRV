@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RPRIEPPRV Form General Total By Class'
@Metadata.ignorePropagatedAnnotations: true
define view entity /EACM/C_RPRIEPPRV_FORM_G
  as select from /EACM/I_RPRIEPPRV as Summary
{
  key Summary.Bukrs as Bukrs,
  key Summary.Fkdat as Fkdat,
  key Summary.Waerk as Waerk,
  key Summary.Zclpr as Zclpr,

      Summary.Waerk as CurrencyCode,
      Summary.Zclpr as Classification,

      cast(
        sum( cast( Summary.Zimpp as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as GeneralClassTotalZimpp,

      cast(
        sum( cast( Summary.Zimco as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as GeneralClassTotalZimco,

      cast(
        sum( cast( Summary.Zimmg as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as GeneralClassTotalZimmg,

      cast(
        sum( cast( Summary.Ziman as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as GeneralClassTotalZiman,

      cast(
        sum( cast( Summary.ImpProvv as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as TotalProvvigione,

      cast(
        sum( cast( Summary.ImpMatur as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as TotalMaturato,

      cast(
        sum( cast( Summary.ImpDaMat as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as TotalDaMaturare,

      cast(
        sum( cast( Summary.ImpRecup as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as TotalRecupero
}
group by
  Summary.Bukrs,
  Summary.Fkdat,
  Summary.Waerk,
  Summary.Zclpr
