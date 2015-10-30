#!/bin/bash

# Do something actual here.
if [ ! -f "/etc/imapd.conf" ]; then
    setup-kolab --default imap || exit 1
    # Shut it down again, because we run this as CMD, in the foreground.
    systemctl stop cyrus-imapd
    pkill -9 -u cyrus
    killall -9 cyrus-master
fi

persist=(
    /etc/pki/tls/certs/
    /etc/pki/tls/private/
    /var/lib/imap/
    /var/spool/imap/
)

for p in ${persist[@]}; do
    if [ -d "${p}" ]; then
        mkdir -p /data$(dirname ${p})
        mv -v ${p} /data$(dirname ${p})
        ln -s /data${p} $(dirname ${p})
    fi
done

systemctl start kolab-saslauthd

# Apply some configuration
exec "$@"

exec top
