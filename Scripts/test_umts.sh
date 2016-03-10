#!/bin/bash
FILE='/home/oracle/CYR/Datos/status_umts_gral_OSSRC3.html'
/home/oracle/sqlcl/bin/sql -s harriague/HARRIAGUE@PERDIDO @/home/oracle/CYR/Scripts/status_umts_gral.sql 07.03.2016 07.03.2016 OSSRC3 22543 24915 $FILE
sed -i 's/&lt;/</g' $FILE
sed -i 's/&gt;/>/g' $FILE
