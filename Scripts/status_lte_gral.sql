set head off
set feedback off
set lines 360
set pages 5000
set verify off
set echo off

spool &5;
WITH  OBJ as (SELECT /*+ materialize */ COUNT(DISTINCT ELEMENT_NAME) CANTIDAD
              FROM MULTIVENDOR_OBJECT2
              WHERE ELEMENT_CLASS = 'LNCEL'
              AND VALID_FINISH_DATE > SYSDATE
              ),
      RFC as  (SELECT /*+ materialize */ FECHA
              FROM CALIDAD_STATUS_REFERENCES
              WHERE FECHA BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                         AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
              ),
       AV as  (SELECT /*+ materialize */ TRUNC(R.PERIOD_START_TIME, 'HH24') FECHA, COUNT(*) CANTIDAD
              FROM NOKLTE_PS_LCELAV_MNC1_RAW r
              WHERE r.PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                        AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
              GROUP BY TRUNC(R.PERIOD_START_TIME, 'HH24')
              ),
      LD  as  (SELECT /*+ materialize */ TRUNC(R.PERIOD_START_TIME, 'HH24') FECHA, COUNT(*) CANTIDAD
              FROM NOKLTE_PS_LCELLD_MNC1_RAW r
              WHERE r.PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                           AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
              GROUP BY TRUNC(R.PERIOD_START_TIME, 'HH24')
              ),
      LT  as  (SELECT /*+ materialize */ TRUNC(R.PERIOD_START_TIME, 'HH24') FECHA, COUNT(*) CANTIDAD
              FROM NOKLTE_PS_LCELLT_MNC1_RAW R
              WHERE R.PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                           AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
              GROUP BY TRUNC(R.PERIOD_START_TIME, 'HH24')
              ),
      PSB as  (SELECT /*+ materialize */ TRUNC(R.PERIOD_START_TIME, 'HH24') FECHA, COUNT(*) CANTIDAD
              FROM NOKLTE_PS_LEPSB_MNC1_RAW r
              WHERE r.PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                           AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
              GROUP BY TRUNC(R.PERIOD_START_TIME, 'HH24')
              ),
      QDL as  (SELECT /*+ materialize */ TRUNC(R.PERIOD_START_TIME, 'HH24') FECHA, COUNT(*) CANTIDAD
              FROM NOKLTE_PS_LPQDL_MNC1_RAW r
              WHERE r.PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                           AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
              GROUP BY TRUNC(R.PERIOD_START_TIME, 'HH24')
              ),
      QUL as  (SELECT /*+ materialize */ TRUNC(R.PERIOD_START_TIME, 'HH24') FECHA, COUNT(*) CANTIDAD
              FROM NOKLTE_PS_LPQUL_MNC1_RAW r
              WHERE r.PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                         AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
              GROUP BY TRUNC(R.PERIOD_START_TIME, 'HH24')
              ),
      RC  as  (SELECT /*+ materialize */ TRUNC(R.PERIOD_START_TIME, 'HH24') FECHA, COUNT(*) CANTIDAD
              FROM NOKLTE_PS_LRRC_MNC1_RAW r
              WHERE r.PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                           AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
              GROUP BY TRUNC(R.PERIOD_START_TIME, 'HH24')
              ),
      EST as  (SELECT /*+ materialize */ TRUNC(R.PERIOD_START_TIME, 'HH24') FECHA, COUNT(*) CANTIDAD
              FROM NOKLTE_PS_LUEST_MNC1_RAW r
              WHERE r.PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                           AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
              GROUP BY TRUNC(R.PERIOD_START_TIME, 'HH24')
              )
SELECT  /*html*/
        to_char(RFC.FECHA,'dd.mm.yyyy HH24') FECHA,
        to_char(OBJ.CANTIDAD) CANTIDAD,
        case  
            when AV.CANTIDAD is null then to_char(AV.CANTIDAD)
            when AV.CANTIDAD = 0 then to_char(AV.CANTIDAD)
            when AV.CANTIDAD not between &3 and &4 then to_char(AV.CANTIDAD) -- fuera del %5 de tolerancia ej.
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
        end AV_CNT,
        case  
            when LD.CANTIDAD is null then to_char(LD.CANTIDAD)
            when LD.CANTIDAD = 0 then to_char(LD.CANTIDAD)
            when LD.CANTIDAD not between &3 and &4 then to_char(LD.CANTIDAD) -- fuera del %5 de tolerancia ej.
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
        end LD_CNT,
        case  
            when LT.CANTIDAD is null then to_char(LT.CANTIDAD)
            when LT.CANTIDAD = 0 then to_char(LT.CANTIDAD)
            when LT.CANTIDAD not between &3 and &4 then to_char(LT.CANTIDAD) -- fuera del %5 de tolerancia ej.
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
        end LT_CNT,
        case  
            when PSB.CANTIDAD is null then to_char(PSB.CANTIDAD)
            when PSB.CANTIDAD = 0 then to_char(PSB.CANTIDAD)
            when PSB.CANTIDAD not between &3 and &4 then to_char(PSB.CANTIDAD) -- fuera del %5 de tolerancia ej.
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
        end PSB_CNT,
        case  
            when QDL.CANTIDAD is null then to_char(QDL.CANTIDAD)
            when QDL.CANTIDAD = 0 then to_char(QDL.CANTIDAD)
            when QDL.CANTIDAD not between &3 and &4 then to_char(QDL.CANTIDAD) -- fuera del %5 de tolerancia ej.
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
        end QDL_CNT,
        case  
            when QUL.CANTIDAD is null then to_char(QUL.CANTIDAD)
            when QUL.CANTIDAD = 0 then to_char(QUL.CANTIDAD)
            when QUL.CANTIDAD not between &3 and &4 then to_char(QUL.CANTIDAD) -- fuera del %5 de tolerancia ej.
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
        end QUL_CNT,
        case  
            when RC.CANTIDAD is null then to_char(RC.CANTIDAD)
            when RC.CANTIDAD = 0 then to_char(RC.CANTIDAD)
            when RC.CANTIDAD not between &3 and &4 then to_char(RC.CANTIDAD) -- fuera del %5 de tolerancia ej.
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
        end RC_CNT,
        case  
            when EST.CANTIDAD is null then to_char(EST.CANTIDAD)
            when EST.CANTIDAD = 0 then to_char(EST.CANTIDAD)
            when EST.CANTIDAD not between &3 and &4 then to_char(EST.CANTIDAD) -- fuera del %5 de tolerancia ej.
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
ORDER BY RFC.FECHA;
SPOOL OFF
EXIT;