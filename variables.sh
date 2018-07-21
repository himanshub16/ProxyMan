#!/bin/bash
#
# If you have found some issues, or some feature request :
# Raise them here : https://github.com/himanshub16/ProxyMan/issues
#
# Author : Himanshu Shekhar (@himanshub16)
# GitHub : "https://github.com/himanshub16/ProxyMan/"
#
# This file lists the variables required across all scripts.
# Credits : https://unix.stackexchange.com/a/10065/147140

# check if stdout is a terminal
if test -t 1; then

    # see if it supports colors
    export ncolors=$(tput colors)

    if test -n "$ncolors" && test $ncolors -ge 8; then
        export bold="$(tput bold)"
        export underline="$(tput smul)"
        export standout="$(tput smso)"
        export normal="$(tput sgr0)"
        export black="$(tput setaf 0)"
        export red="$(tput setaf 1)"
        export green="$(tput setaf 2)"
        export yellow="$(tput setaf 3)"
        export blue="$(tput setaf 4)"
        export magenta="$(tput setaf 5)"
        export cyan="$(tput setaf 6)"
        export white="$(tput setaf 7)"
        export star="🌟"
    fi
fi

export config_dir="$HOME/.config/proxyman"
export default_config="default"
export SHELLRC="$HOME/.bashrc"

case "$SHELL" in
    "$(which bash)") SHELLRC="$HOME/.bashrc"
                     ;;
    "$(which zsh)") SHELLRC="$HOME/.zshrc"
                    ;;
esac

export http_host=""  http_port=""
export https_host="" https_port=""
export ftp_host=""   ftp_port=""
export use_auth=""   use_same=""
export username=""   password=""
export save_for_reuse=""
export config_name=""
export action=""
export targets=""


# This help text contains examples for each command
HELP_TEXT="ProxyMan lets you set system-wide proxy settings.
 ${star}${blue} https://github.com/himanshub16/ProxyMan ${normal}

Usage: proxyman [command]

Commands:
${bold} set     ${normal} \t  set proxy settings
  > proxyman set
${bold} unset   ${normal} \t  unset proxy settings
  > proxyman unset
${bold} list    ${normal} \t  list current settings
  > proxyman list
${bold} configs ${normal} \t  lists available configs
  > proxyman configs
${bold} load    ${normal} \t  load a profile
  > proxyman load 'profile_name'
${bold} delete  ${normal} \t  delete a profile
  > proxyman delete 'profile_name'
${bold} help    ${normal} \t  show this help
  > proxyman help

Allowed options: set, unset, list, configs, load, delete, help
"

# This help text contains each command, but without examples.
HELP_TEXT="ProxyMan lets you set system-wide proxy settings.
 ${star}${blue} https://github.com/himanshub16/ProxyMan ${normal}

Usage: proxyman [command]

Commands:
${bold} set     ${normal} \t  set proxy settings
${bold} unset   ${normal} \t  unset proxy settings
${bold} list    ${normal} \t  list current settings
${bold} configs ${normal} \t  lists available configs
${bold} load    ${normal} \t  load a profile
${bold} delete  ${normal} \t  delete a profile
${bold} help    ${normal} \t  show this help

Allowed options: set, unset, list, configs, load, delete, help
"
