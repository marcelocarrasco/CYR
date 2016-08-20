#!/bin/bash
#scp -r ../Datos/ calidad@perdido.claro.amx:/calidad/example/barby/
#echo 'ha finalizado la copia de archivos'
cd /home/oracle/CYR/Datos/
(echo "Content-type: text/html"; 
echo "Subject: Reporte"; 
echo '<h1 style="color:blue;font-style:italic;">Reporte del dia</h1>';
echo '<h2 style="color:#DBA901">GSM/GPRS</h2>';
cat status_gsm_gral*.html;
echo '<br>';
echo '<h2 style="color:#DBA901">UMTS</h2>';
cat status_umts_gral*.html; 
echo '<br>';
echo '<h2 style="color:#DBA901">LTE</h2>';
cat status_lte_gral*.html) > fileMail.html # |
#/usr/lib/sendmail bcordoba@harriague.com
