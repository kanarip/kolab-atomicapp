#!/bin/bash

mkdir -p /run/lock

if [ -z "$(ls -d /etc/dirsrv/slapd-*/)" ]; then
    setup-kolab ldap || exit 1
    # Stop it again, we run this as CMD
    systemctl stop dirsrv@$(hostname -s)
fi

persist=(
    /etc/dirsrv/
    /var/lib/dirsrv/
    /var/log/dirsrv/
)

for p in ${persist[@]}; do
    if [ -d "${p}" ]; then
        mkdir -p /data$(dirname ${p})
        mv ${p} /data$(dirname ${p})
        ln -s /data${p} $(dirname ${p})
    fi
done

# Apply some configuration
exec "$@"
