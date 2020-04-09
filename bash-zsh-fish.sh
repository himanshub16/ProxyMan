#!/bin/bash
# macOS does not come with readlink or realpath, so we need to take a portable substitute
source "./util/realpath.sh"

case $os in
    "Linux") 
        BASHRC=`readlink -f $HOME/.bashrc`
        ZSHRC=`readlink -f $HOME/.zshrc`
        FISHRC=`readlink -f $HOME/.config/fish/config.fish`
    ;;
    "Darwin") 
        BASHRC=`realpath $HOME/.bashrc`
        ZSHRC=`realpath $HOME/.zshrc`
        FISHRC=`realpath $HOME/.config/fish/config.fish`
    ;;
    *) echo "Operating system not supported. Exiting."
       exit 1
    ;;
esac

which bash &> /dev/null
check_bash="$?"

which zsh &> /dev/null
check_zsh="$?"

which fish &> /dev/null
check_fish="$?"

if [ "$#" = 0 ]; then
    exit
fi

if [ "$check_bash" = 0 ]; then
    bash shellrc.sh "$1" "$BASHRC"
    if [ ! "$1" = "list" ]; then
        echo "To activate in current terminal window"
        echo "run ${bold}source ~/.bashrc${normal}"
    fi
fi

if [ "$check_zsh" = 0 ]; then
    bash shellrc.sh "$1" "$ZSHRC"
    if [ ! "$1" = "list" ]; then
        echo "To activate in current terminal window"
        echo "run ${bold}source ~/.zshrc${normal}"
    fi
fi

if [ "$check_fish" = 0 ]; then
    bash shellrc.sh "$1" "$FISHRC"
    if [ ! "$1" = "list" ]; then
        echo "To activate in current terminal window"
        echo "run ${bold}source ~/.config/fish/config.fish${normal}"
    fi
fi
