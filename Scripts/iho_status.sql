select *
from (
      with RFC as (
              SELECT /*+ materialize */ FECHA
                from CALIDAD_STATUS_REFERENCES
               where FECHA between TO_DATE('&1', 'DD.MM.YYYY')
                               AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
             ) ,
          IHO as (
                  SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
                    FROM UMTS_C_NSN_INTERSHO_MNC1_RAW
                   WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                               AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
                     AND OSSRC = '&3'
                   GROUP BY PERIOD_START_TIME
                 )
      select to_char(RFC.FECHA,'dd.mm.yyyy') FECHA,
             '&3' OSSRC,
             case
                  when IHO.CANTIDAD is null then IHO.CANTIDAD
                  when IHO.CANTIDAD = 0 then IHO.CANTIDAD
                  when IHO.CANTIDAD not between &4 and &5 then IHO.CANTIDAD
                  else '-1'
              end IHO_CNT
      from    RFC,
              IHO
      where   RFC.FECHA = IHO.FECHA (+))
where IHO_CNT != '1';