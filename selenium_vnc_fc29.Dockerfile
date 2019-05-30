FROM cfmeqe/sel_base_fc29

ENV SELENIUM_VERSION=3.141.59 \
    SELENIUM_HOME=/home/selenium \
    SELENIUM_PORT=4445 \
    FIREFOX_VERSION=60.4.0esr \
    GECKODRIVER_VERSION=v0.20.1 \
    DEFAULT_PROFILE_NAME=mylovelyprofile \
    DISPLAY=:99

ENV SELENIUM_PATH=$SELENIUM_HOME/selenium-server/selenium-server-standalone.jar \
    PATH=$SELENIUM_HOME/firefox:/opt/google/chrome:$PATH

WORKDIR $SELENIUM_HOME

# selenium server port
EXPOSE $SELENIUM_PORT

# vnc port
EXPOSE 5999

# chrome
RUN curl -LO https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm && \
    dnf install -y google-chrome-stable_current_x86_64.rpm && \
    rm -f google-chrome-stable_current_x86_64.rpm

# chrome and chrome driver versions should match in order to avoid incompatibility
RUN CHROME_VERSION=$(rpm -q --qf "%{VERSION}\n" google-chrome-stable | sed -Ee 's/^(.*)\..*/\1/') && \
    CHROME_DRIVER_VERSION=$(curl -s https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION) && \
    curl -O https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip && \
    unzip -d /usr/bin/ chromedriver_linux64.zip && \
    chmod a+x /usr/bin/chromedriver && \
    rm -f chromedriver_linux64.zip

# firefox
RUN curl -LO https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-$FIREFOX_VERSION.tar.bz2 && \
    tar -C . -xjvf firefox-$FIREFOX_VERSION.tar.bz2 && \
    rm -f firefox-$FIREFOX_VERSION.tar.bz2 && \
    firefox -headless -CreateProfile $DEFAULT_PROFILE_NAME && \
    echo 'user_pref("app.update.enabled", false);' > $(find ~/.mozilla/firefox -name "*.$DEFAULT_PROFILE_NAME" -type d)/user.js

# gecko for FF
RUN curl -LO https://github.com/mozilla/geckodriver/releases/download/$GECKODRIVER_VERSION/geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz && \
    tar -C /usr/bin/ -xvf geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz && \
    rm -f geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz

# selenium server
ADD http://selenium-release.storage.googleapis.com/3.141/selenium-server-standalone-$SELENIUM_VERSION.jar $SELENIUM_PATH

# Add the xstartup file into the image and add config.
COPY ./xstartup ./vncconfig .vnc/

# Create required dirs and files, change permissions in order to work in openshift
RUN touch $SELENIUM_HOME/.Xauthority && \
    mkdir -p $SELENIUM_HOME/.cache/dconf && \
    chgrp -R 0 $SELENIUM_HOME && \
    chmod -R g=u $SELENIUM_HOME && \
    chmod a+x $SELENIUM_HOME/.vnc/xstartup

USER 1001

ENTRYPOINT HOME=$SELENIUM_HOME vncserver $DISPLAY -fg -SecurityTypes None -Log *:stderr:100
