@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RPRIEPPRV Form Customer'
@Metadata.ignorePropagatedAnnotations: true
define view entity /EACM/C_RPRIEPPRV_FORM_U
  as select from /EACM/I_RPRIEPPRV as Summary
    left outer join /eacm/kna1 as Customer
      on Customer.kunnr = Summary.Kunrg
  association [0..*] to /EACM/C_RPRIEPPRV_FORM_I as _Item
    on  $projection.Bukrs = _Item.Bukrs
    and $projection.Fkdat = _Item.Fkdat
    and $projection.Zcdaz = _Item.Zcdaz
    and $projection.Waerk = _Item.Waerk
    and $projection.Kunrg = _Item.Kunrg
{
  key Summary.Bukrs as Bukrs,
  key Summary.Fkdat as Fkdat,
  key Summary.zcdaz as Zcdaz,
  key Summary.Waerk as Waerk,
  key Summary.Kunrg as Kunrg,

      Customer.name1 as CustomerName,

      cast(
        sum( cast( Summary.Zimpp as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as CustomerTotalZimpp,

      cast(
        sum( cast( Summary.Zimco as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as CustomerTotalZimco,

      cast(
        sum( cast( Summary.Zimmg as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as CustomerTotalZimmg,

      cast(
        sum( cast( Summary.Ziman as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as CustomerTotalZiman,

      cast(
        sum( cast( Summary.ImpProvv as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as CustomerTotalImpProvv,

      cast(
        sum( cast( Summary.ImpMatur as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as CustomerTotalImpMatur,

      cast(
        sum( cast( Summary.ImpDaMat as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as CustomerTotalImpDaMat,

      cast(
        sum( cast( Summary.ImpRecup as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as CustomerTotalImpRecup,

      _Item
}
group by
  Summary.Bukrs,
  Summary.Fkdat,
  Summary.zcdaz,
  Summary.Waerk,
  Summary.Kunrg,
  Customer.name1
