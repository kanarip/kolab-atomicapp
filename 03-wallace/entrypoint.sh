#!/bin/bash

env

if [ -z "${KOLAB_LDAP_MASTER_SERVICE_HOST}" ]; then
    sleep 10
    exit 1
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
    /etc/kolab/kolab.conf

exec "$@"
