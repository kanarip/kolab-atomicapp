#!/bin/bash

. /functions.sh

check_var \
    KOLAB_IMAPF_EXT_SERVICE_HOST \
    || exit 1

sed -r -i \
    -e "s/host, \"192\.168\.56\.101\"/host, \"${KOLAB_IMAPF_EXT_SERVICE_HOST}\"/g" \
    -e "s/tls, false/tls, true/g" \
    /etc/guam/sys.config

exec "$@"
