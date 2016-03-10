with RFC as (
        SELECT /*+ materialize */ FECHA
          from CALIDAD_STATUS_REFERENCES
         where FECHA between TO_DATE('&1', 'DD.MM.YYYY')
                         AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
       ) ,
    TRF as (
        SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM UMTS_C_NSN_TRAFFIC_MNC1_RAW
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
           AND OSSRC = '&3'
         group by PERIOD_START_TIME
       )
select *
from (select  to_char(RFC.FECHA,'dd.mm.yyyy') FECHA,
              '&3' OSSRC,
              case
                when TRF.CANTIDAD is null then '/calidad/data/nsn/storage/xml/'||
                                                lower(substr('&3',4,3))||'/pm/'||--regional cluster
                                                to_char(RFC.FECHA,'yyyymmddHH24')||--folder
                                                '/etlexpmx_BTS_'||to_char(RFC.FECHA,'yyyymmddHH24')||'<COMO_COMPLETO_ESTO>.TRAFFIC.csv.all'--archivo
                when TRF.CANTIDAD = 0 then '/calidad/data/nsn/storage/xml/'||
                                                lower(substr('&3',4,3))||'/pm/'||--regional cluster
                                                to_char(RFC.FECHA,'yyyymmddHH24')||--folder
                                                '/etlexpmx_BTS_'||to_char(RFC.FECHA,'yyyymmddHH24')||'<COMO_COMPLETO_ESTO>.TRAFFIC.csv.all'--archivo
                when TRF.CANTIDAD not between &4  and &5 then '/calidad/data/nsn/storage/xml/'||
                                                lower(substr('&3',4,3))||'/pm/'||--regional cluster
                                                to_char(RFC.FECHA,'yyyymmddHH24')||--folder
                                                '/etlexpmx_BTS_'||to_char(RFC.FECHA,'yyyymmddHH24')||'<COMO_COMPLETO_ESTO>.TRAFFIC.csv.all'--archivo
                else '-1'
              end TRF_CNT
      from    RFC,
              TRF
      where RFC.FECHA = TRF.FECHA (+))
where TRF_CNT != '-1';
