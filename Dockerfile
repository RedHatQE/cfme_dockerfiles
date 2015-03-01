# sections ordered from least likely to change to most
FROM cfmeqe/sel_base:latest
# chrome
ADD https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm /root/google-chrome-stable_current_x86_64.rpm
RUN yum install -y /root/google-chrome-stable_current_x86_64.rpm; rm -f /root/google-chrome-stable_current_x86_64.rpm
# chromedriver
ADD http://chromedriver.storage.googleapis.com/2.14/chromedriver_linux64.zip /root/chrome-driver/chromedriver_linux64.zip
RUN mkdir -p /root/chrome-driver; unzip -d /root/chrome-driver/ /root/chrome-driver/chromedriver_linux64.zip; rm -f /root/chrome-driver/chromedriver_linux64.zip
# xstartup
ADD ./xstartup.sh /xstartup.sh
RUN chmod 775 /xstartup.sh
# selenium
ADD http://selenium-release.storage.googleapis.com/2.45/selenium-server-standalone-2.45.0.jar /root/selenium-server/selenium-server-standalone.jar
# firefox
ADD https://download-installer.cdn.mozilla.net/pub/firefox/releases/latest-esr/linux-x86_64/en-US/firefox-31.5.0esr.tar.bz2 /root/firefox.tar.bz2
RUN tar -C /root/ -xjvf /root/firefox.tar.bz2; rm -f /root/firefox.tar.bz2
# runtime
EXPOSE 22
EXPOSE 4444
EXPOSE 5999
CMD ["/bin/bash", "/xstartup.sh"]
