#!/bin/bash
# plugin to set "wget" proxy settings for ProxyMan
# privileges has to be set by the process which starts this script

CONF_FILE=~/.wgetrc

list_proxy() {
    echo
    echo "${bold}wget proxy settings ${normal}"
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
    for proxytype in "http" "https" "ftp" ; do
        sed -i "/${proxytype}_proxy\=/d" "$CONF_FILE"
        echo "${proxytype}_proxy="     >> "$CONF_FILE"
    done
    for PROTOTYPE in "HTTP" "HTTPS" "FTP" ; do
        sed -i "/${PROTOTYPE}_PROXY\=/d" "$CONF_FILE"
        echo "${PROTOTYPE}_PROXY="     >> "$CONF_FILE"
    done
    sed -i "/use_proxy/d" "$CONF_FILE"
    echo "${blue}wget proxy unset ${normal}"
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

    for proxytype in "http" "https" "ftp"; do
        sed -i "/${proxytype}_proxy\=/d" "$CONF_FILE"
    done
    for PROTOTYPE in "HTTP" "HTTPS" "FTP"; do
        sed -i "/${PROTOTYPE}_PROXY\=/d" "$CONF_FILE"
    done
    sed -i "/use_proxy/d" "$CONF_FILE"

    echo "use_proxy = on" >> "$CONF_FILE"
    # caution: do not use / after stmt
    echo "http_proxy=\"http://${stmt}${http_host}:${http_port}/\""     >> "$CONF_FILE"
    # $https_proxy at the end
    echo "HTTP_PROXY=\"http://${stmt}${http_host}:${http_port}/\""     >> "$CONF_FILE"
    # $HTTPS_PROXY at the end

    if [ "$USE_HTTP_PROXY_FOR_HTTPS" = "true" ]; then
        echo "https_proxy=\"http://${stmt}${http_host}:${http_port}/\"" >> "$CONF_FILE"
        echo "HTTPS_PROXY=\"http://${stmt}${http_host}:${http_port}/\"" >> "$CONF_FILE"
    else
        echo "https_proxy=\"https://${stmt}${https_host}:${https_port}/\"" >> "$CONF_FILE"
        echo "HTTPS_PROXY=\"https://${stmt}${https_host}:${https_port}/\"" >> "$CONF_FILE"
    fi
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
