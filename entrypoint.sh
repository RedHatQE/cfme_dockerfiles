#!/bin/sh

vncserver $DISPLAY -Log *:stderr:100 >> $HOME/allout.txt

# start the selenium server
java -jar $SELENIUM_PATH -port 4445 2>&1 | tee -a $HOME/allout.txt
