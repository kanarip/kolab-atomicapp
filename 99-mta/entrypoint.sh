#!/bin/bash

if [ ! -d "/etc/postfix/ldap/" ]; then
    setup-kolab --default mta
fi

systemctl start kolab-saslauthd

# Apply some configuration
exec "$@"
