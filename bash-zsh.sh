#!/bin/bash
set -x
# macOS does not come with readlink or realpath, so we need to take a portable substitute
source "./util/realpath.sh"

case $os in
    "Linux") 
        BASHRC=`readlink -f $HOME/.bashrc`
        ZSHRC=`readlink -f $HOME/.zshrc`
    ;;
    "Darwin") 
        BASHRC=`realpath $HOME/.bashrc`
        ZSHRC=`realpath $HOME/.zshrc`
    ;;
    *) echo "Operating system not supported. Exiting."
       exit 1
    ;;
esac

which bash &> /dev/null
first="$?"

which zsh &> /dev/null
second="$?"

if [ "$#" = 0 ]; then
    exit
fi

if [ "$first" = 0 ]; then
    bash shellrc.sh "$1" "$BASHRC"
    if [ ! "$1" = "list" ]; then
        echo "To activate in current terminal window"
        echo "run ${bold}source ~/.bashrc${normal}"
    fi
fi

if [ "$second" = 0 ]; then
    bash shellrc.sh "$1" "$ZSHRC"
    if [ ! "$1" = "list" ]; then
        echo "To activate in current terminal window"
        echo "run ${bold}source ~/.zshrc${normal}"
    fi
fi
