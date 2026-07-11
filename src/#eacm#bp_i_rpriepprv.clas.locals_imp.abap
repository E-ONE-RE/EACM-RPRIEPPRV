CLASS lhc_CommissionSummary DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR CommissionSummary RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ CommissionSummary RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK CommissionSummary.

ENDCLASS.

CLASS lhc_CommissionSummary IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD read.
    SELECT FROM /eacm/i_rpriepprv
      FIELDS
        Vkorg,
        Vtweg,
        Zclpr,
        Vbeln,
        Posnr,
        Zcdaz,
        Zidag,
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
      FOR ALL ENTRIES IN @keys
      WHERE Vkorg = @keys-Vkorg
        AND Vtweg = @keys-Vtweg
        AND Zclpr = @keys-Zclpr
        AND Vbeln = @keys-Vbeln
        AND Posnr = @keys-Posnr
        AND Zcdaz = @keys-Zcdaz
        AND Zidag = @keys-Zidag
      INTO CORRESPONDING FIELDS OF TABLE @result.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_I_RPRIEPPRV DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_I_RPRIEPPRV IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
    " Nessun salvataggio tecnico:
    " il PDF passa dalla URL PdfDownload e non da una staging table.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
