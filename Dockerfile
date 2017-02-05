# Dockerfile for a Multi-Room-Audio-Streaming-Server

FROM blitznote/debootstrap-amd64:16.04

MAINTAINER s1lvester <s1lvester@bockhacker.me>

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

ARG SNAPCASTVERSION="0.10.0"
ARG LIBRESPOTVERSION="0.0.20161102"

# get the stuffs
RUN apt-get -qq update &&\
    apt-get -qq install git avahi-daemon avahi-utils dbus shairport-sync supervisor \
        build-essential bzip2 portaudio19-dev libprotoc-dev libvorbisfile3 &&\

# Snapcast, Shairport-sync,avahi and dbus
    curl -L -o /root/out.deb 'https://github.com/badaix/snapcast/releases/download/v'$SNAPCASTVERSION'/snapserver_'$SNAPCASTVERSION'_amd64.deb' &&\
    dpkg -i --force-all /root/out.deb &&\
    apt-get -y -f install &&\
    mkdir -p /root/.config/snapcast/ &&\
    rm -rf /var/run/* &&\
    mkdir -p /var/run/dbus &&\
    chown messagebus:messagebus /var/run/dbus &&\
    dbus-uuidgen --ensure &&\

# Librespot from badaix
    curl -L -o librespot.x64.bz2 'https://github.com/badaix/librespot/releases/download/v'$LIBRESPOTVERSION'/librespot.x64.bz2' &&\
    bzip2 -d librespot.x64.bz2 &&\
    mv librespot.x64 /usr/local/bin/librespot &&\
    chmod a+x /usr/local/bin/librespot &&\

# cleanup
    apt-get -qq autoremove &&\
    apt-get -qq clean &&\
    rm /root/out.deb &&\
    rm -rf /var/lib/apt/lists/*

# mounting dbus on host so avahi can work.
VOLUME /var/run/dbus

# config-files
ADD ./supervisord.conf /etc/supervisord.conf
ADD ./shairport.cfg /etc/shairport.cfg
ADD ./asound.conf /etc/asound.conf
ADD ./start.sh /start.sh
RUN chmod a+x /start.sh

# Snapcast Ports
EXPOSE 1704-1704

# AirPlay ports.
EXPOSE 3689/tcp
EXPOSE 5000-5005/tcp
EXPOSE 5535
EXPOSE 6000-6005/udp

ENTRYPOINT ["/start.sh"]
