#!/bin/bash

echoerr() { printf "\e[32;1m%s\e[0m\n" "$*" >&2; }

DN_URL=$(curl 'https://modarchive.org/index.php?request=view_random' | pup 'a.standard-link attr{href}' | grep '^http')

# echoerr "Download URL: ${DN_URL}"

MOD_FN=$(echo "${DN_URL}" | grep -Po '\#\K.+$')

echoerr "Filename: ${MOD_FN}"

curl -o "${MOD_FN}" "${DN_URL}"

ls -lh "${MOD_FN}"

mikmod "${MOD_FN}"



