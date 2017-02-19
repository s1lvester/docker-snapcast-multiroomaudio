# Dockerfile for a Multi-Room-Audio-Streaming-Server

FROM blitznote/debootstrap-amd64:16.04

MAINTAINER s1lvester <hello@s1lvester.de>

ARG SNAPCASTVERSION="c633110"
ARG LIBRESPOTVERSION="0.0.20161102"

# get the stuffs
RUN apt-get -qq update &&\
    apt-get -qq install git avahi-daemon avahi-utils dbus shairport-sync supervisor \
        build-essential bzip2 portaudio19-dev libprotoc-dev libvorbisfile3 \
        libasound2-dev libvorbisidec-dev libvorbis-dev libflac-dev alsa-utils \
        libavahi-client-dev python-pip &&\

# Snapcast, avahi and dbus
    git clone https://github.com/badaix/snapcast /root/snapcast &&\
    cd /root/snapcast &&\
    git checkout $SNAPCASTVERSION &&\
    git submodule update --init --recursive &&\
    cd server &&\
    make &&\
    make install &&\
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

# supervidord logging
    pip install supervisor-stdout &&\

# cleanup
    apt-get -qq autoremove &&\
    apt-get -qq clean &&\
    rm -rf /var/lib/apt/lists/* &&\
    rm -rf /root/snapcast

# mounting dbus on host so avahi can work.
VOLUME /var/run/dbus

# config-files
ADD ./supervisord.conf /etc/supervisord.conf
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
