#!/bin/bash
# plugin to set "KDE plasma 5" proxy settings for ProxyMan
# privileges has to be set by the process which starts this script


list_proxy() {
    echo
    echo "${bold}Desktop proxy settings (KDE) ${normal}"
    mode=$(kreadconfig5 --file kioslaverc --group "Proxy Settings" --key ProxyType)
    if [ "$mode" = "0" ]; then
        echo "${red}None${normal}"
        return
    fi

    echo "${bold} http ${normal}  "\
         "$(kreadconfig5 --file kioslaverc --group "Proxy Settings" --key httpProxy) "
    echo "${bold} https ${normal} "\
         "$(kreadconfig5 --file kioslaverc --group "Proxy Settings" --key httpsProxy) "
    echo "${bold} ftp ${normal}   "\
         "$(kreadconfig5 --file kioslaverc --group "Proxy Settings" --key ftpProxy) "
    echo "${bold} socks ${normal} "\
         "$(kreadconfig5 --file kioslaverc --group "Proxy Settings" --key sockProxy) "
    echo "${bold} no_proxy ${normal} "\
         "$(kreadconfig5 --file kioslaverc --group "Proxy Settings" --key NoProxyFor) "
}

unset_proxy() {
    kwriteconfig5 --file kioslaverc --group "Proxy Settings" --key ProxyType 0
}

set_proxy() {
    # do quote the variables as blank variables mean nothing when not quoted and show errors
    kwriteconfig5 --file kioslaverc --group "Proxy Settings" --key ProxyType 1
    kwriteconfig5 --file kioslaverc --group "Proxy Settings" --key httpProxy "http://$http_host $http_port"
    kwriteconfig5 --file kioslaverc --group "Proxy Settings" --key httpsProxy "http://$https_host $https_port"
    kwriteconfig5 --file kioslaverc --group "Proxy Settings" --key ftpProxy "ftp://$ftp_host $ftp_port"
    if [[ "$socks_host" != "" ]]; then
        kwriteconfig5 --file kioslaverc --group "Proxy Settings" --key socksProxy "socks://$socks_host $socks_port"
    else
        kwriteconfig5 --file kioslaverc --group "Proxy Settings" --key socksProxy ""
    fi
    if [[ "$no_proxy" != "" ]]; then
        kwriteconfig5 --file kioslaverc --group "Proxy Settings" --key NoProxyFor "$no_proxy"
    else
        kwriteconfig5 --file kioslaverc --group "Proxy Settings" --key NoProxyFor ""
    fi

}


which kwriteconfig5 &> /dev/null
if [ "$?" != 0 ]; then
    exit
fi

if [ "$#" = 0 ]; then
    exit
fi

which kreadconfig5 &> /dev/null
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
