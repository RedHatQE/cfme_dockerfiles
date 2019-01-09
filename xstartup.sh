#!/bin/sh

export DISPLAY=:99
export PATH="/usr/bin:/root/firefox:/root/chrome-driver:/opt/google/chrome:$PATH"

vncserver ${DISPLAY} -Log *:stderr:100 >> /allout.txt

# start nginx which will proxy requests to selenium server
nginx

# start the selenium server
java -jar /root/selenium-server/selenium-server-standalone.jar -port 4445 2>&1 | tee -a /allout.txt
