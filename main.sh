#!/bin/bash
#
# If you have found some issues, or some feature request :
# Raise them here : https://github.com/himanshub16/ProxyMan/issues
# Author : Himanshu Shekhar (@himanshub16)
# here your code starts

# This is the main script which calls other respective scripts.
# In case of doubts regarding how to use, refer the README.md file.

function _do_it_for_all() {
    # Argument
    # $1 : what to do

    local what_to_do="$1"
    if [ -z "$target" ]; then
        bash "bash.sh" "$what_to_do"
        sudo -E bash "environment.sh" "$what_to_do"
        sudo -E bash "apt.sh" "$what_to_do"
        sudo -E bash "dnf.sh" "$what_to_do"
        bash "gsettings.sh" "$what_to_do"
        bash "npm.sh" "$what_to_do"
        bash "dropbox.sh" "$what_to_do"
        bash "git.sh" "$what_to_do"
    else
        for t in "${targets[@]}"
        do
            case "$t" in
                1) _do_it_for_all "$what_to_do"
                   ;;
                2) bash "bash.sh" "$what_to_do"
                   ;;
                3) sudo -E bash "environment.sh" "$what_to_do"
                   ;;
                4) sudo -E bash "apt.sh" "$what_to_do"
                   sudo -E bash "dnf.sh" "$what_to_do"
                   ;;
                5) bash "Desktop/gsettings" "$what_to_do"
                   ;;
                6) bash "npm & yarn" "$what_to_do"
                   ;;
                7) bash "dropbox.sh" "$what_to_do"
                   ;;
                8) bash "git.sh" "$what_to_do"
                   ;;
                *) ;;
            esac
        done

    fi
}

function _dump_it_all() {
    echo "HTTP  > $http_host $http_port"
    echo "HTTPS > $https_host $https_port"
    echo "FTP   > $ftp_host $ftp_port"
    echo "Use auth > $use_auth $username $password"
    echo "Use same > $use_same"
    echo "Config > $config_name $action"
    echo "Targets > ${targets[@]}"
}

function show_current_settings() {
    echo "Someone wants to list all"
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
    echo -n " Use same for HTTPS and FTP (y/n)? "; read use_same
    echo -n " Use auth - userid/password (y/n)? "; read use_auth

    if [[ "$use_auth" = "y" || "$use_auth" = "Y" ]]; then
        read -p " Enter username                 : " username
        echo -n " Enter password (use %40 for @) : " ; read -s password
        echo
    fi

    if [[ "$use_same" = "y" || "$use_same" = "Y" ]]; then
        https_host=$http_host
        ftp_host=$http_host
        https_port=$http_port
        ftp_port=$http_port
        rsync_host=$http_host
        rsync_port=$https_port
    else
        echo -n " HTTPS Proxy ${bold} Host ${normal}"; read https_host
        echo -n " HTTPS Proxy ${bold} Port ${normal}"; read https_port
        echo -n " FTP Proxy ${bold} Host ${normal}"; read ftp_host
        echo -n " FTP Proxy ${bold} Port ${normal}"; read ftp_port
    fi

    echo -n "Save profile for later use (y/n)? "; read save_for_reuse
    if [[ "$save_for_reuse" = "y" || "$save_for_reuse" = "Y" ]]; then
        read -p " Enter profile name  : " config_name
    fi

    echo
}

function prompt_for_proxy_targets() {
    echo "${bold}${blue} Select targets to modify ${normal}"

    echo "|${bold}${red} 1 ${normal}| All of them ... Don't bother me"
    echo "|${bold}${red} 2 ${normal}| Terminal / Bash (current user) "
    echo "|${bold}${red} 3 ${normal}| /etc/environment"
    echo "|${bold}${red} 4 ${normal}| apt/dnf (Package manager)"
    echo "|${bold}${red} 5 ${normal}| Desktop settings (GNOME/Ubuntu)"
    echo "|${bold}${red} 6 ${normal}| npm & yarn"
    echo "|${bold}${red} 7 ${normal}| Dropbox"
    echo "|${bold}${red} 8 ${normal}| Git"
    echo
    echo "Separate multiple choices with space"
    echo -ne "\e[5m ? \e[0m" ; read -a targets
}

function main() {
    source "./variables.sh"
    source "./configs.sh"

    case "$1" in
        "configs"  ) list_configs
                     ;;
        "load"     ) echo "Loading profile : ${blue} $2 ${normal}"
                     load_config "$2"
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
_dump_it_all
