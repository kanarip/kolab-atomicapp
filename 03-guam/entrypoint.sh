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
    -e "s/host, \"192\.168\.56\.101\"/host, \"${KOLAB_IMAPF_EXT_SERVICE_HOST}\"/g" \
    -e "s/tls, false/tls, true/g" \
    -e "s|/etc/ssl/sample.pem|/etc/pki/tls/private/localhost.pem|g" \
    /etc/guam/sys.config

exec "$@"
