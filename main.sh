#!/bin/bash
#
# If you have found some issues, or some feature request : 
# Raise them here : https://github.com/himanshub16/ProxyMan/issues

# expected command line arguments 
#
# Created by "Himanshu Shekhar"
# For ProxyMan "https://github.com/himanshub16/ProxyMan/"
#
# convention to be followed across extension made / to be made
# include this comment section in all plugins to avoid confusions while coding 
#
# plugin to set "TARGET ENVIRON" proxy settings for ProxyMan
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
# $3  : use_same ; "yes" or "no"
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
# $11 : socks_host 
# $12 : socks_port 
# $13 : rsync_host ; added to support rsync ; no offence to rsync haters 
# $14 : rsync_port
 
# here your code starts

# This is the main script which calls other respective scripts.
# In case of doubts regarding how to use, refer the README.md file.
clear
use_same=""
use_auth=""
echo -e "
\e[1m\e[33mProxyMan
=========\e[0m
Tool to set up system wide proxy settings on Linux. 
\e[2m\e[33m🌟\e[0m\e[3m Star it\e[0m : \e[4m\e[34mhttps://github.com/himanshub16/ProxyMan\e[0m

\e[4mThe following options are available : \e[0m
\e[1mset\e[0m    : \e[2mSet proxy settings\e[0m
\e[1munset\e[0m  : \e[2mUnset proxy settings\e[0m

"

read -p "Enter your choice : " choice

if [ "$choice" = "set" ]; then

	# default values
	http_host=""
	http_port=""
	use_same="no"
	https_host=""
	https_port=""
	ftp_host=""
	ftp_port=""
	socks_port=""
	socks_host=""
	rsync_host=""
	rsync_port=""
	username=""
	password=""

	echo
	echo -e "\e[4mEnter details \e[0m : \e[2m\e[3m(leave blank if you don't to use any proxy settings) \e[0m"
	echo
	echo -ne "\e[36m HTTP Proxy host \e[0m"; read http_host
	echo -ne "\e[32m HTTP Proxy port \e[0m "; read http_port
	echo -ne "\e[0m Use same for HTTPS and FTP (y/n) ? \e[0m"; read use_same
	echo -ne "\e[0m Use authentication (y/n) ? \e[0m        "; read use_auth

	if [[ "$use_auth" = "y" || "$use_auth" = "Y" ]]; then
		read -p "Enter username                 : " username
		read -p "Enter password (use %40 for @) : " password
	fi

	if [[ "$use_same" = "y" || "$use_same" = "Y" ]]; then
		https_host=$http_host
		ftp_host=$http_host
		https_port=$http_port
		ftp_port=$http_port
		rsync_host=$http_host
		rsync_port=$https_port
	else
		echo -ne "\e[36m HTTPS Proxy host \e[0m " ; read https_host
		echo -ne "\e[32m HTTPS Proxy port \e[0m " ; read https_port
		echo -ne "\e[36m FTP   Proxy host \e[0m " ; read ftp_host
		echo -ne "\e[32m FTP   Proxy port \e[0m " ; read ftp_port
		echo -ne "\e[36m SOCKS Proxy host \e[0m " ; read socks_host
		echo -ne "\e[32m SOCKS Proxy port \e[0m " ; read socks_port
		echo -ne "\e[36m RSYNC Proxy host \e[0m"  ; read rsync_host
		echo -ne "\e[32m RSYNC Proxy port \e[0m"  ; read rsync_port
	fi

fi

echo
echo -e "\e[0m\e[4m\e[33mEnter targets where you want to modify settings : \e[0m"
echo -e " |\e[36m 1 \e[0m| All of them ... Don't bother me"
echo -e " |\e[36m 2 \e[0m| Terminal / Bash (current user) "
echo -e " |\e[36m 3 \e[0m| Environment variables (/etc/environment)"
echo -e " |\e[36m 4 \e[0m| apt/dnf (package manager)"
echo -e " |\e[36m 5 \e[0m| Desktop settings (GNOME/Ubuntu)"
echo -e " |\e[36m 6 \e[0m| npm"
echo

echo -e "Enter your choices (\e[3m\e[2m separate multiple choices by a space \e[0m ) "
echo -ne "\e[5m? \e[0m" ; read -a targets

echo

case $choice in 
	"set")	
		args=("$http_host" "$http_port" "$use_same" "$use_auth" "$username" "$password" "$https_host" "$https_port" "$ftp_host" "$ftp_port" "$rsync_host" "$rsync_port")
		for i in "${targets[@]}"
		do
			case $i in
				1)
					bash "bash.sh" "${args[@]}"
					sudo bash "environment.sh" "${args[@]}"
					sudo bash "apt.sh" "${args[@]}"
					sudo bash "dnf.sh" "${args[@]}"
					bash "gsettings.sh" "${args[@]}"
					bash "npm.sh" "${args[@]}"
					;;
				2)
					bash "bash.sh" "${args[@]}"
					;;
				3)	sudo bash "environment.sh" "${args[@]}"
					;;
				4)	sudo bash "apt.sh" "${args[@]}"
					sudo bash "dnf.sh" "${args[@]}"
					;;
				5)	bash "gsettings.sh" "${args[@]}"
					;;
				6)	bash "npm.sh" "${args[@]}"
					;;
				*)	;;
			esac
		done
		;;

	"unset") 
		for i in "${targets[@]}"
		do
			case $i in
				1)	echo "Someone wants to unset all"
					bash "bash.sh" "unset"
					sudo bash "environment.sh" "unset"
					sudo bash "apt.sh" "unset"
					sudo bash "dnf.sh" "unset"
					bash "gsettings.sh" "unset"
					bash "npm.sh" "unset"
					;;
				2)
					bash "bash.sh" "unset"
					;;
				3)	sudo bash "environment.sh" "unset"
					;;
				6)	sudo bash "apt.sh" "unset"
					sudo bash "dnf.sh" "unset"
					;;
				5)	bash "gsettings.sh" "unset"
					;;
				6)	bash "npm.sh" "unset"
					;;
				*)	;;
			esac
		done
		;;

	*)	
		;;
esac

echo -e "\e[1m\e[36mDone!\e[0m \e[2mThanks for using :)\e[0m"