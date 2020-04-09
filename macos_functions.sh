#!/bin/bash
#
# If you have found some issues, or some feature request :
# Raise them here : https://github.com/himanshub16/ProxyMan/issues
# Author : Benjamin Gericke (@deg0nz)
#

# This is the script that provides main script functions for macOS.

function _do_it_for_selection() {
    local what_to_do="$1"
    for t in ${targets[@]}
    do
        case "$t" in
            # THIS stmt WILL CAUSE INFINITE RECURSION. DO NOT USE THIS.
            # COMMENTED FOR WARNING
            # 1) _do_it_for_all "$what_to_do"
            #    ;;
            2) bash "networksetup.sh" "$what_to_do"
                ;;
            3) bash "bash-zsh-fish.sh" "$what_to_do"
                ;;
            4) bash "npm.sh" "$what_to_do"
                ;;
            5) bash "git.sh" "$what_to_do"
                ;;
            *) ;;
        esac
    done
}

function _do_it_for_all() {
    # Argument
    # $1 : what to do (set/unset/list)

    local what_to_do="$1"
    if [[ -z "$targets" || "$targets" = "1" ]]; then

        bash "bash-zsh-fish.sh" "$what_to_do"
        bash "networksetup.sh" "$what_to_do"
        bash "npm.sh" "$what_to_do"
        bash "git.sh" "$what_to_do"

    else
        _do_it_for_selection "$what_to_do"
    fi
}

function prompt_for_proxy_targets() {
    echo "${bold}${blue} Select targets to modify ${normal}"

    echo "|${bold}${red} 1 ${normal}| All of them ... Don't bother me"
    echo "|${bold}${red} 2 ${normal}| System-wide settings (networksetup)"
    echo "|${bold}${red} 3 ${normal}| Terminal (bash/zsh/fish for current user) "
    echo "|${bold}${red} 4 ${normal}| npm & yarn"
    echo "|${bold}${red} 5 ${normal}| Git"
    echo
    echo "Separate multiple choices with space"
    echo -n "${bold} ? ${normal}" ; read targets
    export targets=(`echo ${targets}`)
}