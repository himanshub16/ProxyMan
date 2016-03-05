#!/bin/bash
if [[ -e "$HOME/.bashrc" ]]; then
	a=$(grep -i proxy $HOME/.bashrc | wc -l)
	if [[ a -eq 0 ]]; then
		echo ".bashrc is not using proxy."
	else
		echo "For ~/.bashrc..."
		grep -i proxy $HOME/.bashrc
	fi
else
	echo ".bashrc does not exist."
fi

if [[ -e "/etc/environment" ]]; then
	a=$(grep -i proxy /etc/environment | wc -l)
	if [[ a -eq 0 ]]; then
		echo "/etc/environment is not using proxy."
	else
		echo "For /etc/environment"
		grep -i proxy /etc/environment
	fi
else
	echo "/etc/environment does not exist."
fi

echo

if [[ -e "$HOME/.bash_profile" ]]; then
	a=$(grep -i proxy $HOME/.bash_profile | wc -l)
	if [[ a -eq 0 ]]; then
		echo ".bash_profile is not using proxy."
	else
		echo "For ~/.bash_profile..."
		grep -i proxy $HOME/.bash_profile
	fi
else
	echo ".bash_profile does not exist."
fi

echo

if [[ -e "/etc/apt/apt.conf" ]]; then
	echo "This is apt.conf ..."
	cat "/etc/apt/apt.conf"
else
	echo "apt is not using proxy."
fi

echo

mode=$(gsettings get org.gnome.system.proxy mode)
if [[ $mode == "'none'" ]]; then
	echo "The desktop environment is not using any proxy settings."
	echo "Thus, gsettings configurations are ineffective."
elif [[ $mode == "'manual'" ]]; then
	echo "The desktop environment is using manual proxy settings."
	echo "Thus, following gsettings configurations are effective."
	gsettings list-recursively org.gnome.system.proxy
else
	echo "We cannot determine the type of settings. Sorry :("
fi