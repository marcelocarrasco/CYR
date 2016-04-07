#!/bin/bash
cd /home/oracle/CYR/Datos/
FILE='finalReport.html'
#touch $FILE
> $FILE
cat header.html > $FILE

#sed -n '/<table>/,/table>/p' status_gsm_gral_OSSRC1.html >> $FILE

#Insert GSM data
echo '<h2 style="color:#DBA901">GSM/GPRS</h2>' >> $FILE
find . -type f -name 'status_gsm_gral*.html' -exec sed -n '/<table>/,/table>/p' {} \; >> $FILE
echo '<br>' >> $FILE

#Insert UMTS data
echo '<h2 style="color:#DBA901">UMTS</h2>' >> $FILE
find . -type f -name 'status_umts_gral*.html' -exec sed -n '/<table>/,/table>/p' {} \; >> $FILE
echo '<br>' >> $FILE

#Insert LTE data
echo '<h2 style="color:#DBA901">LTE</h2>' >> $FILE
find . -type f -name 'status_lte_gral*.html' -exec sed -n '/<table>/,/table>/p' {} \; >> $FILE
echo '<br>' >> $FILE

#Remove unnecesary comments
sed -i 's/<!-- SQL:*//' $FILE
