select FECHA,
        OSSRC,
        PKT_CNT
from (
      with RFC as (
              SELECT /*+ materialize */ FECHA
                from CALIDAD_STATUS_REFERENCES
               where FECHA between TO_DATE('&&1', 'DD.MM.YYYY')
                               AND TO_DATE('&&2', 'DD.MM.YYYY') + 86399/86400
             ) ,
          PKT as  (
                  SELECT /*+ materialize */ PERIOD_START_TIME , COUNT(*) CANTIDAD
                    FROM UMTS_C_NSN_PKTCALL_MNC1_RAW
                   WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                               AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
                     AND OSSRC = '&&3'
                   group by PERIOD_START_TIME
                 )
      select to_char(RFC.FECHA,'dd.mm.yyyy') FECHA,
             '&3' OSSRC,
             case
                  when PKT.CANTIDAD is not null then PKT.CANTIDAD
                  when PKT.CANTIDAD = 0 then PKT.CANTIDAD
                  when PKT.CANTIDAD not between &&4 and &&5 then PKT.CANTIDAD
                  else -1
              end PKT_CNT
      from    RFC,
              PKT
      where   RFC.FECHA = PKT.PERIOD_START_TIME (+));
--where PKT_CNT != 1;