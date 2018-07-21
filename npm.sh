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
# plugin to set "npm" proxy settings for ProxyMan
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
	echo -e "\e[1m NPM proxy settings \e[0m"
	echo -e "\e[36m HTTP  Proxy \e[0m" $(npm config get proxy)
	echo -e "\e[36m HTTPS Proxy \e[0m" $(npm config get https-proxy)
}

unset_proxy() {
	npm config rm proxy
	npm config rm https-proxy
}

set_proxy() {
	# notice http (without `s`) in `https`, issue #41
	if [ "$4" = "y" ]; then
		var="$5:$6@"
	fi
	if [ "$3" = "y" ]; then
		newvar="://$var$1:$2"
		npm config set proxy "http$newvar"
		npm config set https-proxy "http$newvar"
	elif [ "$3" = "n" ]; then
		npm config set proxy "http://$var$1:$2"
		npm config set https-proxy "http://$var$7:$8"
	fi
}


npm_available="$(which npm)"
if [ "$npm_available" = "" ]; then
	exit
fi

if [ "$#" = 0 ]; then
	exit
fi

if [ "$1" = "unset" ]; then
	# that's what is needed
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
