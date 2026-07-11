CLASS /eacm/cl_rpriepprv_pdf_qry DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
ENDCLASS.

CLASS /eacm/cl_rpriepprv_pdf_qry IMPLEMENTATION.
  METHOD if_rap_query_provider~select.
    TYPES:
      BEGIN OF ty_result,
        companycodefrom     TYPE bukrs,
        companycodeto       TYPE bukrs,
        billingdatefrom     TYPE c LENGTH 8,
        billingdateto       TYPE c LENGTH 8,
        salesorgfrom        TYPE vkorg,
        salesorgto          TYPE vkorg,
        commissionclassfrom TYPE /eacm/zclpr,
        commissionclassto   TYPE /eacm/zclpr,
        agenttypefrom       TYPE /eacm/ztpag,
        agenttypeto         TYPE /eacm/ztpag,
        agentfrom           TYPE /eacm/zcdaz,
        agentto             TYPE /eacm/zcdaz,
        salesdocumentfrom   TYPE vbeln,
        salesdocumentto     TYPE vbeln,
        payerfrom           TYPE kunnr,
        payerto             TYPE kunnr,
        maxduedatefrom      TYPE c LENGTH 8,
        maxduedateto        TYPE c LENGTH 8,
        postingdatefrom     TYPE c LENGTH 8,
        postingdateto       TYPE c LENGTH 8,
        detailprint         TYPE abap_boolean,
        printwithduedate    TYPE abap_boolean,
        bukrs               TYPE bukrs,
        fkdat               TYPE fkdat,
        vkorg               TYPE vkorg,
        zclpr               TYPE /eacm/zclpr,
        zcdaz               TYPE /eacm/zcdaz,
        vbeln               TYPE vbeln,
        kunrg               TYPE kunnr,
        zutmx               TYPE /eacm/zutmx,
        budat               TYPE budat,
        attachment          TYPE xstring,
        mimetype            TYPE c LENGTH 128,
        filename            TYPE c LENGTH 255,
      END OF ty_result.

    DATA lt_result TYPE STANDARD TABLE OF ty_result WITH EMPTY KEY.
    DATA lt_ranges TYPE if_rap_query_filter=>tt_name_range_pairs.
    DATA ls_request TYPE /eacm/cl_rpriepprv_data=>ty_rie_request.
    DATA ls_input TYPE /eacm/cl_rpriepprv_data=>ty_riep_action_input.
    DATA lt_detail TYPE /eacm/cl_rpriepprv_data=>tt_rie_detail.
    DATA lt_summary TYPE /eacm/cl_rpriepprv_data=>tt_rie_detail.
    DATA lt_pdf_data TYPE /eacm/cl_rpriepprv_data=>tt_rie_detail.
    DATA lv_pdf TYPE xstring.
    DATA lv_total_records TYPE int8.
    DATA lv_name TYPE string.
    DATA lv_use_direct_filters TYPE abap_bool.
    DATA lo_paging TYPE REF TO if_rap_query_paging.
    DATA lv_page_size TYPE i.
    DATA lv_offset TYPE i.
    DATA lt_paged_result TYPE STANDARD TABLE OF ty_result WITH EMPTY KEY.

    FIELD-SYMBOLS:
      <range_pair> LIKE LINE OF lt_ranges,
      <first_row>  TYPE /eacm/cl_rpriepprv_data=>ty_rie_detail,
      <result_row> TYPE ty_result.

    " RAP richiede che anche una custom entity tecnica copra formalmente il paging.
    " Anche se qui restituiamo al massimo una sola riga, leggiamo comunque il contesto.
    lo_paging = io_request->get_paging( ).
    lv_page_size = lo_paging->get_page_size( ).
    lv_offset = lo_paging->get_offset( ).

    " Il frontend passa i filtri gia applicati nel List Report.
    TRY.
        lt_ranges = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range.
        CLEAR lt_ranges.
    ENDTRY.

    LOOP AT lt_ranges ASSIGNING <range_pair>.
      lv_name = <range_pair>-name.
      TRANSLATE lv_name TO UPPER CASE.

      READ TABLE <range_pair>-range ASSIGNING FIELD-SYMBOL(<range>) INDEX 1.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      CASE lv_name.
        WHEN 'DETAILPRINT'.
          ls_input-DetailPrint = COND abap_boolean(
            WHEN <range>-low = 'true' OR <range>-low = 'X' OR <range>-low = '1'
            THEN abap_true ELSE abap_false ).

        WHEN 'PRINTWITHDUEDATE'.
          ls_input-PrintWithDueDate = COND abap_boolean(
            WHEN <range>-low = 'true' OR <range>-low = 'X' OR <range>-low = '1'
            THEN abap_true ELSE abap_false ).

        WHEN 'BUKRS'.
          lv_use_direct_filters = abap_true.
          ls_input-CompanyCodeFrom = <range>-low.
          ls_input-CompanyCodeTo = COND #(
            WHEN <range>-high IS NOT INITIAL THEN <range>-high
            ELSE <range>-low ).
          LOOP AT <range_pair>-range ASSIGNING FIELD-SYMBOL(<range_bukrs>).
            APPEND VALUE #(
              sign   = <range_bukrs>-sign
              option = <range_bukrs>-option
              low    = <range_bukrs>-low
              high   = <range_bukrs>-high ) TO ls_request-r_bukrs.
          ENDLOOP.

        WHEN 'FKDAT'.
          lv_use_direct_filters = abap_true.
          ls_input-BillingDateFrom = <range>-low.
          ls_input-BillingDateTo = COND #(
            WHEN <range>-high IS NOT INITIAL THEN <range>-high
            ELSE <range>-low ).
          LOOP AT <range_pair>-range ASSIGNING FIELD-SYMBOL(<range_fkdat>).
            APPEND VALUE #(
              sign   = <range_fkdat>-sign
              option = <range_fkdat>-option
              low    = <range_fkdat>-low
              high   = <range_fkdat>-high ) TO ls_request-r_fkdat.
          ENDLOOP.

        WHEN 'VKORG'.
          lv_use_direct_filters = abap_true.
          ls_input-SalesOrgFrom = <range>-low.
          ls_input-SalesOrgTo = COND #(
            WHEN <range>-high IS NOT INITIAL THEN <range>-high
            ELSE <range>-low ).
          LOOP AT <range_pair>-range ASSIGNING FIELD-SYMBOL(<range_vkorg>).
            APPEND VALUE #(
              sign   = <range_vkorg>-sign
              option = <range_vkorg>-option
              low    = <range_vkorg>-low
              high   = <range_vkorg>-high ) TO ls_request-r_vkorg.
          ENDLOOP.

        WHEN 'ZCLPR'.
          lv_use_direct_filters = abap_true.
          ls_input-CommissionClassFrom = <range>-low.
          ls_input-CommissionClassTo = COND #(
            WHEN <range>-high IS NOT INITIAL THEN <range>-high
            ELSE <range>-low ).
          LOOP AT <range_pair>-range ASSIGNING FIELD-SYMBOL(<range_zclpr>).
            APPEND VALUE #(
              sign   = <range_zclpr>-sign
              option = <range_zclpr>-option
              low    = <range_zclpr>-low
              high   = <range_zclpr>-high ) TO ls_request-r_zclpr.
          ENDLOOP.

        WHEN 'ZCDAZ'.
          lv_use_direct_filters = abap_true.
          ls_input-AgentFrom = <range>-low.
          ls_input-AgentTo = COND #(
            WHEN <range>-high IS NOT INITIAL THEN <range>-high
            ELSE <range>-low ).
          LOOP AT <range_pair>-range ASSIGNING FIELD-SYMBOL(<range_zcdaz>).
            APPEND VALUE #(
              sign   = <range_zcdaz>-sign
              option = <range_zcdaz>-option
              low    = <range_zcdaz>-low
              high   = <range_zcdaz>-high ) TO ls_request-r_zcdaz.
          ENDLOOP.

        WHEN 'VBELN'.
          lv_use_direct_filters = abap_true.
          ls_input-SalesDocumentFrom = <range>-low.
          ls_input-SalesDocumentTo = COND #(
            WHEN <range>-high IS NOT INITIAL THEN <range>-high
            ELSE <range>-low ).
          LOOP AT <range_pair>-range ASSIGNING FIELD-SYMBOL(<range_vbeln>).
            APPEND VALUE #(
              sign   = <range_vbeln>-sign
              option = <range_vbeln>-option
              low    = <range_vbeln>-low
              high   = <range_vbeln>-high ) TO ls_request-r_vbeln.
          ENDLOOP.

        WHEN 'KUNRG'.
          lv_use_direct_filters = abap_true.
          ls_input-PayerFrom = <range>-low.
          ls_input-PayerTo = COND #(
            WHEN <range>-high IS NOT INITIAL THEN <range>-high
            ELSE <range>-low ).
          LOOP AT <range_pair>-range ASSIGNING FIELD-SYMBOL(<range_kunrg>).
            APPEND VALUE #(
              sign   = <range_kunrg>-sign
              option = <range_kunrg>-option
              low    = <range_kunrg>-low
              high   = <range_kunrg>-high ) TO ls_request-r_kunrg.
          ENDLOOP.

        WHEN 'ZUTMX'.
          lv_use_direct_filters = abap_true.
          ls_input-MaxDueDateFrom = <range>-low.
          ls_input-MaxDueDateTo = COND #(
            WHEN <range>-high IS NOT INITIAL THEN <range>-high
            ELSE <range>-low ).
          LOOP AT <range_pair>-range ASSIGNING FIELD-SYMBOL(<range_zutmx>).
            APPEND VALUE #(
              sign   = <range_zutmx>-sign
              option = <range_zutmx>-option
              low    = <range_zutmx>-low
              high   = <range_zutmx>-high ) TO ls_request-r_zutmx.
          ENDLOOP.

        WHEN 'BUDAT'.
          lv_use_direct_filters = abap_true.
          ls_input-PostingDateFrom = <range>-low.
          ls_input-PostingDateTo = COND #(
            WHEN <range>-high IS NOT INITIAL THEN <range>-high
            ELSE <range>-low ).
          LOOP AT <range_pair>-range ASSIGNING FIELD-SYMBOL(<range_budat>).
            APPEND VALUE #(
              sign   = <range_budat>-sign
              option = <range_budat>-option
              low    = <range_budat>-low
              high   = <range_budat>-high ) TO ls_request-r_budat.
          ENDLOOP.
      ENDCASE.
    ENDLOOP.

    " Non stampiamo a vuoto:
    " serve almeno un filtro business arrivato dalla filter bar.
    IF lv_use_direct_filters <> abap_true.
      io_response->set_total_number_of_records( 0 ).
      io_response->set_data( lt_result ).
      RETURN.
    ENDIF.

    " Il popup frontend passa il flag DetailPrint:
    " qui decidiamo quale dataset reale stampare.
    ls_request-detail = xsdbool( ls_input-DetailPrint = abap_true ).
    ls_request-print_with_due_date = ls_input-PrintWithDueDate.

    /eacm/cl_rpriepprv_data=>get_data(
      EXPORTING
        is_request = ls_request
      IMPORTING
        et_detail  = lt_detail
        et_summary = lt_summary ).

    IF ls_input-DetailPrint = abap_true.
      lt_pdf_data = lt_detail.
    ELSE.
      lt_pdf_data = lt_summary.
    ENDIF.

    " La prima riga serve anche a completare i campi di testata
    " se il filtro alto non li ha valorizzati tutti.
    READ TABLE lt_pdf_data ASSIGNING <first_row> INDEX 1.
    IF sy-subrc <> 0.
      io_response->set_total_number_of_records( 0 ).
      io_response->set_data( lt_result ).
      RETURN.
    ENDIF.

    IF ls_input-CompanyCodeFrom IS INITIAL.
      ls_input-CompanyCodeFrom = <first_row>-bukrs.
    ENDIF.
    IF ls_input-BillingDateFrom IS INITIAL.
      ls_input-BillingDateFrom = <first_row>-fkdat.
    ENDIF.
    IF ls_input-SalesOrgFrom IS INITIAL.
      ls_input-SalesOrgFrom = <first_row>-vkorg.
    ENDIF.
    IF ls_input-CommissionClassFrom IS INITIAL.
      ls_input-CommissionClassFrom = <first_row>-zclpr.
    ENDIF.
    IF ls_input-AgentFrom IS INITIAL.
      ls_input-AgentFrom = <first_row>-zcdaz.
    ENDIF.
    IF ls_input-SalesDocumentFrom IS INITIAL.
      ls_input-SalesDocumentFrom = <first_row>-vbeln.
    ENDIF.
    IF ls_input-PayerFrom IS INITIAL.
      ls_input-PayerFrom = <first_row>-kunrg.
    ENDIF.
    IF ls_input-MaxDueDateFrom IS INITIAL.
      ls_input-MaxDueDateFrom = <first_row>-zutmx.
    ENDIF.
    IF ls_input-PostingDateFrom IS INITIAL.
      ls_input-PostingDateFrom = <first_row>-budat.
    ENDIF.

    TRY.
        lv_pdf = /eacm/cl_rpriepprv_form=>get_pdf_from_data(
          is_action_input = ls_input
          it_riepilogo    = lt_pdf_data ).
      CATCH cx_root.
        CLEAR lv_pdf.
    ENDTRY.

    IF lv_pdf IS INITIAL.
      io_response->set_total_number_of_records( 0 ).
      io_response->set_data( lt_result ).
      RETURN.
    ENDIF.

    APPEND VALUE #(
      companycodefrom     = ls_input-CompanyCodeFrom
      companycodeto       = ls_input-CompanyCodeTo
      billingdatefrom     = |{ ls_input-BillingDateFrom }|
      billingdateto       = |{ ls_input-BillingDateTo }|
      salesorgfrom        = ls_input-SalesOrgFrom
      salesorgto          = ls_input-SalesOrgTo
      commissionclassfrom = ls_input-CommissionClassFrom
      commissionclassto   = ls_input-CommissionClassTo
      agenttypefrom       = ls_input-AgentTypeFrom
      agenttypeto         = ls_input-AgentTypeTo
      agentfrom           = ls_input-AgentFrom
      agentto             = ls_input-AgentTo
      salesdocumentfrom   = ls_input-SalesDocumentFrom
      salesdocumentto     = ls_input-SalesDocumentTo
      payerfrom           = ls_input-PayerFrom
      payerto             = ls_input-PayerTo
      maxduedatefrom      = |{ ls_input-MaxDueDateFrom }|
      maxduedateto        = |{ ls_input-MaxDueDateTo }|
      postingdatefrom     = |{ ls_input-PostingDateFrom }|
      postingdateto       = |{ ls_input-PostingDateTo }|
      detailprint         = ls_input-DetailPrint
      printwithduedate    = ls_input-PrintWithDueDate
      bukrs               = ls_input-CompanyCodeFrom
      fkdat               = ls_input-BillingDateFrom
      vkorg               = ls_input-SalesOrgFrom
      zclpr               = ls_input-CommissionClassFrom
      zcdaz               = ls_input-AgentFrom
      vbeln               = ls_input-SalesDocumentFrom
      kunrg               = ls_input-PayerFrom
      zutmx               = ls_input-MaxDueDateFrom
      budat               = ls_input-PostingDateFrom
      attachment          = lv_pdf
      mimetype            = 'application/pdf'
      filename            = /eacm/cl_rpriepprv_form=>build_file_name( ls_input ) ) TO lt_result.

    lv_total_records = lines( lt_result ).

    IF io_request->is_total_numb_of_rec_requested( ).
      io_response->set_total_number_of_records( lv_total_records ).
    ENDIF.

    IF io_request->is_data_requested( ).
      IF lv_page_size >= 0.
        LOOP AT lt_result ASSIGNING <result_row>.
          IF sy-tabix <= lv_offset.
            CONTINUE.
          ENDIF.

          IF lines( lt_paged_result ) >= lv_page_size.
            EXIT.
          ENDIF.

          APPEND <result_row> TO lt_paged_result.
        ENDLOOP.

        io_response->set_data( lt_paged_result ).
      ELSE.
        io_response->set_data( lt_result ).
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

