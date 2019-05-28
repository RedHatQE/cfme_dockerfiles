#!/bin/sh

HOME=$SELENIUM_HOME vncserver $DISPLAY -fg -SecurityTypes None -Log *:stderr:100
