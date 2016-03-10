select *
from (
      with RFC as (
              SELECT /*+ materialize */ FECHA
                from CALIDAD_STATUS_REFERENCES
               where FECHA between TO_DATE('&1', 'DD.MM.YYYY')
                               AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
             ) ,
          L3I as (
                    SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
                      FROM UMTS_C_NSN_L3IUB_MNC1_RAW
                     WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                                 AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
                       AND OSSRC = '&3'
                     GROUP BY PERIOD_START_TIME
                   )
      select to_char(RFC.FECHA,'dd.mm.yyyy') FECHA,
             '&3' OSSRC,
             case
                  when L3I.CANTIDAD is not null then L3I.CANTIDAD
                  when L3I.CANTIDAD = 0 then L3I.CANTIDAD
                  when L3I.CANTIDAD not between &4 and &5 then L3I.CANTIDAD
                  else '-1'
              end L3I_CNT
      from    RFC,
              L3I
      where   RFC.FECHA = L3I.FECHA (+))
where L3I_CNT != '1';