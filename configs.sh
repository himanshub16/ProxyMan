#!/bin/bash
#
# If you have found some issues, or some feature request :
# Raise them here : https://github.com/himanshub16/ProxyMan/issues
# Author : Himanshu Shekhar (@himanshub16)
#
# This file contains the functions (CRUD) required for config managements.
# * list_configs()
# * load_config(profile_name)
# * load_default_config
# * save_config(profile_name)
# * delete_config(profile_name)
# In case of doubts regarding how to use, refer the README.md file.
#
# Required: `variables.sh` has been sourced.

function list_configs() {
    # Arguments : None

    echo "${bold}${cyan}Here are available configs!${normal}"
    ls -1 $config_dir
}

function load_config() {
    # Arguments :
    # $1 -> profile_name

    local profile_path="$config_dir/$1"
    if [ ! -f "$profile_path" ]; then
        echo "${bold}${red}Missing config file at $profile_path. ${normal}"
        exit
    fi

    export http_host=`grep http_host\=   -i $profile_path | cut -d= -f2`
    export http_port=`grep http_port\=   -i $profile_path | cut -d= -f2`
    export https_host=`grep https_host\= -i $profile_path | cut -d= -f2`
    export https_port=`grep https_port\= -i $profile_path | cut -d= -f2`
    export ftp_host=`grep ftp_host\=     -i $profile_path | cut -d= -f2`
    export ftp_port=`grep ftp_port\=     -i $profile_path | cut -d= -f2`
    export rsync_host=$http_host rsync_port=$http_port
    export use_same=`grep use_same\=     -i $profile_path | cut -d= -f2`
    export use_auth=`grep use_auth\=     -i $profile_path | cut -d= -f2`
    export username=`grep username\=     -i $profile_path | cut -d= -f2`
    export password=`grep password\=     -i $profile_path | cut -d= -f2`
    export no_proxy=`grep no_proxy\=     -i $profile_path | cut -d= -f2`
}

function load_default_config() {
    # Arguments : None

    load_config "$default_config"
}

function save_config() {
    # Arguments :
    # $1 -> profile_name
    # Rest variables are picked from environment variables.

    local profile_name="$1"
    local profile_path="$config_dir/$profile_name"
    mkdir -p "$config_dir"

    echo "# Proxyman profile : $profile_name

# Example: 127.0.0.1
http_host=$http_host

# Example: 8080
http_port=$http_port

# Use same values for https and ftp
use_same=$use_same

# use auth is 'y' or 'n', and provide username and password
use_auth=$use_auth
username=$username
password=$password

# If use same is 'y', no need of these
https_host=$https_host
https_port=$https_port
ftp_host=$ftp_host
ftp_port=$ftp_port

# URLs that should be excluded from proxying
no_proxy=$no_proxy
" > $profile_path

    echo "${green}Saved to $profile_path.${normal}"
}

function delete_config() {
    # Arguments :
    # $1 -> profile_name

    local profile_name="$1"
    local profile_path="$config_dir/$profile_name"
    if [ ! -f "$profile_path" ]; then
        echo "${red}Can't find $profile_path ${normal}."
        echo "${red}Config '$profile_name' does not exist.${normal}"
    fi

    rm -f $profile_path
}
