#!/bin/sh

# Change rootpw
echo $PASS | passwd --stdin root

# Set up the environment so selenium can find everything it might want (namely chrome and chromedriver)
/usr/sbin/ssh-keygen -A
/usr/sbin/sshd

# Workaround for https://bugzilla.redhat.com/show_bug.cgi?id=1286787
if [ ! -f /etc/machine-id ]; then
  echo "7f496b3288e64931bd91bf723697e19c" > /etc/machine-id
fi

# Start Xvfb and x11vnc
export DISPLAY=:99
export PATH="/usr/bin:/root/firefox:/root/chrome-driver:$PATH"
export SSLKEYLOGFILE="/root/sslkeyfile.log"

Xvfb $DISPLAY -shmem -screen 0 '1280x1024x16' -ac +extension RANDR &
sleep 5

fluxbox &
x11vnc -display $DISPLAY -N -shared -forever &

touch allout.txt

xterm -maximized -e tail -f allout.txt &

# Start the selenium server
java -jar /root/selenium-server/selenium-server-standalone.jar 2>&1 | tee -a allout.txt
