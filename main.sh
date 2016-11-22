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
 
# here your code starts

# This is the main script which calls other respective scripts.
# In case of doubts regarding how to use, refer the README.md file.
clear
if [ "$1" = "list" ]; then
	echo "Someone wants to list all"
	bash "bash.sh" "list"
	sudo bash "environment.sh" "list"
	sudo bash "apt.sh" "list"
	sudo bash "dnf.sh" "list"
	bash "gsettings.sh" "list"
	bash "npm.sh" "list"
	bash "dropbox.sh" "list"
	bahs "git_config.sh" "list"
	exit
fi

use_same=""
use_auth=""
echo -e "
\e[1m\e[33mProxyMan
=========\e[0m
Tool to set up system wide proxy settings on Linux. 
\e[2m\e[33m🌟\e[0m\e[3m Star it \e[0m : \e[4m\e[34m https://github.com/himanshub16/ProxyMan \e[0m

 \e[4mThe following options are available : \e[0m
\e[1m set \e[0m    : \e[2m Set proxy settings \e[0m
\e[1m unset \e[0m  : \e[2m Unset proxy settings \e[0m
\e[1m list \e[0m   : \e[2m List current settings \e[0m

"

read -p " Enter your choice : " choice

if [ "$choice" = "set" ]; then

	# default values
	http_host=""
	http_port=""
	use_same="no"
	https_host=""
	https_port=""
	ftp_host=""
	ftp_port=""
	username=""
	password=""

	echo
	echo -e " \e[4mEnter details \e[0m : \e[2m\e[3m (leave blank if you don't to use any proxy settings) \e[0m"
	echo
	echo -ne "\e[36m HTTP Proxy host \e[0m"; read http_host
	echo -ne "\e[32m HTTP Proxy port \e[0m"; read http_port
	echo -ne "\e[0m Use same for HTTPS and FTP (y/n) ? \e[0m"; read use_same
	echo -ne "\e[0m Use authentication (y/n) ? \e[0m        "; read use_auth

	if [[ "$use_auth" = "y" || "$use_auth" = "Y" ]]; then
		read -p " Enter username                 : " username
		echo -n " Enter password (use %40 for @) : " ; read -s password
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
	fi

fi

echo
echo -e " \e[0m\e[4m\e[33mEnter targets where you want to modify settings : \e[0m"
echo -e " |\e[36m 1 \e[0m| All of them ... Don't bother me"
echo -e " |\e[36m 2 \e[0m| Terminal / Bash (current user) "
echo -e " |\e[36m 3 \e[0m| Environment variables (/etc/environment)"
echo -e " |\e[36m 4 \e[0m| apt/dnf (package manager)"
echo -e " |\e[36m 5 \e[0m| Desktop settings (GNOME/Ubuntu)"
echo -e " |\e[36m 6 \e[0m| npm"
echo -e " |\e[36m 7 \e[0m| Dropbox"
echo -e " |\e[36m 8 \e[0m| Git"
echo

echo -e " Enter your choices (\e[3m\e[2m separate multiple choices by a space \e[0m ) "
echo -ne "\e[5m ? \e[0m" ; read -a targets

echo

case $choice in 
	"set")	
		args=("$http_host" "$http_port" "$use_same" "$use_auth" "$username" "$password" "$https_host" "$https_port" "$ftp_host" "$ftp_port" )
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
					bash "dropbox.sh" "${args[@]}"
					bash "git_config.sh" "${args[0]}"
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
				7)	bash "dropbox.sh" "${args[@]}"
					;;
				8)	bash "git_config" "${args[@]}"
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
					bash "dropbox.sh" "unset"
					bash "git_config.sh" "unset"
					;;
				2)
					bash "bash.sh" "unset"
					;;
				3)	sudo bash "environment.sh" "unset"
					;;
				4)	sudo bash "apt.sh" "unset"
					sudo bash "dnf.sh" "unset"
					;;
				5)	bash "gsettings.sh" "unset"
					;;
				6)	bash "npm.sh" "unset"
					;;
				7)	bash "dropbox.sh" "unset"
					;;
				8) 	bash "git_config.sh" "unset"
					;;
				*)	;;
			esac
		done
		;;

	"list")
		echo -ne "\e[1m \e[31m This will list all your passwords. Continue ? (y/n) \e[0m"; read 
		if [[ "$REPLY" = "y" || "$REPLY" = "Y" ]]; then
			for i in "${targets[@]}"
			do
				case $i in
					1)	echo "Someone wants to list all"
						bash "bash.sh" "list"
						sudo bash "environment.sh" "list"
						sudo bash "apt.sh" "list"
						sudo bash "dnf.sh" "list"
						bash "gsettings.sh" "list"
						bash "npm.sh" "list"
						bash "dropbox.sh" "list"
						;;
					2)
						bash "bash.sh" "list"
						;;
					3)	sudo bash "environment.sh" "list"
						;;
					4)	sudo bash "apt.sh" "list"
						sudo bash "dnf.sh" "list"
						;;
					5)	bash "gsettings.sh" "list"
						;;
					6)	bash "npm.sh" "list"
						;;
					7) 	bash "dropbox.sh" "list"
						;;
					7) 	bash "git_config.sh" "list"
						;;
					*)	;;
				esac
			done
			
		fi
		;;

	*)	
		;;
esac

echo
echo -e "\e[1m\e[36mDone!\e[0m \e[2mThanks for using :)\e[0m"
