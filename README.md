## ProxyMan
### Tool to set up and manage proxy settings for Linux (download from [releases](https://github.com/himanshub16/ProxyMan/releases/latest/) )

The master branch is version2, [v2](https://github.com/himanshub16/ProxyMan/) of ProxyMan.
For older version, checkout [branch v1](https://github.com/himanshub16/ProxyMan/tree/v1).
To download older versions, checkout releases tagged v1.* [here](https://github.com/himanshub16/ProxyMan/releases).

#### What's new in v2?
* Modular approach. Individual scripts handle individual targets requiring proxy settings.
* This means, a script can be for a single application/domain can be created and easily integrated with main.sh, without much modifications in main.sh (which was not available in v1).
* No issues of privileges for individual scripts. Main script is responsible of executing child script with required privileges. 


