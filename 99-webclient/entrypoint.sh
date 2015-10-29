#!/bin/bash

setup-kolab --default --timezone=Europe/Zurich php
setup-kolab --default freebusy
setup-kolab --default roundcube

# Apply some configuration
exec "$@"
