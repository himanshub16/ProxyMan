## ProxyMan 

### Configuring proxy made so simple on Linux ([releases](https://github.com/himanshub16/ProxyMan/releases/))

(Download [here](https://github.com/himanshub16/ProxyMan/releases/latest/))

#### Usage :
* Download the [zip from here](https://github.com/himanshub16/ProxyMan/releases/latest).
* Extract the zip, open the folder in terminal.
* Enter the following command
`
bash main.sh
`

![Screenshot](https://raw.githubusercontent.com/himanshub16/ProxyMan/master/screenshot.png)

# FAQ
* **Why do someone need it?**

  Because many times, setting up proxy on Linux sucks (esp. authenticated proxies). There are a lot of locations to configure. This tool reduces your effort by setting the proper configuration at the desired place.

* **For which softwares the settings by ProxyMan is effective?**

  ProxyMan sets proxy for `apt`, `bashrc`, `npm`, `dropbox`, `/etc/environment`.

* **There is some application/location it does not support. Any workaround?**

  Why not? Everything is possible. Just raise an issue [here](https://github.com/himanshub16/ProxyMan/issues). 
  If you are a developer, then your contributions are welcome.

* **My distro works like charm. I don't need it.**

  It's great that your distro supports everything. However, many disros do not support authenticated proxy settings. 
  Moreover, there are several apps which don't use system proxy on certain platforms and need their own workaround.

For older version, checkout [branch v1](https://github.com/himanshub16/ProxyMan/tree/v1).
To download older versions, checkout releases tagged v1.* [here](https://github.com/himanshub16/ProxyMan/releases).

#### What's new in v2?
* Modular approach. Individual scripts handle individual targets requiring proxy settings.
* This means, a script can be for a single application/domain can be created and easily integrated with main.sh, without much modifications in main.sh (which was not available in v1).
* No issues of privileges for individual scripts. Main script is responsible of executing child script with required privileges.

 
NOTE : It does not support PAC proxy using "proxy configuration URL". It is for setting up "manual" proxy.

#### A GUI version is under progress. However, it is not ready. If you like to contribute, you can checkout to the [gui branch](https://github.com/himanshub16/ProxyMan/tree/gui) of this project.
