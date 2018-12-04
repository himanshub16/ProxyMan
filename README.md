## ProxyMan [![Gitter chat](https://badges.gitter.im/gitterHQ/gitter.png)](https://gitter.im/proxyman-linux/Lobby)

### Configuring proxy made so simple on Linux ([releases](https://github.com/himanshub16/ProxyMan/releases/))

(Download [here](https://github.com/himanshub16/ProxyMan/releases/latest/))

### Usage

* Install
  `./install`

* Set
  `proxyman set`

* Unset
  `proxyman unset`
  
* List available configs
  `proxyman configs`
  
* Load config (say proxy4)
  `proxyman load proxy4`


### How this is going to be different from **v2**?
* Saves your settings in a `config_file/rc_file` (same as profiles).
* Simple install script lets you use proxyman from anywhere.

### How did v1 and v2 work?
Both versions modified the config files or called the appropriate command of respective tools to configure their internal proxy settings.

Open for discussions at [#49](https://github.com/himanshub16/ProxyMan/issues/49) .
