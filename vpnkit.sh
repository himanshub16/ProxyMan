#!/bin/bash
# plugin to set "wget" proxy settings for ProxyMan
# privileges has to be set by the process which starts this script


list_proxy() {
    echo
}

unset_proxy() {
    echo
}

set_proxy() {
    wsl.exe -d wsl-vpnkit service wsl-vpnkit start
    if [ $? -eq 0 ]; then
        echo "${blue}wsl-vpnkit started ${normal}"
    else
        echo "${blue}wsl-vpnkit not found ${normal}"
    fi
}



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
