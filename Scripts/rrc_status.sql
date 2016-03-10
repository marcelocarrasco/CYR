select *
from (
      with RFC as (
              SELECT /*+ materialize */ FECHA
                from CALIDAD_STATUS_REFERENCES
               where FECHA between TO_DATE('&1', 'DD.MM.YYYY')
                               AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
             ) ,
          RRC as (
                  SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
                    FROM UMTS_C_NSN_RRC_MNC1_RAW
                   WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                               AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
                     AND OSSRC = '&3'
                   GROUP BY PERIOD_START_TIME
                 )
      select to_char(RFC.FECHA,'dd.mm.yyyy') FECHA,
             '&3' OSSRC,
             case
                  when RRC.CANTIDAD is null then RRC.CANTIDAD
                  when RRC.CANTIDAD = 0 then RRC.CANTIDAD
                  when RRC.CANTIDAD not between &4 and &5 then RRC.CANTIDAD
                  else '-1'
              end RRC_CNT
      from    RFC,
              RRC
      where   RFC.FECHA = RRC.FECHA (+))
where RRC_CNT != '1';