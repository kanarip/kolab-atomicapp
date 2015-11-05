#!/bin/bash

if [ ! -d "/etc/postfix/ldap/" ]; then
    setup-kolab --default mta
    systemctl stop postfix
fi

# Apply some configuration
exec "$@"
