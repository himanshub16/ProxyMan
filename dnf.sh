#!/bin/bash
#
# If you have found some issues, or some feature request :
# Raise them here : https://github.com/himanshub16/ProxyMan/issues
#
# expected command line arguments
#
# Created by "Himanshu Shekhar"
# For ProxyMan "https://github.com/himanshub16/ProxyMan/"
#
# convention to be followed across extension made / to be made
# include this comment section in all plugins to avoid confusions while coding
#
# plugin to set "dnf" proxy settings for ProxyMan
#
# The arguments are given in bash syntax to maintain universality and ease
# across all UNIX systems.
# Your language can use it's respective syntax for
# arguments and comments.
# If you don't need any particular proxy settings, ignore the variables.

# $#  : number of arguments
# $1  : http_host
# if this argument is "unset", proxy settings should be unset.

# $2  : http_port
# $3  : use_same ; "y" or "n"
# $4  : use_auth
# $5  : username ; send empty string if not available
# $6  : password ; send empty string if not available
#
# if use same is yes, then no further arguments are considered
#
# $7  : https_host
# $8  : https_port
# $9  : ftp_host
# $10 : ftp_port

# here your code starts

# privileges has to be set by the process which starts this script

list_proxy() {
	echo
	echo -e "\e[1m DNF proxy settings (raw) \e[0m"
	lines="$(cat /etc/dnf/dnf.conf | grep proxy -i | wc -l)"
	if [ "$lines" -gt 0 ]; then
		cat /etc/dnf/dnf.conf | grep proxy -i | sed -e "s/\=/\ /g"
	else
		echo -e "\e[36m None \e[0m"
	fi
}

unset_proxy() {
	if [ ! -e "/etc/dnf/dnf.conf" ]; then
		return
	fi
	if [ "$(cat /etc/dnf/dnf.conf | grep proxy -i | wc -l)" -gt 0 ]; then
		sed "/proxy/d" -i /etc/dnf/dnf.conf
	fi
}

set_proxy() {
	if [ ! -e "/etc/dnf/dnf.conf" ]; then
		touch "/etc/dnf/dnf.conf"
	fi

	echo -n "" > dnf_config.tmp
	echo "proxy=http://$1:$2" > dnf_config.tmp

	if [ "$4" = "y" ]; then
		echo "proxy_username=$5" >> dnf_config.tmp
		echo "proxy_password=$6" >> dnf_config.tmp
	fi
	cat dnf_config.tmp | tee -a /etc/dnf/dnf.conf > /dev/null
	rm dnf_config.tmp
	return
}


dnf_available="$(which dnf)"
if [ "$dnf_available" = "" ]; then
	exit
fi


if [ "$#" = 0 ]; then
	exit
fi

if [ "$1" = "unset" ]; then
	unset_proxy
	exit
	# toggle proxy had issues with commenting and uncommenting
	# dropping the feature currently
elif [ "$1" = "list" ]; then
	list_proxy
	exit
fi

unset_proxy
set_proxy $1 $2 $3 $4 $5 $6 $7 $8 $9 $10
