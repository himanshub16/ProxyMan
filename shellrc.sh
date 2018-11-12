#!/bin/bash

# This is required for Elementary OS which contains ~/.bashrc without \n
_fix_new_line() {
    if [[ $(tail -c 1 "$SHELLRC" | wc --lines) = 0 ]]; then
        echo >> "$1"
    fi
}

list_proxy() {
    echo
    echo "${bold}Shell proxy settings : $SHELLRC ${normal}"
    lines="$(cat $SHELLRC | grep proxy -i | wc -l)"
    if [ "$lines" -gt 0 ]; then
        cat $SHELLRC | grep proxy -i | sed "s/\=/\ /g"
    else
        echo "${red}None${normal}"
    fi
}

unset_proxy() {
    if [ ! -e "$SHELLRC" ]; then
        return
    fi
    # extra effort required to avoid removing custom environment variables set
    # by the user for personal use
    for proxytype in "http" "https" "ftp" "rsync" "no"; do
        sed -i "/export ${proxytype}_proxy\=/d" "$SHELLRC"
    done
    for PROTOTYPE in "HTTP" "HTTPS" "FTP" "RSYNC" "NO"; do
        sed -i "/export ${PROTOTYPE}_PROXY\=/d" "$SHELLRC"
    done
}

set_proxy() {
    unset_proxy
    if [ ! -e "$SHELLRC" ]; then
        touch "$SHELLRC"
    fi

    local stmt=""
    if [ "$use_auth" = "y" ]; then
        stmt="${username}:${password}@"
    fi

    # caution: do not use / after stmt
    echo "export http_proxy=http://${stmt}${http_host}:${http_port}/"     >> "$SHELLRC"
    echo "export https_proxy=https://${stmt}${https_host}:${https_port}/" >> "$SHELLRC"
    echo "export ftp_proxy=ftp://${stmt}${ftp_host}:${ftp_port}/"         >> "$SHELLRC"
    echo "export rsync_proxy=rsync://${stmt}${rsync_host}:${rsync_port}/" >> "$SHELLRC"
    echo "export no_proxy=${no_proxy}"                                    >> "$SHELLRC"
    echo "export HTTP_PROXY=http://${stmt}${http_host}:${http_port}/"     >> "$SHELLRC"
    echo "export HTTPS_PROXY=https://${stmt}${https_host}:${https_port}/" >> "$SHELLRC"
    echo "export FTP_PROXY=ftp://${stmt}${ftp_host}:${ftp_port}/"         >> "$SHELLRC"
    echo "export RSYNC_PROXY=rsync://${stmt}${rsync_host}:${rsync_port}/" >> "$SHELLRC"
    echo "export NO_PROXY=${no_proxy}"                                    >> "$SHELLRC"
}


SHELLRC=$2

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
