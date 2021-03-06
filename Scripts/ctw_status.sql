select *
from (
      with RFC as (
              SELECT /*+ materialize */ FECHA
                from CALIDAD_STATUS_REFERENCES
               where FECHA between TO_DATE('&1', 'DD.MM.YYYY')
                               AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
             ) ,
          CTW as (
                  SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
                    FROM UMTS_C_NSN_CELTPW_MNC1_RAW
                   WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                               AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
                     AND OSSRC = '&3'
                   GROUP BY PERIOD_START_TIME
                 )
      select to_char(RFC.FECHA,'dd.mm.yyyy') FECHA,
             '&3' OSSRC,
             case
                  when CTW.CANTIDAD is null then CTW.CANTIDAD
                  when CTW.CANTIDAD = 0 then CTW.CANTIDAD
                  when CTW.CANTIDAD not between &4 and &5 then CTW.CANTIDAD
                  else '-1'
              end CTW_CNT
      from    RFC,
              CTW
      where   RFC.FECHA = CTW.FECHA (+))
where CTW_CNT != '1';