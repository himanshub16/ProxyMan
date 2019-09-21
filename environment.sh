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
# plugin to set proxy variables in /etc/environment for ProxyMan
# proxy settings in environment variables is applicable to all users
#
# The arguments are given in bash syntax to maintain universality and ease
# across all UNIX systems.
# Your language can use it's respective syntax for
# arguments and comments.
# If you don't need any particular proxy settings, ignore the variables.

# here your code starts

# privileges has to be set by the process which starts this script

# toggle_proxy() {
# 	if [ "$(cat /etc/environment | grep proxy -i | wc -l)" -gt 0 ]; then
# 		sed -e "/proxy/ s/#*//" -i /etc/environment
# 	else
# 		sed -e "/proxy/ s/^#*/#/" -i /etc/environment
# 	fi
# }

fix_new_line() {
	if [[ $(tail -c 1 "$1" | wc --lines ) = 0 ]]; then
		echo >> "$1"
	fi
}

list_proxy() {
	echo
	echo "${bold}Environment proxy settings : /etc/environment${normal}"
	lines="$(cat /etc/environment | grep proxy -i | wc -l)"
	if [ "$lines" -gt 0 ]; then
		cat "/etc/environment" | grep proxy -i | sed "s/\=/\ /g"
	else
		echo -e "\e[36m None \e[0m"
	fi
}

unset_proxy() {
	if [ ! -e "/etc/environment" ]; then
		return
	fi
	sed -i "/proxy\=/d" /etc/environment
	sed -i "/PROXY\=/d" /etc/environment
}

set_proxy() {
	unset_proxy

	if [ ! -e "/etc/environment" ]; then
		touch "/etc/environment"
	fi

	local stmt=""
	if [ "$use_auth" = "y" ]; then
	stmt="${username}:${password}@"
	fi

	echo -n "" > bash_config.tmp

	echo "http_proxy=\"http://${stmt}${http_host}:${http_port}\"" >> bash_config.tmp
	echo "ftp_proxy=\"ftp://${stmt}${ftp_host}:${ftp_port}\"" >> bash_config.tmp
	echo "HTTP_PROXY=\"http://${stmt}${http_host}:${http_port}\"" >> bash_config.tmp
	echo "FTP_PROXY=\"ftp://${stmt}${ftp_host}:${ftp_port}\"" >> bash_config.tmp

	if [ "$USE_HTTP_PROXY_FOR_HTTPS" = "true" ]; then
		echo "https_proxy=\"http://${stmt}${http_host}:${http_port}\"" >> bash_config.tmp
		echo "HTTPS_PROXY=\"http://${stmt}${http_host}:${http_port}\"" >> bash_config.tmp
	else
		echo "https_proxy=\"https://${stmt}${https_host}:${https_port}\"" >> bash_config.tmp
		echo "HTTPS_PROXY=\"https://${stmt}${https_host}:${https_port}\"" >> bash_config.tmp
	fi

	fix_new_line "/etc/environment"
	cat bash_config.tmp | tee -a /etc/environment > /dev/null
	rm bash_config.tmp
	return
}


if [ "$#" = 0 ]; then
	exit
fi

what_to_do=$1
case $what_to_do in
	set) set_proxy
			 ;;
	unset) unset_proxy
				 ;;
	list) list_proxy
				 ;;
	#toggle) toggle_proxy $1 $2 $3 $4 $5 $6 $7 $8 $9 $10 $11 $12
	#      ;;
	*)
				 ;;
esac
