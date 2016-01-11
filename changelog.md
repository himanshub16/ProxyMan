ProxyMan changelog
===============================================================

## v1.4 : Fourth release : January 11, 2016
---------------------------------------------------------------
* unset forced before set to avoid duplicate entries.

## v1.3 : Third release : January 9, 2016
---------------------------------------------------------------
* sudo was missing on the statement that removed apt.conf on unset. Fixed.
* Warning is displayed on toggle to none if any authentication is saved, with option to remove credentials.

## v1.2 : Second release : January 1, 2016
---------------------------------------------------------------
* bashrc and bash_profile changes were not exported, fixed.
* Message to restart terminal session added.
* /etc/environment is not modified to avoid system-wide changes.

## v1.1 : First release : December 31, 2015
---------------------------------------------------------------
* bash_set.conf had no eol, causing warnings from bash on Elementary OS Freya.
* Added semicolon to the end of each line of bash proxy settings
* apt.conf generated had missing semicolon in each line, causing errors. Fixed now.
* gsettings_config.* files are useless, thus removed.
* bash_unset.bak file is useless, thus removed.


## v1.0 : Initial launch (pre-release) : December 30, 2015
---------------------------------------------------------------
* The initial version of the script published.
* Worked fine as tested on Debian Jessie.
