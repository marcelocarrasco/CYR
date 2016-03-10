set head off
set feedback off
set lines 360
set pages 5000
set verify off
set echo off

select * from (
                with RFC as (
                            SELECT /*+ materialize */ FECHA
                            from CALIDAD_STATUS_REFERENCES
                            where FECHA between TO_DATE('&&1', 'DD.MM.YYYY')
                                             AND TO_DATE('&&2', 'DD.MM.YYYY') + 86399/86400
                            ) ,
                      SRL as (
                              SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
                              FROM UMTS_C_NSN_SERVLEV_MNC1_RAW
                              WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                                           and TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
                              AND OSSRC = '&&3'
                              group by PERIOD_START_TIME
                              )
                select to_char(RFC.FECHA,'dd.mm.yyyy HH24') FECHA,
                       '&3' OSSRC,
                       SRL.CANTIDAD CANTIDAD,
                       case  
                            when SRL.CANTIDAD is null then 'select FILENAME, STATUS '||
                                                            'from STATUS_PROCESS_ETL where NETWORK_ELEMENT = ''WCEL'' and MEASUREMENT_TYPE = ''Service_Level'''||
                                                            ' and FILENAME like ''/calidad/data/nsn/storage/xml/'||
                                                            lower(substr('&3',4,3))||'/pm/'||
                                                            to_char(RFC.FECHA,'yyyymmddHH24')||'%.all'';'
                            
                            when SRL.CANTIDAD = 0 then 'select FILENAME, STATUS '||
                                                        'from STATUS_PROCESS_ETL where NETWORK_ELEMENT = ''WCEL'' and MEASUREMENT_TYPE = ''Service_Level'''||
                                                        ' and FILENAME like ''/calidad/data/nsn/storage/xml/'||
                                                        lower(substr('&3',4,3))||'/pm/'||
                                                        to_char(RFC.FECHA,'yyyymmddHH24')||'%.all'';'
                            when SRL.CANTIDAD not between &&TOTAL_OBJ_LOW 
                                  and &&TOTAL_OBJ_HI then 'select FILENAME, STATUS '||
                                                          'from STATUS_PROCESS_ETL where NETWORK_ELEMENT = ''WCEL'' and MEASUREMENT_TYPE = ''Service_Level'''||
                                                          ' and FILENAME like ''/calidad/data/nsn/storage/xml/'||
                                                          lower(substr('&3',4,3))||'/pm/'||
                                                          to_char(RFC.FECHA,'yyyymmddHH24')||'%.all'';'-- fuera del %5 de tolerancia ej.
                            else '-1' --valor de retorno si todo anda ok
                       end SRL_CNT
                from    RFC,
                        SRL
                where RFC.FECHA = SRL.FECHA (+)
                
                ORDER BY RFC.FECHA)
where srl_cnt != '-1';