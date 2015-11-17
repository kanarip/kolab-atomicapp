#!/bin/bash

env

if [ ! -d "/etc/postfix/ldap/" ]; then
    cp /etc/kolab/kolab.conf /root/kolab.conf

    # Subst. some config settings here.

    setup-kolab --config /root/kolab.conf mta
    systemctl stop postfix
fi

systemctl stop kolab-saslauthd

postconf -e "content_filter=smtp:[${KOLAB_ASAV_IN_SERVICE_HOST}]:${KOLAB_ASAV_IN_SERVICE_PORT}"

# Apply some configuration
exec "$@"

exec top
