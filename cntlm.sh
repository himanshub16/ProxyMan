#!/bin/bash
# plugin to set "git" proxy settings for ProxyMan
# privileges has to be set by the process which starts this script

CONF_FILE=`readlink -f /etc/cntlm.conf`

list_proxy() {
    echo
    echo "${bold}cntlm proxy settings : ${normal}"
    if [ -f $CONF_FILE ]; then 
        cat $CONF_FILE | sed -e 's/^/ /'
    else
        echo "${red}None${normal}"
    fi
}

unset_proxy() {
    sudo rm $CONF_FILE 2> /dev/null
    sudo systemctl stop cntlm
}

set_proxy() {
    if [ "$use_cntlm_auth" = "y" ]; then
        echo "Domain          ${cntlm_domain}
Username        ${cntlm_username}
Auth            NTLMv2
${cntlm_conf}
NoProxy         ${no_proxy}
Listen          ${https_port}
" | sudo tee $CONF_FILE > /dev/null

    for i in $(echo ${include_proxy} | sed "s/,/ /g")
    do
        echo "Proxy $i" | sudo tee -a $CONF_FILE > /dev/null
    done
    fi
    sudo systemctl restart cntlm
}


which cntlm &> /dev/null
if [ "$?" != 0 ]; then
    exit
fi

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
    *)
          ;;
esac
