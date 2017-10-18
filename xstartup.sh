#!/bin/sh

# Change rootpw
echo $PASS | passwd --stdin root

# Set up the environment so selenium can find everything it might want (namely chrome and chromedriver)
/usr/sbin/sshd-keygen -A
/usr/sbin/sshd

# Workaround for https://bugzilla.redhat.com/show_bug.cgi?id=1286787
if [ ! -f /etc/machine-id ]; then
  echo "7f496b3288e64931bd91bf723697e19c" > /etc/machine-id
fi

# Start Xvfb and x11vnc
export DISPLAY=:99
export PATH="/usr/bin:/root/firefox:/root/chrome-driver:$PATH"
export SSLKEYLOGFILE="/root/sslkeyfile.log"

Xvfb $DISPLAY -shmem -screen 0 '1280x1024x16' &
sleep 5

fluxbox &
x11vnc -display $DISPLAY -N -shared -forever &

# Start the selenium server
java -jar /root/selenium-server/selenium-server-standalone.jar -ensureCleanSession -trustAllSSLCertificates
