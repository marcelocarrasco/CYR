select *
from (
      with RFC as (
              SELECT /*+ materialize */ FECHA
                from CALIDAD_STATUS_REFERENCES
               where FECHA between TO_DATE('&1', 'DD.MM.YYYY')
                               AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
             ) ,
          SHO as (
                  SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
                    FROM UMTS_C_NSN_SOFTHO_MNC1_RAW
                   WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                               AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
                     AND OSSRC = '&3'
                   GROUP BY PERIOD_START_TIME
                 )
      select to_char(RFC.FECHA,'dd.mm.yyyy') FECHA,
             '&3' OSSRC,
             case
                  when SHO.CANTIDAD is null then SHO.CANTIDAD
                  when SHO.CANTIDAD = 0 then SHO.CANTIDAD
                  when SHO.CANTIDAD not between &4 and &5 then SHO.CANTIDAD
                  else '-1'
              end SHO_CNT
      from    RFC,
              SHO
      where   RFC.FECHA = SHO.FECHA (+))
where SHO_CNT != '1';