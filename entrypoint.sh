#!/bin/sh

HOME=$SELENIUM_HOME vncserver $DISPLAY -Log *:stderr:100 >> $SELENIUM_HOME/allout.txt

# start the selenium server
java -jar $SELENIUM_PATH -port 4445 2>&1 | tee -a $SELENIUM_HOME/allout.txt
