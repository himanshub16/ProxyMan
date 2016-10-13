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

# here your code starts 

# privileges has to be set by the process which starts this script

# toggle_proxy() {
# 	if [ "$(cat $HOME/.bashrc | grep proxy -i | wc -l)" -gt 0 ]; then
# 		sed -e "/proxy/ s/#*//" -i $HOME/.bashrc
# 	else
# 		sed -e "/proxy/ s/^#*/#/" -i $HOME/.bashrc
# 	fi
# }

list_proxy() {
	echo 
	echo -e "\e[1m Bash proxy settings \e[0m"
	lines="$(cat $HOME/.bashrc | grep proxy | wc -l)"
	if [ "$lines" -gt 0 ]; then
		cat $HOME/.bashrc | grep proxy | sed "s/\=/\ /g"
	else
		echo -e "\e[36m None \e[0m"
	fi
}

unset_proxy() {
	if [ ! -e "$HOME/.bashrc" ]; then
		return 
	fi
	sed -i "/proxy\=/d" $HOME/.bashrc
}

set_proxy() {
	if [ ! -e "$HOME/.bashrc" ]; then
		touch "$HOME/.bashrc"
	fi

	var=
	if [ "$4" = "y" ]; then
		var="$5:$6@"
	fi
	
	echo -n "" > bash_config.tmp
	if [ "$3" = "y" ]; then
		newvar="://$var$1:$2"
		echo "http_proxy=\"http$newvar\"" >> bash_config.tmp
		echo "https_proxy=\"https$newvar\"" >> bash_config.tmp
		echo "ftp_proxy=\"ftp$newvar\"" >> bash_config.tmp

		cat bash_config.tmp | tee -a $HOME/.bashrc > /dev/null
		rm bash_config.tmp
		return 

	elif [ "$3" = "n" ]; then
		echo "http_proxy=\"http://$var$1:$2\"" >> bash_config.tmp
		echo "https_proxy=\"https://$var$7:$8\"" >> bash_config.tmp
		echo "ftp_proxy=\"ftp://$var$9:$10\"" >> bash_config.tmp

		cat bash_config.tmp | tee -a $HOME/.bashrc > /dev/null
		rm bash_config.tmp
		return
	fi
}

echo "I am bash.sh"
echo $#
echo $@

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
set_proxy $1 $2 $3 $4 $5 $6 $7 $8 $9 $10 
source "$HOME/.bashrc"
