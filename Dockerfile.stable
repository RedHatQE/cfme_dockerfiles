FROM cfmeqe/sel_base_fc29

#TODO: figure why user 0 was needed
USER 0

ENV SELENIUM_VERSION 3.14.0
ENV FIREFOX_VERSION 60.4.0esr
ENV GECKODRIVER_VERSION v0.20.1

# nginx port for selenium requests
EXPOSE 4444
# selenium server port
EXPOSE 4445

# vnc port
EXPOSE 5999

# chrome
ADD https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm \
    /root/google-chrome-stable_current_x86_64.rpm
RUN dnf install -y /root/google-chrome-stable_current_x86_64.rpm && \
    rm -f /root/google-chrome-stable_current_x86_64.rpm

# chrome and chrome driver versions should match in order to avoid incompatibility

# chromedriver
ENV DESTFILE /root/chrome-driver/chromedriver_linux64.zip
RUN CHROME_VERSION=$(rpm -q --qf "%{VERSION}\n" google-chrome-stable|sed -Ee 's/^(.*)\..*/\1/') && \
    CHROME_DRIVER_VERSION=$(curl -s https://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROME_VERSION}) && \
    mkdir -p /root/chrome-driver && \
    curl -o ${DESTFILE} https://chromedriver.storage.googleapis.com/${CHROME_DRIVER_VERSION}/chromedriver_linux64.zip && \
    unzip -d /root/chrome-driver/ ${DESTFILE} && \
    rm -f ${DESTFILE}

# selenium server
ADD http://selenium-release.storage.googleapis.com/3.14/selenium-server-standalone-$SELENIUM_VERSION.jar \
    /root/selenium-server/selenium-server-standalone.jar

# firefox
ADD https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-$FIREFOX_VERSION.tar.bz2 \
    /root/firefox.tar.bz2

# gecko for FF
ADD https://github.com/mozilla/geckodriver/releases/download/$GECKODRIVER_VERSION/geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz \
    /root/gecko.tar.gz

#copying nginx config for selenium proxy
ADD ./nginx-selenium.conf /etc/nginx/conf.d

# nginx starts 5 workers by default what's too much for one selenium server.
# So, let's decrease it to 1

# nginx shows a warning about not enough hash size by default. Below command multiplies default
# value to 2

RUN  sed -i -- 's/worker_processes.*;/worker_processes 1;/' /etc/nginx/nginx.conf && \
     sed -i -- 's/types_hash_max_size.*;/types_hash_max_size 4096;/' /etc/nginx/nginx.conf


RUN tar -C /root/ -xjvf /root/firefox.tar.bz2 && rm -f /root/firefox.tar.bz2
RUN tar -C /root/firefox/ -xvf /root/gecko.tar.gz && rm -f /root/gecko.tar.gz

# Add the xstartup file into the image and add config.
RUN mkdir /root/.vnc
ADD ./vncxstartup /root/.vnc/xstartup
ADD ./vncconfig /root/.vnc/config
RUN chmod 755 /root/.vnc/xstartup

# get rid of error in vncserver logs
RUN touch $HOME/.Xauthority && touch /allout.txt

ADD ./xstartup.sh /xstartup.sh
RUN chmod 755 /xstartup.sh

ENTRYPOINT ["/xstartup.sh"]
