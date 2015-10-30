#!/bin/bash

# Do something actual here.
if [ ! -f "/etc/imapd.conf" ]; then
    setup-kolab --default imap
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
        mv ${p} /data$(dirname ${p})
        ln -s /data${p} ${p}
    fi
done

systemctl start kolab-saslauthd

# Apply some configuration
exec "$@"
