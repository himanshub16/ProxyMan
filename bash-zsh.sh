#!/bin/bash

which bash &> /dev/null
first="$?"

which zsh &> /dev/null
second="$?"

if [ "$#" = 0 ]; then
    exit
fi

if [ "$first" = 0 ]; then
    bash shellrc.sh "$1" "$HOME/.bashrc"
    echo "To activate in current terminal window"
    echo "run ${bold}source ~/.bashrc${normal}"
fi

if [ "$second" = 0 ]; then
    bash shellrc.sh "$1" "$HOME/.zshrc"
    echo "To activate in current terminal window"
    echo "run ${bold}source ~/.zshrc${normal}"
    echo
fi
