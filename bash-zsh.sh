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
fi

if [ "$second" = 0 ]; then
    bash shellrc.sh "$1" "$HOME/.zshrc"
fi
