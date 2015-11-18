#!/bin/bash

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
    -e "s|^sql_uri = .*$|sql_uri = mysql://${KOLAB_WEBADMIN_DATABASE_USERNAME}:${KOLAB_WEBADMIN_DATABASE_PASSWORD}@${MARIADB_SERVICE_HOST}/${KOLAB_WEBADMIN_DATABASE_NAME}|g" \
    /etc/kolab/kolab.conf

sed -i -r \
    -e "s/%CYRUS_ADMIN_PASSWORD%/${CYRUS_ADMIN_PASSWORD}/g" \
    -e "s/%KOLAB_IMAP_MUPDATE_SERVICE_HOST%/${KOLAB_IMAP_MUPDATE_SERVICE_HOST}/g" \
    -e "s/%KOLAB_IMAP_MUPDATE_SERVICE_PORT%/${KOLAB_IMAP_MUDPATE_SERVICE_PORT}/g" \
    -e "s/%KOLAB_SERVICE_PASSWORD%/${KOLAB_SERVICE_PASSWORD}/g" \
    /etc/kolab/templates/imapd.conf.tpl

setup-kolab imap
killall -9 cyrus-master || :
pkill -9 -u cyrus || :

dirs=(
        /etc/cyrus.conf
        /etc/imapd.conf
        /etc/imapd.annotations.conf
        /var/lib/imap/
        /var/spool/imap/
    )

for dir in ${dirs[@]}; do
    if [ ! -d "/data$(dirname ${dir})" ]; then
        mkdir -p "/data$(dirname ${dir})"
        mv -v ${dir} "/data$(dirname ${dir})"
        ln -svf "/data${dir}" $(dirname ${dir})/$(basename ${dir})
    fi
done

exec "$@"
