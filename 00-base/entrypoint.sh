#!/bin/bash

if [ -z "$@" ]; then
    exec top
else
    exec "$@"
fi
