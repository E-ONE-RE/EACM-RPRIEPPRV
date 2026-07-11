CLASS /eacm/cl_rpriepprv_form DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CLASS-METHODS get_pdf_from_data
      IMPORTING
        is_action_input TYPE /eacm/cl_rpriepprv_data=>ty_riep_action_input
        it_riepilogo    TYPE /eacm/cl_rpriepprv_data=>tt_rie_detail
      RETURNING VALUE(rv_pdf) TYPE xstring
      RAISING
        cx_fp_fdp_error
        cx_fp_form_reader
        cx_fp_ads_util.

    CLASS-METHODS build_file_name
      IMPORTING
        is_action_input TYPE /eacm/cl_rpriepprv_data=>ty_riep_action_input
      RETURNING VALUE(rv_file_name) TYPE string.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_customer_text,
        kunrg TYPE kunnr,
        name1 TYPE string,
      END OF ty_customer_text.
    TYPES tt_customer_text TYPE HASHED TABLE OF ty_customer_text
      WITH UNIQUE KEY kunrg.
    TYPES ty_scope TYPE c LENGTH 7.

    TYPES:
      BEGIN OF ty_header,
        bukrs          TYPE bukrs,
        fkdat          TYPE fkdat,
        totalzimpp     TYPE /eacm/zimpp,
        totalzimco     TYPE /eacm/zimco,
        totalzimmg     TYPE /eacm/zimmg,
        totalziman     TYPE /eacm/ziman,
        totalimpprovv  TYPE /eacm/zimco,
        totalimpmatur  TYPE /eacm/zimmg,
        totalimpdamat  TYPE /eacm/zimmg,
        totalimprecup  TYPE /eacm/zirec,
      END OF ty_header.

    TYPES:
      BEGIN OF ty_total_by_class,
        bukrs            TYPE bukrs,
        fkdat            TYPE fkdat,
        zcdaz            TYPE /eacm/zcdaz,
        waerk            TYPE waers,
        zclpr            TYPE /eacm/zclpr,
        currencycode     TYPE waers,
        classification   TYPE /eacm/zclpr,
        totalzimpp       TYPE /eacm/zimpp,
        totalzimco       TYPE /eacm/zimco,
        totalzimmg       TYPE /eacm/zimmg,
        totalziman       TYPE /eacm/ziman,
        totalprovvigione TYPE /eacm/zimco,
        totalmaturato    TYPE /eacm/zimmg,
        totaldamaturare  TYPE /eacm/zimmg,
        totalrecupero    TYPE /eacm/zirec,
      END OF ty_total_by_class.
    TYPES tt_total_by_class TYPE SORTED TABLE OF ty_total_by_class
      WITH UNIQUE KEY waerk zclpr.

    TYPES:
      BEGIN OF ty_item,
        bukrs       TYPE bukrs,
        fkdat       TYPE fkdat,
        zcdaz       TYPE /eacm/zcdaz,
        waerk       TYPE waers,
        kunrg       TYPE kunnr,
        vbeln       TYPE vbeln,
        posnr       TYPE posnr,
        zclpr       TYPE /eacm/zclpr,
        belnr       TYPE belnr_d,
        namea       TYPE /eacm/zname1_gp,
        customername TYPE string,
        zidfs       TYPE /eacm/zidfs,
        zamcf       TYPE /eacm/zamcf,
        ztpcd       TYPE /eacm/ztpcd,
        zimpp       TYPE /eacm/zimpp,
        zimco       TYPE /eacm/zimco,
        zimmg       TYPE /eacm/zimmg,
        ziman       TYPE /eacm/ziman,
        impprovv    TYPE /eacm/zimco,
        impmatur    TYPE /eacm/zimmg,
        impdamat    TYPE /eacm/zimmg,
        imprecup    TYPE /eacm/zirec,
      END OF ty_item.
    TYPES tt_item TYPE SORTED TABLE OF ty_item
      WITH UNIQUE KEY fkdat vbeln posnr zclpr belnr.

    TYPES:
      BEGIN OF ty_customer,
        bukrs                TYPE bukrs,
        fkdat                TYPE fkdat,
        zcdaz                TYPE /eacm/zcdaz,
        waerk                TYPE waers,
        kunrg                TYPE kunnr,
        customername         TYPE string,
        customertotalzimpp   TYPE /eacm/zimpp,
        customertotalzimco   TYPE /eacm/zimco,
        customertotalzimmg   TYPE /eacm/zimmg,
        customertotalziman   TYPE /eacm/ziman,
        customertotalprovv   TYPE /eacm/zimco,
        customertotalmatur   TYPE /eacm/zimmg,
        customertotaldamat   TYPE /eacm/zimmg,
        customertotalrecup   TYPE /eacm/zirec,
        items                TYPE tt_item,
      END OF ty_customer.
    TYPES tt_customer TYPE SORTED TABLE OF ty_customer
      WITH UNIQUE KEY kunrg.

    TYPES:
      BEGIN OF ty_currency,
        bukrs               TYPE bukrs,
        fkdat               TYPE fkdat,
        zcdaz               TYPE /eacm/zcdaz,
        waerk               TYPE waers,
        currencytotalzimpp  TYPE /eacm/zimpp,
        currencytotalzimco  TYPE /eacm/zimco,
        currencytotalzimmg  TYPE /eacm/zimmg,
        currencytotalziman  TYPE /eacm/ziman,
        currencytotalprovv  TYPE /eacm/zimco,
        currencytotalmatur  TYPE /eacm/zimmg,
        currencytotaldamat  TYPE /eacm/zimmg,
        currencytotalrecup  TYPE /eacm/zirec,
        customers           TYPE tt_customer,
      END OF ty_currency.
    TYPES tt_currency TYPE SORTED TABLE OF ty_currency
      WITH UNIQUE KEY waerk.

    TYPES:
      BEGIN OF ty_agent_currency_total,
        bukrs                 TYPE bukrs,
        fkdat                 TYPE fkdat,
        zcdaz                 TYPE /eacm/zcdaz,
        waerk                 TYPE waers,
        currencycode          TYPE waers,
        agentcurrencytotalzimpp TYPE /eacm/zimpp,
        agentcurrencytotalzimco TYPE /eacm/zimco,
        agentcurrencytotalzimmg TYPE /eacm/zimmg,
        agentcurrencytotalziman TYPE /eacm/ziman,
        agentcurrencytotalprovv TYPE /eacm/zimco,
        agentcurrencytotalmatur TYPE /eacm/zimmg,
        agentcurrencytotaldamat TYPE /eacm/zimmg,
        agentcurrencytotalrecup TYPE /eacm/zirec,
      END OF ty_agent_currency_total.
    TYPES tt_agent_currency_total TYPE SORTED TABLE OF ty_agent_currency_total
      WITH UNIQUE KEY waerk.

    TYPES:
      BEGIN OF ty_agent,
        bukrs             TYPE bukrs,
        fkdat             TYPE fkdat,
        periodfrom        TYPE string,
        periodto          TYPE string,
        zcdaz             TYPE /eacm/zcdaz,
        namea             TYPE /eacm/zname1_gp,
        agentstate        TYPE c LENGTH 20,
        agenttotalzimpp   TYPE /eacm/zimpp,
        agenttotalzimco   TYPE /eacm/zimco,
        agenttotalzimmg   TYPE /eacm/zimmg,
        agenttotalziman   TYPE /eacm/ziman,
        agenttotalprovv   TYPE /eacm/zimco,
        agenttotalmatur   TYPE /eacm/zimmg,
        agenttotaldamat   TYPE /eacm/zimmg,
        agenttotalrecup   TYPE /eacm/zirec,
        currencies        TYPE tt_currency,
        agentcurrencytotals TYPE tt_agent_currency_total,
        agenttotalsbyclass TYPE tt_total_by_class,
      END OF ty_agent.
    TYPES tt_agent TYPE SORTED TABLE OF ty_agent
      WITH UNIQUE KEY zcdaz.

    TYPES:
      BEGIN OF ty_general,
        bukrs              TYPE bukrs,
        fkdat              TYPE fkdat,
        waerk              TYPE waers,
        currencycode       TYPE waers,
        generaltotalzimpp  TYPE /eacm/zimpp,
        generaltotalzimco  TYPE /eacm/zimco,
        generaltotalzimmg  TYPE /eacm/zimmg,
        generaltotalziman  TYPE /eacm/ziman,
        generaltotalprovv  TYPE /eacm/zimco,
        generaltotalmatur  TYPE /eacm/zimmg,
        generaltotaldamat  TYPE /eacm/zimmg,
        generaltotalrecup  TYPE /eacm/zirec,
        generaltotalsbyclass TYPE tt_total_by_class,
      END OF ty_general.
    TYPES tt_general TYPE SORTED TABLE OF ty_general
      WITH UNIQUE KEY waerk.

    TYPES:
      BEGIN OF ty_form,
        header               TYPE ty_header,
        agents               TYPE tt_agent,
        general              TYPE tt_general,
        generaltotalsbyclass TYPE tt_total_by_class,
      END OF ty_form.

    CLASS-METHODS build_summary_xml
      IMPORTING
        is_action_input TYPE /eacm/cl_rpriepprv_data=>ty_riep_action_input
        it_riepilogo    TYPE /eacm/cl_rpriepprv_data=>tt_rie_detail
      RETURNING VALUE(rv_xml_data) TYPE xstring.

    CLASS-METHODS build_summary_form_model
      IMPORTING
        is_action_input TYPE /eacm/cl_rpriepprv_data=>ty_riep_action_input
        it_riepilogo    TYPE /eacm/cl_rpriepprv_data=>tt_rie_detail
      RETURNING VALUE(rs_form) TYPE ty_form.

    CLASS-METHODS get_customer_texts
      IMPORTING
        it_riepilogo TYPE /eacm/cl_rpriepprv_data=>tt_rie_detail
      RETURNING VALUE(rt_customer_text) TYPE tt_customer_text.

    CLASS-METHODS append_xml_element
      IMPORTING
        io_writer TYPE REF TO if_sxml_writer
        iv_name   TYPE string
        iv_value  TYPE string
      RAISING
        cx_sxml_state_error
        cx_sxml_name_error.

    CLASS-METHODS format_date_for_output
      IMPORTING
        iv_date TYPE d
      RETURNING VALUE(rv_text) TYPE string.

    CLASS-METHODS append_header_xml
      IMPORTING
        io_writer TYPE REF TO if_sxml_writer
        is_header TYPE ty_header
      RAISING
        cx_sxml_state_error
        cx_sxml_name_error.

    CLASS-METHODS append_totals_by_class_xml
      IMPORTING
        io_writer         TYPE REF TO if_sxml_writer
        iv_container_name TYPE string
        iv_item_name      TYPE string
        iv_scope          TYPE ty_scope
        it_totals         TYPE tt_total_by_class
      RAISING
        cx_sxml_state_error
        cx_sxml_name_error.

    CLASS-METHODS render_pdf_from_xml
      IMPORTING
        iv_xml_data TYPE xstring
        iv_form_name TYPE fpname
      RETURNING VALUE(rv_pdf) TYPE xstring
      RAISING
        cx_fp_form_reader
        cx_fp_ads_util.
ENDCLASS.

CLASS /eacm/cl_rpriepprv_form IMPLEMENTATION.
  METHOD get_pdf_from_data.
    CONSTANTS lc_form_name TYPE fpname VALUE '/EACM/FR_RPRIEPPRV'.

    DATA lv_xml_data TYPE xstring.

    " Il provider decide gia quale dataset passare.
    " Qui il form costruisce solo l'XML finale coerente con quel dataset.
    IF it_riepilogo IS INITIAL.
      CLEAR rv_pdf.
      RETURN.
    ENDIF.

    lv_xml_data = build_summary_xml(
      is_action_input = is_action_input
      it_riepilogo    = it_riepilogo ).

    IF lv_xml_data IS INITIAL.
      CLEAR rv_pdf.
      RETURN.
    ENDIF.

    rv_pdf = render_pdf_from_xml(
      iv_xml_data  = lv_xml_data
      iv_form_name = lc_form_name ).
  ENDMETHOD.

  METHOD build_summary_xml.
    DATA ls_form TYPE ty_form.

    FIELD-SYMBOLS:
      <agent>    TYPE ty_agent,
      <currency> TYPE ty_currency,
      <customer> TYPE ty_customer,
      <item>     TYPE ty_item,
      <general>  TYPE ty_general,
      <agent_currency_total> TYPE ty_agent_currency_total.

    ls_form = build_summary_form_model(
      is_action_input = is_action_input
      it_riepilogo    = it_riepilogo ).

    IF ls_form-agents IS INITIAL.
      CLEAR rv_xml_data.
      RETURN.
    ENDIF.

    TRY.
        " La gerarchia XML deve seguire lo schema Adobe:
        " Header -> Agent -> Currency -> Customer -> Item
        " con i nodi separati per i totali per classe e per valuta.
        DATA(lo_writer) = CAST if_sxml_writer(
          cl_sxml_string_writer=>create(
            type     = if_sxml=>co_xt_xml10
            encoding = 'UTF-8' ) ).

        lo_writer->open_element( name = 'Form' ).
        lo_writer->open_element( name = 'Header' ).

        append_header_xml(
          io_writer = lo_writer
          is_header = ls_form-header ).

        lo_writer->open_element( name = '_Agent' ).
        LOOP AT ls_form-agents ASSIGNING <agent>.
          lo_writer->open_element( name = 'Agent' ).
          append_xml_element( io_writer = lo_writer iv_name = 'Bukrs' iv_value = |{ <agent>-bukrs }| ).
          append_xml_element( io_writer = lo_writer iv_name = 'Fkdat' iv_value = format_date_for_output( <agent>-fkdat ) ).
          append_xml_element( io_writer = lo_writer iv_name = 'PeriodFrom' iv_value = <agent>-periodfrom ).
          append_xml_element( io_writer = lo_writer iv_name = 'PeriodTo' iv_value = <agent>-periodto ).
          append_xml_element( io_writer = lo_writer iv_name = 'Zcdaz' iv_value = |{ <agent>-zcdaz }| ).
          append_xml_element( io_writer = lo_writer iv_name = 'Namea' iv_value = |{ <agent>-namea }| ).
          append_xml_element( io_writer = lo_writer iv_name = 'AgentState' iv_value = |{ <agent>-agentstate }| ).
          append_xml_element( io_writer = lo_writer iv_name = 'AgentTotalZimpp' iv_value = |{ <agent>-agenttotalzimpp }| ).
          append_xml_element( io_writer = lo_writer iv_name = 'AgentTotalZimco' iv_value = |{ <agent>-agenttotalzimco }| ).
          append_xml_element( io_writer = lo_writer iv_name = 'AgentTotalZimmg' iv_value = |{ <agent>-agenttotalzimmg }| ).
          append_xml_element( io_writer = lo_writer iv_name = 'AgentTotalZiman' iv_value = |{ <agent>-agenttotalziman }| ).
          append_xml_element( io_writer = lo_writer iv_name = 'AgentTotalImpProvv' iv_value = |{ <agent>-agenttotalprovv }| ).
          append_xml_element( io_writer = lo_writer iv_name = 'AgentTotalImpMatur' iv_value = |{ <agent>-agenttotalmatur }| ).
          append_xml_element( io_writer = lo_writer iv_name = 'AgentTotalImpDaMat' iv_value = |{ <agent>-agenttotaldamat }| ).
          append_xml_element( io_writer = lo_writer iv_name = 'AgentTotalImpRecup' iv_value = |{ <agent>-agenttotalrecup }| ).

          lo_writer->open_element( name = '_Currency' ).
          LOOP AT <agent>-currencies ASSIGNING <currency>.
            lo_writer->open_element( name = 'Currency' ).
            append_xml_element( io_writer = lo_writer iv_name = 'Bukrs' iv_value = |{ <currency>-bukrs }| ).
            append_xml_element( io_writer = lo_writer iv_name = 'Fkdat' iv_value = format_date_for_output( <currency>-fkdat ) ).
            append_xml_element( io_writer = lo_writer iv_name = 'Zcdaz' iv_value = |{ <currency>-zcdaz }| ).
            append_xml_element( io_writer = lo_writer iv_name = 'Waerk' iv_value = |{ <currency>-waerk }| ).
            append_xml_element( io_writer = lo_writer iv_name = 'CurrencyTotalZimpp' iv_value = |{ <currency>-currencytotalzimpp }| ).
            append_xml_element( io_writer = lo_writer iv_name = 'CurrencyTotalZimco' iv_value = |{ <currency>-currencytotalzimco }| ).
            append_xml_element( io_writer = lo_writer iv_name = 'CurrencyTotalZimmg' iv_value = |{ <currency>-currencytotalzimmg }| ).
            append_xml_element( io_writer = lo_writer iv_name = 'CurrencyTotalZiman' iv_value = |{ <currency>-currencytotalziman }| ).
            append_xml_element( io_writer = lo_writer iv_name = 'CurrencyTotalImpProvv' iv_value = |{ <currency>-currencytotalprovv }| ).
            append_xml_element( io_writer = lo_writer iv_name = 'CurrencyTotalImpMatur' iv_value = |{ <currency>-currencytotalmatur }| ).
            append_xml_element( io_writer = lo_writer iv_name = 'CurrencyTotalImpDaMat' iv_value = |{ <currency>-currencytotaldamat }| ).
            append_xml_element( io_writer = lo_writer iv_name = 'CurrencyTotalImpRecup' iv_value = |{ <currency>-currencytotalrecup }| ).

            lo_writer->open_element( name = '_Customer' ).
            LOOP AT <currency>-customers ASSIGNING <customer>.
              lo_writer->open_element( name = 'Customer' ).
              append_xml_element( io_writer = lo_writer iv_name = 'Bukrs' iv_value = |{ <customer>-bukrs }| ).
              append_xml_element( io_writer = lo_writer iv_name = 'Fkdat' iv_value = format_date_for_output( <customer>-fkdat ) ).
              append_xml_element( io_writer = lo_writer iv_name = 'Zcdaz' iv_value = |{ <customer>-zcdaz }| ).
              append_xml_element( io_writer = lo_writer iv_name = 'Waerk' iv_value = |{ <customer>-waerk }| ).
              append_xml_element( io_writer = lo_writer iv_name = 'Kunrg' iv_value = |{ <customer>-kunrg }| ).
              append_xml_element( io_writer = lo_writer iv_name = 'CustomerName' iv_value = |{ <customer>-customername }| ).
              append_xml_element( io_writer = lo_writer iv_name = 'CustomerTotalZimpp' iv_value = |{ <customer>-customertotalzimpp }| ).
              append_xml_element( io_writer = lo_writer iv_name = 'CustomerTotalZimco' iv_value = |{ <customer>-customertotalzimco }| ).
              append_xml_element( io_writer = lo_writer iv_name = 'CustomerTotalZimmg' iv_value = |{ <customer>-customertotalzimmg }| ).
              append_xml_element( io_writer = lo_writer iv_name = 'CustomerTotalZiman' iv_value = |{ <customer>-customertotalziman }| ).
              append_xml_element( io_writer = lo_writer iv_name = 'CustomerTotalImpProvv' iv_value = |{ <customer>-customertotalprovv }| ).
              append_xml_element( io_writer = lo_writer iv_name = 'CustomerTotalImpMatur' iv_value = |{ <customer>-customertotalmatur }| ).
              append_xml_element( io_writer = lo_writer iv_name = 'CustomerTotalImpDaMat' iv_value = |{ <customer>-customertotaldamat }| ).
              append_xml_element( io_writer = lo_writer iv_name = 'CustomerTotalImpRecup' iv_value = |{ <customer>-customertotalrecup }| ).

              lo_writer->open_element( name = '_Item' ).
              LOOP AT <customer>-items ASSIGNING <item>.
                lo_writer->open_element( name = 'Item' ).
                append_xml_element( io_writer = lo_writer iv_name = 'Bukrs' iv_value = |{ <item>-bukrs }| ).
                append_xml_element( io_writer = lo_writer iv_name = 'Fkdat' iv_value = format_date_for_output( <item>-fkdat ) ).
                append_xml_element( io_writer = lo_writer iv_name = 'Zcdaz' iv_value = |{ <item>-zcdaz }| ).
                append_xml_element( io_writer = lo_writer iv_name = 'Waerk' iv_value = |{ <item>-waerk }| ).
                append_xml_element( io_writer = lo_writer iv_name = 'Kunrg' iv_value = |{ <item>-kunrg }| ).
                append_xml_element( io_writer = lo_writer iv_name = 'Vbeln' iv_value = |{ <item>-vbeln }| ).
                append_xml_element( io_writer = lo_writer iv_name = 'Posnr' iv_value = |{ <item>-posnr }| ).
                append_xml_element( io_writer = lo_writer iv_name = 'Zclpr' iv_value = |{ <item>-zclpr }| ).
                append_xml_element( io_writer = lo_writer iv_name = 'Belnr' iv_value = |{ <item>-belnr }| ).
                append_xml_element( io_writer = lo_writer iv_name = 'Namea' iv_value = |{ <item>-namea }| ).
                append_xml_element( io_writer = lo_writer iv_name = 'CustomerName' iv_value = |{ <item>-customername }| ).
                append_xml_element( io_writer = lo_writer iv_name = 'Zidfs' iv_value = |{ <item>-zidfs }| ).
                append_xml_element( io_writer = lo_writer iv_name = 'Zamcf' iv_value = |{ <item>-zamcf }| ).
                append_xml_element( io_writer = lo_writer iv_name = 'Ztpcd' iv_value = |{ <item>-ztpcd }| ).
                append_xml_element( io_writer = lo_writer iv_name = 'Zimpp' iv_value = |{ <item>-zimpp }| ).
                append_xml_element( io_writer = lo_writer iv_name = 'Zimco' iv_value = |{ <item>-zimco }| ).
                append_xml_element( io_writer = lo_writer iv_name = 'Zimmg' iv_value = |{ <item>-zimmg }| ).
                append_xml_element( io_writer = lo_writer iv_name = 'Ziman' iv_value = |{ <item>-ziman }| ).
                append_xml_element( io_writer = lo_writer iv_name = 'ImpProvv' iv_value = |{ <item>-impprovv }| ).
                append_xml_element( io_writer = lo_writer iv_name = 'ImpMatur' iv_value = |{ <item>-impmatur }| ).
                append_xml_element( io_writer = lo_writer iv_name = 'ImpDaMat' iv_value = |{ <item>-impdamat }| ).
                append_xml_element( io_writer = lo_writer iv_name = 'ImpRecup' iv_value = |{ <item>-imprecup }| ).
                lo_writer->close_element( ).
              ENDLOOP.
              lo_writer->close_element( ).
              lo_writer->close_element( ).
            ENDLOOP.
            lo_writer->close_element( ).
            lo_writer->close_element( ).
          ENDLOOP.
          lo_writer->close_element( ).

          append_totals_by_class_xml(
            io_writer         = lo_writer
            iv_container_name = '_AgentTotalsByClass'
            iv_item_name      = 'AgentTotalsByClass'
            iv_scope          = 'AGENT'
            it_totals         = <agent>-agenttotalsbyclass ).

          lo_writer->open_element( name = '_AgentCurrencyTotals' ).
          LOOP AT <agent>-agentcurrencytotals ASSIGNING <agent_currency_total>.
            lo_writer->open_element( name = 'AgentCurrencyTotals' ).
            append_xml_element( io_writer = lo_writer iv_name = 'Bukrs' iv_value = |{ <agent_currency_total>-bukrs }| ).
            append_xml_element( io_writer = lo_writer iv_name = 'Fkdat' iv_value = format_date_for_output( <agent_currency_total>-fkdat ) ).
            append_xml_element( io_writer = lo_writer iv_name = 'Zcdaz' iv_value = |{ <agent_currency_total>-zcdaz }| ).
            append_xml_element( io_writer = lo_writer iv_name = 'Waerk' iv_value = |{ <agent_currency_total>-waerk }| ).
            append_xml_element( io_writer = lo_writer iv_name = 'CurrencyCode' iv_value = |{ <agent_currency_total>-currencycode }| ).
            append_xml_element( io_writer = lo_writer iv_name = 'AgentCurrencyTotalZimpp' iv_value = |{ <agent_currency_total>-agentcurrencytotalzimpp }| ).
            append_xml_element( io_writer = lo_writer iv_name = 'AgentCurrencyTotalZimco' iv_value = |{ <agent_currency_total>-agentcurrencytotalzimco }| ).
            append_xml_element( io_writer = lo_writer iv_name = 'AgentCurrencyTotalZimmg' iv_value = |{ <agent_currency_total>-agentcurrencytotalzimmg }| ).
            append_xml_element( io_writer = lo_writer iv_name = 'AgentCurrencyTotalZiman' iv_value = |{ <agent_currency_total>-agentcurrencytotalziman }| ).
            append_xml_element( io_writer = lo_writer iv_name = 'AgentCurrencyTotalImpProvv' iv_value = |{ <agent_currency_total>-agentcurrencytotalprovv }| ).
            append_xml_element( io_writer = lo_writer iv_name = 'AgentCurrencyTotalImpMatur' iv_value = |{ <agent_currency_total>-agentcurrencytotalmatur }| ).
            append_xml_element( io_writer = lo_writer iv_name = 'AgentCurrencyTotalImpDaMat' iv_value = |{ <agent_currency_total>-agentcurrencytotaldamat }| ).
            append_xml_element( io_writer = lo_writer iv_name = 'AgentCurrencyTotalImpRecup' iv_value = |{ <agent_currency_total>-agentcurrencytotalrecup }| ).
            lo_writer->close_element( ).
          ENDLOOP.
          lo_writer->close_element( ).
          lo_writer->close_element( ).
        ENDLOOP.
        lo_writer->close_element( ).

        lo_writer->open_element( name = '_General' ).
        LOOP AT ls_form-general ASSIGNING <general>.
          lo_writer->open_element( name = 'General' ).
          append_xml_element( io_writer = lo_writer iv_name = 'Bukrs' iv_value = |{ <general>-bukrs }| ).
          append_xml_element( io_writer = lo_writer iv_name = 'Fkdat' iv_value = format_date_for_output( <general>-fkdat ) ).
          append_xml_element( io_writer = lo_writer iv_name = 'Waerk' iv_value = |{ <general>-waerk }| ).
          append_xml_element( io_writer = lo_writer iv_name = 'CurrencyCode' iv_value = |{ <general>-currencycode }| ).
          append_xml_element( io_writer = lo_writer iv_name = 'GeneralTotalZimpp' iv_value = |{ <general>-generaltotalzimpp }| ).
          append_xml_element( io_writer = lo_writer iv_name = 'GeneralTotalZimco' iv_value = |{ <general>-generaltotalzimco }| ).
          append_xml_element( io_writer = lo_writer iv_name = 'GeneralTotalZimmg' iv_value = |{ <general>-generaltotalzimmg }| ).
          append_xml_element( io_writer = lo_writer iv_name = 'GeneralTotalZiman' iv_value = |{ <general>-generaltotalziman }| ).
          append_xml_element( io_writer = lo_writer iv_name = 'GeneralTotalImpProvv' iv_value = |{ <general>-generaltotalprovv }| ).
          append_xml_element( io_writer = lo_writer iv_name = 'GeneralTotalImpMatur' iv_value = |{ <general>-generaltotalmatur }| ).
          append_xml_element( io_writer = lo_writer iv_name = 'GeneralTotalImpDaMat' iv_value = |{ <general>-generaltotaldamat }| ).
          append_xml_element( io_writer = lo_writer iv_name = 'GeneralTotalImpRecup' iv_value = |{ <general>-generaltotalrecup }| ).

          append_totals_by_class_xml(
            io_writer         = lo_writer
            iv_container_name = '_GeneralTotalsByClass'
            iv_item_name      = 'GeneralTotalsByClass'
            iv_scope          = 'GENERAL'
            it_totals         = <general>-generaltotalsbyclass ).
          lo_writer->close_element( ).
        ENDLOOP.
        lo_writer->close_element( ).

        append_totals_by_class_xml(
          io_writer         = lo_writer
          iv_container_name = '_GeneralTotalsByClass'
          iv_item_name      = 'GeneralTotalsByClass'
          iv_scope          = 'GENERAL'
          it_totals         = ls_form-generaltotalsbyclass ).

        lo_writer->close_element( ).
        lo_writer->close_element( ).

        rv_xml_data = CAST cl_sxml_string_writer( lo_writer )->get_output( ).
      CATCH cx_sxml_state_error cx_sxml_name_error.
        CLEAR rv_xml_data.
    ENDTRY.
  ENDMETHOD.

  METHOD build_summary_form_model.
    DATA lt_customer_text TYPE tt_customer_text.
    DATA ls_item TYPE ty_item.
    DATA ls_total TYPE ty_total_by_class.
    DATA lv_bukrs TYPE bukrs.
    DATA lv_fkdat TYPE fkdat.
    DATA lv_period_from TYPE fkdat.
    DATA lv_period_to TYPE fkdat.

    FIELD-SYMBOLS:
      <rie>           TYPE /eacm/cl_rpriepprv_data=>ty_rie_detail,
      <customer_text> TYPE ty_customer_text,
      <agent>         TYPE ty_agent,
      <currency>      TYPE ty_currency,
      <agent_currency_total> TYPE ty_agent_currency_total,
      <customer>      TYPE ty_customer,
      <item>          TYPE ty_item,
      <agent_total>   TYPE ty_total_by_class,
      <general>       TYPE ty_general,
      <general_total> TYPE ty_total_by_class.

    lt_customer_text = get_customer_texts( it_riepilogo ).

    lv_bukrs = is_action_input-CompanyCodeFrom.
    IF lv_bukrs IS INITIAL.
      lv_bukrs = is_action_input-CompanyCodeTo.
    ENDIF.

    lv_fkdat = is_action_input-BillingDateFrom.
    IF lv_fkdat IS INITIAL.
      lv_fkdat = is_action_input-BillingDateTo.
    ENDIF.

    " Nel report originale la testata "Period" usa sempre s_fkdat-low e s_fkdat-high.
    " Se l'utente inserisce una sola data, la riutilizziamo su entrambe le estremita.
    lv_period_from = is_action_input-BillingDateFrom.
    IF lv_period_from IS INITIAL.
      lv_period_from = is_action_input-BillingDateTo.
    ENDIF.

    lv_period_to = is_action_input-BillingDateTo.
    IF lv_period_to IS INITIAL.
      lv_period_to = is_action_input-BillingDateFrom.
    ENDIF.

    IF ( lv_bukrs IS INITIAL OR lv_fkdat IS INITIAL
         OR lv_period_from IS INITIAL OR lv_period_to IS INITIAL )
       AND it_riepilogo IS NOT INITIAL.
      READ TABLE it_riepilogo ASSIGNING <rie> INDEX 1.
      IF sy-subrc = 0.
        IF lv_bukrs IS INITIAL.
          lv_bukrs = <rie>-bukrs.
        ENDIF.
        IF lv_fkdat IS INITIAL.
          lv_fkdat = <rie>-fkdat.
        ENDIF.
        IF lv_period_from IS INITIAL.
          lv_period_from = <rie>-fkdat.
        ENDIF.
        IF lv_period_to IS INITIAL.
          lv_period_to = <rie>-fkdat.
        ENDIF.
      ENDIF.
    ENDIF.

    rs_form-header-bukrs = lv_bukrs.
    " Nel layout originale la data in alto a destra e la data di stampa (sy-datum).
    " Riutilizziamo Header-Fkdat per non introdurre un campo tecnico in piu.
    rs_form-header-fkdat = sy-datum.
    " Da una tabella piatta costruiamo il modello gerarchico del form.
    LOOP AT it_riepilogo ASSIGNING <rie>.
      rs_form-header-totalzimpp += <rie>-zimpp.
      rs_form-header-totalzimco += <rie>-zimco.
      rs_form-header-totalzimmg += <rie>-zimmg.
      rs_form-header-totalziman += <rie>-ziman.
      rs_form-header-totalimpprovv += <rie>-imp_provv.
      rs_form-header-totalimpmatur += <rie>-imp_matur.
      rs_form-header-totalimpdamat += <rie>-imp_da_mat.
      rs_form-header-totalimprecup += <rie>-imp_recup.

      READ TABLE rs_form-agents ASSIGNING <agent>
        WITH TABLE KEY zcdaz = <rie>-zcdaz.
      IF sy-subrc <> 0.
        INSERT VALUE #(
          bukrs      = lv_bukrs
          fkdat      = sy-datum
          periodfrom = format_date_for_output( lv_period_from )
          periodto   = format_date_for_output( lv_period_to )
          zcdaz      = <rie>-zcdaz
          namea      = <rie>-namea
          agentstate = 'Active' ) INTO TABLE rs_form-agents ASSIGNING <agent>.
      ENDIF.

      <agent>-agenttotalzimpp += <rie>-zimpp.
      <agent>-agenttotalzimco += <rie>-zimco.
      <agent>-agenttotalzimmg += <rie>-zimmg.
      <agent>-agenttotalziman += <rie>-ziman.
      <agent>-agenttotalprovv += <rie>-imp_provv.
      <agent>-agenttotalmatur += <rie>-imp_matur.
      <agent>-agenttotaldamat += <rie>-imp_da_mat.
      <agent>-agenttotalrecup += <rie>-imp_recup.

      READ TABLE <agent>-currencies ASSIGNING <currency>
        WITH TABLE KEY waerk = <rie>-waerk.
      IF sy-subrc <> 0.
        INSERT VALUE #(
          bukrs = lv_bukrs
          fkdat = lv_fkdat
          zcdaz = <rie>-zcdaz
          waerk = <rie>-waerk ) INTO TABLE <agent>-currencies ASSIGNING <currency>.
      ENDIF.

      <currency>-currencytotalzimpp += <rie>-zimpp.
      <currency>-currencytotalzimco += <rie>-zimco.
      <currency>-currencytotalzimmg += <rie>-zimmg.
      <currency>-currencytotalziman += <rie>-ziman.
      <currency>-currencytotalprovv += <rie>-imp_provv.
      <currency>-currencytotalmatur += <rie>-imp_matur.
      <currency>-currencytotaldamat += <rie>-imp_da_mat.
      <currency>-currencytotalrecup += <rie>-imp_recup.

      READ TABLE <agent>-agentcurrencytotals ASSIGNING <agent_currency_total>
        WITH TABLE KEY waerk = <rie>-waerk.
      IF sy-subrc <> 0.
        INSERT VALUE #(
          bukrs        = lv_bukrs
          fkdat        = lv_fkdat
          zcdaz        = <rie>-zcdaz
          waerk        = <rie>-waerk
          currencycode = <rie>-waerk ) INTO TABLE <agent>-agentcurrencytotals ASSIGNING <agent_currency_total>.
      ENDIF.

      <agent_currency_total>-agentcurrencytotalzimpp += <rie>-zimpp.
      <agent_currency_total>-agentcurrencytotalzimco += <rie>-zimco.
      <agent_currency_total>-agentcurrencytotalzimmg += <rie>-zimmg.
      <agent_currency_total>-agentcurrencytotalziman += <rie>-ziman.
      <agent_currency_total>-agentcurrencytotalprovv += <rie>-imp_provv.
      <agent_currency_total>-agentcurrencytotalmatur += <rie>-imp_matur.
      <agent_currency_total>-agentcurrencytotaldamat += <rie>-imp_da_mat.
      <agent_currency_total>-agentcurrencytotalrecup += <rie>-imp_recup.

      READ TABLE <currency>-customers ASSIGNING <customer>
        WITH TABLE KEY kunrg = <rie>-kunrg.
      IF sy-subrc <> 0.
        INSERT VALUE #(
          bukrs = lv_bukrs
          fkdat = lv_fkdat
          zcdaz = <rie>-zcdaz
          waerk = <rie>-waerk
          kunrg = <rie>-kunrg
          customername = COND #(
            WHEN line_exists( lt_customer_text[ kunrg = <rie>-kunrg ] )
            THEN lt_customer_text[ kunrg = <rie>-kunrg ]-name1
            ELSE '' ) ) INTO TABLE <currency>-customers ASSIGNING <customer>.
      ENDIF.

      IF <customer>-customername IS INITIAL
         AND line_exists( lt_customer_text[ kunrg = <rie>-kunrg ] ).
        <customer>-customername = lt_customer_text[ kunrg = <rie>-kunrg ]-name1.
      ENDIF.

      <customer>-customertotalzimpp += <rie>-zimpp.
      <customer>-customertotalzimco += <rie>-zimco.
      <customer>-customertotalzimmg += <rie>-zimmg.
      <customer>-customertotalziman += <rie>-ziman.
      <customer>-customertotalprovv += <rie>-imp_provv.
      <customer>-customertotalmatur += <rie>-imp_matur.
      <customer>-customertotaldamat += <rie>-imp_da_mat.
      <customer>-customertotalrecup += <rie>-imp_recup.

      READ TABLE <customer>-items ASSIGNING <item>
        WITH TABLE KEY
          fkdat = <rie>-fkdat
          vbeln = <rie>-vbeln
          posnr = <rie>-posnr
          zclpr = <rie>-zclpr
          belnr = <rie>-belnr.
      IF sy-subrc <> 0.
        CLEAR ls_item.
        ls_item-bukrs = lv_bukrs.
        ls_item-fkdat = <rie>-fkdat.
        ls_item-zcdaz = <rie>-zcdaz.
        ls_item-waerk = <rie>-waerk.
        ls_item-kunrg = <rie>-kunrg.
        ls_item-vbeln = <rie>-vbeln.
        ls_item-posnr = <rie>-posnr.
        ls_item-zclpr = <rie>-zclpr.
        ls_item-belnr = <rie>-belnr.
        ls_item-namea = <rie>-namea.
        ls_item-customername = <customer>-customername.
        ls_item-zidfs = <rie>-zidfs.
        ls_item-zamcf = <rie>-zamcf.
        ls_item-ztpcd = <rie>-ztpcd.
        INSERT ls_item INTO TABLE <customer>-items ASSIGNING <item>.
      ENDIF.

      <item>-zimpp += <rie>-zimpp.
      <item>-zimco += <rie>-zimco.
      <item>-zimmg += <rie>-zimmg.
      <item>-ziman += <rie>-ziman.
      <item>-impprovv += <rie>-imp_provv.
      <item>-impmatur += <rie>-imp_matur.
      <item>-impdamat += <rie>-imp_da_mat.
      <item>-imprecup += <rie>-imp_recup.

      READ TABLE <agent>-agenttotalsbyclass ASSIGNING <agent_total>
        WITH TABLE KEY waerk = <rie>-waerk zclpr = <rie>-zclpr.
      IF sy-subrc <> 0.
        CLEAR ls_total.
        ls_total-bukrs = lv_bukrs.
        ls_total-fkdat = lv_fkdat.
        ls_total-zcdaz = <rie>-zcdaz.
        ls_total-waerk = <rie>-waerk.
        ls_total-zclpr = <rie>-zclpr.
        ls_total-currencycode = <rie>-waerk.
        ls_total-classification = <rie>-zclpr.
        INSERT ls_total INTO TABLE <agent>-agenttotalsbyclass ASSIGNING <agent_total>.
      ENDIF.

      <agent_total>-totalzimpp += <rie>-zimpp.
      <agent_total>-totalzimco += <rie>-zimco.
      <agent_total>-totalzimmg += <rie>-zimmg.
      <agent_total>-totalziman += <rie>-ziman.
      <agent_total>-totalprovvigione += <rie>-imp_provv.
      <agent_total>-totalmaturato += <rie>-imp_matur.
      <agent_total>-totaldamaturare += <rie>-imp_da_mat.
      <agent_total>-totalrecupero += <rie>-imp_recup.

      READ TABLE rs_form-general ASSIGNING <general>
        WITH TABLE KEY waerk = <rie>-waerk.
      IF sy-subrc <> 0.
        INSERT VALUE #(
          bukrs        = lv_bukrs
          fkdat        = lv_fkdat
          waerk        = <rie>-waerk
          currencycode = <rie>-waerk ) INTO TABLE rs_form-general ASSIGNING <general>.
      ENDIF.

      <general>-generaltotalzimpp += <rie>-zimpp.
      <general>-generaltotalzimco += <rie>-zimco.
      <general>-generaltotalzimmg += <rie>-zimmg.
      <general>-generaltotalziman += <rie>-ziman.
      <general>-generaltotalprovv += <rie>-imp_provv.
      <general>-generaltotalmatur += <rie>-imp_matur.
      <general>-generaltotaldamat += <rie>-imp_da_mat.
      <general>-generaltotalrecup += <rie>-imp_recup.

      READ TABLE <general>-generaltotalsbyclass ASSIGNING <general_total>
        WITH TABLE KEY waerk = <rie>-waerk zclpr = <rie>-zclpr.
      IF sy-subrc <> 0.
        CLEAR ls_total.
        ls_total-bukrs = lv_bukrs.
        ls_total-fkdat = lv_fkdat.
        ls_total-waerk = <rie>-waerk.
        ls_total-zclpr = <rie>-zclpr.
        ls_total-currencycode = <rie>-waerk.
        ls_total-classification = <rie>-zclpr.
        INSERT ls_total INTO TABLE <general>-generaltotalsbyclass ASSIGNING <general_total>.
      ENDIF.

      <general_total>-totalzimpp += <rie>-zimpp.
      <general_total>-totalzimco += <rie>-zimco.
      <general_total>-totalzimmg += <rie>-zimmg.
      <general_total>-totalziman += <rie>-ziman.
      <general_total>-totalprovvigione += <rie>-imp_provv.
      <general_total>-totalmaturato += <rie>-imp_matur.
      <general_total>-totaldamaturare += <rie>-imp_da_mat.
      <general_total>-totalrecupero += <rie>-imp_recup.

      READ TABLE rs_form-generaltotalsbyclass ASSIGNING <general_total>
        WITH TABLE KEY waerk = <rie>-waerk zclpr = <rie>-zclpr.
      IF sy-subrc <> 0.
        CLEAR ls_total.
        ls_total-bukrs = lv_bukrs.
        ls_total-fkdat = lv_fkdat.
        ls_total-waerk = <rie>-waerk.
        ls_total-zclpr = <rie>-zclpr.
        ls_total-currencycode = <rie>-waerk.
        ls_total-classification = <rie>-zclpr.
        INSERT ls_total INTO TABLE rs_form-generaltotalsbyclass ASSIGNING <general_total>.
      ENDIF.

      <general_total>-totalzimpp += <rie>-zimpp.
      <general_total>-totalzimco += <rie>-zimco.
      <general_total>-totalzimmg += <rie>-zimmg.
      <general_total>-totalziman += <rie>-ziman.
      <general_total>-totalprovvigione += <rie>-imp_provv.
      <general_total>-totalmaturato += <rie>-imp_matur.
      <general_total>-totaldamaturare += <rie>-imp_da_mat.
      <general_total>-totalrecupero += <rie>-imp_recup.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_customer_texts.
    DATA lt_customer_range TYPE RANGE OF kunnr.

    FIELD-SYMBOLS <rie> TYPE /eacm/cl_rpriepprv_data=>ty_rie_detail.

    LOOP AT it_riepilogo ASSIGNING <rie>.
      IF <rie>-kunrg IS INITIAL.
        CONTINUE.
      ENDIF.

      IF line_exists( lt_customer_range[ low = <rie>-kunrg ] ).
        CONTINUE.
      ENDIF.

      APPEND VALUE #(
        sign   = 'I'
        option = 'EQ'
        low    = <rie>-kunrg ) TO lt_customer_range.
    ENDLOOP.

    IF lt_customer_range IS INITIAL.
      RETURN.
    ENDIF.

    SELECT kunnr, name1
      FROM /eacm/kna1 "da cancellare prob
      WHERE kunnr IN @lt_customer_range
      INTO TABLE @DATA(lt_kna1).

    LOOP AT lt_kna1 INTO DATA(ls_kna1).
      INSERT VALUE #(
        kunrg = ls_kna1-kunnr
        name1 = ls_kna1-name1 ) INTO TABLE rt_customer_text.
    ENDLOOP.
  ENDMETHOD.

  METHOD append_xml_element.
    io_writer->open_element( name = iv_name ).
    io_writer->write_value( iv_value ).
    io_writer->close_element( ).
  ENDMETHOD.

  METHOD format_date_for_output.
    IF iv_date IS INITIAL OR iv_date = '00000000'.
      CLEAR rv_text.
      RETURN.
    ENDIF.

    rv_text = |{ iv_date+6(2) }.{ iv_date+4(2) }.{ iv_date(4) }|.
  ENDMETHOD.

  METHOD append_header_xml.
    append_xml_element( io_writer = io_writer iv_name = 'Bukrs' iv_value = |{ is_header-bukrs }| ).
    append_xml_element( io_writer = io_writer iv_name = 'Fkdat' iv_value = format_date_for_output( is_header-fkdat ) ).
    append_xml_element( io_writer = io_writer iv_name = 'TotalZimpp' iv_value = |{ is_header-totalzimpp }| ).
    append_xml_element( io_writer = io_writer iv_name = 'TotalZimco' iv_value = |{ is_header-totalzimco }| ).
    append_xml_element( io_writer = io_writer iv_name = 'TotalZimmg' iv_value = |{ is_header-totalzimmg }| ).
    append_xml_element( io_writer = io_writer iv_name = 'TotalZiman' iv_value = |{ is_header-totalziman }| ).
    append_xml_element( io_writer = io_writer iv_name = 'TotalImpProvv' iv_value = |{ is_header-totalimpprovv }| ).
    append_xml_element( io_writer = io_writer iv_name = 'TotalImpMatur' iv_value = |{ is_header-totalimpmatur }| ).
    append_xml_element( io_writer = io_writer iv_name = 'TotalImpDaMat' iv_value = |{ is_header-totalimpdamat }| ).
    append_xml_element( io_writer = io_writer iv_name = 'TotalImpRecup' iv_value = |{ is_header-totalimprecup }| ).
  ENDMETHOD.

  METHOD append_totals_by_class_xml.
    FIELD-SYMBOLS <total> TYPE ty_total_by_class.

    " Lo stesso helper serve sia per i totali per classe dell'agente
    " sia per quelli generali: cambia solo il prefisso dei campi XML.
    io_writer->open_element( name = iv_container_name ).
    LOOP AT it_totals ASSIGNING <total>.
      io_writer->open_element( name = iv_item_name ).
      append_xml_element( io_writer = io_writer iv_name = 'Bukrs' iv_value = |{ <total>-bukrs }| ).
      append_xml_element( io_writer = io_writer iv_name = 'Fkdat' iv_value = format_date_for_output( <total>-fkdat ) ).

      IF iv_scope = 'AGENT'.
        append_xml_element( io_writer = io_writer iv_name = 'Zcdaz' iv_value = |{ <total>-zcdaz }| ).
      ENDIF.

      append_xml_element( io_writer = io_writer iv_name = 'Waerk' iv_value = |{ <total>-waerk }| ).
      append_xml_element( io_writer = io_writer iv_name = 'Zclpr' iv_value = |{ <total>-zclpr }| ).
      append_xml_element( io_writer = io_writer iv_name = 'CurrencyCode' iv_value = |{ <total>-currencycode }| ).
      append_xml_element( io_writer = io_writer iv_name = 'Classification' iv_value = |{ <total>-classification }| ).

      IF iv_scope = 'AGENT'.
        append_xml_element( io_writer = io_writer iv_name = 'AgentClassTotalZimpp' iv_value = |{ <total>-totalzimpp }| ).
        append_xml_element( io_writer = io_writer iv_name = 'AgentClassTotalZimco' iv_value = |{ <total>-totalzimco }| ).
        append_xml_element( io_writer = io_writer iv_name = 'AgentClassTotalZimmg' iv_value = |{ <total>-totalzimmg }| ).
        append_xml_element( io_writer = io_writer iv_name = 'AgentClassTotalZiman' iv_value = |{ <total>-totalziman }| ).
      ELSE.
        append_xml_element( io_writer = io_writer iv_name = 'GeneralClassTotalZimpp' iv_value = |{ <total>-totalzimpp }| ).
        append_xml_element( io_writer = io_writer iv_name = 'GeneralClassTotalZimco' iv_value = |{ <total>-totalzimco }| ).
        append_xml_element( io_writer = io_writer iv_name = 'GeneralClassTotalZimmg' iv_value = |{ <total>-totalzimmg }| ).
        append_xml_element( io_writer = io_writer iv_name = 'GeneralClassTotalZiman' iv_value = |{ <total>-totalziman }| ).
      ENDIF.

      append_xml_element( io_writer = io_writer iv_name = 'TotalProvvigione' iv_value = |{ <total>-totalprovvigione }| ).
      append_xml_element( io_writer = io_writer iv_name = 'TotalMaturato' iv_value = |{ <total>-totalmaturato }| ).
      append_xml_element( io_writer = io_writer iv_name = 'TotalDaMaturare' iv_value = |{ <total>-totaldamaturare }| ).
      append_xml_element( io_writer = io_writer iv_name = 'TotalRecupero' iv_value = |{ <total>-totalrecupero }| ).
      io_writer->close_element( ).
    ENDLOOP.
    io_writer->close_element( ).
  ENDMETHOD.

  METHOD render_pdf_from_xml.
    DATA(lo_reader) = cl_fp_form_reader=>create_form_reader( iv_form_name ).
    DATA(lv_layout) = lo_reader->get_layout( ).

    cl_fp_ads_util=>render_pdf(
      EXPORTING
        iv_xml_data   = iv_xml_data
        iv_xdp_layout = lv_layout
        iv_locale     = 'it_IT'
      IMPORTING
        ev_pdf        = rv_pdf ).
  ENDMETHOD.

  METHOD build_file_name.
    DATA lv_scope TYPE string.
    DATA lv_bukrs TYPE bukrs.
    DATA lv_fkdat TYPE fkdat.

    lv_scope = COND #( WHEN is_action_input-DetailPrint = abap_true THEN 'DETAIL' ELSE 'SUMMARY' ).
    lv_bukrs = is_action_input-CompanyCodeFrom.
    IF lv_bukrs IS INITIAL.
      lv_bukrs = is_action_input-CompanyCodeTo.
    ENDIF.

    lv_fkdat = is_action_input-BillingDateFrom.
    IF lv_fkdat IS INITIAL.
      lv_fkdat = is_action_input-BillingDateTo.
    ENDIF.

    rv_file_name = |RPRIEPPRV_{ lv_bukrs }_{ lv_fkdat }_{ lv_scope }.pdf|.
  ENDMETHOD.
ENDCLASS.

