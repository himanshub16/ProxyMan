#!/bin/bash
# plugin to set "docker" proxy settings for ProxyMan
# privileges has to be set by the process which starts this script

CONF_FILE=`readlink -f /etc/systemd/system/docker.service.d/http-proxy.conf`
CONF_INSDIE_DOCKER="$HOME/.docker/config.json"

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
    
    if [ ! -e "$CONF_INSDIE_DOCKER" ]; then
        return
    fi

    if ! type "jq" > /dev/null; then
        echo "please install jq"
    else
        jq 'del(.proxies)' "$CONF_INSDIE_DOCKER" > "$HOME/.docker/config_new.json"
        cat "$HOME/.docker/config_new.json" > "$CONF_INSDIE_DOCKER"
        rm -f "$HOME/.docker/config_new.json"
    fi
}

set_proxy() {
    unset_proxy
    mkdir -p /etc/systemd/system/docker.service.d
    mkdir -p "$HOME/.docker/"

    if [[ ! -e "$CONF_FILE" ]]; then
        echo -n "" > $CONF_FILE
        echo "[Service]" >> $CONF_FILE
    fi

    if [[ ! -e "$CONF_INSDIE_DOCKER" ]]; then
        echo -n "{}" > $CONF_INSDIE_DOCKER
    fi

    local stmt=""
    if [ "$use_auth" = "y" ]; then
        stmt="${username}:${password}@"
    fi



    if [ "$USE_HTTP_PROXY_FOR_HTTPS" = "true" ]; then
        echo 'Environment="HTTP_PROXY=http://'${stmt}${http_host}:${http_port}'/" "HTTPS_PROXY=http://'${stmt}${https_host}:${https_port}'/" "NO_PROXY='${no_proxy}'"'\
             >> $CONF_FILE
        
        if ! type "jq" > /dev/null; then
            echo "please install jq"
        else
            JSON_STRING=$( jq \
                --arg httpProxy "http://${stmt}${http_host}:${http_port}" \
                --arg httpsProxy "http://${stmt}${http_host}:${http_port}" \
                --arg noProxy "${no_proxy}" \
                '. + { proxies: { default : {httpProxy: $httpProxy, httpsProxy: $httpsProxy, noProxy: $noProxy }}}' \
                "$CONF_INSDIE_DOCKER")

            jq '.' <<< $JSON_STRING > $CONF_INSDIE_DOCKER
        fi
    else
        echo 'Environment="HTTP_PROXY=http://'${stmt}${http_host}:${http_port}'/" "HTTPS_PROXY=https://'${stmt}${https_host}:${https_port}'/" "NO_PROXY='${no_proxy}'"'\
             >> $CONF_FILE

        if ! type "jq" > /dev/null; then
            echo "please install jq"
        else
            JSON_STRING=$( jq \
                --arg httpProxy "http://${stmt}${http_host}:${http_port}" \
                --arg httpsProxy "https://${stmt}${http_host}:${http_port}" \
                --arg noProxy "${no_proxy}" \
                '. + { proxies: { default : {httpProxy: $httpProxy, httpsProxy: $httpsProxy, noProxy: $noProxy }}}' \
                "$CONF_INSDIE_DOCKER")

            jq '.' <<< $JSON_STRING > $CONF_INSDIE_DOCKER
        fi
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
