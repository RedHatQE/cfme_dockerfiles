# sections ordered from least likely to change to most
#FROM cfmeqe/sel_base:latest
FROM sel_base
#FROM psav/sel_base

ENV CHROME_DRIVER_VERSION 2.35
ENV SELENIUM_VERSION 3.9.1
ENV FIREFOX_VERSION 45.9.0esr
ENV GECKO_DRIVER_VERSION 0.21.0

USER 0

# chrome
ADD ./google-chrome-stable_current_x86_64.rpm \
    /root/google-chrome-stable_current_x86_64.rpm
RUN dnf install -y /root/google-chrome-stable_current_x86_64.rpm && \
    rm -f /root/google-chrome-stable_current_x86_64.rpm
# chromedriver
ADD ./chromedriver_linux64.zip \
    /root/chrome-driver/chromedriver_linux64.zip
RUN mkdir -p /root/chrome-driver &&\
    unzip -d /root/chrome-driver/ /root/chrome-driver/chromedriver_linux64.zip &&\
    rm -f /root/chrome-driver/chromedriver_linux64.zip
# xstartup
ADD ./xstartup.sh /xstartup.sh
RUN chmod 775 /xstartup.sh
# selenium
ADD ./selenium-server-standalone-$SELENIUM_VERSION.jar \
    /root/selenium-server/selenium-server-standalone.jar
# firefox
COPY ./firefox-$FIREFOX_VERSION.tar.bz2 \
    /root/firefox.tar.bz2
COPY ./geckodriver-v$GECKO_DRIVER_VERSION-linux64.tar.gz \
    /root/gecko.tar.gz

RUN tar -C /root/ -xjvf /root/firefox.tar.bz2 && rm -f /root/firefox.tar.bz2
RUN tar -C /root/firefox/ -xvf /root/gecko.tar.gz && rm -f /root/gecko.tar.gz

# runtime
EXPOSE 22
EXPOSE 4444
EXPOSE 5999

CMD ["/bin/bash", "/xstartup.sh"]
