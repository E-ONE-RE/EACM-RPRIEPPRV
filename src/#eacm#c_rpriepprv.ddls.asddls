@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Riepilogo provvigioni'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

define root view entity /EACM/C_RPRIEPPRV
  provider contract transactional_query

  as projection on /EACM/I_RPRIEPPRV
{
  key Vkorg,
  key Vtweg,
  key Zclpr,
  key Vbeln,
  key Posnr,
  key Zcdaz,
  key Zidag,

  Bukrs,
  ZtpagDoc,
  Namea,
  Ztpag,
  Zdeag,
  Vkgrp,
  Vkbur,
  Waerk,
  Zzwaer,
  Kunrg,
  Fkart,
  Vbtyp,
  Fkdat,
  Belnr,
  Bldat,
  Budat,
  Blart,
  Matnr,
  Maktx,
  Zutmx,
  Zstre,
  Zpcpr,
  Zdest,
  Zhistor,
  Zabin,
  Kostl,
  Ztprv,
  Kurrf,
  SignMultiplier,
  Zimpp,
  Zimco,
  Zimmg,
  Ziman,
  ImpProvv,
  ImpMatur,
  ImpDaMat,
  ImpRecup,
  Zidfs,
  Zamcf,
  Ztpcd,
  Zwaersp,
  Zkurrfp,
  Zpercsosp
}
