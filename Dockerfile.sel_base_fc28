FROM fedora:28
RUN rpm -ivh http://linuxdownload.adobe.com/adobe-release/adobe-release-x86_64-1.0-1.noarch.rpm
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux
RUN yum install -y x11vnc wget fluxbox bzip2 xterm nano xorg-x11-server-Xvfb net-tools dbus-glib gtk2 java-1.8.0-openjdk flash-plugin alsa-plugins-pulseaudio libcurl unzip xdg-utils redhat-lsb GConf2 libXScrnSaver xorg-x11-fonts-ISO8859-1-75dpi xorg-x11-fonts-ISO8859-1-100dpi dejavu* openssh-server gtk3
RUN mkdir -p /.mozilla/plugins
RUN ln -s /usr/lib64/flash-plugin/libflashplayer.so /.mozilla/plugins/libflashplayer.so
