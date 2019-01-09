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

# location of subscripts
DIR="$(cd "$(dirname "$0")" && pwd)"

clear
if [ "$1" = "list" ]; then
    echo "Someone wants to list all"
    bash "$DIR/bash.sh" "list"
    sudo bash "$DIR/environment.sh" "list"
    sudo bash "$DIR/apt.sh" "list"
    sudo bash "$DIR/dnf.sh" "list"
    bash "$DIR/gsettings.sh" "list"
    bash "$DIR/npm.sh" "list"
    bash "$DIR/dropbox.sh" "list"
    bash "$DIR/git.sh" "list"
    bash "$DIR/docker.sh" "list"
    exit
fi

http_host=""
http_port=""
use_same="n"
https_host=""
https_port=""
ftp_host=""
ftp_port=""
use_auth="n"
username=""
password=""
save_for_reuse=""
profile_name=""
no_proxy=""

if [[ "$1" == "load" && "$2" == "" ]]; then
    echo -ne "\e[1m \e[31mPlease provide a config! \e[0m"
    echo
    exit
fi

if [ "$1" == "load" ]; then
    choice="set"

else
    echo -e "
\e[1m\e[33mProxyMan
=========\e[0m
Tool to set up system wide proxy settings on Linux.
\e[2m\e[33m🌟\e[0m\e[3m Star it \e[0m : \e[4m\e[34m https://github.com/himanshub16/ProxyMan \e[0m

\e[4mThe following options are available : \e[0m
\e[1m set \e[0m    : \e[2m Set proxy settings \e[0m
\e[1m unset \e[0m  : \e[2m Unset proxy settings \e[0m
\e[1m list \e[0m   : \e[2m List current settings \e[0m
\e[1m load \e[0m   : \e[2m Load previously saved settings \e[0m
"

    read -p " Enter your choice : " choice

    if [[ (! "$choice" = "set") && (! "$choice" = "unset") && (! "$choice" = "list") && (! "$choice" = "load") ]]; then
        echo "Invalid choice! Will exit."
        exit
    fi

    if [ "$choice" = "set" ]; then

        echo
        echo -e " \e[4mEnter details \e[0m : \e[2m\e[3m (leave blank if you don't to use any proxy settings) \e[0m"
        echo
        echo -ne "\e[36m HTTP Proxy host \e[0m"; read http_host
        echo -ne "\e[32m HTTP Proxy port \e[0m"; read http_port
        echo -ne "\e[0m Use same for HTTPS and FTP (y/n)  ? \e[0m"; read use_same
        echo -ne "\e[0m Use authentication (y/n)  ? \e[0m        "; read use_auth

        if [[ "$use_auth" = "y" || "$use_auth" = "Y" ]]; then
            read -p " Enter username                 : " username
            echo -n " Enter password (use %40 for @) : " ; read -s password
        fi

        echo -ne "\e[0m Save settings for later use (y/n) ? \e[0m"; read save_for_reuse

        if [[ "$save_for_reuse" = "y" || "$save_for_reuse" = "Y" ]]; then
            read -p " Enter config name                 : " profile_name
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
        echo -ne "\e[0m Add no_proxy hosts (y/n)  ? \e[0m        "; read use_no_proxy
        if [[ "$use_no_proxy" = "y" || "$use_no_proxy" = "Y" ]]; then
            read -p " Enter no_proxy values (e.g: localhost,127.0.0.1,*.local) : " no_proxy
        fi
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
echo -e " |\e[36m 9 \e[0m| Docker"
echo

echo -e " Enter your choices (\e[3m\e[2m separate multiple choices by a space \e[0m ) "
echo -ne "\e[5m ? \e[0m" ; read -a targets

echo

case $choice in
    "set"|"load")

        if [[ "$1" != "load"  && ( "$save_for_reuse" = "y" || "$save_for_reuse" = "Y" ) ]]; then
            config_file="http_host=$http_host%s\nhttp_port=$http_port%s\nuse_same=$use_same\nuse_auth=$use_auth\nusername=$username\npassword=$password\nhttps_host=$https_host\nhttps_port=$https_port\nftp_host=$ftp_host\nftp_port=$ftp_port\nno_proxy=$no_proxy"
            printf $config_file > "$DIR/profiles/$profile_name".txt
        fi

        if [[ $choice == "load" || $1 == "load" ]]; then

            if [[ $choice == "load" ]]; then
                echo -e "\e[0m Available configs: \e[0m"
                for entry in "$DIR/profiles"/*.txt
                do
                    if [ -f "$entry" ];then
                        echo -e "\e[36m   $(basename $entry | cut -d\. -f1) \e[0m"
                    fi
                done
                echo -ne "\e[36m Config Name \e[0m " ; read config_name
            fi

            if [ "$1" = "load" ]; then

                if [ "$2" = "" ]; then
                    echo -ne "\e[1m \e[31mPlease provide a config! \e[0m"
                    echo
                    exit
                fi

                config_name=$2
            fi

            if [ ! -e "$DIR"/profiles/"$config_name".txt ]; then
                echo -ne "\e[1m \e[31mFile does not exist! \e[0m"
                echo
                exit
            fi

            http_host=`grep http_host -i $DIR/profiles/$config_name.txt  | cut -d= -f2`
            http_port=`grep http_port -i $DIR/profiles/$config_name.txt  | cut -d= -f2`
            use_same=`grep use_same -i $DIR/profiles/$config_name.txt  | cut -d= -f2`
            use_auth=`grep use_auth -i $DIR/profiles/$config_name.txt  | cut -d= -f2`
            username=`grep username -i $DIR/profiles/$config_name.txt  | cut -d= -f2`
            password=`grep password -i $DIR/profiles/$config_name.txt  | cut -d= -f2`
            https_host=`grep https_host -i $DIR/profiles/$config_name.txt  | cut -d= -f2`
            https_port=`grep https_port -i $DIR/profiles/$config_name.txt  | cut -d= -f2`
            ftp_host=`grep ftp_host -i $DIR/profiles/$config_name.txt  | cut -d= -f2`
            ftp_port=`grep ftp_port -i $DIR/profiles/$config_name.txt  | cut -d= -f2`
            no_proxy=`grep no_proxy -i $DIR/profiles/$config_name.txt  | cut -d= -f2`

            echo -e " Config \033[0;36m$config_name\033[0m successfully loaded"
        fi

        args=("$http_host" "$http_port" "$use_same" "$use_auth" "$username" "$password" "$https_host" "$https_port" "$ftp_host" "$ftp_port" "$no_proxy" )

        for i in "${targets[@]}"
        do
            case $i in
                1)
                    bash "$DIR/bash.sh" "${args[@]}"
                    sudo bash "$DIR/environment.sh" "${args[@]}"
                    sudo bash "$DIR/apt.sh" "${args[@]}"
                    sudo bash "$DIR/dnf.sh" "${args[@]}"
                    bash "$DIR/gsettings.sh" "${args[@]}"
                    bash "$DIR/npm.sh" "${args[@]}"
                    bash "$DIR/dropbox.sh" "${args[@]}"
                    bash "$DIR/git.sh" "${args[@]}"
                    bash "$DIR/docker.sh" "${args[@]}"
                    ;;
                2)
                    bash "$DIR/bash.sh" "${args[@]}"
                    ;;
                3)	sudo bash "$DIR/environment.sh" "${args[@]}"
                    ;;
                4)	sudo bash "$DIR/apt.sh" "${args[@]}"
                    sudo bash "$DIR/dnf.sh" "${args[@]}"
                    ;;
                5)	bash "$DIR/gsettings.sh" "${args[@]}"
                    ;;
                6)	bash "$DIR/npm.sh" "${args[@]}"
                    ;;
                7)	bash "$DIR/dropbox.sh" "${args[@]}"
                    ;;
                8)	bash "$DIR/git.sh" "${args[@]}"
                    ;;
                9)	bash "$DIR/docker.sh" "${args[@]}"
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
                    bash "$DIR/bash.sh" "unset"
                    sudo bash "$DIR/environment.sh" "unset"
                    sudo bash "$DIR/apt.sh" "unset"
                    sudo bash "$DIR/dnf.sh" "unset"
                    bash "$DIR/gsettings.sh" "unset"
                    bash "$DIR/npm.sh" "unset"
                    bash "$DIR/dropbox.sh" "unset"
                    bash "$DIR/git.sh" "unset"
                    bash "$DIR/docker.sh" "unset"
                    ;;
                2)
                    bash "$DIR/bash.sh" "unset"
                    ;;
                3)	sudo bash "$DIR/environment.sh" "unset"
                    ;;
                4)	sudo bash "$DIR/apt.sh" "unset"
                    sudo bash "$DIR/dnf.sh" "unset"
                    ;;
                5)	bash "$DIR/gsettings.sh" "unset"
                    ;;
                6)	bash "$DIR/npm.sh" "unset"
                    ;;
                7)	bash "$DIR/dropbox.sh" "unset"
                    ;;
                8) 	bash "$DIR/git.sh" "unset"
                    ;;
                9) 	bash "$DIR/docker.sh" "unset"
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
                        bash "$DIR/bash.sh" "list"
						            sudo bash "$DIR/environment.sh" "list"
						            sudo bash "$DIR/apt.sh" "list"
						            sudo bash "$DIR/dnf.sh" "list"
						            bash "$DIR/gsettings.sh" "list"
						            bash "$DIR/npm.sh" "list"
						            bash "$DIR/dropbox.sh" "list"
                                    bash "$DIR/git.sh" "list"
                                    bash "$DIR/docker.sh" "list"
						            ;;
					          2)
						            bash "$DIR/bash.sh" "list"
						            ;;
					          3)	sudo bash "$DIR/environment.sh" "list"
						            ;;
					          4)	sudo bash "$DIR/apt.sh" "list"
						            sudo bash "$DIR/dnf.sh" "list"
						            ;;
					          5)	bash "$DIR/gsettings.sh" "list"
						            ;;
					          6)	bash "$DIR/npm.sh" "list"
						            ;;
					          7) 	bash "$DIR/dropbox.sh" "list"
						            ;;
					          8) 	bash "$DIR/git.sh" "list"
                                    ;;
                              9) 	bash "$DIR/docker.sh" "list"
						            ;;
					          *)	;;
				        esac
			      done

		    fi
		    ;;

	  *)
        echo "Invalid choice! Will exit now"
        exit
		    ;;
esac

echo
echo -e "\e[1m\e[36mDone!\e[0m \e[2mThanks for using :)\e[0m"
