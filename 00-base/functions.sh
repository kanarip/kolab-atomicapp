#!/bin/bash

exec 3>&1

function check_var() {
    if [ -z "$(eval "echo \$$1")" ]; then
        echo "$1 not defined."
        return 1
    fi

    return 0
}

function check_vars() {
    retval=0

    while [ $# -gt 0 ]; do
        retval=$(( $(check_var $1 >&3; echo $?) + ${retval} ))
        shift
    done

    return ${retval}
}

function domain_to_root_dn() {
    echo "dc=$(echo $1 | sed -e 's/\./,dc=/g')"
}

function persist() {
    while [ $# -gt 0 ]; do
        if [ ! -d "/data$(dirname $1)" ]; then
            mkdir -p "/data$(dirname $1)"
        fi

        echo -n "mv: "; mv -v $1 "/data$(dirname $1)"
        echo -n "ln: "; ln -svf "/data$1" "$(dirname $1)/$(basename $1)"

        shift
    done
}
