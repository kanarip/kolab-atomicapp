#!/bin/bash

. /functions.sh

check_var \
    KOLAB_IMAPF_EXT_SERVICE_HOST \
    || exit 1

if [ ! -f "/etc/pki/tls/private/localhost.pem" ]; then
    pushd /etc/pki/tls/certs/
    ./make-dummy-cert ../private/localhost.pem
    popd
fi

sed -r -i \
    -e "s/host, \"127\.0\.0\.1\"/host, \"${KOLAB_IMAPF_EXT_SERVICE_HOST}\"/g" \
    /etc/guam/sys.config

exec "$@"
