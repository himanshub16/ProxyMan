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
# plugin to set "docker" proxy settings for ProxyMan
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

# fix_new_line() {
#     if [[ $(tail -c 1 "$1" | wc --lines ) = 0 ]]; then
#         echo >> "$1"
#     fi
# }

list_proxy() {
	# inefficient way as the file is read twice.. think of some better way
	echo
	echo -e "\e[1m docker proxy settings \e[0m"
    if [ ! -e "/etc/systemd/system/docker.service.d/http-proxy.conf" ]; then
        echo -e "\e[36m None \e[0m"
		return
    else
        lines="$(cat /etc/systemd/system/docker.service.d/http-proxy.conf | grep proxy -i | wc -l)"
    	if [ "$lines" -gt 0 ]; then
    		cat /etc/systemd/system/docker.service.d/http-proxy.conf | grep proxy -i | sed -e "s/Environment=//g" -e "s/\_/\ /g"
    	else
    		echo -e "\e[36m None \e[0m"
    	fi
	fi
}

unset_proxy() {
	if [ ! -e "/etc/systemd/system/docker.service.d/http-proxy.conf" ]; then
		return
	fi
	if [ "$(cat /etc/systemd/system/docker.service.d/http-proxy.conf | grep proxy -i | wc -l)" -gt 0 ]; then
		sudo rm /etc/systemd/system/docker.service.d/http-proxy.conf
	fi
}

set_proxy() {
	if [ ! -e "/etc/systemd/system/docker.service.d/http-proxy.conf" ]; then
		sudo touch "/etc/systemd/system/docker.service.d/http-proxy.conf"
	fi
	var=
	if [ "$4" = "y" ]; then
		var="$5:$6@"
	fi
	echo -n "" > docker_config.tmp
	if [ "$3" = "y" ]; then
		newvar="://$var$1:$2"
        echo "[Service]" >> docker_config.tmp
		echo "Environment=\"HTTP_PROXY=http$newvar\"" >> docker_config.tmp
		echo "Environment=\"HTTP_PROXY=http$newvar\"" >> docker_config.tmp

        # fix_new_line "/etc/systemd/system/docker.service.d/http-proxy.conf"
		cat docker_config.tmp | sudo tee -a /etc/systemd/system/docker.service.d/http-proxy.conf > /dev/null
		rm docker_config.tmp
		return

	elif [ "$3" = "n" ]; then
        echo "[Service]" >> docker_config.tmp
		echo "Environment=\"HTTP_PROXY=http://$var$1:$2\";" >> docker_config.tmp
		echo "Environment=\"HTTP_PROXY=http://$var$7:$8\";" >> docker_config.tmp

		cat docker_config.tmp | sudo tee -a /etc/systemd/system/docker.service.d/http-proxy.conf > /dev/null
		rm docker_config.tmp
		return
	fi
}


docker_available="$(which docker)"
if [ "$docker_available" = "" ]; then
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
