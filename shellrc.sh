#!/bin/bash
# plugin to set "generic shellrc" proxy settings for ProxyMan
# shellrc - ~/.bashrc, ~/.zshrc, /etc/environment
# privileges has to be set by the process which starts this script

# This is required for Elementary OS which contains ~/.bashrc without \n
_fix_new_line() {
    if [[ $(tail -c 1 "$SHELLRC" | wc --lines) = 0 ]]; then
        echo >>"$1"
    fi
}

list_proxy() {
    echo
    echo "${bold}Shell proxy settings : $SHELLRC ${normal}"
    lines="$(cat $SHELLRC | grep proxy -i | wc -l)"
    if [ "$lines" -gt 0 ]; then
        cat $SHELLRC | grep proxy -i
    else
        echo "${red}None${normal}"
    fi
}

_modify_shellrc_variable_line() {
    PROXY_VARIABLE_NAME="$1"
    DELETE="$2"

    # Fish shell needs the variables to be explicitely unset, so we replace, if on Fish
    # If $DELETE is empty, we will delete the whole line, even when we are on Fish
    # This is needed for cleaning the $SHELLRC file before setting a new proxy
    if [[ ("$SHELLRC" == *"fish"*) && (-z "$DELETE") ]]; then
        SED_STRING="s/.*${PROXY_VARIABLE_NAME}.*/set -e ${PROXY_VARIABLE_NAME}/g"
    else
        SED_STRING="/.*${PROXY_VARIABLE_NAME}.*/d"
    fi

    # We use -i.bak and delete the backup file afterwards to be compatible with GNU sed and BSD sed at the same time
    # (as in https://stackoverflow.com/questions/5694228/sed-in-place-flag-that-works-both-on-mac-bsd-and-linux)
    sed -i.bak "$SED_STRING" "$SHELLRC" && rm ${SHELLRC}.bak
}

unset_proxy() {
    if [ ! -e "$SHELLRC" ]; then
        return
    fi

    # Option to definitely delete the whole line
    DELETE="$1"

    for proxytype in "http" "https" "ftp" "rsync" "no"; do
        # Handle lower case entries
        PROXY_VARIABLE_NAME="${proxytype}_proxy"
        _modify_shellrc_variable_line $PROXY_VARIABLE_NAME "$DELETE"

        # Handle upper case entries
        PROXY_VARIABLE_NAME=$(echo "$PROXY_VARIABLE_NAME" | awk '{print toupper($0)}')
        _modify_shellrc_variable_line $PROXY_VARIABLE_NAME "$DELETE"
    done
}

set_proxy() {
    unset_proxy "DELETE"
    if [ ! -e "$SHELLRC" ]; then
        touch "$SHELLRC"
    fi

    local stmt=""
    if [ "$use_auth" = "y" ]; then
        stmt="${username}:${password}@"
    fi

    # caution: do not use / after stmt
    echo "export http_proxy=\"http://${stmt}${http_host}:${http_port}/\""     >> "$SHELLRC"
    # $https_proxy at the end
    echo "export ftp_proxy=\"ftp://${stmt}${ftp_host}:${ftp_port}/\""         >> "$SHELLRC"
    echo "export rsync_proxy=\"rsync://${stmt}${rsync_host}:${rsync_port}/\"" >> "$SHELLRC"
    echo "export no_proxy=\"${no_proxy}\""                                    >> "$SHELLRC"
    echo "export HTTP_PROXY=\"http://${stmt}${http_host}:${http_port}/\""     >> "$SHELLRC"
    # $HTTPS_PROXY at the end
    echo "export FTP_PROXY=\"ftp://${stmt}${ftp_host}:${ftp_port}/\""         >> "$SHELLRC"
    echo "export RSYNC_PROXY=\"rsync://${stmt}${rsync_host}:${rsync_port}/\"" >> "$SHELLRC"
    echo "export NO_PROXY=\"${no_proxy}\""                                    >> "$SHELLRC"

    if [ "$USE_HTTP_PROXY_FOR_HTTPS" = "true" ]; then
        echo "export https_proxy=\"http://${stmt}${http_host}:${http_port}/\"" >> "$SHELLRC"
        echo "export HTTPS_PROXY=\"http://${stmt}${http_host}:${http_port}/\"" >> "$SHELLRC"
    else
        echo "export https_proxy=\"https://${stmt}${https_host}:${https_port}/\"" >> "$SHELLRC"
        echo "export HTTPS_PROXY=\"https://${stmt}${https_host}:${https_port}/\"" >> "$SHELLRC"
    fi
}


export SHELLRC=$2

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
