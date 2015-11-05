#!/bin/bash

exec su -s /bin/bash - amavis -c 'nohup /usr/sbin/clamd -c /etc/clamd.d/amavisd.conf --pid /var/run/amavisd/clamd.pid &'

if [ -z "$@" ]; then
    exec /usr/sbin/amavisd -u amavis -g amavis foreground
else
    exec "$@"
fi
