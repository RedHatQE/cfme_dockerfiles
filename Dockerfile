# selenium base image, autobuilt by docker hub so we can be a little lazy
# when we build sel_ff_chrome
FROM fedora:23
MAINTAINER "CFME QE <cloudforms-qe@redhat.com>"
# Bring in all the dependencies; we could probably do this with deplist and bash
# shenanigans, but the manual method does the job well enough
RUN dnf -y update && \
    dnf -y install http://linuxdownload.adobe.com/linux/x86_64/adobe-release-x86_64-1.0-1.noarch.rpm && \
    rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux && \
    dnf -y install x11vnc wget fluxbox bzip2 xterm nano xorg-x11-server-Xvfb \
    net-tools dbus-glib dbus-x11 gtk2 java-1.8.0-openjdk-headless flash-plugin nspluginwrapper \
    alsa-plugins-pulseaudio libcurl unzip xdg-utils redhat-lsb GConf2 \
    libXScrnSaver xorg-x11-fonts-ISO8859-1-75dpi xorg-x11-fonts-ISO8859-1-100dpi \
    dejavu* openssh-server nginx supervisor python-gunicorn python-flask libexif && \
    dnf clean all
RUN mkdir -p /.mozilla/plugins && \
    ln -s /usr/lib64/flash-plugin/libflashplayer.so /.mozilla/plugins/libflashplayer.so && \
    sed -i 's#/dev/random#/dev/urandom#' /etc/alternatives/jre/lib/security/java.security

CMD ["/usr/bin/supervisord"]
