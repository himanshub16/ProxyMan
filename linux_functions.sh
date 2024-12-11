#!/bin/bash
#
# If you have found some issues, or some feature request :
# Raise them here : https://github.com/himanshub16/ProxyMan/issues
# Author : Himanshu Shekhar (@himanshub16)
#

# This is the script that provides main script functions for Linux.

function _do_it_for_selection() {
    local what_to_do="$1"
    for t in "${targets[@]}"
    do
        case "$t" in
            # THIS stmt WILL CAUSE INFINITE RECURSION. DO NOT USE THIS.
            # COMMENTED FOR WARNING
            # 1) _do_it_for_all "$what_to_do"
            #    ;;
            2) bash "bash-zsh-fish.sh" "$what_to_do"
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
}

function _do_it_for_all() {
    # Argument
    # $1 : what to do (set/unset/list)

    local what_to_do="$1"
    if [[ -z "$targets" || "$targets" = "1" ]]; then
        bash "bash-zsh-fish.sh" "$what_to_do"
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
        _do_it_for_selection "$what_to_do"
    fi
}

function prompt_for_proxy_targets() {
    echo "${bold}${blue} Select targets to modify ${normal}"

    echo "|${bold}${red} 1 ${normal}| All of them ... Don't bother me"
    echo "|${bold}${red} 2 ${normal}| Terminal (bash/zsh/fish for current user)  "
    echo "|${bold}${red} 3 ${normal}| /etc/environment"
    echo "|${bold}${red} 4 ${normal}| apt/dnf (Package manager)"
    echo "|${bold}${red} 5 ${normal}| Desktop settings (GNOME/Ubuntu/KDE)"
    echo "|${bold}${red} 6 ${normal}| npm & yarn"
    echo "|${bold}${red} 7 ${normal}| Dropbox"
    echo "|${bold}${red} 8 ${normal}| Git"
    echo "|${bold}${red} 9 ${normal}| Docker"
    echo
    echo "Separate multiple choices with space"
    echo -n "${bold} ? ${normal}" ; read targets
    export targets=(`echo ${targets}`)
}