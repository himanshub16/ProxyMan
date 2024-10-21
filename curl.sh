#!/bin/bash
# plugin to set "curl" proxy settings for ProxyMan
# privileges has to be set by the process which starts this script

CONF_FILE=~/.curlrc

list_proxy() {
    echo
    echo "${bold}curl proxy settings ${normal}"
    lines="$(cat $CONF_FILE | grep proxy -i | cut -d"=" -f2 | wc -w)"
    if [ "$lines" -gt 0 ]; then
        cat $CONF_FILE | grep proxy -i | sed -e 's/^/ /'
    else
        echo "${red}None${normal}"
    fi
}

unset_proxy() {
    if [ ! -e "$CONF_FILE" ]; then
        return
    fi
    # extra effort required to avoid removing custom environment variables set
    # by the user for personal use
    for proxytype in "http" ; do
        sed -i "/proxy\=/d" "$CONF_FILE"
    done
    echo "${blue}curl proxy unset ${normal}"
}

set_proxy() {
    unset_proxy
    if [ ! -e "$CONF_FILE" ]; then
        touch "$CONF_FILE"
    fi

    local stmt=""
    if [ "$use_auth" = "y" ]; then
        stmt="${username}:${password}@"
    fi

    sed -i "/proxy\=/d" "$CONF_FILE"

    # caution: do not use / after stmt
    echo "proxy=\"http://${stmt}${http_host}:${http_port}/\""     >> "$CONF_FILE"
    list_proxy
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
