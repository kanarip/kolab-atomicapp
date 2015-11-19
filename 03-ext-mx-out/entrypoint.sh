#!/bin/bash

. /functions.sh

check_vars \
    DOMAIN \
    KOLAB_ASAV_OUT_SERVICE_HOST \
    KOLAB_ASAV_OUT_SERVICE_PORT \
    KOLAB_LDAP_MASTER_SERVICE_HOST \
    KOLAB_SERVICE_PASSWORD \
    || exit 1

if [ ! -d "/etc/postfix/ldap/" ]; then
    cp /etc/kolab/kolab.conf /root/kolab.conf

    # Subst. some config settings here.

    setup-kolab --config /root/kolab.conf mta
    systemctl stop postfix

    sed -i -r \
        -e "s/^server_host = .*$/server_host = ${KOLAB_LDAP_MASTER_SERVICE_HOST}/g" \
        -e "s/^search_base = .*$/search_base = $(domain_to_root_dn ${DOMAIN})/g" \
        -e "s/^bind_dn = .*$/bind_dn = uid=kolab-service,ou=Special Users,$(domain_to_root_dn ${DOMAIN})/g" \
        -e "s/^bind_pw = .*$/bind_pw = ${KOLAB_SERVICE_PASSWORD}/g" \
        /etc/postfix/ldap/*.cf
fi

persist \
    /var/spool/postfix/

systemctl stop kolab-saslauthd

postconf -e "content_filter=smtp:[${KOLAB_ASAV_OUT_SERVICE_HOST}]:${KOLAB_ASAV_OUT_SERVICE_PORT}"

exec "$@"
