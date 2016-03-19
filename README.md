#ProxyMan (for Linux)

Author : Himanshu Shekhar < https://github.com/himanshushekharb16/ProxyMan/ >

The version number is mentioned in the main.sh file.

CLI Tool to set up and manage proxy settings for Debian/Ubuntu Linux distributions.

Additionally, script proxy_check.sh is provided to check your current proxy settings.
This helps much in debugging and observing the behaviour of proxy configuration tools.

Free software licensed under GNU GPL v2

How to use this tool?
=====================
Browse to the directory containing this tool and the following commands would help you out.

bash main.sh : To set up/unset proxy settings

bash proxy_check.sh : To check your current proxy settings

What does it requires on?
=========================
Perhaps, nothing in a modern day GNU/Linux distribution. 
The entire script is written in bash and uses common GNU components. It is specifically written for distros having the following components :
gsettings, apt, bash
Tools used in the bash script are : sed, grep, regex.
However, you should make sure that sed, grep and bash are available on your system.
Also, you need to have sudo privilege in order to modify APT settings.
If you don't have sudo permissions, remove the "sudo" word from lines 126 and 194 and run the script as root in order to set APT proxy settings.

Why this tool?
==============
The options for configuring proxy settings in desktop environment (as observed in distros as Debian, Ubuntu) set proxy for the Desktop Environment (technically speaking gsettings), but they were observed not work well for other locations as bash and apt. 
The major problem arises in the case of authenticated proxies, where the "Apply System Wide" option, does not sets up authentication for the proxy.
This tool is a way of manually setting up proxy individually to Desktop Environment, Package Manager, and the Shell, i.e. gsettings, bash and apt.
