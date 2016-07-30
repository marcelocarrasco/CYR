set head off
set feedback off
set lines 360
set pages 5000
set verify off
set echo off

spool &4;
WITH  OBJ as (
                SELECT  CANTIDAD,
                        ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&3',1,INSTR('&3',',',1,1)-1),'999999.999'))) AV_LOW,
                        ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&3',1,INSTR('&3',',',1,1)-1),'999999.999'))) AV_HI,
                        ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&3',INSTR('&3',',',1,1)+1,INSTR('&3',',',1,2)-INSTR('&3',',',1,1)-1),'999999.999'))) LD_LOW ,
                        ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&3',INSTR('&3',',',1,1)+1,INSTR('&3',',',1,2)-INSTR('&3',',',1,1)-1),'999999.999'))) LD_HI,
                        ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&3',INSTR('&3',',',1,2)+1,INSTR('&3',',',1,3)-INSTR('&3',',',1,2)-1),'999999.999'))) LT_LOW,
                        ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&3',INSTR('&3',',',1,2)+1,INSTR('&3',',',1,3)-INSTR('&3',',',1,2)-1),'999999.999'))) LT_HI,
                        ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&3',INSTR('&3',',',1,3)+1,INSTR('&3',',',1,4)-INSTR('&3',',',1,3)-1),'999999.999'))) PSB_LOW,
                        ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&3',INSTR('&3',',',1,3)+1,INSTR('&3',',',1,4)-INSTR('&3',',',1,3)-1),'999999.999'))) PSB_HI,
                        ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&3',INSTR('&3',',',1,4)+1,INSTR('&3',',',1,5)-INSTR('&3',',',1,4)-1),'999999.999'))) QDL_LOW,
                        ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&3',INSTR('&3',',',1,4)+1,INSTR('&3',',',1,5)-INSTR('&3',',',1,4)-1),'999999.999'))) QDL_HI,
                        ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&3',INSTR('&3',',',1,5)+1,INSTR('&3',',',1,6)-INSTR('&3',',',1,5)-1),'999999.999'))) QUL_LOW,
                        ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&3',INSTR('&3',',',1,5)+1,INSTR('&3',',',1,6)-INSTR('&3',',',1,5)-1),'999999.999'))) QUL_HI,
                        ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&3',INSTR('&3',',',1,6)+1,INSTR('&3',',',1,7)-INSTR('&3',',',1,6)-1),'999999.999'))) RC_LOW,
                        ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&3',INSTR('&3',',',1,6)+1,INSTR('&3',',',1,7)-INSTR('&3',',',1,6)-1),'999999.999'))) RC_HI,
                        ROUND(CANTIDAD -(CANTIDAD* TO_NUMBER(SUBSTR('&3',INSTR('&3',',',1,7)+1),'999999.999'))) EST_LOW,
                        ROUND(CANTIDAD +(CANTIDAD* TO_NUMBER(SUBSTR('&3',INSTR('&3',',',1,7)+1),'999999.999'))) EST_HI
                FROM  (
                      SELECT /*+ materialize */ COUNT(DISTINCT ELEMENT_NAME) CANTIDAD
                      FROM MULTIVENDOR_OBJECT2
                      WHERE ELEMENT_CLASS = 'LNCEL'
                      AND VALID_FINISH_DATE > SYSDATE
                      )),
      RFC as  (
                SELECT /*+ materialize */ FECHA
                FROM CALIDAD_STATUS_REFERENCES
                WHERE FECHA BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
              ),
       AV as  (
                SELECT /*+ materialize */ TRUNC(R.PERIOD_START_TIME, 'HH24') FECHA, COUNT(*) CANTIDAD
                FROM NOKLTE_PS_LCELAV_MNC1_RAW r
                WHERE r.PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                              AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
                GROUP BY TRUNC(R.PERIOD_START_TIME, 'HH24')
              ),
      LD  as  (
                SELECT /*+ materialize */ TRUNC(R.PERIOD_START_TIME, 'HH24') FECHA, COUNT(*) CANTIDAD
                FROM NOKLTE_PS_LCELLD_MNC1_RAW r
                WHERE r.PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                             AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
                GROUP BY TRUNC(R.PERIOD_START_TIME, 'HH24')
              ),
      LT  as  (
                SELECT /*+ materialize */ TRUNC(R.PERIOD_START_TIME, 'HH24') FECHA, COUNT(*) CANTIDAD
                FROM NOKLTE_PS_LCELLT_MNC1_RAW R
                WHERE R.PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                             AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
                GROUP BY TRUNC(R.PERIOD_START_TIME, 'HH24')
              ),
      PSB as  (
                SELECT /*+ materialize */ TRUNC(R.PERIOD_START_TIME, 'HH24') FECHA, COUNT(*) CANTIDAD
                FROM NOKLTE_PS_LEPSB_MNC1_RAW r
                WHERE r.PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                             AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
                GROUP BY TRUNC(R.PERIOD_START_TIME, 'HH24')
              ),
      QDL as  (
                SELECT /*+ materialize */ TRUNC(R.PERIOD_START_TIME, 'HH24') FECHA, COUNT(*) CANTIDAD
                FROM NOKLTE_PS_LPQDL_MNC1_RAW r
                WHERE r.PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                             AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
                GROUP BY TRUNC(R.PERIOD_START_TIME, 'HH24')
              ),
      QUL as  (
                SELECT /*+ materialize */ TRUNC(R.PERIOD_START_TIME, 'HH24') FECHA, COUNT(*) CANTIDAD
                FROM NOKLTE_PS_LPQUL_MNC1_RAW r
                WHERE r.PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                           AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
                GROUP BY TRUNC(R.PERIOD_START_TIME, 'HH24')
              ),
      RC  as  (
                SELECT /*+ materialize */ TRUNC(R.PERIOD_START_TIME, 'HH24') FECHA, COUNT(*) CANTIDAD
                FROM NOKLTE_PS_LRRC_MNC1_RAW r
                WHERE r.PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                             AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
                GROUP BY TRUNC(R.PERIOD_START_TIME, 'HH24')
              ),
      EST as  (
                SELECT /*+ materialize */ TRUNC(R.PERIOD_START_TIME, 'HH24') FECHA, COUNT(*) CANTIDAD
                FROM NOKLTE_PS_LUEST_MNC1_RAW r
                WHERE r.PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                             AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
                GROUP BY TRUNC(R.PERIOD_START_TIME, 'HH24')
              )
select  /*html*/ to_char(sysdate-1,'dd.mm.yyyy') FECHA,
        null CANTIDAD,
        to_char(OBJ.AV_LOW)||' <-> '||to_char(OBJ.AV_HI) AV_CNT,
        to_char(OBJ.LD_LOW)||' <-> '||to_char(OBJ.LD_HI) LD_CNT,
        to_char(OBJ.LT_LOW)||' <-> '||to_char(OBJ.LT_HI) LT_CNT,
        to_char(OBJ.PSB_LOW)||' <-> '||to_char(OBJ.PSB_HI) PSB_CNT,
        to_char(OBJ.QDL_LOW)||' <-> '||to_char(OBJ.QDL_HI) QDL_CNT,
        to_char(OBJ.QUL_LOW)||' <-> '||to_char(OBJ.QUL_HI) QUL_CNT,
        to_char(OBJ.RC_LOW)||' <-> '||to_char(OBJ.RC_HI) RC_CNT,
        to_char(OBJ.EST_LOW)||' <-> '||to_char(OBJ.EST_HI) EST_CNT
from OBJ
union
SELECT  to_char(RFC.FECHA,'dd.mm.yyyy HH24') FECHA,
        to_char(OBJ.CANTIDAD) CANTIDAD,
        case  
            when AV.CANTIDAD is null then
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
            when AV.CANTIDAD = 0 then
                      to_char(AV.CANTIDAD)
            when AV.CANTIDAD not between OBJ.AV_LOW and OBJ.AV_HI then
                      to_char(AV.CANTIDAD)
            else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green'
                      ||CHR(38)||'gt;'
                      || to_char(AV.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;' --valor de retorno si todo anda ok
        end AV_CNT,
        case  
            when LD.CANTIDAD is null then
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
            when LD.CANTIDAD = 0 then
                      to_char(LD.CANTIDAD)
            when LD.CANTIDAD not between OBJ.LD_LOW and OBJ.LD_HI then
                      to_char(LD.CANTIDAD) -- fuera del % de tolerancia ej.
            else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green'
                      ||CHR(38)||'gt;'
                      ||to_char(LD.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;' --valor de retorno si todo anda ok
        end LD_CNT,
        case  
            when LT.CANTIDAD is null then
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
            when LT.CANTIDAD = 0 then
                      to_char(LT.CANTIDAD)
            when LT.CANTIDAD not between OBJ.LT_LOW and OBJ.LT_HI then
                      to_char(LT.CANTIDAD) -- fuera del %5 de tolerancia ej.
            else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green'
                      ||CHR(38)||'gt;'
                      ||to_char(LT.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;' --valor de retorno si todo anda ok
        end LT_CNT,
        case  
            when PSB.CANTIDAD is null then
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
            when PSB.CANTIDAD = 0 then
                      to_char(PSB.CANTIDAD)
            when PSB.CANTIDAD not between OBJ.PSB_LOW and OBJ.PSB_HI then
                      to_char(PSB.CANTIDAD) -- fuera del %5 de tolerancia ej.
            else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green'
                      ||CHR(38)||'gt;'
                      ||to_char(PSB.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;' --valor de retorno si todo anda ok
        end PSB_CNT,
        case  
            when QDL.CANTIDAD is null then
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
            when QDL.CANTIDAD = 0 then 
                      to_char(QDL.CANTIDAD)
            when QDL.CANTIDAD not between OBJ.QDL_LOW and QDL_HI then
                      to_char(QDL.CANTIDAD) -- fuera del %5 de tolerancia ej.
            else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green'
                      ||CHR(38)||'gt;'
                      ||to_char(QDL.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;' --valor de retorno si todo anda ok
        end QDL_CNT,
        case  
            when QUL.CANTIDAD is null then
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
            when QUL.CANTIDAD = 0 then
                        to_char(QUL.CANTIDAD)
            when QUL.CANTIDAD not between OBJ.QUL_LOW and OBJ.QUL_HI then
                        to_char(QUL.CANTIDAD) -- fuera del %5 de tolerancia ej.
            else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green'
                      ||CHR(38)||'gt;'
                      ||to_char(QUL.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;' --valor de retorno si todo anda ok
        end QUL_CNT,
        case  
            when RC.CANTIDAD is null then
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
            when RC.CANTIDAD = 0 then
                      to_char(RC.CANTIDAD)
            when RC.CANTIDAD not between OBJ.RC_LOW and OBJ.RC_HI then
                      to_char(RC.CANTIDAD) -- fuera del %5 de tolerancia ej.
            else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green'
                      ||CHR(38)||'gt;'
                      ||to_char(RC.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;' --valor de retorno si todo anda ok
        end RC_CNT,
        case  
            when EST.CANTIDAD is null then
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
            when EST.CANTIDAD = 0 then
                      to_char(EST.CANTIDAD)
            when EST.CANTIDAD not between OBJ.EST_LOW and OBJ.EST_HI then
                      to_char(EST.CANTIDAD) -- fuera del %5 de tolerancia ej.
            else chr(38)||'lt;'
                      || 'strong'
                      ||CHR(38)||'gt;'
                      || chr(38)||'lt;'
                      || 'font color="green'
                      ||CHR(38)||'gt;'
                      ||to_char(EST.CANTIDAD)
                      ||CHR(38)||'lt;'
                      ||'/font'
                      ||chr(38)||'gt;'
                      ||CHR(38)||'lt;'
                      ||'/strong'
                      ||CHR(38)||'gt;' --valor de retorno si todo anda ok
        end EST_CNT
FROM  OBJ,
      RFC,
      AV,
      LD,
      LT,
      PSB,
      QDL,
      QUL,
      RC,
      EST
WHERE RFC.FECHA = AV.FECHA (+)
AND RFC.FECHA = LD.FECHA (+)
AND RFC.FECHA = LT.FECHA (+)
AND RFC.FECHA = PSB.FECHA (+)
AND RFC.FECHA = QDL.FECHA (+)
AND RFC.FECHA = QUL.FECHA (+)
AND RFC.FECHA = RC.FECHA (+)
AND RFC.FECHA = EST.FECHA (+)
ORDER BY FECHA;
SPOOL OFF
EXIT;