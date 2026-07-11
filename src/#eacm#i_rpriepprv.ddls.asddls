@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '/EACM/I_RPRIEPPRV - Riepilogo Provv.'
@Metadata.ignorePropagatedAnnotations: true

define root view entity /EACM/I_RPRIEPPRV
  as select from /eacm/prdo as Prdo

    left outer join /EACM/I_RPAGENT as LastAgent
      on LastAgent.zcdaz = Prdo.zcdaz
      
    left outer join /eacm/zpraa as Agent
      on Agent.zcdaz = LastAgent.zcdaz
     and Agent.erdat  = LastAgent.erdat
     and Agent.zstre <> 'A'
     and Agent.zstre <> 'S'
     
    left outer join /eacm/zpr02 as AgentType
      on AgentType.ztpag = Agent.ztpag
      
    left outer join /eacm/zpr48 as SignRule
      on SignRule.vbtyp = Prdo.vbtyp
      
    left outer join /EACM/I_RPPRDP as Prdp
      on Prdp.vkorg = Prdo.vkorg
     and Prdp.vtweg = Prdo.vtweg
     and Prdp.zclpr = Prdo.zclpr
     and Prdp.vbeln = Prdo.vbeln
     and Prdp.posnr = Prdo.posnr
     and Prdp.zcdaz = Prdo.zcdaz
     and Prdp.zidag = Prdo.zidag
     and Prdp.waerk = Prdo.waerk
{
  key Prdo.vkorg             as Vkorg,
  key Prdo.vtweg             as Vtweg,
  key Prdo.zclpr             as Zclpr,
  key Prdo.vbeln             as Vbeln,
  key Prdo.posnr             as Posnr,
  key Prdo.zcdaz             as Zcdaz, 
  key Prdo.zidag             as Zidag,

      Prdo.bukrs             as Bukrs,
      Prdo.ztpag             as ZtpagDoc,
      Agent.name1            as Namea,
      Agent.ztpag            as Ztpag,
      AgentType.zdeag        as Zdeag,
      Prdo.vkgrp             as Vkgrp,
      Prdo.vkbur             as Vkbur,
      Prdo.waerk             as Waerk,
      Prdo.zwaer             as Zzwaer,
      Prdo.kunrg             as Kunrg,
      Prdo.fkart             as Fkart,
      Prdo.vbtyp             as Vbtyp,
      Prdo.fkdat             as Fkdat,
      Prdo.belnr             as Belnr,
      Prdo.bldat             as Bldat,
      Prdo.budat             as Budat,
      Prdo.blart             as Blart,
      Prdo.matnr             as Matnr,
      Prdo.maktx             as Maktx,
      Prdo.zutmx             as Zutmx,
      Prdo.zstre             as Zstre,
      Prdo.zpcpr             as Zpcpr,
      Prdo.zdest             as Zdest,
      Prdo.zhistor           as Zhistor,
      Prdo.zabin             as Zabin,
      Prdo.kostl             as Kostl,
      Prdo.ztprv             as Ztprv,
      Prdo.kurrf             as Kurrf,

      case when SignRule.zsegn = '-1' then -1 else 1 end as SignMultiplier,

      cast( case
        when SignRule.zsegn is null then curr_to_decfloat_amount( Prdo.zimpp )
        else curr_to_decfloat_amount( Prdo.zimpp ) * ( case when SignRule.zsegn = '-1' then -1 else 1 end )
      end as abap.dec( 23, 2 ) ) as Zimpp,

      cast( case
        when SignRule.zsegn is null then
          case when Prdo.ziman <> 0 then curr_to_decfloat_amount( Prdo.ziman ) else curr_to_decfloat_amount( Prdo.zimco ) end
        else
          case when Prdo.ziman <> 0 then curr_to_decfloat_amount( Prdo.ziman ) else curr_to_decfloat_amount( Prdo.zimco ) end
          * ( case when SignRule.zsegn = '-1' then -1 else 1 end )
      end as abap.dec( 23, 2 ) ) as Zimco,

      cast( case
        when Prdo.ziman <> 0 and Prdp.Ziman is not null and SignRule.zsegn is null
          then curr_to_decfloat_amount( Prdp.Ziman )
        when Prdo.ziman <> 0 and Prdp.Ziman is not null
          then curr_to_decfloat_amount( Prdp.Ziman ) * ( case when SignRule.zsegn = '-1' then -1 else 1 end )
        when SignRule.zsegn is null 
          then curr_to_decfloat_amount( Prdo.zimmg )
        else curr_to_decfloat_amount( Prdo.zimmg ) * ( case when SignRule.zsegn = '-1' then -1 else 1 end )
      end as abap.dec( 23, 2 ) ) as Zimmg,

      cast( case
        when SignRule.zsegn is null then curr_to_decfloat_amount( Prdo.ziman )
        else curr_to_decfloat_amount( Prdo.ziman ) * ( case when SignRule.zsegn = '-1' then -1 else 1 end )
      end as abap.dec( 23, 2 ) ) as Ziman,

      cast( case
        when SignRule.zsegn is null then
          case when Prdo.ziman <> 0 then curr_to_decfloat_amount( Prdo.ziman ) else curr_to_decfloat_amount( Prdo.zimco ) end
        else
          case when Prdo.ziman <> 0 then curr_to_decfloat_amount( Prdo.ziman ) else curr_to_decfloat_amount( Prdo.zimco ) end
          * ( case when SignRule.zsegn = '-1' then -1 else 1 end )
      end as abap.dec( 23, 2 ) ) as ImpProvv,

      cast( case
        when Prdo.ziman <> 0 and Prdp.Ziman is not null and SignRule.zsegn is null
          then curr_to_decfloat_amount( Prdp.Ziman )
        when Prdo.ziman <> 0 and Prdp.Ziman is not null
          then curr_to_decfloat_amount( Prdp.Ziman ) * ( case when SignRule.zsegn = '-1' then -1 else 1 end )
        when SignRule.zsegn is null 
          then curr_to_decfloat_amount( Prdo.zimmg )
        else curr_to_decfloat_amount( Prdo.zimmg ) * ( case when SignRule.zsegn = '-1' then -1 else 1 end )
      end as abap.dec( 23, 2 ) ) as ImpMatur,

      cast(
        ( case
            when SignRule.zsegn is null then
              case when Prdo.ziman <> 0 then curr_to_decfloat_amount( Prdo.ziman ) else curr_to_decfloat_amount( Prdo.zimco ) end
            else
              case when Prdo.ziman <> 0 then curr_to_decfloat_amount( Prdo.ziman ) else curr_to_decfloat_amount( Prdo.zimco ) end
              * ( case when SignRule.zsegn = '-1' then -1 else 1 end )
          end )
        -
        ( case
            when Prdo.ziman <> 0 and Prdp.Ziman is not null and SignRule.zsegn is null
              then curr_to_decfloat_amount( Prdp.Ziman )
            when Prdo.ziman <> 0 and Prdp.Ziman is not null
              then curr_to_decfloat_amount( Prdp.Ziman ) * ( case when SignRule.zsegn = '-1' then -1 else 1 end )
            when SignRule.zsegn is null 
              then curr_to_decfloat_amount( Prdo.zimmg )
            else curr_to_decfloat_amount( Prdo.zimmg ) * ( case when SignRule.zsegn = '-1' then -1 else 1 end )
          end )
      as abap.dec( 23, 2 ) ) as ImpDaMat,

      cast( case
        when Prdo.ziman <> 0 and Prdp.Zirec is not null and SignRule.zsegn is null
          then curr_to_decfloat_amount( Prdp.Zirec )
        when Prdo.ziman <> 0 and Prdp.Zirec is not null
          then curr_to_decfloat_amount( Prdp.Zirec ) * ( case when SignRule.zsegn = '-1' then -1 else 1 end )
        else 0
      end as abap.dec( 23, 2 ) ) as ImpRecup,

      Prdp.Zidfs             as Zidfs,
      Prdp.Zamcf             as Zamcf,
      Prdp.Ztpcd             as Ztpcd,
      Prdp.zwaersp           as Zwaersp,
      Prdp.Zkurrfp           as Zkurrfp,
      Prdp.Zpercsosp         as Zpercsosp
}
where LastAgent.zcdaz is not null
  and Prdo.zstre <> 'D'


    
