#!/bin/bash
# plugin to set "dnf" proxy settings for ProxyMan
# privileges has to be set by the process which starts this script


CONF_FILE=`readlink -f /etc/dnf/dnf.conf`

fix_new_line() {
    if [[ $(tail -c 1 "$CONF_FILE" | wc --lines ) = 0 ]]; then
        echo >> "$1"
    fi
}

list_proxy() {
    # inefficient way as the file is read twice.. think of some better way
    echo
    echo "${bold}APT proxy settings : ${normal}"
    lines="$(cat $CONF_FILE | grep proxy -i | wc -l)"
    if [ "$lines" -gt 0 ]; then
        cat "$CONF_FILE" | grep proxy -i | wc -l
    else
        echo "${red}None${normal}"
    fi
}

unset_proxy() {
    if [ ! -e "$CONF_FILE" ]; then
        return
    fi
    if [ "$(cat $CONF_FILE | grep proxy -i | wc -l)" -gt 0 ]; then
        sed "/proxy/d" $CONF_FILE -i
    fi
}

set_proxy() {
    unset_proxy
    if [ ! -e "$CONF_FILE" ]; then
        touch "$CONF_FILE"
    fi

    echo "proxy=http://${http_host}:${http_port}" >> "$CONF_FILE"

    if [ "$use_auth" = "y" ]; then
        echo "proxy_username=${username}" >> "$CONF_FILE"
        echo "proxy_password=${password}" >> "$CONF_FILE"
    fi
}


which dnf &> /dev/null
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
