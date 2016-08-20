set head off
set feedback off
set lines 360
set pages 5000
set verify off
set echo off

spool &5;
with  OBJ as (
              SELECT  CANTIDAD,
                      ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&4',1,INSTR('&4',',',1,1)-1),'999999.999'))) TF2_LOW,
                      ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&4',1,INSTR('&4',',',1,1)-1),'999999.999'))) TF2_HI,
                      ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,1)+1,INSTR('&4',',',1,2)-INSTR('&4',',',1,1)-1),'999999.999'))) HO2_LOW ,
                      ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,1)+1,INSTR('&4',',',1,2)-INSTR('&4',',',1,1)-1),'999999.999'))) HO2_HI,
                      ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,2)+1,INSTR('&4',',',1,3)-INSTR('&4',',',1,2)-1),'999999.999'))) SR2_LOW,
                      ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,2)+1,INSTR('&4',',',1,3)-INSTR('&4',',',1,2)-1),'999999.999'))) SR2_HI,
                      ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,3)+1,INSTR('&4',',',1,4)-INSTR('&4',',',1,3)-1),'999999.999'))) RE2_LOW,
                      ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,3)+1,INSTR('&4',',',1,4)-INSTR('&4',',',1,3)-1),'999999.999'))) RE2_HI,
                      ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,4)+1,INSTR('&4',',',1,5)-INSTR('&4',',',1,4)-1),'999999.999'))) RC2_LOW,
                      ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,4)+1,INSTR('&4',',',1,5)-INSTR('&4',',',1,4)-1),'999999.999'))) RC2_HI,
                      ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,5)+1,INSTR('&4',',',1,6)-INSTR('&4',',',1,5)-1),'999999.999'))) FE2_LOW,
                      ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,5)+1,INSTR('&4',',',1,6)-INSTR('&4',',',1,5)-1),'999999.999'))) FE2_HI,
                      ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,6)+1,INSTR('&4',',',1,7)-INSTR('&4',',',1,6)-1),'999999.999'))) CO2_LOW,
                      ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,6)+1,INSTR('&4',',',1,7)-INSTR('&4',',',1,6)-1),'999999.999'))) CO2_HI,
                      ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,7)+1,INSTR('&4',',',1,8)-INSTR('&4',',',1,7)-1),'999999.999'))) PC2_LOW,
                      ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,7)+1,INSTR('&4',',',1,8)-INSTR('&4',',',1,7)-1),'999999.999'))) PC2_HI,
                      ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,8)+1,INSTR('&4',',',1,9)-INSTR('&4',',',1,8)-1),'999999.999'))) QOS_LOW,
                      ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,8)+1,INSTR('&4',',',1,9)-INSTR('&4',',',1,8)-1),'999999.999'))) QOS_HI,
                      ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,9)+1),'999999.999'))) RXQ_LOW,
                      ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&4',INSTR('&4',',',1,9)+1),'999999.999'))) RXQ_HI
        FROM  (
                SELECT /*+ materialize */ COUNT(DISTINCT ELEMENT_NAME) CANTIDAD
                FROM MULTIVENDOR_OBJECT2
                WHERE ELEMENT_CLASS = 'BTS'
                AND VALID_FINISH_DATE > SYSDATE
                AND OSSRC = '&3'
              )) ,
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
                AND OSSRC = '&3'
                GROUP BY PERIOD_START_TIME
              ),
       HO2 as (
                SELECT PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
                FROM GSM_C_NSN_HO_HOU2 --
                WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                         AND TO_DATE('&2', 'DD.MM.YYYY')  + 86399/86400
                AND OSSRC = '&3'
                GROUP BY PERIOD_START_TIME
              ),
       SR2 as (
                SELECT PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
                FROM GSM_C_NSN_SERVICE_HOU2 --
                WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                         AND TO_DATE('&2', 'DD.MM.YYYY')  + 86399/86400
                AND OSSRC = '&3'
                GROUP BY PERIOD_START_TIME
              ),
       RE2 as (
                SELECT PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
                FROM GSM_C_NSN_RESAVAIL_HOU2 --
                WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                         AND TO_DATE('&2', 'DD.MM.YYYY')  + 86399/86400
                AND OSSRC = '&3'
                GROUP BY PERIOD_START_TIME
              ),
       RC2 as (
                SELECT PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
                FROM GSM_C_NSN_RESACC_HOU2 --
                WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                         AND TO_DATE('&2', 'DD.MM.YYYY')  + 86399/86400
                AND OSSRC = '&3'
                GROUP BY PERIOD_START_TIME
              ),
       FE2 as (
                SELECT PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
                FROM GSM_C_NSN_FER_HOU2 --
                WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                         AND TO_DATE('&2', 'DD.MM.YYYY')  + 86399/86400
                AND OSSRC = '&3'
                GROUP BY PERIOD_START_TIME
              ),
       CO2 as (
                SELECT PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
                FROM GSM_C_NSN_COD_SCH_HOU2 --
                WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                         AND TO_DATE('&2', 'DD.MM.YYYY')  + 86399/86400
                AND OSSRC = '&3'
                GROUP BY PERIOD_START_TIME
              ),
       PC2 as (
                SELECT PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
                FROM GSM_C_NSN_PCU_HOU2 --
                WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                         AND TO_DATE('&2', 'DD.MM.YYYY')  + 86399/86400
                AND OSSRC = '&3'
                GROUP BY PERIOD_START_TIME
              ),
       QOS as (
                SELECT PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
                FROM GSM_C_NSN_QOSPCL_HOU2 --
                WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                         AND TO_DATE('&2', 'DD.MM.YYYY')  + 86399/86400
                AND OSSRC = '&3'
                GROUP BY PERIOD_START_TIME
              ),
       RXQ as (
                SELECT PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
                FROM GSM_C_NSN_RXQUAL_HOU2 --
                WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                         AND TO_DATE('&2', 'DD.MM.YYYY')  + 86399/86400
                AND OSSRC = '&3'
                GROUP BY PERIOD_START_TIME
              )
select  /*html*/ to_char(sysdate-1,'dd.mm.yyyy') FECHA,
        null OSSRC,
        null CANTIDAD,
        to_char(OBJ.TF2_LOW)||' <-> '||to_char(OBJ.TF2_HI) TF2_CNT,
        'S/UMBRAL' HO2_CNT,
        to_char(OBJ.SR2_LOW)||' <-> '||to_char(OBJ.SR2_HI) SR2_CNT,
        to_char(OBJ.RE2_LOW)||' <-> '||to_char(OBJ.RE2_HI) RE2_CNT,
        to_char(OBJ.RC2_LOW)||' <-> '||to_char(OBJ.RC2_HI) RC2_CNT,
        'S/UMBRAL' FE2_CNT,
        to_char(OBJ.CO2_LOW)||' <-> '||to_char(OBJ.CO2_HI) CO2_CNT,
        to_char(OBJ.PC2_LOW)||' <-> '||to_char(OBJ.PC2_HI) PC2_CNT,
        'S/UMBRAL' QOS_CNT,
        'S/UMBRAL' RXQ_CNT
from OBJ
union
select  to_char(RFC.FECHA,'dd.mm.yyyy HH24') FECHA,
       '&3' OSSRC,
       to_char(OBJ.CANTIDAD) CANTIDAD,
       case  
            when TF2.CANTIDAD is null then 
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
            when TF2.CANTIDAD = 0 then 
                      to_char(TF2.CANTIDAD)
            when TF2.CANTIDAD not between OBJ.TF2_LOW and OBJ.TF2_HI then
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || to_char(TF2.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
            when TF2.CANTIDAD >= ((OBJ.CANTIDAD)*90) /100 then
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green"'
                      ||CHR(38)||'gt;'
                      || to_char(TF2.CANTIDAD)
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
                      || to_char(TF2.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;' --valor de retorno si todo anda ok
       end TF2_CNT,
       case
          when HO2.CANTIDAD is null then
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
          when HO2.CANTIDAD = 0 then
                      to_char(HO2.CANTIDAD)
          else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="black"'
                      ||CHR(38)||'gt;'
                      ||to_char(HO2.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end HO2_CNT,
      case
          when SR2.CANTIDAD is null then 
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
          when SR2.CANTIDAD = 0 then
                      to_char(SR2.CANTIDAD)
          when SR2.CANTIDAD not between OBJ.SR2_LOW and OBJ.SR2_HI then
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || to_char(SR2.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          when SR2.CANTIDAD >= ((OBJ.CANTIDAD)*90) /100 then
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green"'
                      ||CHR(38)||'gt;'
                      || to_char(SR2.CANTIDAD)
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
                      ||to_char(SR2.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end SR2_CNT,
      case
          when RE2.CANTIDAD is null then
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
          when RE2.CANTIDAD = 0 then
                      to_char(RE2.CANTIDAD)
          when RE2.CANTIDAD not between OBJ.RE2_LOW and OBJ.RE2_HI then
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || to_char(RE2.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          when RE2.CANTIDAD >= ((OBJ.CANTIDAD)*90) /100 then
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green"'
                      ||CHR(38)||'gt;'
                      || to_char(RE2.CANTIDAD)
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
                      ||to_char(RE2.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end RE2_CNT,
      case
          when RC2.CANTIDAD is null then
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
          when RC2.CANTIDAD = 0 then
                      to_char(RC2.CANTIDAD)
          when RC2.CANTIDAD not between OBJ.RC2_LOW and OBJ.RC2_HI then
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || to_char(RC2.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          when RC2.CANTIDAD >= ((OBJ.CANTIDAD)*90) /100 then
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green"'
                      ||CHR(38)||'gt;'
                      || to_char(RC2.CANTIDAD)
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
                      ||to_char(RC2.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end RC2_CNT,
      case
          when FE2.CANTIDAD is null then 
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
          when FE2.CANTIDAD = 0 then
                      to_char(FE2.CANTIDAD)
          else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="black"'
                      ||CHR(38)||'gt;'
                      ||to_char(FE2.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end FE2_CNT,
      case
          when CO2.CANTIDAD is null then
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
          when CO2.CANTIDAD = 0 then
                      to_char(CO2.CANTIDAD)
          when CO2.CANTIDAD not between OBJ.CO2_LOW and OBJ.CO2_HI then
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || to_char(CO2.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          when CO2.CANTIDAD >= ((OBJ.CANTIDAD)*90) /100 then
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green"'
                      ||CHR(38)||'gt;'
                      || to_char(CO2.CANTIDAD)
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
                      ||to_char(CO2.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end CO2_CNT,
      case
          when PC2.CANTIDAD is null then
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
          when PC2.CANTIDAD = 0 then
                      to_char(PC2.CANTIDAD)
          when PC2.CANTIDAD not between OBJ.PC2_LOW and OBJ.PC2_HI then
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="red"'
                      ||CHR(38)||'gt;'
                      || to_char(PC2.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
          when PC2.CANTIDAD >= ((OBJ.CANTIDAD)*90) /100 then
                      chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green"'
                      ||CHR(38)||'gt;'
                      || to_char(PC2.CANTIDAD)
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
                      ||to_char(PC2.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end PC2_CNT,
      case
          when QOS.CANTIDAD is null then
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
          when QOS.CANTIDAD = 0 then
                      to_char(QOS.CANTIDAD)
          else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="black"'
                      ||CHR(38)||'gt;'
                      ||to_char(QOS.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;'
      end QOS_CNT,
      case
          when RXQ.CANTIDAD is null then
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
          when RXQ.CANTIDAD = 0 then
                      to_char(RXQ.CANTIDAD)
         else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="black"'
                      ||CHR(38)||'gt;'
                      ||to_char(RXQ.CANTIDAD)
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
ORDER BY FECHA;
spool off
exit;