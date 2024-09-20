#!/bin/bash
# plugin to set "flatpak" proxy settings for ProxyMan
# privileges has to be set by the process which starts this script





CONF_FILE=`readlink -m $HOME/.local/share/flatpak/overrides/global`

fix_new_line() {
    if [[ $(tail -c 1 "$CONF_FILE" | wc --lines ) = 0 ]]; then
        echo >> "$1"
    fi
}

list_proxy() {
    echo
    echo "${bold}flatpak proxy settings : ${normal}"
    if [ "$(cat $CONF_FILE | grep PROXYMAN -i | wc -l)" -gt 0 ]; then
        firstline=$(("$(grep -n -m 1 "###### START PROXYMAN CONFIG ######" $CONF_FILE | cut -d: -f1)"+1))
        lastline=$(("$(grep -n -m 1 "###### END PROXYMAN CONFIG ######" $CONF_FILE | cut -d: -f1)"-1))
        sed -n "${firstline},${lastline}p" $CONF_FILE
    else
        echo "${red}None${normal}"
    fi
}

unset_proxy() {
    if [ ! -e "$CONF_FILE" ]; then
        return
    fi
    if [ "$(cat $CONF_FILE | grep PROXYMAN -i | wc -l)" -gt 0 ]; then
        firstline="$(grep -n -m 1 "###### START PROXYMAN CONFIG ######" $CONF_FILE | cut -d: -f1)"
        lastline="$(grep -n -m 1 "###### END PROXYMAN CONFIG ######" $CONF_FILE | cut -d: -f1)"
        sed -i "${firstline},${lastline}d" $CONF_FILE
    fi
}


set_proxy() {
    unset_proxy
    if [ ! -e "$CONF_FILE" ]; then
        mkdir -p $(dirname "$CONF_FILE")
        touch "$CONF_FILE"
    fi

    local stmt=""
    if [ "$use_auth" = "y" ]; then
        stmt="${username}:${password}@"
    fi

    # caution: do not use / after stmt

    echo "###### START PROXYMAN CONFIG ######" >> "$CONF_FILE"
    echo "[Environment]" >> "$CONF_FILE"
    echo "    http_proxy=http://${stmt}${http_host}:${http_port}" \
         >> "$CONF_FILE"
    echo "    HTTP_PROXY=http://${stmt}${http_host}:${http_port}" \
         >> "$CONF_FILE"         
    if [ "$USE_HTTP_PROXY_FOR_HTTPS" = "true" ]; then
        echo "    https_proxy=http://${stmt}${https_host}:${https_port}" \
         >> "$CONF_FILE"
        echo "    HTTPS_PROXY=http://${stmt}${https_host}:${https_port}" \
         >> "$CONF_FILE"
    else
        echo "    https_proxy=https://${stmt}${https_host}:${https_port}" \
         >> "$CONF_FILE"
        echo "    HTTPS_PROXY=http://${stmt}${https_host}:${https_port}" \
         >> "$CONF_FILE"
    fi
    echo "###### END PROXYMAN CONFIG ######" >> "$CONF_FILE"
}

which flatpak &> /dev/null
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
