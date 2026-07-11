@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RPRIEPPRV Form Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity /EACM/C_RPRIEPPRV_FORM_I
  as select from /EACM/I_RPRIEPPRV as Summary
    left outer join /eacm/kna1 as Customer
      on Customer.kunnr = Summary.Kunrg
{
  key Summary.Bukrs as Bukrs,
  key Summary.Fkdat as Fkdat,
  key Summary.Zcdaz as Zcdaz,
  key Summary.Waerk as Waerk,
  key Summary.Kunrg as Kunrg,
  key Summary.Vbeln as Vbeln,
  key Summary.Posnr as Posnr,
  key Summary.Zclpr as Zclpr,
  key Summary.Belnr as Belnr,

      Summary.Namea as Namea,
      Customer.name1 as CustomerName,
      Summary.Zidfs as Zidfs,
      Summary.Zamcf as Zamcf,
      Summary.Ztpcd as Ztpcd,

      cast(
        sum( cast( Summary.Zimpp as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as Zimpp,

      cast(
        sum( cast( Summary.Zimco as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as Zimco,

      cast(
        sum( cast( Summary.Zimmg as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as Zimmg,

      cast(
        sum( cast( Summary.Ziman as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as Ziman,

      cast(
        sum( cast( Summary.ImpProvv as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as ImpProvv,

      cast(
        sum( cast( Summary.ImpMatur as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as ImpMatur,

      cast(
        sum( cast( Summary.ImpDaMat as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as ImpDaMat,

      cast(
        sum( cast( Summary.ImpRecup as abap.dec( 23, 2 ) ) )
        as abap.dec( 23, 2 ) ) as ImpRecup
}
group by
  Summary.Bukrs,
  Summary.Fkdat,
  Summary.Zcdaz,
  Summary.Waerk,
  Summary.Kunrg,
  Summary.Vbeln,
  Summary.Posnr,
  Summary.Zclpr,
  Summary.Belnr,
  Summary.Namea,
  Customer.name1,
  Summary.Zidfs,
  Summary.Zamcf,
  Summary.Ztpcd
