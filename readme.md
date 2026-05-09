# linux-surface-config

Config files I set for my Surface Pro 9 on Linux (Fedora Workstation 44)

To install, copy everything (except `readme.md`) to `/etc/`.

## other things I did

* Installed [linux-surface](https://github.com/linux-surface/linux-surface/wiki/Installation-and-Setup)
  - When you do this, also install and enable `iptsd`.
* Used [this guide](https://github.com/linux-surface/linux-surface/issues/2102) for Fedora 44
* Got [TouchUp](https://github.com/mityax/gnome-extension-touchup) for Gnome
* Ran `gsettings set org.gnome.desktop.interface enable-animations false` to disable animations
* Using Ungoogled Chromium instead of Firefox as Firefox is crazy inefficient for some reason