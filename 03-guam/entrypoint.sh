#!/bin/bash

. /functions.sh

check_var \
    KOLAB_IMAPF_EXT_SERVICE_HOST \
    KOLAB_IMAPF_EXT_SERVICE_PORT \
    || exit 1

sed -r -i \
    -e "s/host, \"192\.168\.56\.101\"/host, \"${KOLAB_IMAPF_EXT_SERVICE_HOST}\"/g" \
    -e "s/port, 143/port, ${KOLAB_IMAPF_EXT_SERVICE_PORT}/g" \
    -e "s/tls, false/tls, true/g" \
    /root/guam.git/app.config

exec "$@"
