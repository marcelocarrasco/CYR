select *
from (
      with RFC as (
              SELECT /*+ materialize */ FECHA
                from CALIDAD_STATUS_REFERENCES
               where FECHA between TO_DATE('&1', 'DD.MM.YYYY')
                               AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
             ) ,
          HSW as (
                  SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
                    FROM UMTS_C_NSN_HSDPAW_MNC1_RAW
                   WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                               AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
                     AND OSSRC = '&3'
                   GROUP BY PERIOD_START_TIME
                 )
      select to_char(RFC.FECHA,'dd.mm.yyyy') FECHA,
             '&3' OSSRC,
             case
                  when HSW.CANTIDAD is null then HSW.CANTIDAD
                  when HSW.CANTIDAD = 0 then HSW.CANTIDAD
                  when HSW.CANTIDAD not between &4 and &5 then HSW.CANTIDAD
                  else '-1'
              end HSW_CNT
      from    RFC,
              HSW
      where   RFC.FECHA = HSW.FECHA (+))
where HSW_CNT != '1';
