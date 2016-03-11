#!bin/bash

sed -i 's/&lt;/</g' $1
sed -i 's/&gt;/>/g' $1

