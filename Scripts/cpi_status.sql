select *
from (
      with RFC as (
              SELECT /*+ materialize */ FECHA
                from CALIDAD_STATUS_REFERENCES
               where FECHA between TO_DATE('&1', 'DD.MM.YYYY')
                               AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
             ) ,
          CPI as (
                  SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
                    FROM UMTS_C_NSN_CPICHQ_MNC1_RAW
                   WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                               AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
                     AND OSSRC = '&3'
                   GROUP BY PERIOD_START_TIME
                 )
      select to_char(RFC.FECHA,'dd.mm.yyyy') FECHA,
             '&3' OSSRC,
             case
                  when CPI.CANTIDAD is null then CPI.CANTIDAD
                  when CPI.CANTIDAD = 0 then CPI.CANTIDAD
                  when CPI.CANTIDAD not between substr(&4,1,instr(&4,',',1)) and substr(&4,instr(&4,',',1)+1,length(&4)) then CPI.CANTIDAD
                  else -1
              end CPI_CNT
      from    RFC,
              CPI
      where   RFC.FECHA = CPI.FECHA (+))
where CPI_CNT != 1;
