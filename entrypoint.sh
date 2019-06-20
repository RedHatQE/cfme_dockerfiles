#!/bin/sh

# start nginx which will proxy requests to selenium server. nginx listens to requests on 4444
# and forwards them to 4445
nginx

HOME=$SELENIUM_HOME vncserver $DISPLAY -fg -Log *:stderr:100
