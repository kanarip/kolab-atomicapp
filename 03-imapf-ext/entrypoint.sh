#!/bin/bash

. /functions.sh

check_vars \
    DOMAIN \
    KOLAB_IMAP_MUPDATE_SERVICE_HOST \
    KOLAB_IMAP_MUPDATE_SERVICE_PORT \
    KOLAB_LDAP_MASTER_SERVICE_HOST \
    KOLAB_SERVICE_PASSWORD \
    CYRUS_ADMIN_PASSWORD \
    || exit 1

sed -i -r \
    -e "s/^primary_domain = .*$/primary_domain = ${DOMAIN}/g" \
    -e "s|^ldap_uri = .*$|ldap_uri = ldap://${KOLAB_LDAP_MASTER_SERVICE_HOST}:${KOLAB_LDAP_MASTER_SERVICE_PORT}|g" \
    -e "s/^base_dn = .*$/base_dn = $(domain_to_root_dn ${DOMAIN})/g" \
    -e "s/^domain_base_dn = .*$/domain_base_dn = ou=Domains,$(domain_to_root_dn ${DOMAIN})/g" \
    -e "s/^bind_dn = .*$/bind_dn = uid=kolab-service,ou=Special Users,$(domain_to_root_dn ${DOMAIN})/g" \
    -e "s/^bind_pw = .*$/bind_pw = ${KOLAB_SERVICE_PASSWORD}/g" \
    -e "s/^admin_password = .*$/admin_password = ${CYRUS_ADMIN_PASSWORD}/g" \
    -e "s/^service_bind_dn = .*$/service_bind_dn = uid=kolab-service,ou=Special Users,$(domain_to_root_dn ${DOMAIN})/g" \
    -e "s/^service_bind_pw = .*$/service_bind_pw = ${KOLAB_SERVICE_PASSWORD}/g" \
    /etc/kolab/kolab.conf

sed -i -r \
    -e "s/%CYRUS_ADMIN_PASSWORD%/${CYRUS_ADMIN_PASSWORD}/g" \
    -e "s/%KOLAB_IMAP_MUPDATE_SERVICE_HOST%/${KOLAB_IMAP_MUPDATE_SERVICE_HOST}/g" \
    -e "s/%KOLAB_IMAP_MUPDATE_SERVICE_PORT%/${KOLAB_IMAP_MUPDATE_SERVICE_PORT}/g" \
    -e "s/%KOLAB_SERVICE_PASSWORD%/${KOLAB_SERVICE_PASSWORD}/g" \
    /etc/kolab/templates/imapd.conf.tpl

cp /etc/kolab/kolab.conf /root/kolab.conf

setup-kolab --config /root/kolab.conf imap

persist \
    /etc/cyrus.conf \
    /etc/imapd.conf \
    /etc/imapd.annotations.conf \
    /var/lib/imap/ \
    /var/spool/imap/

exec "$@"
