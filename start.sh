#! /bin/sh
# set defaults
export ENV_SPOTIFY_NAME="${ENV_SPOTIFY_NAME:=Snapcast}"
export ENV_SPOTIFY_BITRATE="${ENV_SPOTIFY_BITRATE:=160}"

# setup dbus
rm -rf /var/run/dbus
mkdir -p /var/run/dbus
chown -R messagebus:messagebus /var/run/dbus
dbus-uuidgen --ensure
dbus-daemon --system --fork
sleep 5

supervisord -c /etc/supervisord.conf

exec "$@"
