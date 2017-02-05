#! /bin/sh

# setup dbus
rm -rf /var/run/dbus
mkdir -p /var/run/dbus
chown -R messagebus:messagebus /var/run/dbus
dbus-uuidgen --ensure
dbus-daemon --system --fork
sleep 5

supervisord -c /etc/supervisord.conf

exec "$@"
