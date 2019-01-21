#!/bin/bash
# plugin to set "dnf" proxy settings for ProxyMan
# privileges has to be set by the process which starts this script

CONF_FILE="/etc/systemd/system/docker.service.d/http-proxy.conf"


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
    if [ "$(cat $CONF_FILE | grep proxy -i | wc -l)" -gt 0 ]; then
        sudo rm $CONF_FILE
        sudo service docker restart
    fi
}

set_proxy() {
    unset_proxy
    if [ ! -e "$CONF_FILE" ]; then
        sudo touch "$CONF_FILE"
    fi

    local stmt=""
    if [ "$use_auth" = "y" ]; then
        stmt="${username}:${password}@"
    fi

    echo -n "" > docker_config.tmp
    echo "[Service]" >> docker_config.tmp
    echo "Environment=\"HTTP_PROXY=http://${stmt}${http_host}:${http_port}\";" \
         >> docker_config.tmp
    echo "Environment=\"HTTP_PROXY=http://${stmt}${http_host}:${http_port}\";" \
         >> docker_config.tmp

    cat docker_config.tmp | sudo tee -a $CONF_FILE > /dev/null
    rm docker_config.tmp
    sudo service docker restart
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
         ;;
    unset) unset_proxy
           ;;
    list) list_proxy
          ;;
    *)
          ;;
esac
