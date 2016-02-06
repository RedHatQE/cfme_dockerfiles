#!/bin/sh

# Change rootpw
echo $PASS | passwd --stdin root

# Set up the environment so selenium can find everything it might want (namely chrome and chromedriver)
/usr/sbin/sshd-keygen -A
/usr/sbin/sshd

export DISPLAY=:99
export PATH="/usr/bin:/root/firefox:/root/chrome-driver:$PATH"

Xvfb $DISPLAY -shmem -screen 0 '1280x1024x16' &
sleep 5

fluxbox &
x11vnc -display $DISPLAY -N -shared -forever &

# Start the selenium server
xterm -maximized -e java -jar /root/selenium-server/selenium-server-standalone.jar -ensureCleanSession -trustAllSSLCertificates
