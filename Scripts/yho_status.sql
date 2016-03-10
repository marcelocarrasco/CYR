select *
from (
      with RFC as (
              SELECT /*+ materialize */ FECHA
                from CALIDAD_STATUS_REFERENCES
               where FECHA between TO_DATE('&1', 'DD.MM.YYYY')
                               AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
             ) ,
          YHO as (
                  SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
                    FROM UMTS_C_NSN_INTSYSHO_MNC1_RAW
                   WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                               AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
                     AND OSSRC = '&3'
                   GROUP BY PERIOD_START_TIME
                 )
      select to_char(RFC.FECHA,'dd.mm.yyyy') FECHA,
             '&3' OSSRC,
             case
                  when YHO.CANTIDAD is null then YHO.CANTIDAD
                  when YHO.CANTIDAD = 0 then YHO.CANTIDAD
                  when YHO.CANTIDAD not between &4 and &5 then YHO.CANTIDAD
                  else '-1'
              end YHO_CNT
      from    RFC,
              YHO
      where   RFC.FECHA = YHO.FECHA (+))
where YHO_CNT != '1';