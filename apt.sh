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
# plugin to set "apt" proxy settings for ProxyMan
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

fix_new_line() {
    if [[ $(tail -c 1 "$1" | wc --lines ) = 0 ]]; then
        echo >> "$1"
    fi
}

list_proxy() {
	# inefficient way as the file is read twice.. think of some better way
	echo
	echo -e "\e[1m APT proxy settings \e[0m"
	lines="$(cat /etc/apt/apt.conf | grep proxy -i | wc -l)"
	if [ "$lines" -gt 0 ]; then
		cat /etc/apt/apt.conf | grep proxy -i | sed -e "s/Acquire//g" -e "s/\:\:/\ /g" -e "s/\;//g"
	else
		echo -e "\e[36m None \e[0m"
	fi
}

unset_proxy() {
	if [ ! -e "/etc/apt/apt.conf" ]; then
		return
	fi
	if [ "$(cat /etc/apt/apt.conf | grep proxy -i | wc -l)" -gt 0 ]; then
		sed "/Proxy/d" -i /etc/apt/apt.conf
	fi
}

set_proxy() {
	if [ ! -e "/etc/apt/apt.conf" ]; then
		touch "/etc/apt/apt.conf"
	fi
	var=
	if [ "$4" = "y" ]; then
		var="$5:$6@"
	fi
	echo -n "" > apt_config.tmp
	if [ "$3" = "y" ]; then
		newvar="://$var$1:$2"
		echo "Acquire::Http::Proxy \"http$newvar\";" >> apt_config.tmp
		echo "Acquire::Https::Proxy \"http$newvar\";" >> apt_config.tmp
		echo "Acquire::Ftp::Proxy \"ftp$newvar\";" >> apt_config.tmp

    fix_new_line "/etc/apt/apt.conf"
		cat apt_config.tmp | tee -a /etc/apt/apt.conf > /dev/null
		rm apt_config.tmp
		return

	elif [ "$3" = "n" ]; then
		echo "Acquire::Http::Proxy \"http://$var$1:$2\";" >> apt_config.tmp
		echo "Acquire::Https::Proxy \"http://$var$7:$8\";" >> apt_config.tmp
		echo "Acquire::Ftp::Proxy \"ftp://$var$9:$10\";" >> apt_config.tmp

		cat apt_config.tmp | tee -a /etc/apt/apt.conf > /dev/null
		rm apt_config.tmp
		return
	fi
}


apt_available="$(which apt)"
if [ "$apt_available" = "" ]; then
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
