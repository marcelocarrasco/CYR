#!bin/bash

sed -i 's/&lt;/</g' $1
sed -i 's/&gt;/>/g' $1
sed -i 's/14px/10px/g' $1
sed -i 's/Georgia/Verdana/g' $1
sed -i '/<script type=/,/script>/d' $1
sed -i '/<div><input /d' $1
cat $1 | tr "\n" "|" | grep -o '<table>.*</table>' | sed 's/\(<table>\|<\/table>\)//g' | sed 's/|/\n/g' > $2 
