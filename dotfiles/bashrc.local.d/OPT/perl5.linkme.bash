#!/bin/bash

if [[ -z "${PERL_LOCAL_LIB_ROOT}" ]]; then
    PERL_LOCAL_LIB_SH=~/perl5/local-lib.sh

    if [[ ! -f "${PERL_LOCAL_LIB_SH}" ]]; then
        perl -Mlocal::lib > "${PERL_LOCAL_LIB_SH}"
    fi

    # shellcheck disable=SC1090
    source "${PERL_LOCAL_LIB_SH}"

    # path-append ~/perl5/bin

    export PERLDOC="-MPod::Text::Color"
fi
