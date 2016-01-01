#!/bin/bash
# ProxyMan v1.1
# Author : Himanshu Shekhar < https://github.com/himanshushekharb16/ProxyMan >

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.
#
# Tools used/required for implementation : bash, sed, grep, regex support, gsettings, apt
# and of-course privilege for setting up apt. 
# The user should be in the sudoers to set up apt, or modify the script as required.
#
# Credits : https://wiki.archlinux.org/index.php/Proxy_settings
#           https://wiki.archlinux.org/index.php/Environment_variables
#           https://developer.gnome.org/ProxyConfiguration/
#           Alan Pope : https://wiki.ubuntu.com/AlanPope
#			The Linux Command Line, William E. Shotts
#           Ubuntu Forums
#           Stack Exchange
# and many more Google search links.
#
# This script sets the proxy configuration for a general system from the Debian family.
# Configures apt, environment variables and gsettings
# The Network Manager settings (native to Gnome), sets system-wide proxy settings
# but does not set up authentication
# which is not an issue except the case of apt, which does not work
# for authenticated proxy in this manner.
# Also, this script rules out the need of configuring proxy for apt separately.
# Also, as tested, it does not work for bash/Terminal.
# Thus, we need to configure not one but three things: 
# gsettings, apt, and environment variables.
#
# ASSUMPTIONS : 
# toggle checks current mode taking gsettings as default
# 
# So, lets proceed.

# function to configure environment variables
configure_environment() {
# configure_environment $http_host $http_port $use_auth $use_same $username $password $https_host $https_port $ftp_host $ftp_port $socks_host $socks_port
	if [[ $4 == 'y' ]]; then
		if [[ $3 == 'y' ]]; then
			sed -i "s/<PROXY>/$5\:$6\@$1\:$2/g" bash_set.conf
		else
			sed -i "s/<PROXY>/$1:$2/g" bash_set.conf
		fi
	elif [[ $4 == 'n' ]]; then
		if [[ $3 == 'y' ]]; then
			auth=$5:$6@
		else
			auth=''
		fi
		sed -i '/proxy/dI' bash_set.conf
		echo "export http_proxy=$auth$1:$2" > bash_set.conf
		echo "export HTTP_PROXY=$auth$1:$2" >> bash_set.conf
		echo "export https_proxy=$auth$7:$8" >> bash_set.conf
		echo "export HTTPS_PROXY=$auth$7:$8" >> bash_set.conf
		echo "export ftp_proxy=$auth$9:$10" >> bash_set.conf
		echo "export FTP_PROXY=$auth$9:$10" >> bash_set.conf
		echo "export socks_proxy=$auth$11:$12" >> bash_set.conf
		echo "export SOCKS_PROXY=$auth$11:$12" >> bash_set.conf
		read -e -p "Enter proxy settings for rsync in format host:port " -i $1:$2 rsync
		echo "export rsync_proxy=$auth$rsync" >> bash_set.conf
		echo "export RSYNC_PROXY=$auth$rsync" >> bash_set.conf
	fi

	if [[ $3 == "y" ]]; then # require authentication
		sed -i "s/<PROXY>/$4:$5@$1:$2/g" bash_set.conf
	else 
		sed -i "s/<PROXY>/$1:$2/g" bash_set.conf
	fi

	if [[ -e "$HOME/.bashrc" ]]; then
		cat ./bash_set.conf >> $HOME/.bashrc
	fi
	if [[ -e "$HOME/.bash_profile" ]]; then
		cat ./bash_set.conf >> $HOME/.bash_profile
	fi
}

configure_apt() {
#configure_apt $http_host $http_port $use_auth $use_same $username $password $https_host $https_port $ftp_host $ftp_port $socks_host $socks_port
	echo $3:"Enter your System password (if asked)..."
	if [[ $3 == "n" ]]; then
		if [[ $4 == "y" ]]; then
			sed -i "s/<HOST>/$http_host/g" apt_config.conf
			sed -i "s/<PORT>/$http_port/g" apt_config.conf
			sed -i "s/<USERID>\:<PASSWORD>\@//g" apt_config.conf
		elif [[ $4 == "n" ]]; then
			echo Acquire\:\:Http\:\:Proxy\ \"http\:\/\/$1\:$2\/\"\; > apt_config.conf
			echo Acquire\:\:Https\:\:Proxy\ \"https\:\/\/$7\:$8\/\"\; >> apt_config.conf
			echo Acquire\:\:Ftp\:\:Proxy\ \"Ftp\:\/\/$9\:$10\/\"\; >> apt_config.conf
			echo Acquire\:\:Socks\:\:Proxy\ \"socks\:\/\/$11\:$12\/\"\; >> apt_config.conf
		else
			echo "Error!"
			exit 1
		fi
	elif [[ $3 == "y" ]]; then
		if [[ $4 == "y" ]]; then
			sed -i "s/<USERID>/$5/g" apt_config.conf
			sed -i "s/<PASSWORD>/$6/g" apt_config.conf
			sed -i "s/<HOST>/$1/g" apt_config.conf
			sed -i "s/<PORT>/$2/g" apt_config.conf
		else
			echo Acquire\:\:Http\:\:Proxy\ \"http\:\/\/$5\:$6\@$1\:$2\/\"\; > apt_config.conf
			echo Acquire\:\:Https\:\:Proxy\ \"https\:\/\/$5\:$6\@$7\:$8\/\"\; >> apt_config.conf
			echo Acquire\:\:Ftp\:\:Proxy\ \"ftp\:\/\/$5\:$6\@$9\:$10\/\"\; >> apt_config.conf
			echo Acquire\:\:Socks\:\:Proxy\ \"socks\:\/\/$5\:$6\@$11\:$12\/\"\; >> apt_config.conf
		fi
	else
		echo "Error encountered!"
		exit 1
	fi
	
	cp ./apt_config.conf /etc/apt/apt.conf
}

configure_gsettings() {
# configure_gsettings $http_host $http_port $use_auth $use_same $username $password $https_host $https_port $ftp_host $ftp_port $socks_host $socks_port
	gsettings set org.gnome.system.proxy mode 'manual'
	if [[ $4 == "y" ]]; then
		gsettings set org.gnome.system.proxy use-same-proxy true
		gsettings set org.gnome.system.proxy.http enabled true
		gsettings set org.gnome.system.proxy.http host "'$1'"; 
		gsettings set org.gnome.system.proxy.http port "$2"; 
		gsettings set org.gnome.system.proxy.https host "'$1'"
		gsettings set org.gnome.system.proxy.https port "$2"; 
		gsettings set org.gnome.system.proxy.socks host "'$1'"
		gsettings set org.gnome.system.proxy.socks port "$2"; 
		gsettings set org.gnome.system.proxy.ftp host "'$1'"
		gsettings set org.gnome.system.proxy.ftp port "$2"; 
	else
		gsettings set org.gnome.system.proxy use-same-proxy false
		gsettings set org.gnome.system.proxy.http enabled true
		gsettings set org.gnome.system.proxy.http host "'$1'"
		gsettings set org.gnome.system.proxy.http port "$2"
		gsettings set org.gnome.system.proxy.https host "'$7'"
		gsettings set org.gnome.system.proxy.https port "$8"
		gsettings set org.gnome.system.proxy.socks host "'$11'"
		gsettings set org.gnome.system.proxy.socks port "$12"
		gsettings set org.gnome.system.proxy.ftp host "'$9'"
		gsettings set org.gnome.system.proxy.ftp port "$10"
	fi
	if [[ $3 == "y" ]]; then
		gsettings set org.gnome.system.proxy.http use-authentication true
		gsettings set org.gnome.system.proxy.http authentication-user "'$5'"
		gsettings set org.gnome.system.proxy.http authentication-password "'$6'"
	else
		gsettings set org.gnome.system.proxy.http use-authentication false
		gsettings set org.gnome.system.proxy.http authentication-user "''"
		gsettings set org.gnome.system.proxy.http authentication-password "''"
	fi
}

unset_environment() {
	# unset all environment variables from bash_profile and bashrc
	if [[ -e "/etc/environment" ]]; then
		sed -i '/proxy\|PROXY\|Proxy/d' ~/.bash_profile
		sed -i '/ProxyMan/d' ~/.bash_profile
		sed -i '/github\.com/d' ~/.bash_profile
		sed -i '/Alan\ Pope/d' ~/.bash_profile
		sed -i '/end\ of\ proxy\ settings/d' ~/.bash_profile
	fi
	if [[ -e "/etc/environment" ]]; then
		sed -i '/proxy\|PROXY\|Proxy/d' ~/.bashrc
		sed -i '/ProxyMan/d' ~/.bashrc
		sed -i '/github\.com/d' ~/.bashrc
		sed -i '/Alan\ Pope/d' ~/.bashrc
		sed -i '/end\ of\ proxy\ settings/d' ~/.bashrc
	fi
}

unset_gsettings() {
	gsettings set org.gnome.system.proxy mode 'none'
}

unset_apt() {
	echo "Enter your system password if asked..."
	if [[ -e "/etc/apt/apt.conf" ]]; then
		rm /etc/apt/apt.conf
	fi
}

set_parameters() {
	echo "HTTP parameters : "
	read -p "Enter Host IP          : " http_host
	read -p "Enter Host Port        : " http_port
	read -e -p "Enable authentication (y/n)	: " -i "n" use_auth
	if [[ $use_auth == 'y' ]]; then
		read -p "Enter Proxy Username   : " username
		echo -n "Enter password         : "
		read -s password
		echo
	fi
	read -e -p "Use the same values for all http, https, ftp, socks (y/n) : " -i "y" use_same
	if [[ $use_same == 'n' ]]; then
		echo 
		echo "FTP parameters : "
		read -p "Enter Host IP          : " ftp_host
		read -p "Enter Host Port        : " ftp_port
		echo "HTTPS parameters : "
		read -p "Enter Host IP          : " https_host
		read -p "Enter Host Port        : " https_port
		echo "SOCKS parameters : "
		read -p "Enter Host IP          : " socks_host
		read -p "Enter Host Port        : " socks_port
	fi

	if [[ $1 == "ALL" ]]; then
		configure_apt $http_host $http_port $use_auth $use_same $username $password $https_host $https_port $ftp_host $ftp_port $socks_host $socks_port
		configure_gsettings $http_host $http_port $use_auth $use_same $username $password $https_host $https_port $ftp_host $ftp_port $socks_host $socks_port
		configure_environment $http_host $http_port $use_auth $use_same $username $password $https_host $https_port $ftp_host $ftp_port $socks_host $socks_port
	elif [[ $1 -eq 1 ]]; then
		configure_environment $http_host $http_port $use_auth $use_same $username $password $https_host $https_port $ftp_host $ftp_port $socks_host $socks_port
	elif [[ $1 -eq 2 ]]; then
		configure_gsettings $http_host $http_port $use_auth $use_same $username $password $https_host $https_port $ftp_host $ftp_port $socks_host $socks_port
	elif [[ $1 -eq 3 ]]; then
		configure_apt $http_host $http_port $use_auth $use_same $username $password $https_host $https_port $ftp_host $ftp_port $socks_host $socks_port
	else
		echo "Invalid arguments! ERROR encountered."
		exit 1
	fi
}


# Here is where the script starts
# Above were the functions to be used
clear
echo "
MESSAGE : In case of options, one value is displayed as the default value.
Do erase it to use other value.

ProxyMan v1.1
This script is documented in README.md file.

There are the following options for this script
TASK   :     DESCRIPTION

toggle : Toggle current mode ( none <--> manual ) for Desktop-environment, 
         with old configuration
set    : Configure all settings, recommended (to configure)
unset  : Remove proxy settings from all places
sfew   : Apply proxy settings from selective locations
ufew   : Unset proxy settings from selective locations
q      : Quit this program

"

read -p "Enter your choice : " choice

if [[ choice == 'q' ]]; then
	exit
fi

# create temporary files with extension .conf to be configured
if [[ -e "apt_config.bak" && -e "bash_set.bak" ]]; then
	cp apt_config.bak apt_config.conf
	cp bash_set.bak bash_set.conf
else  
	echo "Required files are missing. Please check for files apt_config.bak and bash_set.bak" >&2
	exit 1
fi

# take inputs and perform as necessary
case "$choice" in 
	toggle) mode=$(gsettings get org.gnome.system.proxy mode)
			if [ $mode == "'none'" ]; then
				gsettings set org.gnome.system.proxy mode 'manual'
			elif [ $mode == "'manual'" ]; then
				gsettings set org.gnome.system.proxy mode 'none'
			else
				echo "Invalid values found! Please recheck gsettings."
				exit
			fi
			echo "Operation completed successfully."
		;;
	set)	set_parameters ALL
		;;
	unset)	unset_gsettings
			unset_apt
			unset_environment
		;;
	sfew)	echo 
			echo "Where do you want to set proxy?"
			echo "1 : Terminal only."
			echo "2 : Desktop-environment/GUI and apps"
			echo "3 : APT/Software Center only"
			read 
			set_parameters $REPLY
		;;
	ufew)	echo 
			echo "Where do you want to unset proxy?"
			echo "1 : Terminal only."
			echo "2 : Desktop-environment/GUI and apps"
			echo "3 : APT/Software Center only"
			read 
			case $REPLY in 
				1) unset_environment
					;;
				2) unset_gsettings
					;;
				3) unset_apt
					;;
				*)	echo "Invalid arguments! Please retry."
					exit 1
					;;
			esac
		;;
	*) exit 1
		;;
esac
rm apt_config.conf bash_set.conf 
echo "Job done!"
echo "Thanks for using. :-)"