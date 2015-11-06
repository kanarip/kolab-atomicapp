#!/bin/bash

su -s /bin/bash - amavis -c 'nohup /usr/sbin/clamd -c /etc/clamd.d/amavisd.conf --pid /var/run/amavisd/clamd.pid &'

if [ $# -lt 1 ]; then
    exec /usr/sbin/amavisd \
        -u amavis \
        -g amavis \
        -c /etc/amavisd/amavisd.conf \
        foreground
else
    exec "$@"
fi
