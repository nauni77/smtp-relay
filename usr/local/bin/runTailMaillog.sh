#! /bin/sh
while [ ! -f /var/log/maillog ]; 
do 
    echo "waiting for file to appear : /var/log/maillog"
    sleep 1s;
done
echo "file exists : /var/log/maillog"
/usr/bin/tail -f /var/log/maillog