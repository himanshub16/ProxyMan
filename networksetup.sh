#!/bin/bash
#
# If you have found some issues, or some feature request :
# Raise them here : https://github.com/himanshub16/ProxyMan/issues
# Author : Benjamin Gericke (@deg0nz)
#

# This is the script that provides functions for macOS's networksetup tool.

function _prompt_networkservices_targets() {
    echo "${bold}${blue} Select network interfaces to modify ${normal}"

    echo "|${bold}${red} 1 ${normal}| All of them ... Don't bother me"
    local IFS=$'\n'
    local counter=2
    for line in $(networksetup -listallnetworkservices); do
        # TODO: Handle disabled services
        if [[ "$line" == "An asterisk (*) denotes that a network service is disabled." ]]; then
            continue
        fi
        echo "|${bold}${red} ${counter} ${normal}| ${line} "
        # We write the array from 0, although 1 is "all devices"
        # loop for selected services must be adjusted
        arraypos="(($counter-2))"
        networkservices_array[$arraypos]="$line"
        ((counter++))
    done
    echo
    echo "Separate multiple choices with space"
    echo -n "${bold} ? ${normal}" ; read targets_networkservices
    export targets_networkservices=(`echo ${targets_networkservices}`)
}

function _set_proxy_for_networkservice() {
    local networkservice="$1"
    # Parameters: [-setwebproxy networkservice domain portnumber authenticated username password]
    if [[ "$use_auth" = "y" ]]; then
        networksetup -setwebproxy "$networkservice" "$http_host" "$http_port" on "$username" "$password"
        networksetup -setsecurewebproxy "$networkservice" "$https_host" "$https_port" on "$username" "$password"
        networksetup -setftpproxy "$networkservice" "$http_host" "$http_port" on "$username" "$password"
    else
        networksetup -setwebproxy "$networkservice" "$http_host" "$http_port" off
        networksetup -setsecurewebproxy "$networkservice" "$https_host" "$https_port" off
        networksetup -setftpproxy "$networkservice" "$http_host" "$http_port" off
    fi

    networksetup -setproxybypassdomains "$networkservice" "$no_proxy"
}

function _unset_proxy_for_networkservice() {
    local networkservice="$1"

    networksetup -setwebproxystate "$networkservice" off
    networksetup -setsecurewebproxystate "$networkservice" off
    networksetup -setftpproxystate "$networkservice" off
    networksetup -setproxyautodiscovery "$networkservice" off
}

function list_proxy() {
    # TODO
    echo "Listing proxies for system-wide settings on macOS is not yet implemented."
    echo "Please look into System Preferences -> Network -> <Networkdevice> -> Advanced -> Proxies for now."
}

function unset_proxy() {
    echo "Additional information for ${bold}unsetting${normal} system-wide proxy is needed."

    _prompt_networkservices_targets

    if [[ -z "$targets_networkservices" || "$targets_networkservices" = "1" ]]; then
        # Unset for all services
        local IFS=$'\n'
        for networkservice in ${networkservices_array[*]}; do
            _unset_proxy_for_networkservice "$networkservice"
        done
    else
        # Unset for selection
        for arrayindex in ${targets_networkservices[@]}; do
            # We need to correct the index, because 1 is "all devices", so all the indexes are increased by 1
            corrected_index="(($arrayindex-2))"
            _unset_proxy_for_networkservice "${networkservices_array[$corrected_index]}"
        done
    fi    
}

function set_proxy() {
    echo "Additional information for ${bold}setting${normal} system-wide proxy is needed."

    _prompt_networkservices_targets
        
    if [[ -z "$targets_networkservices" || "$targets_networkservices" = "1" ]]; then
        # Set for all services
        local IFS=$'\n'
        for networkservice in ${networkservices_array[*]}; do
            _set_proxy_for_networkservice "$networkservice"
        done
    else
        # Set for selection of services
        for arrayindex in ${targets_networkservices[@]}; do
            # We need to correct the index, because 1 is "all devices", so all the indexes are increased by 1
            corrected_index="(($arrayindex-2))"
            _set_proxy_for_networkservice "${networkservices_array[$corrected_index]}"
        done
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