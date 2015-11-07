#!/bin/bash

if [ $# -lt 1 ]; then
    exec top
else
    exec "$@"
fi
