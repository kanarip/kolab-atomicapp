#!/bin/bash

if [ ! -d "/srv/stick.git" ]; then
    git clone https://git.kolab.org/diffusion/QA/stick.git /srv/stick.git
elif [ -z "${PS1}" ]; then
    pushd /srv/stick.git
    git remote set-url origin https://git.kolab.org/diffusion/QA/stick.git
    git fetch origin
    git reset --hard origin/master
    git clean -d -f -x
    popd
fi

source /functions.sh

export TEST_BUILD=${TEST_BUILD:-0}
export TEST_FUNCTIONAL=${TEST_FUNCTIONAL:-0}
export TEST_INTEGRATION=${TEST_INTEGRATION:-0}
export TEST_PERFORMANCE=${TEST_PERFORMANCE:-0}
export TEST_UNIT=${TEST_UNIT:-0}
export TEST_OBS=${TEST_OBS:-0}

# If PS1 is set, we're interactive
if [ ! -z "${PS1}" ]; then
    # Set a sensible prompt
    PS1='[\u@${IMAGE} \W]\$ '

    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWUNTRACKEDFILES=1
    export GIT_PS1_SHOWUPSTREAM="auto verbose"

    if [ ! -f "/etc/bash_completion" ]; then
        if [ -f "/etc/bash_completion.d/git" ]; then
            . /etc/bash_completion.d/git
            PS1='[\u@${IMAGE} \W$(__git_ps1 " (%s)")]\$ '
        fi
    else
        PS1='[\u@${IMAGE} \W$(__git_ps1 " (%s)")]\$ '
    fi

    export PS1

    PROMPT_COMMAND="echo -ne '\033]0;${IMAGE} (in ${HOSTNAME})\007'"

    if [ -f "/usr/share/git-core/contrib/completion/git-prompt.sh" ]; then
        source /usr/share/git-core/contrib/completion/git-prompt.sh
    fi
fi

if [ ! -d "/srv/${PACKAGE}.git" ]; then
    git clone ${RO_URI} /srv/${PACKAGE}.git

    pushd /srv/${PACKAGE}.git

    for branch in $(git branch -la | sed -e 's/^* //g' -e 's/  //g' -e '/remotes\/origin\/HEAD/d' -e 's|remotes/origin/||g' | sort -u); do
        git checkout $branch
    done

    popd
else
    pushd /srv/${PACKAGE}.git

    git remote set-url origin ${RO_URI}
    git fetch origin
    git reset --hard origin/master
    git clean -d -f -x

    for branch in $(git branch -la | sed -e 's/^* //g' -e '/\(detached from/d' -e 's/  //g' -e '/remotes\/origin\/HEAD/d' -e 's|remotes/origin/||g' | sort -u); do
        git checkout $branch
    done

    popd
fi

retval=0

if [ -x "$(which yum 2>/dev/null)" ]; then
    yum clean metadata; retval=$(( ${retval} + $? ))
    yum -y update; retval=$(( ${retval} + $? ))
    rpmdev-setuptree; retval=$(( ${retval} + $? ))
elif [ -x "$(which apt-get 2>/dev/null)" ]; then
    apt-get update; retval=$(( ${retval} + $? ))
fi

pushd /srv/${PACKAGE}.git

if [ ! -z "${COMMIT}" ]; then
    git checkout ${COMMIT}; retval=$(( ${retval} + $? ))
fi

# TODO: A differential has a base commit.

if [ ${retval} -ne 0 ]; then
    _report
    exit 1
fi

if [ -x "../stick.git/drydocker/${PACKAGE}/test_build.sh" -a ${TEST_BUILD} -eq 1 ]; then
    retval=$(_shell ../stick.git/drydocker/${PACKAGE}/test_build.sh)
    if [ ${retval} -ne 0 ]; then
        _report
        exit 1
    fi
fi

if [ -x "../stick.git/drydocker/${PACKAGE}/test_unit.sh" -a ${TEST_UNIT} -eq 1 ]; then
    retval=$(_shell ../stick.git/drydocker/${PACKAGE}/test_unit.sh)
    if [ ${retval} -ne 0 ]; then
        _report
        exit 1
    fi
fi

if [ -x "../stick.git/drydocker/${PACKAGE}/test_functional.sh" -a ${TEST_FUNCTIONAL} -eq 1 ]; then
    retval=$(_shell ../stick.git/drydocker/${PACKAGE}/test_functional.sh)
    if [ ${retval} -ne 0 ]; then
        _report
        exit 1
    fi
fi

if [ -x "../stick.git/drydocker/${PACKAGE}/test_obs.sh" ]; then
    retval=$(_shell ../stick.git/drydocker/${PACKAGE}/test_obs.sh)
    if [ ${retval} -ne 0 ]; then
        _report
        exit 1
    fi
fi

if [ -x "../stick.git/drydocker/${PACKAGE}/test_integration.sh" -a ${TEST_INTEGRATION} -eq 1 ]; then
    retval=$(_shell ../stick.git/drydocker/${PACKAGE}/test_integration.sh)
    if [ ${retval} -ne 0 ]; then
        _report
        exit 1
    fi
fi

if [ -x "../stick.git/drydocker/${PACKAGE}/test_obs_checkin.sh" ]; then
    retval=$(_shell ../stick.git/drydocker/${PACKAGE}/test_obs_checkin.sh)
    if [ ${retval} -ne 0 ]; then
        _report
        exit 1
    fi
fi

popd

_report
