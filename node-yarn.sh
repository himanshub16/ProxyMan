#!/bin/bash
# plugin to set "yarn" (nodejs) proxy settings for ProxyMan
# privileges has to be set by the process which starts this script

list_proxy() {
    echo
    echo "${bold}yarn proxy settings : ${normal}"
    echo "http $(yarn config get proxy)"
    echo "https $(yarn config get https-proxy)"

    if [[ $(yarn config get strict-ssl) = "true" && $(yarn config get proxy) != "null" ]]; then
        echo "${bold}${red} strict-ssl is true. Would recommend to set it false"
        echo "> ${white} yarn config set strict-ssl false ${normal}"
    fi
}

unset_proxy() {
    yarn config delete proxy
    yarn config delete https-proxy
}

set_proxy() {
    local stmt=""
    if [ "$use_auth" = "y" ]; then
        stmt="${username}:${password}@"
    fi

    # caution: do not use / after stmt
    yarn config set proxy "http://${stmt}${http_host}:${http_port}/"

    if [ "$USE_HTTP_PROXY_FOR_HTTPS" = "true" ]; then
        yarn config set https-proxy "http://${stmt}${http_host}:${http_port}/"
    else
        yarn config set https-proxy "https://${stmt}${https_host}:${https_port}/"
    fi
}

which yarn &> /dev/null
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
