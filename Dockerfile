# sections ordered from least likely to change to most
#FROM cfmeqe/sel_base:latest
#FROM sel_base
FROM psav/sel_base

ENV CHROME_DRIVER_VERSION 2.35
ENV SELENIUM_VERSION 3.9.1
ENV FIREFOX_VERSION 58.0.2

USER 0

# chrome
ADD https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm \
    /root/google-chrome-stable_current_x86_64.rpm
RUN dnf install -y /root/google-chrome-stable_current_x86_64.rpm && \
    rm -f /root/google-chrome-stable_current_x86_64.rpm
# chromedriver
ADD http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip \
    /root/chrome-driver/chromedriver_linux64.zip
RUN mkdir -p /root/chrome-driver &&\
    unzip -d /root/chrome-driver/ /root/chrome-driver/chromedriver_linux64.zip &&\
    rm -f /root/chrome-driver/chromedriver_linux64.zip
# xstartup
ADD ./xstartup.sh /xstartup.sh
RUN chmod 775 /xstartup.sh
# selenium
ADD http://selenium-release.storage.googleapis.com/3.9/selenium-server-standalone-$SELENIUM_VERSION.jar \
    /root/selenium-server/selenium-server-standalone.jar
# firefox
ADD https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-$FIREFOX_VERSION.tar.bz2 \
    /root/firefox.tar.bz2
ADD https://github.com/mozilla/geckodriver/releases/download/v0.19.1/geckodriver-v0.19.1-linux64.tar.gz \
    /root/gecko.tar.gz

RUN tar -C /root/ -xjvf /root/firefox.tar.bz2 && rm -f /root/firefox.tar.bz2
RUN tar -C /root/firefox/ -xvf /root/gecko.tar.gz && rm -f /root/gecko.tar.gz

# runtime
EXPOSE 22
EXPOSE 4444
EXPOSE 5999

CMD ["/bin/bash", "/xstartup.sh"]
