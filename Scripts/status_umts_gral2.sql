set head off
set feedback off
set lines 360
set pages 5000
set verify off
set echo off

spool "/home/oracle/CYR/Datos/status_umts_gral.html";
select /*html*/ FECHA,
      SRL_CNT,
      TRF_CNT,
      CRS_CNT,
      HSW_CNT,
      CTP_CNT,
      RRC_CNT,
      YHO_CNT,
      SHO_CNT,
      IHO_CNT,
      CTW_CNT,
      CPI_CNT,
      L3I_CNT,
      PKT_CNT
from table(f_status_umts_gral('&1','&2','&3',&4,&5));
spool off
exit;
