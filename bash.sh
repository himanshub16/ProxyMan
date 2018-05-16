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
# plugin to set "Users's bashrc" proxy settings for ProxyMan
#
# The arguments are given in bash syntax to maintain universality and ease
# across all UNIX systems.
# Your language can use it's respective syntax for
# arguments and comments.
# If you don't need any particular proxy settings, ignore the variables.

# $#  : number of arguments
# $1  : http_host
# if this argument is "unset", proxy settings should be unset.
# if this is "toggle", toggle settings.


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
#
# but if only one argument follows
#
# $11 : no_proxy ; send empty string if not available

# here your code starts

# privileges has to be set by the process which starts this script

# toggle_proxy() {
# 	if [ "$(cat $HOME/.bashrc | grep proxy -i | wc -l)" -gt 0 ]; then
# 		sed -e "/proxy/ s/#*//" -i $HOME/.bashrc
# 	else
# 		sed -e "/proxy/ s/^#*/#/" -i $HOME/.bashrc
# 	fi
# }

fix_new_line() {
    if [[ $(tail -c 1 "$1" | wc --lines ) = 0 ]]; then
        echo >> "$1"
    fi
}

list_proxy() {
	echo
	echo -e "\e[1m Bash proxy settings \e[0m"
	lines="$(cat $HOME/.bashrc | grep proxy -i | wc -l)"
	if [ "$lines" -gt 0 ]; then
		cat $HOME/.bashrc | grep proxy -i | sed "s/\=/\ /g"
	else
		echo -e "\e[36m None \e[0m"
	fi
}

unset_proxy() {
	if [ ! -e "$HOME/.bashrc" ]; then
		return
	fi
	sed -i "/proxy\=/d" $HOME/.bashrc
	sed -i "/PROXY\=/d" $HOME/.bashrc
}

set_proxy() {
	if [ ! -e "$HOME/.bashrc" ]; then
		touch "$HOME/.bashrc"
	fi

	var=
	if [ "$4" = "y" ]; then
		var="$5:$6@"
	fi

	exc=
	if [ "$#" -eq 8 ]; then
		exc="$7"
	elif [ "$#" -eq 12 ]; then
		exc="$11"
	fi

	echo -n "" > bash_config.tmp
	if [ "$3" = "y" ]; then
		newvar="://$var$1:$2"
		echo "http_proxy=\"http$newvar\"" >> bash_config.tmp
		echo "https_proxy=\"https$newvar\"" >> bash_config.tmp
		echo "ftp_proxy=\"ftp$newvar\"" >> bash_config.tmp
		echo "HTTP_PROXY=\"http$newvar\"" >> bash_config.tmp
		echo "HTTPS_PROXY=\"https$newvar\"" >> bash_config.tmp
		echo "FTP_PROXY=\"ftp$newvar\"" >> bash_config.tmp

		if [ -n "$exc" ]; then
			echo "no_proxy=\"$exc\"" >> bash_config.tmp
			echo "NO_PROXY=\"$exc\"" >> bash_config.tmp
		fi

    fix_new_line $HOME/.bashrc
		cat bash_config.tmp | tee -a $HOME/.bashrc > /dev/null
		rm bash_config.tmp
		return

	elif [ "$3" = "n" ]; then
		echo "http_proxy=\"http://$var$1:$2\"" >> bash_config.tmp
		echo "https_proxy=\"https://$var$7:$8\"" >> bash_config.tmp
		echo "ftp_proxy=\"ftp://$var$9:$10\"" >> bash_config.tmp
		echo "HTTP_PROXY=\"http://$var$1:$2\"" >> bash_config.tmp
		echo "HTTPS_PROXY=\"https://$var$7:$8\"" >> bash_config.tmp
		echo "FTP_PROXY=\"ftp://$var$9:$10\"" >> bash_config.tmp

		if [ -n "$exc" ]; then
			echo "no_proxy=\"$exc\"" >> bash_config.tmp
			echo "NO_PROXY=\"$exc\"" >> bash_config.tmp
		fi

		cat bash_config.tmp | tee -a $HOME/.bashrc > /dev/null
		rm bash_config.tmp
		return
	fi
}

if [ "$#" = 0 ]; then
	exit
fi

if [ "$1" = "unset" ]; then
	# that's what is needed
	unset_proxy
	source "$HOME/.bashrc"
	exit
# elif [ "$1" = "toggle" ]; then
# 	toggle_proxy $1 $2 $3 $4 $5 $6 $7 $8 $9 $10 $11 $12
# 	exit
elif [ "$1" = "list" ]; then
	list_proxy
	exit
fi


unset_proxy
set_proxy $1 $2 $3 $4 $5 $6 $7 $8 $9 $10 $11
source "$HOME/.bashrc"
