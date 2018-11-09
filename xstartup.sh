#!/bin/sh

export DISPLAY=:99
export PATH="/usr/bin:/root/firefox:/root/chrome-driver:$PATH"

vncserver ${DISPLAY} -Log *:stderr:100 >> /allout.txt

# Start the selenium server
java -jar /root/selenium-server/selenium-server-standalone.jar 2>&1 | tee -a /allout.txt