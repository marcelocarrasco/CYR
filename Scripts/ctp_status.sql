select *
from (
      with RFC as (
              SELECT /*+ materialize */ FECHA
                from CALIDAD_STATUS_REFERENCES
               where FECHA between TO_DATE('&1', 'DD.MM.YYYY')
                               AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
             ) ,
          CTP as (
                  SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
                    FROM UMTS_C_NSN_CELLTP_MNC1_RAW
                   WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                               AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
                     AND OSSRC = '&3'
                   GROUP BY PERIOD_START_TIME
                 )
      select to_char(RFC.FECHA,'dd.mm.yyyy') FECHA,
             '&3' OSSRC,
             case
                  when CTP.CANTIDAD is null then CTP.CANTIDAD
                  when CTP.CANTIDAD = 0 then CTP.CANTIDAD
                  when CTP.CANTIDAD not between &4 and &5 then CTP.CANTIDAD
                  else '-1'
              end CTP_CNT
      from    RFC,
              CTP
      where   RFC.FECHA = CTP.FECHA (+))
where CTP_CNT != '1';
