select  /*csv*/ element_class,
        ossrc,
        cantidad,
        round(cantidad-(cantidad*0.05)) OBJ_LOW,
        round(cantidad+(cantidad*0.05)) OBJ_HI
from (
      SELECT  ELEMENT_CLASS,
              ossrc,
              COUNT(distinct element_name) AS CANTIDAD
      FROM MULTIVENDOR_OBJECT2
      WHERE ELEMENT_CLASS IN ('BTS','WCELL','LNCEL')
      AND VALID_FINISH_DATE > SYSDATE
      GROUP BY ossrc,ELEMENT_CLASS);