CLASS /eacm/cl_rpriepprv_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES tt_r_bukrs TYPE RANGE OF bukrs.
    TYPES tt_r_fkdat TYPE RANGE OF fkdat.
    TYPES tt_r_vkorg TYPE RANGE OF vkorg.
    TYPES tt_r_zclpr TYPE RANGE OF /eacm/zclpr.
    TYPES tt_r_ztpag TYPE RANGE OF /eacm/ztpag.
    TYPES tt_r_zcdaz TYPE RANGE OF /eacm/zcdaz.
    TYPES tt_r_vbeln TYPE RANGE OF vbeln.
    TYPES tt_r_kunrg TYPE RANGE OF kunnr.
    TYPES tt_r_zutmx TYPE RANGE OF /eacm/zutmx.
    TYPES tt_r_budat TYPE RANGE OF budat.

    TYPES:
      BEGIN OF ty_riep_action_input,
        CompanyCodeFrom   TYPE bukrs,
        CompanyCodeTo     TYPE bukrs,
        BillingDateFrom   TYPE fkdat,
        BillingDateTo     TYPE fkdat,
        SalesOrgFrom      TYPE vkorg,
        SalesOrgTo        TYPE vkorg,
        CommissionClassFrom TYPE /eacm/zclpr,
        CommissionClassTo TYPE /eacm/zclpr,
        AgentTypeFrom     TYPE /eacm/ztpag,
        AgentTypeTo       TYPE /eacm/ztpag,
        AgentFrom         TYPE /eacm/zcdaz,
        AgentTo           TYPE /eacm/zcdaz,
        SalesDocumentFrom TYPE vbeln,
        SalesDocumentTo   TYPE vbeln,
        PayerFrom         TYPE kunnr,
        PayerTo           TYPE kunnr,
        MaxDueDateFrom    TYPE /eacm/zutmx,
        MaxDueDateTo      TYPE /eacm/zutmx,
        PostingDateFrom   TYPE budat,
        PostingDateTo     TYPE budat,
        DetailPrint       TYPE abap_boolean,
        PrintWithDueDate  TYPE abap_boolean,
      END OF ty_riep_action_input.

    TYPES:
      BEGIN OF ty_rie_request,
        detail              TYPE abap_bool,
        print_with_due_date TYPE abap_bool,
        r_bukrs             TYPE tt_r_bukrs,
        r_fkdat             TYPE tt_r_fkdat,
        r_vkorg             TYPE tt_r_vkorg,
        r_zclpr             TYPE tt_r_zclpr,
        r_ztpag             TYPE tt_r_ztpag,
        r_zcdaz             TYPE tt_r_zcdaz,
        r_vbeln             TYPE tt_r_vbeln,
        r_kunrg             TYPE tt_r_kunrg,
        r_zutmx             TYPE tt_r_zutmx,
        r_budat             TYPE tt_r_budat,
      END OF ty_rie_request.

    TYPES:
      BEGIN OF ty_rie_detail,
        vkorg          TYPE vkorg,
        vtweg          TYPE vtweg,
        zclpr          TYPE /eacm/zclpr,
        vbeln          TYPE vbeln,
        posnr          TYPE posnr,
        zcdaz          TYPE /eacm/zcdaz,
        zidag          TYPE /eacm/zidag,
        bukrs          TYPE bukrs,
        ztpagdoc       TYPE /eacm/ztpag,
        namea          TYPE /eacm/zname1_gp,
        ztpag          TYPE /eacm/ztpag,
        zdeag          TYPE /eacm/zdeag,
        vkgrp          TYPE vkgrp,
        vkbur          TYPE vkbur,
        waerk          TYPE waers,
        zzwaer         TYPE /eacm/zcuky,
        kunrg          TYPE kunnr,
        fkart          TYPE fkart,
        vbtyp          TYPE vbtyp,
        fkdat          TYPE fkdat,
        belnr          TYPE belnr_d,
        bldat          TYPE bldat,
        budat          TYPE budat,
        blart          TYPE blart,
        matnr          TYPE matnr,
        maktx          TYPE maktx,
        zutmx          TYPE /eacm/zutmx,
        zstre          TYPE /eacm/zstre,
        zpcpr          TYPE /eacm/zpercag3,
        zdest          TYPE /eacm/zdest,
        zhistor        TYPE /eacm/histordo,
        zabin          TYPE /eacm/zabin,
        kostl          TYPE kostl,
        ztprv          TYPE /eacm/ztprv,
        kurrf          TYPE /eacm/zkurrf,
        ziman          TYPE /eacm/ziman,
        signmultiplier TYPE i,
        zimpp          TYPE /eacm/zimpp,
        zimco          TYPE /eacm/zimco,
        zimmg          TYPE /eacm/zimmg,
        zidfs          TYPE /eacm/zidfs,
        zamcf          TYPE /eacm/zamcf,
        ztpcd          TYPE /eacm/ztpcd,
        zwaersp        TYPE /eacm/zwaersp,
        zkurrfp        TYPE /eacm/zkurrfp,
        zpercsosp      TYPE /eacm/zpercsosp,
        zzinc          TYPE /eacm/zzincasso,
        imp_provv      TYPE /eacm/zimco,
        imp_matur      TYPE /eacm/zimmg,
        imp_da_mat     TYPE /eacm/zimmg,
        imp_recup      TYPE /eacm/zirec,
      END OF ty_rie_detail.
    TYPES tt_rie_detail TYPE STANDARD TABLE OF ty_rie_detail WITH EMPTY KEY.

    CLASS-METHODS get_data
      IMPORTING
        is_request TYPE ty_rie_request
      EXPORTING
        et_detail  TYPE tt_rie_detail
        et_summary TYPE tt_rie_detail.

    CLASS-METHODS get_detail
      IMPORTING
        is_request         TYPE ty_rie_request
      RETURNING
        VALUE(rt_detail)   TYPE tt_rie_detail.

    CLASS-METHODS build_summary
      IMPORTING
        it_detail          TYPE tt_rie_detail
      RETURNING
        VALUE(rt_summary)  TYPE tt_rie_detail.

  PRIVATE SECTION.
    CLASS-METHODS aggregate_riepilogo_documents
      IMPORTING
        it_detail             TYPE tt_rie_detail
      RETURNING
        VALUE(rt_riepilogo)   TYPE tt_rie_detail.

    CLASS-METHODS enrich_advance_values
      IMPORTING
        is_request TYPE ty_rie_request
      CHANGING
        ct_riepilogo TYPE tt_rie_detail.

    CLASS-METHODS calculate_business_amounts
      CHANGING
        ct_riepilogo TYPE tt_rie_detail.
ENDCLASS.

CLASS /eacm/cl_rpriepprv_data IMPLEMENTATION.
  METHOD get_data.
    " Punto unico di orchestrazione dati:
    " legge il dettaglio e poi, in base al flag, prepara dettaglio o riepilogo.
    CLEAR: et_detail, et_summary.

    et_detail = get_detail( is_request ).

    IF is_request-detail = abap_true.
      enrich_advance_values(
        EXPORTING
          is_request = is_request
        CHANGING
          ct_riepilogo = et_detail ).

      calculate_business_amounts(
        CHANGING
          ct_riepilogo = et_detail ).
    ELSE.
      et_summary = build_summary( et_detail ).

      enrich_advance_values(
        EXPORTING
          is_request = is_request
        CHANGING
          ct_riepilogo = et_summary ).

      calculate_business_amounts(
        CHANGING
          ct_riepilogo = et_summary ).
    ENDIF.
  ENDMETHOD.

  METHOD get_detail.
    DATA lv_has_bukrs TYPE c LENGTH 1.
    DATA lv_has_fkdat TYPE c LENGTH 1.
    DATA lv_has_vkorg TYPE c LENGTH 1.
    DATA lv_has_zclpr TYPE c LENGTH 1.
    DATA lv_has_ztpag TYPE c LENGTH 1.
    DATA lv_has_zcdaz TYPE c LENGTH 1.
    DATA lv_has_vbeln TYPE c LENGTH 1.
    DATA lv_has_kunrg TYPE c LENGTH 1.
    DATA lv_has_zutmx TYPE c LENGTH 1.
    DATA lv_has_budat TYPE c LENGTH 1.

    IF is_request-r_bukrs IS NOT INITIAL.
      lv_has_bukrs = 'X'.
    ENDIF.
    IF is_request-r_fkdat IS NOT INITIAL.
      lv_has_fkdat = 'X'.
    ENDIF.
    IF is_request-r_vkorg IS NOT INITIAL.
      lv_has_vkorg = 'X'.
    ENDIF.
    IF is_request-r_zclpr IS NOT INITIAL.
      lv_has_zclpr = 'X'.
    ENDIF.
    IF is_request-r_ztpag IS NOT INITIAL.
      lv_has_ztpag = 'X'.
    ENDIF.
    IF is_request-r_zcdaz IS NOT INITIAL.
      lv_has_zcdaz = 'X'.
    ENDIF.
    IF is_request-r_vbeln IS NOT INITIAL.
      lv_has_vbeln = 'X'.
    ENDIF.
    IF is_request-r_kunrg IS NOT INITIAL.
      lv_has_kunrg = 'X'.
    ENDIF.
    IF is_request-r_zutmx IS NOT INITIAL.
      lv_has_zutmx = 'X'.
    ENDIF.
    IF is_request-r_budat IS NOT INITIAL.
      lv_has_budat = 'X'.
    ENDIF.

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
        Zidfs,
        Zamcf,
        Ztpcd,
        Zwaersp,
        Zkurrfp,
        Zpercsosp
      WHERE ( @lv_has_bukrs = '' OR Bukrs IN @is_request-r_bukrs )
        AND ( @lv_has_fkdat = '' OR Fkdat IN @is_request-r_fkdat )
        AND ( @lv_has_vkorg = '' OR Vkorg IN @is_request-r_vkorg )
        AND ( @lv_has_zclpr = '' OR Zclpr IN @is_request-r_zclpr )
        AND ( @lv_has_ztpag = '' OR ZtpagDoc IN @is_request-r_ztpag )
        AND ( @lv_has_zcdaz = '' OR Zcdaz IN @is_request-r_zcdaz )
        AND ( @lv_has_vbeln = '' OR Vbeln IN @is_request-r_vbeln )
        AND ( @lv_has_kunrg = '' OR Kunrg IN @is_request-r_kunrg )
        AND ( @lv_has_zutmx = '' OR Zutmx IN @is_request-r_zutmx )
        AND ( @lv_has_budat = '' OR Budat IN @is_request-r_budat )
      INTO CORRESPONDING FIELDS OF TABLE @rt_detail.

    SORT rt_detail BY vkorg vtweg zclpr vbeln zcdaz posnr zidag.
  ENDMETHOD.

  METHOD build_summary.
    rt_summary = aggregate_riepilogo_documents( it_detail ).
  ENDMETHOD.

  METHOD aggregate_riepilogo_documents.
    DATA ls_grouped TYPE ty_rie_detail.
    DATA lv_old_vkorg TYPE vkorg.
    DATA lv_old_vtweg TYPE vtweg.
    DATA lv_old_zclpr TYPE /eacm/zclpr.
    DATA lv_old_vbeln TYPE vbeln.
    DATA lv_old_zcdaz TYPE /eacm/zcdaz.
    DATA lv_old_waerk TYPE waers.
    DATA lv_group_open TYPE abap_bool.

    DATA lv_imp_vbeln TYPE vbeln.
    DATA lv_imp_posnr TYPE posnr.
    DATA lv_imp_zcdaz TYPE /eacm/zcdaz.
    DATA lv_imp_zidag TYPE /eacm/zidag.

    " Il report originale non raggruppa per solo agente:
    " accorpa per documento + agente, mantenendo anche la valuta.
    " Le chiavi effettive sono quindi:
    " vkorg / vtweg / zclpr / vbeln / zcdaz / waerk.
    LOOP AT it_detail ASSIGNING FIELD-SYMBOL(<detail>).
      IF lv_group_open = abap_false
         OR lv_old_vkorg <> <detail>-vkorg
         OR lv_old_vtweg <> <detail>-vtweg
         OR lv_old_zclpr <> <detail>-zclpr
         OR lv_old_vbeln <> <detail>-vbeln
         OR lv_old_zcdaz <> <detail>-zcdaz
         OR lv_old_waerk <> <detail>-waerk.

        IF lv_group_open = abap_true.
          APPEND ls_grouped TO rt_riepilogo.
        ENDIF.

        ls_grouped = <detail>.
        CLEAR: ls_grouped-posnr,
               ls_grouped-zidag,
               ls_grouped-matnr,
               ls_grouped-maktx,
               ls_grouped-zutmx,
               ls_grouped-zpcpr,
               ls_grouped-zhistor,
               ls_grouped-zabin,
               ls_grouped-kostl,
               ls_grouped-zdest,
               ls_grouped-budat,
               ls_grouped-zstre,
               ls_grouped-zidfs,
               ls_grouped-zamcf,
               ls_grouped-ztpcd,
               ls_grouped-zwaersp,
               ls_grouped-zkurrfp,
               ls_grouped-zpercsosp,
               ls_grouped-zzinc,
               ls_grouped-imp_provv,
               ls_grouped-imp_matur,
               ls_grouped-imp_da_mat,
               ls_grouped-imp_recup.
        CLEAR: lv_imp_vbeln, lv_imp_posnr, lv_imp_zcdaz, lv_imp_zidag.
        lv_group_open = abap_true.
      ELSE.
        ls_grouped-zimco += <detail>-zimco.
        ls_grouped-zimmg += <detail>-zimmg.
        ls_grouped-ziman += <detail>-ziman.
      ENDIF.

      IF lv_imp_vbeln <> <detail>-vbeln
         OR lv_imp_posnr <> <detail>-posnr
         OR lv_imp_zcdaz <> <detail>-zcdaz
         OR lv_imp_zidag <> <detail>-zidag.
        ls_grouped-zimpp += <detail>-zimpp.
      ENDIF.

      lv_old_vkorg = <detail>-vkorg.
      lv_old_vtweg = <detail>-vtweg.
      lv_old_zclpr = <detail>-zclpr.
      lv_old_vbeln = <detail>-vbeln.
      lv_old_zcdaz = <detail>-zcdaz.
      lv_old_waerk = <detail>-waerk.

      lv_imp_vbeln = <detail>-vbeln.
      lv_imp_posnr = <detail>-posnr.
      lv_imp_zcdaz = <detail>-zcdaz.
      lv_imp_zidag = <detail>-zidag.
    ENDLOOP.

    IF lv_group_open = abap_true.
      APPEND ls_grouped TO rt_riepilogo.
    ENDIF.
  ENDMETHOD.

  METHOD enrich_advance_values.
    TYPES:
      BEGIN OF ty_prdp_sum,
        ziman TYPE /eacm/ziman,
        zirec TYPE /eacm/zirec,
        zzinc TYPE /eacm/zzincasso,
      END OF ty_prdp_sum.

    DATA ls_prdp_detail TYPE ty_prdp_sum.
    DATA ls_prdp_doc TYPE ty_prdp_sum.

    " Qui recuperiamo gli importi collegati agli anticipi dal PRDP:
    " a livello riga se siamo in dettaglio, a livello documento se siamo in riepilogo.
    LOOP AT ct_riepilogo ASSIGNING FIELD-SYMBOL(<rie>).
      CLEAR: ls_prdp_detail, ls_prdp_doc.

      IF is_request-detail = abap_true.
        SELECT SINGLE
          SUM( ziman ) AS ziman,
          SUM( zirec ) AS zirec,
          SUM( zinc ) AS zzinc
          FROM /eacm/zprdp
          WHERE vkorg = @<rie>-vkorg
            AND vtweg = @<rie>-vtweg
            AND zclpr = @<rie>-zclpr
            AND vbeln = @<rie>-vbeln
            AND posnr = @<rie>-posnr
            AND zcdaz = @<rie>-zcdaz
            AND zidag = @<rie>-zidag
            AND zstre <> 'D'
          INTO CORRESPONDING FIELDS OF @ls_prdp_detail.
      ELSE.
        SELECT SINGLE
          SUM( ziman ) AS ziman,
          SUM( zirec ) AS zirec,
          SUM( zinc ) AS zzinc
          FROM /eacm/zprdp
          WHERE vkorg = @<rie>-vkorg
            AND vtweg = @<rie>-vtweg
            AND zclpr = @<rie>-zclpr
            AND vbeln = @<rie>-vbeln
            AND zcdaz = @<rie>-zcdaz
            AND zstre <> 'D'
          INTO CORRESPONDING FIELDS OF @ls_prdp_doc.
      ENDIF.

      IF is_request-detail = abap_true.
        IF <rie>-ziman IS NOT INITIAL.
          <rie>-zimmg = ls_prdp_detail-ziman * <rie>-signmultiplier.
          <rie>-imp_recup = ls_prdp_detail-zirec * <rie>-signmultiplier.
          <rie>-zzinc = ls_prdp_detail-zzinc * <rie>-signmultiplier.
        ENDIF.
      ELSE.
        IF <rie>-ziman IS NOT INITIAL.
          <rie>-zimmg = ls_prdp_doc-ziman * <rie>-signmultiplier.
          <rie>-imp_recup = ls_prdp_doc-zirec * <rie>-signmultiplier.
          <rie>-zzinc = ls_prdp_doc-zzinc * <rie>-signmultiplier.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD calculate_business_amounts.
    " Traduzione finale nei campi business letti dal PDF.
    LOOP AT ct_riepilogo ASSIGNING FIELD-SYMBOL(<rie>).
      CLEAR: <rie>-imp_provv,
             <rie>-imp_matur,
             <rie>-imp_da_mat.

      IF <rie>-ziman IS NOT INITIAL.
        <rie>-imp_provv = <rie>-ziman.
        <rie>-imp_matur = <rie>-zimmg.
        <rie>-imp_da_mat = <rie>-imp_provv - <rie>-imp_matur.
      ELSE.
        <rie>-imp_provv = <rie>-zimco.
        <rie>-imp_matur = <rie>-zimmg.
        <rie>-imp_da_mat = <rie>-imp_provv - <rie>-imp_matur.
        CLEAR <rie>-imp_recup.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

