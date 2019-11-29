#!/bin/bash
# plugin to set "npm" proxy settings for ProxyMan
# privileges has to be set by the process which starts this script

list_proxy() {
    echo
    echo "${bold}npm proxy settings : ${normal}"
    echo "http $(npm config get proxy)"
    echo "https $(npm config get https-proxy)"

    if [[ $(npm config get strict-ssl) = "true" && $(npm config get proxy) != "null" ]]; then
        echo "${bold}${red} strict-ssl is true. Would recommend to set it false"
        echo "> ${white} npm config set strict-ssl false ${normal}"
    fi
}

unset_proxy() {
    npm config delete proxy
    npm config delete https-proxy
}

set_proxy() {
    local stmt=""
    if [ "$use_auth" = "y" ]; then
        stmt="${username}:${password}@"
    fi

    # caution: do not use / after stmt
    npm config set proxy "http://${stmt}${http_host}:${http_port}/"

    if [ "$USE_HTTP_PROXY_FOR_HTTPS" = "true" ]; then
        npm config set https-proxy "http://${stmt}${http_host}:${http_port}/"
    else
        npm config set https-proxy "https://${stmt}${https_host}:${https_port}/"
    fi
}

which npm &> /dev/null
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
