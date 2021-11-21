#!/bin/bash
# plugin to set "wget" proxy settings for ProxyMan
# privileges has to be set by the process which starts this script

CONF_FILE=/etc/resolv.conf

list_proxy() {
    echo
    echo "${bold}resolv.conf proxy settings ${normal}"
    lines="$(cat $CONF_FILE | grep nameserver -i | wc -w)"
    if [ "$lines" -gt 0 ]; then
        cat $CONF_FILE | grep nameserver -i | sed -e 's/^/ /'
    else
        echo "${red}None${normal}"
    fi
}

unset_proxy() {
    if [ ! -e "$CONF_FILE" ]; then
        return
    fi

    sed -i "/nameserver/d" "$CONF_FILE"
    echo "nameserver 8.8.8.8" >> "$CONF_FILE"
    echo "nameserver 8.8.8.4" >> "$CONF_FILE"
}

set_proxy() {
    unset_proxy
    if [ ! -e "$CONF_FILE" ]; then
        touch "$CONF_FILE"
    fi

    sed -i "/nameserver/d" "$CONF_FILE"
    echo "${red}Add nameservers in resolvconf.sh ${normal}"
    # Update the addresses here...
    echo "nameserver 8.8.8.8" >> "$CONF_FILE"
    echo "nameserver 8.8.8.4" >> "$CONF_FILE"
}



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
