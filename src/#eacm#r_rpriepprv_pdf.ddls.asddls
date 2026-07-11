@EndUserText.label: 'RPRIEPPRV PDF download'
@ObjectModel.query.implementedBy: 'ABAP:/EACM/CL_RPRIEPPRV_PDF_QRY'
define root custom entity /EACM/R_RPRIEPPRV_PDF
{
  // Chiavi tecniche storiche mantenute per stabilita del contratto OData.
  // Il frontend nuovo pero usa i campi business diretti della filter bar.
  key CompanyCodeFrom     : bukrs;
  key CompanyCodeTo       : bukrs;
  key BillingDateFrom     : abap.char(8);
  key BillingDateTo       : abap.char(8);
  key SalesOrgFrom        : vkorg;
  key SalesOrgTo          : vkorg;
  key CommissionClassFrom : /eacm/zclpr;
  key CommissionClassTo   : /eacm/zclpr;
  key AgentTypeFrom       : /eacm/ztpag;
  key AgentTypeTo         : /eacm/ztpag;
  key AgentFrom           : /eacm/zcdaz;
  key AgentTo             : /eacm/zcdaz;
  key SalesDocumentFrom   : vbeln;
  key SalesDocumentTo     : vbeln;
  key PayerFrom           : kunnr;
  key PayerTo             : kunnr;
  key MaxDueDateFrom      : abap.char(8);
  key MaxDueDateTo        : abap.char(8);
  key PostingDateFrom     : abap.char(8);
  key PostingDateTo       : abap.char(8);
  key DetailPrint         : abap_boolean;
  key PrintWithDueDate    : abap_boolean;

  // Campi business reali del List Report.
  // Restano hidden perche servono solo come contratto tecnico del PdfDownload.
  @UI.hidden: true
  Bukrs                   : bukrs;

  @UI.hidden: true
  Fkdat                   : fkdat;

  @UI.hidden: true
  Vkorg                   : vkorg;

  @UI.hidden: true
  Zclpr                   : /eacm/zclpr;

  @UI.hidden: true
  zcdaz                   : /eacm/zcdaz;

  @UI.hidden: true
  Vbeln                   : vbeln;

  @UI.hidden: true
  Kunrg                   : kunnr;

  @UI.hidden: true
  Zutmx                   : /eacm/zutmx;

  @UI.hidden: true
  Budat                   : budat;

  @UI.hidden: true
  Attachment              : abap.rawstring(0);

  FileName                : abap.char(255);

  @UI.hidden: true
  MimeType                : abap.char(128);
}
