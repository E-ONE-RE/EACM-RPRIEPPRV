@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '/EACM/I_RPPRDP - estrazione dati ZPRDP'
@Metadata.ignorePropagatedAnnotations: true
define view entity /EACM/I_RPPRDP as select from /eacm/zprdp as Dp
{
  key Dp.vkorg,
  key Dp.vtweg,
  key Dp.zclpr,
  key Dp.vbeln,
  key Dp.posnr,
  key Dp.zcdaz,
  key Dp.zidag,

      Dp.waerk,

      @Semantics.amount.currencyCode: 'waerk'
      sum( Dp.ziman )         as Ziman,

      @Semantics.amount.currencyCode: 'waerk'
      sum( Dp.zirec )         as Zirec,

      @Semantics.amount.currencyCode: 'waerk'
      sum( Dp.zinc )         as Zzinc,

      @Semantics.amount.currencyCode: 'waerk'
      sum(
        case
          when Dp.ztpcd = 'S' then Dp.ziprv
          else cast( 0 as /eacm/ziprv )
        end
      )                       as Sospeso,

      max( Dp.zidfs )         as Zidfs,
      max( Dp.zamcf )         as Zamcf,
      max( Dp.ztpcd )         as Ztpcd,
      Dp.zwaersp,
      max( Dp.zkurrfp )       as Zkurrfp,
      max( Dp.zpercsosp )     as Zpercsosp
}
where Dp.zstre <> 'D'
group by
  Dp.vkorg,
  Dp.vtweg,
  Dp.zclpr,
  Dp.vbeln,
  Dp.posnr,
  Dp.zcdaz,
  Dp.zidag,
  Dp.waerk,
  Dp.zwaersp
