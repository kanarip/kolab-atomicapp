#!/bin/bash

# Create 3 as an alias for 1, so the _shell function
# can output data without the caller getting the input.
exec 3>&1

function _report {
    echo $(printf '%0.1s' "="{1..72})
    cat ${TMPDIR:-/tmp}/report.log
    rm -rf ${TMPDIR:-/tmp}/report.log
    echo $(printf '%0.1s' "="{1..72})
}

export -f _report

function _report_msg {
    printf "%*s" $(( ( ${BASH_SUBSHELL} - 1 ) * 4 )) " " >> ${TMPDIR:-/tmp}/report.log
    echo "$@" >> ${TMPDIR:-/tmp}/report.log
}

export -f _report_msg

function _shell {
    revision=$(git rev-parse HEAD 2>/dev/null)
    if [ -z "${revision}" ]; then
        pushd /srv/${PACKAGE}.git >/dev/null 2>&1 3>&1
        revision=$(git rev-parse HEAD 2>/dev/null)
        popd >/dev/null 2>&1 3>&1
    fi

    if [ -z "${revision}" ]; then
        revision=unknown
    fi

    echo "Running $@ ..." >&3
    $@ >&3 2>&3 ; retval=$?

    if [ ${retval} -eq 0 ]; then
        _report_msg "Running '$@' OK (at ${revision})"
        echo "Running $@ OK (at ${revision})" >&3
    else
        _report_msg "Running '$@' FAILED (at ${revision})"
        echo "Running $@ FAILED (at ${revision})" >&3
    fi

    echo ${retval}
}

export -f _shell

function _install_package {
    if [ -x "$(which yum 2>/dev/null)" ]; then
        yum -y install $@
    elif [ -x "$(which apt-get 2>/dev/null)" ]; then
        apt-get -y install $@
    fi
}

function _install_package_builddep {
    if [ -x "$(which yum 2>/dev/null)" ]; then
        yum-builddep -y --disablerepo=openSUSE_Tools $@
    elif [ -x "$(which apt-get 2>/dev/null)" ]; then
        apt-get -y build-dep $@
    fi
}
