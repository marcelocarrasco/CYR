set head off
set feedback off
set lines 360
set pages 5000
set verify off
set echo off

spool &6;
with  OBJ as (
        SELECT /*+ materialize */ COUNT(DISTINCT ELEMENT_NAME) CANTIDAD
        FROM MULTIVENDOR_OBJECT2
        WHERE ELEMENT_CLASS = 'BTS'
        AND VALID_FINISH_DATE > SYSDATE
        AND OSSRC = '&3'
        ) ,
      RFC as (
        SELECT FECHA
          FROM CALIDAD_STATUS_REFERENCES
         WHERE FECHA BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                         AND TO_DATE('&2', 'DD.MM.YYYY')  + 86399/86400
       ),
       TF2 as (
        SELECT PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM GSM_C_NSN_TRAFFIC_HOU2 --
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY')  + 86399/86400
                                    /* AND BSC_GID = '&BCS'*/
           AND OSSRC = '&3'
         GROUP BY PERIOD_START_TIME
       ),
       HO2 as (
        SELECT PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM GSM_C_NSN_HO_HOU2 --
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY')  + 86399/86400
                                     /*AND BSC_GID = '&BCS'*/
           AND OSSRC = '&3'
         GROUP BY PERIOD_START_TIME
       ),
       SR2 as (
        SELECT PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM GSM_C_NSN_SERVICE_HOU2 --
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY')  + 86399/86400
                                     /*AND BSC_GID = '&BCS'*/
           AND OSSRC = '&3'
         GROUP BY PERIOD_START_TIME
       ),
       RE2 as (
        SELECT PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM GSM_C_NSN_RESAVAIL_HOU2 --
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY')  + 86399/86400
                                     /*AND BSC_GID = '&BCS'*/
           AND OSSRC = '&3'
         GROUP BY PERIOD_START_TIME
       ),
       RC2 as (
        SELECT PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM GSM_C_NSN_RESACC_HOU2 --
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY')  + 86399/86400
                                    /* AND BSC_GID = '&BCS'*/
           AND OSSRC = '&3'
         GROUP BY PERIOD_START_TIME
       ),
       FE2 as (
        SELECT PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM GSM_C_NSN_FER_HOU2 --
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY')  + 86399/86400
                                     /*AND BSC_GID = '&BCS'*/
           AND OSSRC = '&3'
         GROUP BY PERIOD_START_TIME
       ),
       CO2 as (
        SELECT PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM GSM_C_NSN_COD_SCH_HOU2 --
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY')  + 86399/86400
                                     /*AND BSC_GID = '&BCS'*/
           AND OSSRC = '&3'
         GROUP BY PERIOD_START_TIME
       ),
       PC2 as (
        SELECT PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM GSM_C_NSN_PCU_HOU2 --
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY')  + 86399/86400
                                     /*AND BSC_GID = '&BCS'*/
           AND OSSRC = '&3'
         GROUP BY PERIOD_START_TIME
       ),
       QOS as (
        SELECT PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM GSM_C_NSN_QOSPCL_HOU2 --
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY')  + 86399/86400
                                    /* AND BSC_GID = '&BCS'*/
           AND OSSRC = '&3'
         GROUP BY PERIOD_START_TIME
       ),
       RXQ as (
        SELECT PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM GSM_C_NSN_RXQUAL_HOU2 --
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY')  + 86399/86400
           /*AND BSC_GID = '&BCS'*/
           AND OSSRC = '&3'
         GROUP BY PERIOD_START_TIME
       )
select /*html*/ to_char(RFC.FECHA,'dd.mm.yyyy HH24') FECHA,
       '&3' OSSRC,
       to_char(OBJ.CANTIDAD) CANTIDAD,
       case  
            when TF2.CANTIDAD is null then to_char(TF2.CANTIDAD)
            when TF2.CANTIDAD = 0 then to_char(TF2.CANTIDAD)
            when TF2.CANTIDAD not between &4 and &5 then to_char(TF2.CANTIDAD) -- fuera del %5 de tolerancia ej.
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
                      ||CHR(38)||'gt;' --valor de retorno si todo anda ok
       end TF2_CNT,
       case
          when HO2.CANTIDAD is null then to_char(HO2.CANTIDAD)
          when HO2.CANTIDAD = 0 then to_char(HO2.CANTIDAD)
          when HO2.CANTIDAD not between &4  and &5 then to_char(HO2.CANTIDAD)
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
      end HO2_CNT,
      case
          when SR2.CANTIDAD is null then to_char(SR2.CANTIDAD)
          when SR2.CANTIDAD = 0 then to_char(SR2.CANTIDAD)
          when SR2.CANTIDAD not between &4 and &5 then to_char(SR2.CANTIDAD)
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
      end SR2_CNT,
      case
          when RE2.CANTIDAD is null then to_char(RE2.CANTIDAD)
          when RE2.CANTIDAD = 0 then to_char(RE2.CANTIDAD)
          when RE2.CANTIDAD not between &4 and &5 then to_char(RE2.CANTIDAD)
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
      end RE2_CNT,
      case
          when RC2.CANTIDAD is null then to_char(RC2.CANTIDAD)
          when RC2.CANTIDAD = 0 then to_char(RC2.CANTIDAD)
          when RC2.CANTIDAD not between &4 and &5 then to_char(RC2.CANTIDAD)
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
      end RC2_CNT,
      case
          when FE2.CANTIDAD is null then to_char(FE2.CANTIDAD)
          when FE2.CANTIDAD = 0 then to_char(FE2.CANTIDAD)
          when FE2.CANTIDAD not between &4 and &5 then to_char(FE2.CANTIDAD)
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
      end FE2_CNT,
      case
          when CO2.CANTIDAD is null then to_char(CO2.CANTIDAD)
          when CO2.CANTIDAD = 0 then to_char(CO2.CANTIDAD)
          when CO2.CANTIDAD not between &4 and &5 then to_char(CO2.CANTIDAD)
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
      end CO2_CNT,
      case
          when PC2.CANTIDAD is null then to_char(PC2.CANTIDAD)
          when PC2.CANTIDAD = 0 then to_char(PC2.CANTIDAD)
          when PC2.CANTIDAD not between &4 and &5 then to_char(PC2.CANTIDAD)
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
      end PC2_CNT,
      case
          when QOS.CANTIDAD is null then to_char(QOS.CANTIDAD)
          when QOS.CANTIDAD = 0 then to_char(QOS.CANTIDAD)
          when QOS.CANTIDAD not between &4 and &5 then to_char(QOS.CANTIDAD)
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
      end QOS_CNT,
      case
          when RXQ.CANTIDAD is null then to_char(RXQ.CANTIDAD)
          when RXQ.CANTIDAD = 0 then to_char(RXQ.CANTIDAD)
          when RXQ.CANTIDAD not between &4 and &5 then to_char(RXQ.CANTIDAD)
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
      end RXQ_CNT
from    OBJ,
        RFC,
        TF2,
        HO2,
        SR2,
        RE2,
        RC2,
        FE2,
        CO2,
        PC2,
        QOS,
        RXQ
where RFC.FECHA = TF2.FECHA (+)
and   RFC.FECHA = HO2.FECHA (+)
and   RFC.FECHA = SR2.FECHA (+)
AND   RFC.FECHA = RE2.FECHA (+)
AND RFC.FECHA = RC2.FECHA (+)
AND RFC.FECHA = FE2.FECHA (+)
AND RFC.FECHA = CO2.FECHA (+)
AND RFC.FECHA = PC2.FECHA (+)
AND RFC.FECHA = QOS.FECHA (+)
AND RFC.FECHA = RXQ.FECHA (+)
ORDER BY RFC.FECHA;
spool off
exit;
