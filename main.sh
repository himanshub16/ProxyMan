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


function _do_it_for_all() {
    # Argument
    # $1 : what to do (set/unset/list)

    local what_to_do="$1"
    if [[ -z "$targets" || "$targets" = "1" ]]; then
        bash "bash-zsh.sh" "$what_to_do"
	# avoiding /etc/environment in all because it requires logout after unset
	# bashrc / zshrc is sufficient, and sudo -E might suffice
	if [[ "$what_to_do" = "list" ]]; then
            sudo -E bash "environment.sh" "$what_to_do"
        fi
        bash "gsettings.sh" "$what_to_do"
        bash "kde5.sh" "$what_to_do"
        bash "npm.sh" "$what_to_do"
        bash "dropbox.sh" "$what_to_do"
        bash "git.sh" "$what_to_do"

        # isn't required, but still checked to avoid sudo in main all the time
        SUDO_CMDS="apt dnf docker"
        for cmd in $SUDO_CMDS; do
            command -v $cmd > /dev/null && sudo -E bash "${cmd}.sh" "$what_to_do" || :
        done
    else
        for t in "${targets[@]}"
        do
            case "$t" in
                # THIS stmt WILL CAUSE INFINITE RECURSION. DO NOT USE THIS.
                # COMMENTED FOR WARNING
                # 1) _do_it_for_all "$what_to_do"
                #    ;;
                2) bash "bash-zsh.sh" "$what_to_do"
                   ;;
                3) sudo -E bash "environment.sh" "$what_to_do"
                   ;;
                4) sudo -E bash "apt.sh" "$what_to_do"
                   sudo -E bash "dnf.sh" "$what_to_do"
                   ;;
                5) bash "gsettings.sh" "$what_to_do"
                   bash "kde5.sh" "$what_to_do"
                   ;;
                6) bash "npm.sh" "$what_to_do"
                   ;;
                7) bash "dropbox.sh" "$what_to_do"
                   ;;
                8) bash "git.sh" "$what_to_do"
                   ;;
                9) sudo -E bash "docker.sh" "$what_to_do"
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

function prompt_for_proxy_targets() {
    echo "${bold}${blue} Select targets to modify ${normal}"

    echo "|${bold}${red} 1 ${normal}| All of them ... Don't bother me"
    echo "|${bold}${red} 2 ${normal}| Terminal / bash / zsh (current user) "
    echo "|${bold}${red} 3 ${normal}| /etc/environment"
    echo "|${bold}${red} 4 ${normal}| apt/dnf (Package manager)"
    echo "|${bold}${red} 5 ${normal}| Desktop settings (GNOME/Ubuntu/KDE)"
    echo "|${bold}${red} 6 ${normal}| npm & yarn"
    echo "|${bold}${red} 7 ${normal}| Dropbox"
    echo "|${bold}${red} 8 ${normal}| Git"
    echo "|${bold}${red} 9 ${normal}| Docker"
    echo
    echo "Separate multiple choices with space"
    echo -ne "\e[5m ? \e[0m" ; read targets
    export targets=(`echo ${targets}`)
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
