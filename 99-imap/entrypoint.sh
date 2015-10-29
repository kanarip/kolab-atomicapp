#!/bin/bash

if [ ! -f "/etc/imapd.conf" ]; then
    setup-kolab --default imap
fi

systemctl start kolab-saslauthd

# Apply some configuration
exec "$@"
