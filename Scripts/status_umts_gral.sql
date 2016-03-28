set head off
set feedback off
set lines 360
set pages 5000
set verify off
set echo off

spool &6;
with  OBJ as (
        SELECT  cantidad CANTIDAD,
                round(cantidad -(cantidad*0.05)) RFC_LOW,
                round(cantidad +(cantidad*0.05)) RFC_HI,
                round(cantidad -(cantidad* substr(&4,1,instr(&4,',',1)))) SRL_LOW,
                round(cantidad +(cantidad* substr(&4,1,instr(&4,',',1)))) SRL_HI,
                round(cantidad -(cantidad* substr(&4,instr(&4,',',2)+1,instr(&4,',',3)-1))) TRF_LOW,
                round(cantidad +(cantidad* substr(&4,instr(&4,',',3)+1,instr(&4,',',4)-1))) TRF_HI,
                round(cantidad -(cantidad* substr(&4,instr(&4,',',4)+1,instr(&4,',',5)-1))) CRS_LOW,
                round(cantidad +(cantidad* substr(&4,instr(&4,',',5)+1,instr(&4,',',6)-1))) CRS_HI,
                round(cantidad -(cantidad* substr(&4,instr(&4,',',6)+1,instr(&4,',',7)-1))) HSW_LOW,
                round(cantidad +(cantidad*0.05)) HSW_HI,
                round(cantidad -(cantidad*0.05)) CTP_LOW,
                round(cantidad +(cantidad*0.05)) CTP_HI,
                round(cantidad -(cantidad*0.05)) RRC_LOW,
                round(cantidad +(cantidad*0.05)) RRC_HI,
                round(cantidad -(cantidad*0.05)) YHO_LOW,
                round(cantidad +(cantidad*0.05)) YHO_HI,
                round(cantidad -(cantidad*0.05)) SHO_LOW,
                round(cantidad +(cantidad*0.05)) SHO_HI,
                round(cantidad -(cantidad*0.05)) IHO_LOW,
                round(cantidad +(cantidad*0.05)) IHO_HI,
                round(cantidad -(cantidad*0.05)) CTW_LOW,
                round(cantidad +(cantidad*0.05)) CTW_HI,
                round(cantidad -(cantidad*0.05)) CPI_LOW,
                round(cantidad +(cantidad*0.05)) CPI_HI,
                round(cantidad -(cantidad*0.05)) L3I_LOW,
                round(cantidad +(cantidad*0.05)) L3I_HI,
                round(cantidad -(cantidad*0.05)) PKT_LOW,
                round(cantidad +(cantidad*0.05)) PKT_HI
        FROM  (
                SELECT /*+ materialize */ COUNT(DISTINCT ELEMENT_NAME) CANTIDAD
                FROM MULTIVENDOR_OBJECT2
                WHERE ELEMENT_CLASS = 'WCELL'
                AND VALID_FINISH_DATE > SYSDATE
                AND OSSRC = '&3'
              )) ,
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
select /*html*/ to_char(RFC.FECHA,'dd.mm.yyyy HH24') FECHA,
       '&3' OSSRC,
       to_char(OBJ.CANTIDAD) CANTIDAD,
       case  
            when SRL.CANTIDAD is null then to_char(SRL.CANTIDAD)
                      
            when SRL.CANTIDAD = 0 then TO_CHAR(SRL.CANTIDAD)
            when SRL.CANTIDAD not between OBJ.SRL_LOW and OBJ.SRL_HI then 
                      to_char(SRL.CANTIDAD)-- fuera del %5 de tolerancia ej.
            else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green"'
                      ||CHR(38)||'gt;'
                      ||' OK '
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'--valor de retorno si todo anda ok
       end SRL_CNT,
       case
          when TRF.CANTIDAD is null then 
                          to_char(TRF.CANTIDAD)
          when TRF.CANTIDAD = 0 then 
                          to_char(TRF.CANTIDAD)
          when TRF.CANTIDAD not between OBJ.TRF_LOW  and OBJ.TRF_HI then 
                          to_char(TRF.CANTIDAD)
          else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green"'
                      ||CHR(38)||'gt;'
                      ||' OK '
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end TRF_CNT,
      case
          when CRS.CANTIDAD is null then 
                      to_char(CRS.CANTIDAD)
          when CRS.CANTIDAD = 0 then 
                      to_char(CRS.CANTIDAD)
          when CRS.CANTIDAD not between OBJ.CRS_LOW and OBJ.CRS_HI then 
                      to_char(CRS.CANTIDAD)
          else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green"'
                      ||CHR(38)||'gt;'
                      ||' OK '
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end CRS_CNT,
      case
          when HSW.CANTIDAD is null then 
                      to_char(HSW.CANTIDAD)
          when HSW.CANTIDAD = 0 then 
                      to_char(HSW.CANTIDAD)
          when HSW.CANTIDAD not between OBJ.HSW_LOW and OBJ.HSW_HI then 
                      to_char(HSW.CANTIDAD)
          else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green"'
                      ||CHR(38)||'gt;'
                      ||' OK '
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end HSW_CNT,
      case
          when CTP.CANTIDAD is null then 
                      to_char(CTP.CANTIDAD)
          when CTP.CANTIDAD = 0 then 
                      to_char(CTP.CANTIDAD)
          when CTP.CANTIDAD not between OBJ.CTP_LOW and OBJ.CTP_HI then 
                      to_char(CTP.CANTIDAD)
          else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green"'
                      ||CHR(38)||'gt;'
                      ||' OK '
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end CTP_CNT,
      case
          when RRC.CANTIDAD is null then 
                      to_char(RRC.CANTIDAD)
          when RRC.CANTIDAD = 0 then 
                      to_char(RRC.CANTIDAD)
          when RRC.CANTIDAD not between OBJ.RRC_LOW and OBJ.RRC_HI then 
                      to_char(RRC.CANTIDAD)
          else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green"'
                      ||CHR(38)||'gt;'
                      ||' OK '
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end RRC_CNT,
      case
          when YHO.CANTIDAD is null then 
                      to_char(YHO.CANTIDAD)
          when YHO.CANTIDAD = 0 then 
                      to_char(YHO.CANTIDAD)
          when YHO.CANTIDAD not between OBJ.YHO_LOW and OBJ.YHO_HI then 
                      to_char(YHO.CANTIDAD)
          else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green"'
                      ||CHR(38)||'gt;'
                      ||' OK '
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end YHO_CNT,
      case
          when SHO.CANTIDAD is null then 
                      to_char(SHO.CANTIDAD)
          when SHO.CANTIDAD = 0 then 
                      to_char(SHO.CANTIDAD)
          when SHO.CANTIDAD not between OBJ.SHO_LOW and OBJ.SHO_HI then 
                      to_char(SHO.CANTIDAD)
          else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green"'
                      ||CHR(38)||'gt;'
                      ||' OK '
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end SHO_CNT,
      case
          when IHO.CANTIDAD is null then 
                      to_char(IHO.CANTIDAD)
          when IHO.CANTIDAD = 0 then 
                      to_char(IHO.CANTIDAD)
          when IHO.CANTIDAD not between OBJ.IHO_LOW and OBJ.IHO_HI then 
                      to_char(IHO.CANTIDAD)
          else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green"'
                      ||CHR(38)||'gt;'
                      ||' OK '
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end IHO_CNT,
      case
          when CTW.CANTIDAD is null then 
                      to_char(CTW.CANTIDAD)
          when CTW.CANTIDAD = 0 then 
                      to_char(CTW.CANTIDAD)
          when CTW.CANTIDAD not between OBJ.CTW_LOW and OBJ.CTW_HI then 
                      to_char(CTW.CANTIDAD)
          else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green"'
                      ||CHR(38)||'gt;'
                      ||' OK '
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end CTW_CNT,
      case
          when CPI.CANTIDAD is null then 
                      to_char(CPI.CANTIDAD)
          when CPI.CANTIDAD = 0 then 
                      to_char(CPI.CANTIDAD)
          when CPI.CANTIDAD not between OBJ.CPI_LOW and OBJ.CPI_HI then 
                      to_char(CPI.CANTIDAD)
          else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green"'
                      ||CHR(38)||'gt;'
                      ||' OK '
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end CPI_CNT,
      case
          when L3I.CANTIDAD is null then 
                      to_char(L3I.CANTIDAD)
          when L3I.CANTIDAD = 0 then 
                      to_char(L3I.CANTIDAD)
          when L3I.CANTIDAD not between OBJ.L3I_LOW and OBJ.L3I_HI then 
                      to_char(L3I.CANTIDAD)
          else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green"'
                      ||CHR(38)||'gt;'
                      ||' OK '
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end L3I_CNT,
      case
          when PKT.CANTIDAD is  null then 
                      to_char(PKT.CANTIDAD)
          when PKT.CANTIDAD = 0 then 
                      to_char(PKT.CANTIDAD)
          when PKT.CANTIDAD not between OBJ.PKT_LOW and OBJ.PKT_HI then 
                      to_char(PKT.CANTIDAD)
          else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green"'
                      ||CHR(38)||'gt;'
                      ||' OK '
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
ORDER BY RFC.FECHA;
spool off
exit;
