#! /bin/sh
# set defaults
export SPOTIFY_NAME="${SPOTIFY_NAME:=Snapcast}"
export SPOTIFY_BITRATE="${SPOTIFY_BITRATE:=160}"

# setup dbus
rm -rf /var/run/dbus || mkdir -p /var/run/dbus
chown -R messagebus:messagebus /var/run/dbus
dbus-uuidgen --ensure
dbus-daemon --system --fork
sleep 5

supervisord -c /etc/supervisord.conf

exec "$@"
