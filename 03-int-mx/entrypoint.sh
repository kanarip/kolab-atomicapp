#!/bin/bash

env

if [ ! -d "/etc/postfix/ldap/" ]; then
    setup-kolab --default mta
    systemctl stop postfix
fi

systemctl start kolab-saslauthd

# Apply some configuration
exec "$@"
