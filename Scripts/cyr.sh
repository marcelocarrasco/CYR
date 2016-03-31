#!/bin/bash
ps cax | grep control_raw.sh > /dev/null
if [ $? -eq 0 ]; then
  echo "Process is running."
else
  sh /home/oracle/CYR/Scripts/control_raw.sh
fi
