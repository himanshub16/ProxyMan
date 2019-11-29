#!/bin/bash
# plugin to set "GNOME" proxy settings for ProxyMan
# privileges has to be set by the process which starts this script


list_proxy() {
    echo
    echo "${bold}Desktop proxy settings (GNOME) ${normal}"
    mode=$(gsettings get org.gnome.system.proxy mode | tr -d "'")
    if [ "$mode" = "none" ]; then
        echo "${red}None${normal}"
        return
    fi

    echo "${bold} http ${normal}  "\
         "$(gsettings get org.gnome.system.proxy.http host) "\
         "$(gsettings get org.gnome.system.proxy.http port)"
    echo "${bold} Auth ${normal}  "\
         "$(gsettings get org.gnome.system.proxy.http use-authentication) "\
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
    echo "${bold} no_proxy ${normal} "\
         "$(gsettings get org.gnome.system.proxy ignore-hosts) "
}

unset_proxy() {
    gsettings set org.gnome.system.proxy mode none
}

set_proxy() {
    # do quote the variables as blank variables mean nothing when not quoted and show errors
    gsettings set org.gnome.system.proxy mode "manual"
    gsettings set org.gnome.system.proxy.http host "$http_host"
    gsettings set org.gnome.system.proxy.http port "$http_port"
    gsettings set org.gnome.system.proxy.https host "$https_host"
    gsettings set org.gnome.system.proxy.https port "$https_port"
    gsettings set org.gnome.system.proxy.ftp host "$ftp_host"
    gsettings set org.gnome.system.proxy.ftp port "$ftp_port"
    gsettings set org.gnome.system.proxy.http authentication-password "$password"
    gsettings set org.gnome.system.proxy.http authentication-user "$username"

    if [ "$use_auth" = "y" ]; then
        gsettings set org.gnome.system.proxy.http use-authentication true
    else
        gsettings set org.gnome.system.proxy.http use-authentication false
    fi

    if [[ $no_proxy =~ .*,.* ]]; then
        IFS=',' read -r -a array <<< "$no_proxy"
        _no_proxy=$(printf ",'%s'" "${array[@]}")
        _no_proxy="[${_no_proxy:1}]"
        gsettings set org.gnome.system.proxy ignore-hosts "${_no_proxy}"
    elif [[ $no_proxy != "" ]]; then
            gsettings set org.gnome.system.proxy ignore-hosts "['${no_proxy}']"
    else
        gsettings set org.gnome.system.proxy ignore-hosts ""
    fi
}


which gsettings &> /dev/null
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
