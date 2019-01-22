#!/bin/bash
# plugin to set "apt" proxy settings for ProxyMan
# privileges has to be set by the process which starts this script


CONF_FILE="/etc/environment"

fix_new_line() {
    if [[ $(tail -c 1 "$CONF_FILE" | wc --lines ) = 0 ]]; then
        echo >> "$1"
    fi
}

list_proxy() {
    # inefficient way as the file is read twice.. think of some better way
    echo
    echo "${bold}environment proxy settings : ${normal}"
    lines="$(cat $CONF_FILE | grep proxy -i | wc -l)"
    if [ "$lines" -gt 0 ]; then
        cat $CONF_FILE | grep proxy -i
    else
        echo -e "${red}None${normal}"
    fi
}

unset_proxy() {
    if [ ! -e "$CONF_FILE" ]; then
        return
    fi
    for PROTOTYPE in "HTTP" "HTTPS" "FTP" "RSYNC" "NO"; do
        sed -i "/${PROTOTYPE}_PROXY\=/Id" "$CONF_FILE"
    done
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

    # caution: do not use / after stmt
    echo "http_proxy=\"http://${stmt}${http_host}:${http_port}\"" \
         >> "$CONF_FILE"
    echo "HTTP_PROXY=\"http://${stmt}${http_host}:${http_port}\"" \
         >> "$CONF_FILE"
    echo "https_proxy=\"http://${stmt}${http_host}:${http_port}\"" \
         >> "$CONF_FILE"
    echo "HTTPS_PROXY=\"http://${stmt}${http_host}:${http_port}\"" \
         >> "$CONF_FILE"
    echo "ftp_proxy=\"http://${stmt}${http_host}:${http_port}\"" \
        >> "$CONF_FILE"
    echo "FTP_PROXY=\"http://${stmt}${http_host}:${http_port}\"" \
        >> "$CONF_FILE"
    echo "no_proxy=\"${no_proxy}\"" \
        >> "$CONF_FILE"
    echo "NO_PROXY=\"${no_proxy}\"" \
        >> "$CONF_FILE"
}



if [ ! -e $CONF_FILE ]; then
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
