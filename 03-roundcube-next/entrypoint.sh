#!/bin/bash

. /functions.sh

check_var KOLAB_JMAP_PROXY_SERVICE_HOST || check_var JMAP_HOST || exit 1

if [ ! -z "${KOLAB_JMAP_PROXY_SERVICE_HOST}" ]; then
    export JMAP_HOST="http://${KOLAB_JMAP_PROXY_SERVICE_HOST}:${KOLAB_JMAP_PROXY_SERVICE_PORT:-80}"
fi

exec "$@"
