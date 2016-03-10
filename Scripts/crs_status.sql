select *
from (
      with RFC as (
              SELECT /*+ materialize */ FECHA
                from CALIDAD_STATUS_REFERENCES
               where FECHA between TO_DATE('&1', 'DD.MM.YYYY')
                               AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
             ) ,CRS as (
              SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
                FROM UMTS_C_NSN_CELLRES_MNC1_RAW
               WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                           AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
                 AND OSSRC = '&3'
               group by PERIOD_START_TIME
             )
      select to_char(RFC.FECHA,'dd.mm.yyyy') FECHA,
             '&3' OSSRC,
             case
                when CRS.CANTIDAD is null then CRS.CANTIDAD
                when CRS.CANTIDAD = 0 then CRS.CANTIDAD
                when CRS.CANTIDAD not between &4 and &5 then CRS.CANTIDAD
                else '-1'
            end CRS_CNT
      from    RFC,
              CRS
      where   RFC.FECHA = CRS.FECHA (+))
where CRS_CNT != '1';