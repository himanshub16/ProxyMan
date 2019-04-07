#!/bin/bash

BASHRC=`readlink -f $HOME/.bashrc`
ZSHRC=`readlink -f $HOME/.zshrc`

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
