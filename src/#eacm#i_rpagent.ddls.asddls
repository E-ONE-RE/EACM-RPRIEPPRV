@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '/EACM/I_RPAGENT - estrazione dati ZPRAA'
@Metadata.ignorePropagatedAnnotations: true
define view entity /EACM/I_RPAGENT as select from /eacm/zpraa as Agent
{
    key Agent.zcdaz,
      max( Agent.erdat ) as erdat
}
where Agent.zstre <> 'A'
  and Agent.erdat <= $session.system_date
group by Agent.zcdaz
