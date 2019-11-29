#!/bin/bash
# plugin to set "docker" proxy settings for ProxyMan
# privileges has to be set by the process which starts this script

CONF_FILE=`readlink -f /etc/systemd/system/docker.service.d/http-proxy.conf`


reload_docker_service() {
    echo "reloading docker"
    systemctl daemon-reload
    systemctl restart docker.service
    echo "done"
}


list_proxy() {
    # inefficient way as the file is read twice.. think of some better way
    echo -e "${bold}docker proxy settings: ${normal}"
    if [ ! -e "$CONF_FILE" ]; then
        echo -e "${red}None${normal}"
        return
    else
        lines="$(cat $CONF_FILE | grep proxy -i | wc -l)"
        if [ "$lines" -gt 0 ]; then
            cat $CONF_FILE | grep proxy -i | sed -e "s/Environment=//g" -e "s/\_/\ /g"
        else
            echo -e "${red}None${normal}"
        fi
    fi
}

unset_proxy() {
    if [ ! -e "$CONF_FILE" ]; then
        return
    fi
    for PROTOTYPE in "HTTP" "HTTPS" "FTP" "RSYNC" "NO"; do
        sed -i "/${PROTOTYPE}_PROXY\=/d" "$CONF_FILE"
    done
}

set_proxy() {
    unset_proxy
    mkdir -p /etc/systemd/system/docker.service.d
    if [[ ! -e "$CONF_FILE" ]]; then
        echo -n "" > $CONF_FILE
        echo "[Service]" >> $CONF_FILE
    fi

    local stmt=""
    if [ "$use_auth" = "y" ]; then
        stmt="${username}:${password}@"
    fi

    if [ "$USE_HTTP_PROXY_FOR_HTTPS" = "true" ]; then
        echo 'Environment="HTTP_PROXY=http://'${stmt}${http_host}:${http_port}'/" "HTTPS_PROXY=http://'${stmt}${https_host}:${https_port}'/" "NO_PROXY='${no_proxy}'"'\
             >> $CONF_FILE
    else
        echo 'Environment="HTTP_PROXY=http://'${stmt}${http_host}:${http_port}'/" "HTTPS_PROXY=https://'${stmt}${https_host}:${https_port}'/" "NO_PROXY='${no_proxy}'"'\
             >> $CONF_FILE
    fi


    return
}


which docker &> /dev/null
if [ "$?" != 0 ]; then
    exit
fi

if [ "$#" = 0 ]; then
    exit
fi

what_to_do=$1
case $what_to_do in
    set) set_proxy
         reload_docker_service
         ;;
    unset) unset_proxy
           reload_docker_service
           ;;
    list) list_proxy
          ;;
    *)
          ;;
esac
