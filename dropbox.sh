#!/bin/bash
# plugin to set "dropbox" proxy settings for ProxyMan
# privileges has to be set by the process which starts this script


DROPBOX_PY="dropbox"

list_proxy() {
    echo
    echo "${blue} Dropbox doesn't show proxy settings. No worries! ${normal}"
}

unset_proxy() {
    $DROPBOX_PY proxy none &> /dev/null
}

set_proxy() {
    eval "$DROPBOX_PY proxy manual http $http_host $http_port $username $password &> /dev/null"
}


which $DROPBOX_PY &> /dev/null
if [ "$?" != 0 ]; then
    exit
fi

if [ "$#" = 0 ]; then
    exit
fi

what_to_do=$1
case $what_to_do in
    set) set_proxy
         ;;
    unset) unset_proxy
           ;;
    list) list_proxy
          ;;
    *)
          ;;
esac
