--undefine OSSRC
set VERIFY off
set FEEDBACK off

--DEFINE TOTAL_OBJ_LOW=22388
--DEFINE TOTAL_OBJ_HI=23018
--DEFINE OSSCRC='OSSRC3'


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
       ) ,
      TRF as (
        SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM UMTS_C_NSN_TRAFFIC_MNC1_RAW
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
           AND OSSRC = '&3'
         group by PERIOD_START_TIME
       ) ,
      CRS as (
        SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM UMTS_C_NSN_CELLRES_MNC1_RAW
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
           AND OSSRC = '&3'
         group by PERIOD_START_TIME
       ) ,
      HSW as (
        SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM UMTS_C_NSN_HSDPAW_MNC1_RAW
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
           AND OSSRC = '&3'
         GROUP BY PERIOD_START_TIME
       ) ,
      CTP as (
        SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM UMTS_C_NSN_CELLTP_MNC1_RAW
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
           AND OSSRC = '&3'
         GROUP BY PERIOD_START_TIME
       ) ,
      RRC as (
        SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM UMTS_C_NSN_RRC_MNC1_RAW
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
           AND OSSRC = '&3'
         GROUP BY PERIOD_START_TIME
       ) ,
      YHO as (
        SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM UMTS_C_NSN_INTSYSHO_MNC1_RAW
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
           AND OSSRC = '&3'
         GROUP BY PERIOD_START_TIME
       ) ,
      SHO as (
        SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM UMTS_C_NSN_SOFTHO_MNC1_RAW
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
           AND OSSRC = '&3'
         GROUP BY PERIOD_START_TIME
       ) ,
      IHO as (
        SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM UMTS_C_NSN_INTERSHO_MNC1_RAW
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
           AND OSSRC = '&3'
         GROUP BY PERIOD_START_TIME
       ) ,
     CTW as (
        SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM UMTS_C_NSN_CELTPW_MNC1_RAW
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
           AND OSSRC = '&3'
         GROUP BY PERIOD_START_TIME
       ) ,
      CPI as (
        SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM UMTS_C_NSN_CPICHQ_MNC1_RAW
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
           AND OSSRC = '&3'
         GROUP BY PERIOD_START_TIME
       ) ,
      L3I as (
        SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM UMTS_C_NSN_L3IUB_MNC1_RAW
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
           AND OSSRC = '&3'
         GROUP BY PERIOD_START_TIME
       ) ,
     PKT as  (
        SELECT /*+ materialize */ PERIOD_START_TIME FECHA, COUNT(*) CANTIDAD
          FROM UMTS_C_NSN_PKTCALL_MNC1_RAW
         WHERE PERIOD_START_TIME BETWEEN TO_DATE('&1', 'DD.MM.YYYY')
                                     AND TO_DATE('&2', 'DD.MM.YYYY') + 86399/86400
           AND OSSRC = '&3'
         group by PERIOD_START_TIME
       )
select /*html*/ to_char(RFC.FECHA,'dd.mm.yyyy') FECHA,to_char(RFC.FECHA,'HH24') HORA,
       '&3' OSSRC,
       case  
            when SRL.CANTIDAD is null then SRL.CANTIDAD 
            when SRL.CANTIDAD = 0 then SRL.CANTIDAD
            when SRL.CANTIDAD not between &&4 
                  and &&5 then SRL.CANTIDAD -- fuera del %5 de tolerancia ej.
            else -1 --valor de retorno si todo anda ok
       end SRL_CNT,
       case
          when TRF.CANTIDAD is null then TRF.CANTIDAD
          when TRF.CANTIDAD = 0 then TRF.CANTIDAD
          when TRF.CANTIDAD not between &4  and &5 then TRF.CANTIDAD
          else -1
      end TRF_CNT,
      case
          when CRS.CANTIDAD is null then CRS.CANTIDAD
          when CRS.CANTIDAD = 0 then CRS.CANTIDAD
          when CRS.CANTIDAD not between &4 and &5 then CRS.CANTIDAD
          else -1
      end CRS_CNT,
      case
          when HSW.CANTIDAD is null then HSW.CANTIDAD
          when HSW.CANTIDAD = 0 then HSW.CANTIDAD
          when HSW.CANTIDAD not between &4 and &5 then HSW.CANTIDAD
          else -1
      end HSW_CNT,
      case
          when CTP.CANTIDAD is null then CTP.CANTIDAD
          when CTP.CANTIDAD = 0 then CTP.CANTIDAD
          when CTP.CANTIDAD not between &4 and &5 then CTP.CANTIDAD
          else -1
      end CTP_CNT,
      case
          when RRC.CANTIDAD is null then RRC.CANTIDAD
          when RRC.CANTIDAD = 0 then RRC.CANTIDAD
          when RRC.CANTIDAD not between &4 and &5 then RRC.CANTIDAD
          else -1
      end RRC_CNT,
      case
          when YHO.CANTIDAD is null then YHO.CANTIDAD
          when YHO.CANTIDAD = 0 then YHO.CANTIDAD
          when YHO.CANTIDAD not between &4 and &5 then YHO.CANTIDAD
          else -1
      end YHO_CNT,
      case
          when SHO.CANTIDAD is null then SHO.CANTIDAD
          when SHO.CANTIDAD = 0 then SHO.CANTIDAD
          when SHO.CANTIDAD not between &4 and &5 then SHO.CANTIDAD
          else -1
      end SHO_CNT,
      case
          when IHO.CANTIDAD is null then IHO.CANTIDAD
          when IHO.CANTIDAD = 0 then IHO.CANTIDAD
          when IHO.CANTIDAD not between &4 and &5 then IHO.CANTIDAD
          else -1
      end IHO_CNT,
      case
          when CTW.CANTIDAD is null then CTW.CANTIDAD
          when CTW.CANTIDAD = 0 then CTW.CANTIDAD
          when CTW.CANTIDAD not between &4 and &5 then CTW.CANTIDAD
          else -1
      end CTW_CNT,
      case
          when CPI.CANTIDAD is null then CPI.CANTIDAD
          when CPI.CANTIDAD = 0 then CPI.CANTIDAD
          when CPI.CANTIDAD not between &4 and &5 then CPI.CANTIDAD
          else -1
      end CPI_CNT,
      case
          when L3I.CANTIDAD is not null then L3I.CANTIDAD
          when L3I.CANTIDAD = 0 then L3I.CANTIDAD
          when L3I.CANTIDAD not between &4 and &5 then L3I.CANTIDAD
          else -1
      end L3I_CNT,
      case
          when PKT.CANTIDAD is not null then PKT.CANTIDAD
          when PKT.CANTIDAD = 0 then PKT.CANTIDAD
          when PKT.CANTIDAD not between &4 and &5 then PKT.CANTIDAD
          else -1
      end PKT_CNT
from    RFC,
        SRL,
        TRF,
        CRS,
        HSW,
        CTP,
        RRC,
        YHO,
        SHO,
        IHO,
        CTW,
        CPI,
        L3I,
        PKT
where RFC.FECHA = SRL.FECHA (+)
and   RFC.FECHA = TRF.FECHA (+)
and   RFC.FECHA = CRS.FECHA (+)
AND   RFC.FECHA = HSW.FECHA (+)
AND RFC.FECHA = CTP.FECHA (+)
AND RFC.FECHA = RRC.FECHA (+)
AND RFC.FECHA = YHO.FECHA (+)
AND RFC.FECHA = SHO.FECHA (+)
AND RFC.FECHA = IHO.FECHA (+)
AND RFC.FECHA = CTW.FECHA (+)
AND RFC.FECHA = CPI.FECHA (+)
AND RFC.FECHA = L3I.FECHA (+)
and RFC.FECHA = PKT.FECHA (+)
ORDER BY RFC.FECHA;
