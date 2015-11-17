#!/bin/bash

su -s /bin/bash - amavis -c 'nohup /usr/sbin/clamd -c /etc/clamd.d/amavisd.conf --pid /var/run/amavisd/clamd.pid &'

env

if [ -z "${DOMAIN}" -o "${DOMAIN}" == "" ]; then
    DOMAIN="docker.container"
fi

if [ -z "$(hostname | awk -F'.' '{print $3}')" -a ! -z "${DOMAIN}" ]; then
    sed -r -i \
        -e "s/^\\\$mydomain = .*$/\$mydomain = '${DOMAIN}';/g" \
        -e "s/^# \\\$myhostname.*$/\$myhostname = '$(hostname).${DOMAIN}';/g" \
        /etc/amavisd/amavisd.conf
fi

if [ "${KOLAB_ROLE}" == "ASAV_IN" ]; then
    FORWARD_METHOD="smtp:[${KOLAB_EXT_MX_IN_SERVICE_HOST}]:10025"
elif [ "${KOLAB_ROLE}" == "ASAV_OUT" ]; then
    FORWARD_METHOD="smtp:[${KOLAB_EXT_MX_OUT_SERVICE_HOST}]:10025"
fi

if [ ! -z "${FORWARD_METHOD}" ]; then
    sed -r -i \
        -e "s/^# \\\$forward_method.*$/\$forward_method = '${FORWARD_METHOD}';/g" \
        /etc/amavisd/amavisd.conf
fi

if [ $# -lt 1 ]; then
    exec /usr/sbin/amavisd \
        -u amavis \
        -g amavis \
        -c /etc/amavisd/amavisd.conf \
        foreground
else
    exec "$@"
fi
