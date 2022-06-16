#!/bin/bash
tempc=$(vcgencmd measure_temp | egrep -o '[0-9]*\.[0-9]*')

tempmsg="Temperature $tempc Degree Celcius" 

echo "The temperature is $tempc degree celcius."

#curl "https://api.telegram.org/botXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/sendMessage?chat_id=517557723&text=$tempmsg"

#sleep 1


dwn=$(grep -w 'Download:' speedtest.txt)
upl=$(grep -w 'Upload:' speedtest.txt)

speeddata="$dwn $upl"

echo "The internet speed is as below $speeddata"

#sleep 10


FINALMSG="$tempmsg  $speeddata"

curl "https://api.telegram.org/botXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/sendMessage?chat_id=517557723&text=$FINALMSG"

sleep 10

curl -s "https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py" | python - > speedtest.txt
