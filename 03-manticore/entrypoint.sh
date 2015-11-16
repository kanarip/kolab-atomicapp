#!/bin/bash
set -e

sed -i \
    -e "s/email: 'admin@admin.com',/email: '${MONGODB_ADMIN_EMAIL:-admin@admin.com}',/g" \
    -e "s/password: 'admin',/password: '${MONGODB_ADMIN_PASSWORD:-password}'/g" \
    /var/www/manticore.git/server/config/seed.js

export MONGOLAB_URI="mongodb://${MONGODB_USERNAME}:${MONGODB_PASSWORD}@${MONGODB_SERVICE_HOST}/${MONGODB_DATABASE}"

exec "$@"
