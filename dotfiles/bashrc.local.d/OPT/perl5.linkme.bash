#!/bin/bash

PERL_LOCAL_LIB_SH=~/perl5/local-lib.sh
if [[ -z "${PERL_LOCAL_LIB_ROOT}" ]]; then
   if [[ ! -f "${PERL_LOCAL_LIB_SH}" ]]; then
       perl -Mlocal::lib > "${PERL_LOCAL_LIB_SH}"
   fi
   # echo SOURCE
   source "${PERL_LOCAL_LIB_SH}"
fi

path-append ~/perl5/bin

export PERLDOC="-MPod::Text::Color"

