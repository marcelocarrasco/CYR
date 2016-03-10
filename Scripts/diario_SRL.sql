

-- /calidad/data/nsn/storage/xml/rc3/pm/2015120112/etlexpmx_WCEL_2015120112.Service_Level.csv.all

--select * from status_process_etl where 
--FILENAME like '/calidad/data/nsn/storage/xml/rc3/pm/2016022503/etlexpmx_%_2016022503.Service_Level.csv.all';
--
--select to_char(sysdate,'yyyymmddHH24') from dual;


--undefine OSSRC
set VERIFY off
set FEEDBACK off

--DEFINE TOTAL_OBJ_LOW=22388
--DEFINE TOTAL_OBJ_HI=23018
--DEFINE OSSCRC='OSSRC3'

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
                              AND OSSRC = '&&OSSRC'
                              group by PERIOD_START_TIME
                              )
                select /*html*/ to_char(RFC.FECHA,'dd.mm.yyyy HH24') FECHA,to_char(RFC.FECHA,'HH24') HORA,
                       '&OSSRC' OSSRC,
                       SRL.CANTIDAD CANTIDAD,
                       case  
                            when SRL.CANTIDAD is null then '/calidad/data/nsn/storage/xml/rc3/pm/'||
                                                            to_char(RFC.FECHA,'yyyymmddHH24')||
                                                            '/etlexpmx_WCEL_'||to_char(RFC.FECHA,'yyyymmddHH24')||
                                                            '.Service_Level.csv.all' 
                            when SRL.CANTIDAD = 0 then '/calidad/data/nsn/storage/xml/rc3/pm/'||
                                                        to_char(RFC.FECHA,'yyyymmddHH24')||
                                                        '/etlexpmx_WCEL_'||to_char(RFC.FECHA,'yyyymmddHH24')||
                                                        '.Service_Level.csv.all'
                            when SRL.CANTIDAD not between &&TOTAL_OBJ_LOW 
                                  and &&TOTAL_OBJ_HI then '/calidad/data/nsn/storage/xml/rc3/pm/'||
                                                          to_char(RFC.FECHA,'yyyymmddHH24')||
                                                          '/etlexpmx_WCEL_'||to_char(RFC.FECHA,'yyyymmddHH24')||
                                                          '.Service_Level.csv.all' -- fuera del %5 de tolerancia ej.
                            else '-1' --valor de retorno si todo anda ok
                       end SRL_CNT
                from    RFC,
                        SRL
                where RFC.FECHA = SRL.FECHA (+)
                
                ORDER BY RFC.FECHA)
where srl_cnt = '-1';
