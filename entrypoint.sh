#!/bin/sh

HOME=$SELENIUM_HOME vncserver $DISPLAY -SecurityTypes None -Log *:stderr:100 >> $SELENIUM_HOME/allout.txt
