#!/bin/bash
cd /home/oracle/CYR/Datos/
FILE='finalReport.html'
#touch $FILE
> $FILE
cat header.html > $FILE

#sed -n '/<table>/,/table>/p' status_gsm_gral_OSSRC1.html >> $FILE

#Insert GSM data
echo '<h2 style="color:#DBA901">GSM/GPRS</h2>' >> $FILE
find . -type f -name "status_gsm_gral*.html" | sort -u | while read htmlFile
do
   sed -n '/<table>/,/table>/p' $htmlFile >> $FILE
done
echo '<br>' >> $FILE

#Insert UMTS data
echo '<h2 style="color:#DBA901">UMTS</h2>' >> $FILE
find . -type f -name "status_umts_gral*.html" | sort -u | while read htmlFile
do
   sed -n '/<table>/,/table>/p' $htmlFile >> $FILE
done
echo '<br>' >> $FILE

#Insert LTE data
echo '<h2 style="color:#DBA901">LTE</h2>' >> $FILE
find . -type f -name "status_lte_gral*.html" | sort -u | while read htmlFile
do
   sed -n '/<table>/,/table>/p' $htmlFile >> $FILE
done
echo '<br>' >> $FILE

#Remove unnecesary comments
sed -i 's/<!-- SQL:*//' $FILE

#Close html tags
echo '</body></html>' >> $FILE
