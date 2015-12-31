ProxyMan changelog
===============================================================

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