#!/bin/sh

# Change rootpw
echo $PASS | passwd --stdin root

# Set up the environment so selenium can find everything it might want (namely chrome and chromedriver)
/usr/sbin/sshd-keygen -A
/usr/sbin/sshd

export DISPLAY=:99
Xvfb :99 -shmem -screen 0 1280x1024x16 &
x11vnc -display :99 -N -forever &
export PATH="/usr/bin:/root/firefox:/root/chrome-driver:$PATH"

# Start the window manager
fluxbox &

# Start the selenium server
xterm -maximized -e java -jar /root/selenium-server/selenium-server-standalone.jar -ensureCleanSession -trustAllSSLCertificates
