#!/bin/bash
# plugin to set "dnf" proxy settings for ProxyMan
# privileges has to be set by the process which starts this script


list_proxy() {
    echo
    echo "${bold}Desktop proxy settings (GNOME) ${normal}"
    mode=$(gsettings get org.gnome.system.proxy | tr -d "'")
    if [ "$mode" = "none"]; then
        echo "${red}None${normal}"
        return
    fi

    echo "${bold} http ${normal}  "\
         "$(gsettings get org.gnome.system.proxy.http host) "\
         "$(gsettings get org.gnome.system.proxy.http port)"
    echo "${bold} Auth ${normal}  "\
         "$(gsettings get org.gnome.system.proxy.http authentication-user) "\
         "$(gsettings get org.gnome.system.proxy.http authentication-password)"
    echo "${bold} https ${normal} "\
         "$(gsettings get org.gnome.system.proxy.https host) "\
         "$(gsettings get org.gnome.system.proxy.https port)"
    echo "${bold} ftp ${normal}   "\
         "$(gsettings get org.gnome.system.proxy.ftp host) "\
         "$(gsettings get org.gnome.system.proxy.ftp port)"
    echo "${bold} socks ${normal} "\
         "$(gsettings get org.gnome.system.proxy.socks host) "\
         "$(gsettings get org.gnome.system.proxy.socks port)"
}

unset_proxy() {
    gsettings set org.gnome.system.proxy mode none
}

set_proxy() {
    gsettings set org.gnome.system.proxy mode manual
    gsettings set org.gnome.system.proxy.http host $http_proxy
    gsettings set org.gnome.system.proxy.http port $http_proxy
    gsettings set org.gnome.system.proxy.http authentication-user $username
    gsettings set org.gnome.system.proxy.http authentication-password $password
    gsettings set org.gnome.system.proxy.https host $https_proxy
    gsettings set org.gnome.system.proxy.https port $https_proxy
    gsettings set org.gnome.system.proxy.ftp host $ftp_proxy
    gsettings set org.gnome.system.proxy.ftp port $ftp_proxy
}


which $gsettings &> /dev/null
if [ "$#" != 0 ]; then
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
