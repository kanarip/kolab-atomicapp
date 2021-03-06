#!/bin/bash

. /functions.sh

check_var MARIADB_SERVICE_HOST || check_var ROUNDCUBEMAIL_DATABASE_SERVICE_HOST || exit 1

check_vars \
    DOMAIN \
    KOLAB_LDAP_MASTER_SERVICE_HOST \
    KOLAB_LDAP_MASTER_SERVICE_PORT \
    KOLAB_SERVICE_PASSWORD \
    KOLAB_ROUNDCUBEMAIL_DATABASE_USERNAME \
    KOLAB_ROUNDCUBEMAIL_DATABASE_PASSWORD \
    KOLAB_ROUNDCUBEMAIL_DATABASE_NAME \
    || exit 1

if [ ! -z "${MARIADB_SERVICE_HOST}" ]; then
    db_host=${MARIADB_SERVICE_HOST}
else
    db_host=${ROUNDCUBEMAIL_DATABASE_SERVICE_HOST}
fi

sed -i -r \
    -e "s/^primary_domain = .*$/primary_domain = ${DOMAIN}/g" \
    -e "s|^ldap_uri = .*$|ldap_uri = ldap://${KOLAB_LDAP_MASTER_SERVICE_HOST}:${KOLAB_LDAP_MASTER_SERVICE_PORT}|g" \
    -e "s/^base_dn = .*$/base_dn = $(domain_to_root_dn ${DOMAIN})/g" \
    -e "s/^domain_base_dn = .*$/domain_base_dn = ou=Domains,$(domain_to_root_dn ${DOMAIN})/g" \
    -e "s/^bind_dn = .*$/bind_dn = uid=kolab-service,ou=Special Users,$(domain_to_root_dn ${DOMAIN})/g" \
    -e "s/^bind_pw = .*$/bind_pw = ${KOLAB_SERVICE_PASSWORD}/g" \
    -e "s/^service_bind_dn = .*$/service_bind_dn = uid=kolab-service,ou=Special Users,$(domain_to_root_dn ${DOMAIN})/g" \
    -e "s/^service_bind_pw = .*$/service_bind_pw = ${KOLAB_SERVICE_PASSWORD}/g" \
    /etc/kolab/kolab.conf

export TERM=xterm
tables=$(mysql \
        -h ${db_host} \
        -u ${KOLAB_ROUNDCUBEMAIL_DATABASE_USERNAME} \
        --password=${KOLAB_ROUNDCUBEMAIL_DATABASE_PASSWORD} \
        ${KOLAB_ROUNDCUBEMAIL_DATABASE_NAME} \
        -e 'show tables;' \
        2>/dev/null
    )

if [ -z "${tables}" ]; then
    mysql \
        -h ${db_host} \
        -u ${KOLAB_ROUNDCUBEMAIL_DATABASE_USERNAME} \
        --password=${KOLAB_ROUNDCUBEMAIL_DATABASE_PASSWORD} \
        ${KOLAB_ROUNDCUBEMAIL_DATABASE_NAME} \
        < /usr/share/doc/roundcubemail-*/SQL/mysql.initial.sql
fi

exec "$@"
