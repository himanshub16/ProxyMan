#!/bin/bash
# plugin to set "git" proxy settings for ProxyMan
# privileges has to be set by the process which starts this script


list_proxy() {
    echo
    echo "${bold}git proxy settings : ${normal}"
    local git_http_current=$(git config --global http.proxy)
    if [ -z $git_http_current ]; then
        echo "http.proxy ${red}None${normal}"
    else
        echo "${bold} http ${normal}  "\
            "$(git config --global http.proxy) "
    fi

    local git_https_current=$(git config --global https.proxy)
    if [ -z $git_https_current ]; then
        echo "https.proxy ${red}None${normal}"
    else
        echo "${bold} https ${normal}  "\
            "$(git config --global https.proxy) "
    fi
}

unset_proxy() {
    git config --global --unset http.proxy
    git config --global --unset https.proxy
}

set_proxy() {
    local stmt=""
    if [ "$use_auth" = "y" ]; then
        stmt="${username}:${password}@"
    fi

    # caution: do not use / after stmt
    git config --global http.proxy "http://${stmt}${http_host}:${http_port}/"
    if [ "$USE_HTTP_PROXY_FOR_HTTPS" = "true" ]; then
        git config --global https.proxy "http://${stmt}${https_host}:${https_port}/"
    else
        git config --global https.proxy "https://${stmt}${https_host}:${https_port}/"
    fi
}


which git &> /dev/null
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
