#!/bin/bash
# plugin to set "wget" proxy settings for ProxyMan
# privileges has to be set by the process which starts this script


list_proxy() {
    echo
    echo "${bold}wget proxy settings : ${normal}"
    local wget_bashrc_proxy=$(cat ~/.bashrc | grep -q 'wget -e use_proxy=yes')
    local wget_zshrc_proxy=$(cat ~/.zshrc | grep -q 'wget -e use_proxy=yes')
    if [[ $wget_bashrc_proxy -eq 0 ]]; then
        cat ~/.bashrc | grep 'wget -e use_proxy=yes' -i | sed -e 's/^/ /'
    elif [[ $wget_zshrc_proxy -eq 0 ]]; then
        cat ~/.zshrc | grep 'wget -e use_proxy=yes' -i | sed -e 's/^/ /'
    else
        echo "${red}None${normal}"
    fi
}

unset_proxy() {
    sed -i "/wget -e use_proxy=yes/d" ~/.bashrc
    sed -i "/wget -e use_proxy=yes/d" ~/.zshrc
}

set_proxy() {
    local stmt=""
    if [ "$use_auth" = "y" ]; then
        stmt="${username}:${password}@"
    fi
    local wget_http_proxy="http_proxy=http://${stmt}${http_host}:${http_port}/"
    local wget_https_proxy=""
    local wget_ftp_proxy=""
    # caution: do not use / after stmt
  
    if [ "$USE_HTTP_PROXY_FOR_HTTPS" = "true" ]; then
        wget_https_proxy=$wget_http_proxy
        wget_ftp_proxy=$wget_http_proxy
    else
        wget_https_proxy="https_proxy=https://${stmt}${https_host}:${https_port}/"
        wget_ftp_proxy="ftp_proxy=ftp://${stmt}${ftp_host}:${ftp_port}/"
    fi

    echo "alias wget='wget -e use_proxy=yes -e $wget_http_proxy -e $wget_https_proxy -e $wget_ftp_proxy \$@'" >> ~/.bashrc
    echo "alias wget='wget -e use_proxy=yes -e $wget_http_proxy -e $wget_https_proxy -e $wget_ftp_proxy \$@'" >> ~/.zshrc
}


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
