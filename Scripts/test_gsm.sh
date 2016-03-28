#!/bin/bash
FILE='/home/oracle/CYR/Datos/status_gsm_gral_OSSRC3.html'
/home/oracle/sqlcl/bin/sql -s harriague/HARRIAGUE@PERDIDO @/home/oracle/CYR/Scripts/status_gsm_gral.sql 10.03.2016 10.03.2016 OSSRC3 6930 7660 $FILE
sed -i 's/&lt;/</g' $FILE
sed -i 's/&gt;/>/g' $FILE
sed -i 's/14px/10px/g' $FILE
sed -i 's/Georgia/Verdana/g' $FILE
sed -i '/<script type=/,/script>/d' $FILE
sed -i '/<div><input /d' $FILE
