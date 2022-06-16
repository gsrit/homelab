#!/bin/bash

speeddata=$(grep -w 'Download\|Upload:' speedtest.txt)
echo -e "The internet speed is as below \n $speeddata"

