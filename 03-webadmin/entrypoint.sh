#!/bin/bash

env

if [ -z "${MARIADB_SERVICE_HOST}" -a -z "${WEBADMIN_DATABASE_SERVICE_HOST}" ]; then
    sleep 10
    exit 1
fi

if [ ! -z "${MARIADB_SERVICE_HOST}" ]; then
    db_host=${MARIADB_SERVICE_HOST}
else
    db_host=${WEBADMIN_DATABASE_SERVICE_HOST}
fi

sed -i -r \
    -e "s/^primary_domain = .*$/primary_domain = ${DOMAIN}/g" \
    -e "s|^ldap_uri = .*$|ldap_uri = ldap://${KOLAB_LDAP_MASTER_SERVICE_HOST}:${KOLAB_LDAP_MASTER_SERVICE_POST}|g" \
    -e "s/^base_dn = .*$/base_dn = dc=$(echo ${DOMAIN} | sed -e 's/\./,dc=/g')/g" \
    -e "s/^domain_base_dn = .*$/domain_base_dn = ou=Domains,dc=$(echo ${DOMAIN} | sed -e 's/\./,dc=/g')/g" \
    -e "s/^bind_dn = .*$/bind_dn = uid=kolab-service,ou=Special Users,dc=$(echo ${DOMAIN} | sed -e 's/\./,dc=/g')/g" \
    -e "s/^bind_pw = .*$/bind_pw = ${KOLAB_SERVICE_PASSWORD}/g" \
    -e "s/^service_bind_dn = .*$/service_bind_dn = uid=kolab-service,ou=Special Users,dc=$(echo ${DOMAIN} | sed -e 's/\./,dc=/g')/g" \
    -e "s/^service_bind_pw = .*$/service_bind_pw = ${KOLAB_SERVICE_PASSWORD}/g" \
    -e "s|^sql_uri = .*$|sql_uri = mysql://${KOLAB_WEBADMIN_DATABASE_USERNAME}:${KOLAB_WEBADMIN_DATABASE_PASSWORD}@${db_host}/${KOLAB_WEBADMIN_DATABASE_NAME}|g" \
    /etc/kolab/kolab.conf

export TERM=xterm
tables=$(mysql \
        -h ${db_host} \
        -u ${KOLAB_WEBADMIN_DATABASE_USERNAME} \
        --password=${KOLAB_WEBADMIN_DATABASE_PASSWORD} \
        ${KOLAB_WEBADMIN_DATABASE_NAME} \
        -e 'show tables;' \
        2>/dev/null
    )

if [ -z "${tables}" ]; then
    mysql \
        -h ${db_host} \
        -u ${KOLAB_WEBADMIN_DATABASE_USERNAME} \
        --password=${KOLAB_WEBADMIN_DATABASE_PASSWORD} \
        ${KOLAB_WEBADMIN_DATABASE_NAME} \
        < /usr/share/doc/kolab-webadmin-*/kolab_wap.sql
fi

exec "$@"
