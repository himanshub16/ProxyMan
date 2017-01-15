## ProxyMan (download [here](https://github.com/himanshub16/ProxyMan/releases/latest/))
### Tool to set up and manage proxy settings for Linux (download from [releases](https://github.com/himanshub16/ProxyMan/releases/) )

Usage :
cd to the folder and enter the following command:
`
bash main.sh
`

The master branch is version2, [v2](https://github.com/himanshub16/ProxyMan/) of ProxyMan.
For older version, checkout [branch v1](https://github.com/himanshub16/ProxyMan/tree/v1).
To download older versions, checkout releases tagged v1.* [here](https://github.com/himanshub16/ProxyMan/releases).

NOTE : It does not support PAC proxy using "proxy configuration URL". It is for setting up "manual" proxy.

#### What's new in v2?
* Modular approach. Individual scripts handle individual targets requiring proxy settings.
* This means, a script can be for a single application/domain can be created and easily integrated with main.sh, without much modifications in main.sh (which was not available in v1).
* No issues of privileges for individual scripts. Main script is responsible of executing child script with required privileges. 

#### As of now, the GUI is buggy. It works for most cases, but doesn't always work for setting up apt.conf or /etc/environment. 
#### Hope to find a fix soon.

#### Steps taken to fix it as of now : 
  * Use pkexec to gain privileged access.
  * Use sudo with system function from cstdlib.
  * Use gksu (avoiding as it's not preinstalled in most distros).
  


