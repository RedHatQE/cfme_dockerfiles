FROM cfmeqe/sel_base_fc29

ENV SELENIUM_VERSION=3.14.0 \
    SELENIUM_HOME=/home/selenium \
    FIREFOX_VERSION=60.4.0esr \
    GECKODRIVER_VERSION=v0.20.1 \
    DEFAULT_PROFILE_NAME=mylovelyprofile \
    DISPLAY=:99

ENV SELENIUM_PATH=$SELENIUM_HOME/selenium-server/selenium-server-standalone.jar \
    PATH=$SELENIUM_HOME/firefox:/opt/google/chrome:$PATH

WORKDIR $SELENIUM_HOME

# selenium server port
EXPOSE 4445

# vnc port
EXPOSE 5999

# chrome
ADD https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm .
RUN dnf install -y google-chrome-stable_current_x86_64.rpm && \
    rm -f google-chrome-stable_current_x86_64.rpm

# chrome and chrome driver versions should match in order to avoid incompatibility

# chromedriver
RUN CHROME_VERSION=$(rpm -q --qf "%{VERSION}\n" google-chrome-stable|sed -Ee 's/^(.*)\..*/\1/') && \
    CHROME_DRIVER_VERSION=$(curl -s https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION) && \
    curl -O https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip && \
    unzip -d /usr/bin/ chromedriver_linux64.zip && \
    chmod a+x /usr/bin/chromedriver && \
    rm -f chromedriver_linux64.zip

# selenium server
ADD http://selenium-release.storage.googleapis.com/3.14/selenium-server-standalone-$SELENIUM_VERSION.jar \
    $SELENIUM_PATH

# firefox
ADD https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-$FIREFOX_VERSION.tar.bz2 .

# gecko for FF
ADD https://github.com/mozilla/geckodriver/releases/download/$GECKODRIVER_VERSION/geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz .

RUN tar -C . -xjvf firefox-$FIREFOX_VERSION.tar.bz2 && \
    rm -f firefox-$FIREFOX_VERSION.tar.bz2 && \
    tar -C /usr/bin/ -xvf geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz && \
    rm -f geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz && \
    firefox -headless -CreateProfile $DEFAULT_PROFILE_NAME && \
    echo 'user_pref("app.update.enabled", false);' > $(find ~/.mozilla/firefox -name "*.$DEFAULT_PROFILE_NAME" -type d)/user.js

# Add the xstartup file into the image and add config.
COPY ./xstartup ./vncconfig .vnc/
COPY ./entrypoint.sh .
RUN touch $SELENIUM_HOME/.Xauthority && \
    mkdir -p $SELENIUM_HOME/.cache/dconf && \
    chgrp -R 0 $SELENIUM_HOME && \
    chmod -R g=u $SELENIUM_HOME && \
    chmod a+x $SELENIUM_HOME/.vnc/xstartup && \
    chmod a+x $SELENIUM_HOME/entrypoint.sh

USER 1001

ENTRYPOINT ["./entrypoint.sh"]
