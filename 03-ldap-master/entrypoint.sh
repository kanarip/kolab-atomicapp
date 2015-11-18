#!/bin/bash

if [ -z "${KOLAB_LDAP_MASTER_SERVICE_HOST}" ]; then
    export KOLAB_LDAP_MASTER_SERVICE_HOST=$(ip a sh dev $(route -n | grep ^0.0.0.0 | awk '{print $8}') | grep "    inet " | awk '{print $2}' | awk -F'/' '{print $1}')
fi

cp -vf /etc/hosts /etc/hosts.docker
if echo "# test access" >> /etc/hosts || umount /etc/hosts 2>/dev/null ; then
    echo "${KOLAB_LDAP_MASTER_SERVICE_HOST} ${HOSTNAME}.${DOMAIN} ${HOSTNAME}" > /etc/hosts
fi

sed -i \
    -e "s/%hostname%/${HOSTNAME}/g" \
    -e "s/%domain%/${DOMAIN}/g" \
    -e "s/%cyrus_admin_password%/${CYRUS_ADMIN_PASSWORD}/g" \
    -e "s/%kolab_service_password%/${KOLAB_SERVICE_PASSWORD}/g" \
    /usr/share/dirsrv/data/template.ldif

cat >/tmp/setup-ds.inf <<EOF
[General]
FullMachineName = ${HOSTNAME}.${DOMAIN}
SuiteSpotUserID = nobody
SuiteSpotGroup = nobody
AdminDomain = ${DOMAIN}
ConfigDirectoryLdapURL = ldap://${KOLAB_LDAP_MASTER_SERVICE_HOST}:389/o=NetscapeRoot
ConfigDirectoryAdminID = admin
ConfigDirectoryAdminPwd = ${ADMIN_PASSWORD}

[slapd]
SlapdConfigForMC = Yes
UseExistingMC = 0
ServerPort = 389
ServerIdentifier = ldap
Suffix = dc=$(echo ${DOMAIN} | sed -e 's/\./,dc=/g')
RootDN = cn=Directory Manager
RootDNPwd = ${DIRECTORY_MANAGER_PASSWORD}
ds_bename = $(echo ${DOMAIN} | sed -e 's/\./_/g')
AddSampleEntries = No
EOF

if [ ! -d "/etc/dirsrv/slapd-ldap/" ]; then
    timeout 40s setup-ds.pl --debug --silent --file=/tmp/setup-ds.inf || :
    kill -15 ns-slapd

    if [ -f /var/run/dirsrv/slapd-ldap.pid ]; then

        tries=1
        while [ ! -z "$(cat /var/run/dirsrv/slapd-ldap.pid) 2>/dev/null)" -a ${tries} -le 20 ]; do
            echo "Waiting for process $(cat /var/run/dirsrv/slapd-ldap.pid) to terminate..."
            sleep 1
            let tries++
        done

        kill -9 $(cat /var/run/dirsrv/slapd-ldap.pid) 2>/dev/null || :
    fi
fi

dirs=(
        /etc/dirsrv/
        /etc/kolab/
        /var/lib/dirsrv/
    )

for dir in ${dirs[@]}; do
    if [ ! -d "/data$(dirname ${dir})" ]; then
        mkdir -p "/data$(dirname ${dir})"
        mv -v ${dir} "/data$(dirname ${dir})"
        ln -svf "/data${dir}" $(dirname ${dir})/$(basename ${dir})
    fi
done

exec "$@"
