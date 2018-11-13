## ProxyMan [![Gitter chat](https://badges.gitter.im/gitterHQ/gitter.png)](https://gitter.im/proxyman-linux/Lobby)

### Configuring proxy made so simple on Linux ([releases](https://github.com/himanshub16/ProxyMan/releases/))

(Download [here](https://github.com/himanshub16/ProxyMan/releases/latest/))

### Usage

* Set
  `./main.sh set`

* Unset
  `./main.sh unset`
  
* List available configs
  `./main.sh configs`
  
* Load config (say proxy4)
  `./main.sh load proxy4`


### How this is going to be different from **v2**?
* Saves your settings in a `config_file/rc_file` (same as profiles).
* Single script sourced in `.bashrc/.zshrc` ensures the right config is sourced directly instead of manually invoking the script.

### How did v1 and v2 work?
Both versions modified the config files or called the appropriate command of respective tools to configure their internal proxy settings.

### The need for this change.
Most of the tools/targets which proxyman sets proxy for work well with `http_proxy` environment variable. Thus, the need for manually configuring proxy for each target becomes insignificant.

Also, there can be a use-case where the user wants granular control like different proxy for different application. However, such use-case is very small.

Open for discussions at [#49](https://github.com/himanshub16/ProxyMan/issues/49) .
