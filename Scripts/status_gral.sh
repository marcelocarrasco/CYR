#!/bin/bash
RETVAL=`sqlplus -s harriague/HARRIAGUE@PERDIDO <<EOF
SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF LINES 160
SELECT '/home/oracle/sqlcl/bin/sql -s harriague/HARRIAGUE@PERDIDO @/home/oracle/CYR/Scripts/status_umts_gral.sql '
  ||TO_CHAR(sysdate-1,'dd.mm.yyyy')
  ||' '
  ||TO_CHAR(sysdate-1,'dd.mm.yyyy')
  ||' '
  || ossrc
  ||' '
  ||ROUND(cantidad-(cantidad*0.05))
  ||' '
  ||ROUND(cantidad+(cantidad*0.05))
  ||' '
  ||'/home/oracle/CYR/Datos/status_umts_gral_'||ossrc||'.html'
FROM
  (SELECT ELEMENT_CLASS,
    OSSRC,
    COUNT(DISTINCT element_name) AS CANTIDAD
  FROM MULTIVENDOR_OBJECT2
  WHERE ELEMENT_CLASS  IN ('WCELL')
  AND VALID_FINISH_DATE > SYSDATE
  GROUP BY ossrc,
    ELEMENT_CLASS
  );
EXIT;
EOF`

IFS=';' read -ra NAMES <<< "$RETVAL"

if [ -z "$RETVAL" ]; then
  echo "No rows returned from database"
  exit 0
else
  for i in "${NAMES[@]}"; do
    echo $i
  done
fi
# /home/oracle/sqlcl/bin/sql -s harriague/HARRIAGUE@PERDIDO @/home/oracle/CYR/Scripts/status_gral.sql 25.02.2016 25.02.2016 OSSRC3 22388 23018
