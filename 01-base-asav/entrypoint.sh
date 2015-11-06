#!/bin/bash

su -s /bin/bash - amavis -c 'nohup /usr/sbin/clamd -c /etc/clamd.d/amavisd.conf --pid /var/run/amavisd/clamd.pid &'

if [ -z "${DOMAIN}" -o "${DOMAIN}" == "" ]; then
    DOMAIN="docker.container"
fi

if [ -z "$(hostname | awk -F'.' '{print $3}')" -a ! -z "${DOMAIN}" ]; then
    sed -r -i \
        -e "s/^\\\$mydomain = .*$/\$mydomain = '${DOMAIN}';/g" \
        -e "s/^# \\\$myhostname.*$/\$myhostname = '$(hostname).${DOMAIN}';/g" \
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
