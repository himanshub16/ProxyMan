#!/bin/bash
#
# If you have found some issues, or some feature request :
# Raise them here : https://github.com/himanshub16/ProxyMan/issues
# Author : Himanshu Shekhar (@himanshub16)
#

# This is the main script which calls other respective scripts.
# In case of doubts regarding how to use, refer the README.md file.

source "./variables.sh"
source "./configs.sh"

# Load main functions for current operating system
case $os in
    "Linux") source "./linux_functions.sh"
    ;;
    "Darwin") source "./macos_functions.sh"
    ;;
    *) echo "Operating system not supported. Exiting."
       exit 1
    ;;
esac

function _dump_it_all() {
    echo "HTTP  > $http_host $http_port"
    echo "HTTPS > $https_host $https_port"
    echo "FTP   > $ftp_host $ftp_port"
    echo "no_proxy > $no_proxy"
    echo "Use auth > $use_auth $username $password"
    echo "Use same > $use_same"
    echo "Config > $config_name $action"
    echo "Targets > ${targets[@]}"
}

function show_current_settings() {
    echo "Hmm... listing it all"
    _do_it_for_all "list"
}

function unset_all_proxy() {
    echo "${red}Unset all proxy settings${normal}"
    _do_it_for_all "unset"
}

function set_all_proxy() {
    echo "${blue}Setting proxy...${normal}"
    _do_it_for_all "set"
}

function prompt_for_proxy_values() {
    echo "${bold}${blue} Enter details to set proxy ${normal}"

    echo -n " HTTP Proxy ${bold} Host ${normal}"; read http_host
    echo -n " HTTP Proxy ${bold} Port ${normal}"; read http_port
    echo -n " Use auth - userid/password (y/n)? "; read use_auth

    if [[ "$use_auth" = "y" || "$use_auth" = "Y" ]]; then
        echo "${bold}${red} Please don't save your passwords on shared computers.${normal}"
        read -p " Enter username                 : " username
        echo -n " Enter password (use %40 for @) : " ; read -s password
        echo
    fi

    echo -n " Use same for HTTPS and FTP (y/n)? "; read use_same
    if [[ "$use_same" = "y" || "$use_same" = "Y" ]]; then
        https_host=$http_host
        ftp_host=$http_host
        https_port=$http_port
        ftp_port=$http_port
    else
        echo -n " HTTPS Proxy ${bold} Host ${normal}"; read https_host
        echo -n " HTTPS Proxy ${bold} Port ${normal}"; read https_port
        echo -n " FTP Proxy ${bold} Host ${normal}"; read ftp_host
        echo -n " FTP Proxy ${bold} Port ${normal}"; read ftp_port
    fi
    # socks_proxy is omitted, as is usually not required
    # rsync is kept same as http to reduce number of inputs in interactive mode
    # and used only in shellrc
    rsync_host=$http_host
    rsync_port=$http_port

    echo -n " No Proxy ${green} (default $no_proxy) ${normal}"; read _no_proxy
    if [[ $_no_proxy != "" ]]; then
        no_proxy=$_no_proxy
    fi

    echo -n "Save profile for later use (y/n)? "; read save_for_reuse
    if [[ "$save_for_reuse" = "y" || "$save_for_reuse" = "Y" ]]; then
        read -p " Enter profile name  : " config_name
        save_config $config_name
    fi

    echo
}

function main() {
    case "$1" in
        "configs"  ) list_configs
                     ;;
        "load"     ) echo "Loading profile : ${blue} $2 ${normal}"
                     load_config "$2"
                     _dump_it_all
                     prompt_for_proxy_targets
                     set_all_proxy
                     ;;
        "delete"   ) echo "Deleting profile : ${red} $2 ${normal}"
                     delete_config "$2"
                     ;;
        "set"      ) prompt_for_proxy_values
                     prompt_for_proxy_targets
                     set_all_proxy
                     ;;
        "unset"    ) if test -t 1; then
                        prompt_for_proxy_targets
                     fi
                     unset_all_proxy
                     ;;
        "list"     ) show_current_settings
                     ;;
        * | "help" ) echo -e "$HELP_TEXT"
                     ;;
    esac
}


main "$@"
# _dump_it_all
echo "Done"
