set head off
set feedback off
set lines 360
set pages 5000
set verify off
set echo off

spool &5;
with  OBJ as (
        SELECT  CANTIDAD,
                ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&4',1,INSTR('&4',',',1,1)-1),'999999.999'))) SRL_LOW,
                ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&4',1,INSTR('&4',',',1,1)-1),'999999.999'))) SRL_HI,
                ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,1)+1,INSTR('&4',',',1,2)-INSTR('&4',',',1,1)-1),'999999.999'))) TRF_LOW ,
                ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,1)+1,INSTR('&4',',',1,2)-INSTR('&4',',',1,1)-1),'999999.999'))) TRF_HI,
                ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,2)+1,INSTR('&4',',',1,3)-INSTR('&4',',',1,2)-1),'999999.999'))) CRS_LOW,
                ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,2)+1,INSTR('&4',',',1,3)-INSTR('&4',',',1,2)-1),'999999.999'))) CRS_HI,
                ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,3)+1,INSTR('&4',',',1,4)-INSTR('&4',',',1,3)-1),'999999.999'))) HSW_LOW,
                ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,3)+1,INSTR('&4',',',1,4)-INSTR('&4',',',1,3)-1),'999999.999'))) HSW_HI,
                ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,4)+1,INSTR('&4',',',1,5)-INSTR('&4',',',1,4)-1),'999999.999'))) CTP_LOW,
                ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,4)+1,INSTR('&4',',',1,5)-INSTR('&4',',',1,4)-1),'999999.999'))) CTP_HI,
                ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,5)+1,INSTR('&4',',',1,6)-INSTR('&4',',',1,5)-1),'999999.999'))) RRC_LOW,
                ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,5)+1,INSTR('&4',',',1,6)-INSTR('&4',',',1,5)-1),'999999.999'))) RRC_HI,
                ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,6)+1,INSTR('&4',',',1,7)-INSTR('&4',',',1,6)-1),'999999.999'))) YHO_LOW,
                ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,6)+1,INSTR('&4',',',1,7)-INSTR('&4',',',1,6)-1),'999999.999'))) YHO_HI,
                ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,7)+1,INSTR('&4',',',1,8)-INSTR('&4',',',1,7)-1),'999999.999'))) SHO_LOW,
                ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,7)+1,INSTR('&4',',',1,8)-INSTR('&4',',',1,7)-1),'999999.999'))) SHO_HI,
                ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,8)+1,INSTR('&4',',',1,9)-INSTR('&4',',',1,8)-1),'999999.999'))) IHO_LOW,
                ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,8)+1,INSTR('&4',',',1,9)-INSTR('&4',',',1,8)-1),'999999.999'))) IHO_HI,
                ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,9)+1,INSTR('&4',',',1,10)-INSTR('&4',',',1,9)-1),'999999.999'))) CTW_LOW,
                ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,9)+1,INSTR('&4',',',1,10)-INSTR('&4',',',1,9)-1),'999999.999'))) CTW_HI,
                ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,10)+1,INSTR('&4',',',1,11)-INSTR('&4',',',1,10)-1),'999999.999'))) CPI_LOW,
                ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,10)+1,INSTR('&4',',',1,11)-INSTR('&4',',',1,10)-1),'999999.999'))) CPI_HI,
                ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,11)+1,INSTR('&4',',',1,12)-INSTR('&4',',',1,11)-1),'999999.999'))) L3I_LOW,
                ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,11)+1,INSTR('&4',',',1,12)-INSTR('&4',',',1,11)-1),'999999.999'))) L3I_HI,
                ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,12)+1),'999999.999'))) PKT_LOW,
                ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,12)+1),'999999.999'))) PKT_HI
        FROM  (
                SELECT /*+ materialize */ COUNT(DISTINCT ELEMENT_NAME) CANTIDAD
                FROM MULTIVENDOR_OBJECT2
                WHERE ELEMENT_CLASS = 'WCELL'
                AND VALID_FINISH_DATE > SYSDATE
                AND OSSRC = '&3'
              )),
      RFC as (
        SELECT /*+ materialize */ FECHA
          from CALIDAD_STATUS_REFERENCES
         where FECHA between TO_DATE('&1', 'DD.MM.YYYY')
                         AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
       ) ,
      SRL as (
        SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM UMTS_C_NSN_SERVLEV_MNC1_RAW
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     and TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
           AND OSSRC = '&3'
         group by PERIOD_START_TIME
       ) ,
      TRF as (
        SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM UMTS_C_NSN_TRAFFIC_MNC1_RAW
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
           AND OSSRC = '&3'
         group by PERIOD_START_TIME
       ) ,
      CRS as (
        SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM UMTS_C_NSN_CELLRES_MNC1_RAW
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
           AND OSSRC = '&3'
         group by PERIOD_START_TIME 
       ) ,
      HSW as (
        SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM UMTS_C_NSN_HSDPAW_MNC1_RAW
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
           AND OSSRC = '&3'
         GROUP BY PERIOD_START_TIME 
       ) ,
      CTP as (
        SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM UMTS_C_NSN_CELLTP_MNC1_RAW
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
           AND OSSRC = '&3'
         GROUP BY PERIOD_START_TIME
       ) ,
      RRC as (
        SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM UMTS_C_NSN_RRC_MNC1_RAW
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
           AND OSSRC = '&3'
         GROUP BY PERIOD_START_TIME
       ) ,
      YHO as (
        SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM UMTS_C_NSN_INTSYSHO_MNC1_RAW
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
           AND OSSRC = '&3'
         GROUP BY PERIOD_START_TIME
       ) ,
      SHO as (
        SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM UMTS_C_NSN_SOFTHO_MNC1_RAW
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
           AND OSSRC = '&3'
         GROUP BY PERIOD_START_TIME
       ) ,
      IHO as (
        SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM UMTS_C_NSN_INTERSHO_MNC1_RAW
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
           AND OSSRC = '&3'
         GROUP BY PERIOD_START_TIME
       ) ,
     CTW as (
        SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM UMTS_C_NSN_CELTPW_MNC1_RAW
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
           AND OSSRC = '&3'
         GROUP BY PERIOD_START_TIME
       ) ,
      CPI as (
        SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM UMTS_C_NSN_CPICHQ_MNC1_RAW
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
           AND OSSRC = '&3'
         GROUP BY PERIOD_START_TIME
       ) ,
      L3I as (
        SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM UMTS_C_NSN_L3IUB_MNC1_RAW
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
           AND OSSRC = '&3'
         GROUP BY PERIOD_START_TIME
       ) ,
     PKT as  (
        SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM UMTS_C_NSN_PKTCALL_MNC1_RAW
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
           AND OSSRC = '&3'
         group by PERIOD_START_TIME
       )
select  /*html*/ to_char(sysdate-1,'dd.mm.yyyy') FECHA,
        null OSSRC,
        null CANTIDAD,
        to_char(OBJ.SRL_LOW)||' <-> '||to_char(OBJ.SRL_HI) SRL_CNT,
        to_char(OBJ.TRF_LOW)||' <-> '||to_char(OBJ.TRF_HI) TRF_CNT,
        to_char(OBJ.CRS_LOW)||' <-> '||to_char(OBJ.CRS_HI) CRS_CNT,
        to_char(OBJ.HSW_LOW)||' <-> '||to_char(OBJ.HSW_HI) HSW_CNT,
        to_char(OBJ.CTP_LOW)||' <-> '||to_char(OBJ.CTP_HI) CTP_CNT,
        to_char(OBJ.RRC_LOW)||' <-> '||to_char(OBJ.RRC_HI) RRC_CNT,
        to_char(OBJ.YHO_LOW)||' <-> '||to_char(OBJ.YHO_HI) YHO_CNT,
        'S/UMBRAL' SHO_CNT,
        'S/UMBRAL' IHO_CNT,
        to_char(OBJ.CTW_LOW)||' <-> '||to_char(OBJ.CTW_HI) CTW_CNT,
        to_char(OBJ.CPI_LOW)||' <-> '||to_char(OBJ.CPI_HI) CPI_CNT,
        to_char(OBJ.L3I_LOW)||' <-> '||to_char(OBJ.L3I_HI) L3I_CNT,
        to_char(OBJ.PKT_LOW)||' <-> '||to_char(OBJ.PKT_HI) PKT_CNT
from OBJ
union
select  to_char(RFC.FECHA,'dd.mm.yyyy HH24') FECHA,
       '&3' OSSRC,
       to_char(OBJ.CANTIDAD) CANTIDAD,
       case  
            when SRL.CANTIDAD is null then 
                       chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || ' S/VALOR '
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
            when SRL.CANTIDAD = 0 then 
                      TO_CHAR(SRL.CANTIDAD)
            when SRL.CANTIDAD not between OBJ.SRL_LOW and OBJ.SRL_HI then 
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || to_char(SRL.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
            when SRL.CANTIDAD >= ((OBJ.CANTIDAD)*90) /100 then
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green"'
                      ||CHR(38)||'gt;'
                      || to_char(SRL.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
            else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || to_char(SRL.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
       end SRL_CNT,
       case
          when TRF.CANTIDAD is null then 
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || ' S/VALOR '
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          when TRF.CANTIDAD = 0 then 
                          to_char(TRF.CANTIDAD)
          when TRF.CANTIDAD not between OBJ.TRF_LOW  and OBJ.TRF_HI then 
                          chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || to_char(TRF.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          when TRF.CANTIDAD >= ((OBJ.CANTIDAD)*90) /100 then
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green"'
                      ||CHR(38)||'gt;'
                      || to_char(TRF.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      ||to_char(TRF.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end TRF_CNT,
      case
          when CRS.CANTIDAD is null then 
                       chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || ' S/VALOR '
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          when CRS.CANTIDAD = 0 then 
                      to_char(CRS.CANTIDAD)
          when CRS.CANTIDAD not between OBJ.CRS_LOW and OBJ.CRS_HI then 
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || to_char(CRS.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          when CRS.CANTIDAD >= ((OBJ.CANTIDAD)*90) /100 then
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green"'
                      ||CHR(38)||'gt;'
                      || to_char(CRS.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      ||to_char(CRS.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end CRS_CNT,
      case
          when HSW.CANTIDAD is null then 
                       chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || ' S/VALOR '
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          when HSW.CANTIDAD = 0 then 
                      to_char(HSW.CANTIDAD)
          when HSW.CANTIDAD not between OBJ.HSW_LOW and OBJ.HSW_HI then 
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || to_char(HSW.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          when HSW.CANTIDAD >= ((OBJ.CANTIDAD)*90) /100 then
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green"'
                      ||CHR(38)||'gt;'
                      || to_char(HSW.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      ||to_char(HSW.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end HSW_CNT,
      case
          when CTP.CANTIDAD is null then 
                       chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || ' S/VALOR '
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          when CTP.CANTIDAD = 0 then 
                      to_char(CTP.CANTIDAD)
          when CTP.CANTIDAD not between OBJ.CTP_LOW and OBJ.CTP_HI then 
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || to_char(CTP.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          when CTP.CANTIDAD >= ((OBJ.CANTIDAD)*90) /100 then
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green"'
                      ||CHR(38)||'gt;'
                      || to_char(CTP.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      ||to_char(CTP.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end CTP_CNT,
      case
          when RRC.CANTIDAD is null then 
                       chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || ' S/VALOR '
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          when RRC.CANTIDAD = 0 then 
                      to_char(RRC.CANTIDAD)
          when RRC.CANTIDAD not between OBJ.RRC_LOW and OBJ.RRC_HI then 
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || to_char(RRC.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          when RRC.CANTIDAD >= ((OBJ.CANTIDAD)*90) /100 then
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green"'
                      ||CHR(38)||'gt;'
                      || to_char(RRC.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      ||to_char(RRC.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end RRC_CNT,
      case
          when YHO.CANTIDAD is null then 
                       chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || ' S/VALOR '
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          when YHO.CANTIDAD = 0 then 
                      to_char(YHO.CANTIDAD)
          when YHO.CANTIDAD not between OBJ.YHO_LOW and OBJ.YHO_HI then 
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || to_char(YHO.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          when YHO.CANTIDAD >= ((OBJ.CANTIDAD)*90) /100 then
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green"'
                      ||CHR(38)||'gt;'
                      || to_char(YHO.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      ||to_char(YHO.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end YHO_CNT,
      case
          when SHO.CANTIDAD is null then 
                       chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || ' S/VALOR '
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          when SHO.CANTIDAD = 0 then 
                      to_char(SHO.CANTIDAD)
          else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="black"'
                      ||CHR(38)||'gt;'
                      ||to_char(SHO.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end SHO_CNT,
      case
          when IHO.CANTIDAD is null then 
                       chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || ' S/VALOR '
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          when IHO.CANTIDAD = 0 then 
                      to_char(IHO.CANTIDAD)
          else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="black"'
                      ||CHR(38)||'gt;'
                      ||to_char(IHO.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end IHO_CNT,
      case
          when CTW.CANTIDAD is null then 
                       chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || ' S/VALOR '
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          when CTW.CANTIDAD = 0 then 
                      to_char(CTW.CANTIDAD)
          when CTW.CANTIDAD not between OBJ.CTW_LOW and OBJ.CTW_HI then 
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || to_char(CTW.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          when CTW.CANTIDAD >= ((OBJ.CANTIDAD)*90) /100 then
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green"'
                      ||CHR(38)||'gt;'
                      || to_char(CTW.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      ||to_char(CTW.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end CTW_CNT,
      case
          when CPI.CANTIDAD is null then 
                       chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || ' S/VALOR '
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          when CPI.CANTIDAD = 0 then 
                      to_char(CPI.CANTIDAD)
          when CPI.CANTIDAD not between OBJ.CPI_LOW and OBJ.CPI_HI then 
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || to_char(CPI.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          when CPI.CANTIDAD >= ((OBJ.CANTIDAD)*90) /100 then
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green"'
                      ||CHR(38)||'gt;'
                      || to_char(CPI.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      ||to_char(CPI.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end CPI_CNT,
      case
          when L3I.CANTIDAD is null then 
                       chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || ' S/VALOR '
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          when L3I.CANTIDAD = 0 then 
                      to_char(L3I.CANTIDAD)
          when L3I.CANTIDAD not between OBJ.L3I_LOW and OBJ.L3I_HI then 
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || to_char(L3I.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          when L3I.CANTIDAD >= ((OBJ.CANTIDAD)*90) /100 then
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green"'
                      ||CHR(38)||'gt;'
                      || to_char(L3I.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      ||to_char(L3I.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end L3I_CNT,
      case
          when PKT.CANTIDAD is  null then 
                       chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || ' S/VALOR '
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          when PKT.CANTIDAD = 0 then 
                      to_char(PKT.CANTIDAD)
          when PKT.CANTIDAD not between OBJ.PKT_LOW and OBJ.PKT_HI then 
                       chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || to_char(PKT.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          when PKT.CANTIDAD >= ((OBJ.CANTIDAD)*90) /100 then
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green"'
                      ||CHR(38)||'gt;'
                      || to_char(PKT.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      ||to_char(PKT.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end PKT_CNT
from    OBJ,
        RFC,
        SRL,
        TRF,
        CRS,
        HSW,
        CTP,
        RRC,
        YHO,
        SHO,
        IHO,
        CTW,
        CPI,
        L3I,
        PKT
where RFC.FECHA = SRL.FECHA (+)
and   RFC.FECHA = TRF.FECHA (+)
and   RFC.FECHA = CRS.FECHA (+)
AND   RFC.FECHA = HSW.FECHA (+)
AND RFC.FECHA = CTP.FECHA (+)
AND RFC.FECHA = RRC.FECHA (+)
AND RFC.FECHA = YHO.FECHA (+)
AND RFC.FECHA = SHO.FECHA (+)
AND RFC.FECHA = IHO.FECHA (+)
AND RFC.FECHA = CTW.FECHA (+)
AND RFC.FECHA = CPI.FECHA (+)
AND RFC.FECHA = L3I.FECHA (+)
and RFC.FECHA = PKT.FECHA (+)
ORDER BY FECHA;
spool off
exit;
