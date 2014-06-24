FROM cfmeqe/sel_base:latest
ADD http://selenium-release.storage.googleapis.com/2.42/selenium-server-standalone-2.42.2.jar /root/selenium-server/selenium-server-standalone.jar
ADD https://download-installer.cdn.mozilla.net/pub/firefox/releases/29.0.1/linux-x86_64/en-US/firefox-29.0.1.tar.bz2 /root/firefox.tar.bz2
ADD https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm /root/google-chrome-stable_current_x86_64.rpm
ADD http://chromedriver.storage.googleapis.com/2.10/chromedriver_linux64.zip /root/chrome-driver/chromedriver_linux64.zip
ADD ./xstartup.sh /xstartup.sh
RUN chmod 775 /xstartup.sh
RUN mkdir -p /root/chrome-driver
RUN tar -C /root/ -xjvf /root/firefox.tar.bz2
RUN unzip -d /root/chrome-driver/ /root/chrome-driver/chromedriver_linux64.zip
RUN yum install -y /root/google-chrome-stable_current_x86_64.rpm
EXPOSE 22
EXPOSE 4444
EXPOSE 5999
CMD ["/bin/bash", "/xstartup.sh"]
