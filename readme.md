# linux-surface-config

Config files I set for my Surface Pro 9 on Linux (Fedora Workstation 44)

To install, copy everything (except `readme.md`) to `/etc/`.

Also see [tips.md](tips.md) if you want more tips and explanations.

## other things I did

* Installed [linux-surface](https://github.com/linux-surface/linux-surface/wiki/Installation-and-Setup)
  - When you do this, also install and enable `iptsd`. I use a custom fork I made (https://github.com/zeroxoneafour/iptsd/tree/disable-on-stylus) to set a custom stylus responsiveness.
* Used [this guide](https://github.com/linux-surface/linux-surface/issues/2102) for Fedora 44
  - I actually now have my own build of kernel 7.1 with linux-surface on my GitHub actions, but I will not provide support for it and do not recommend its usage

### for gnome

* Got [TouchUp](https://github.com/mityax/gnome-extension-touchup) for Gnome
* Ran `gsettings set org.gnome.desktop.interface enable-animations false` to disable animations

### for plasma
* Got [Panel Colorizor](https://github.com/luisbocanegra/plasma-panel-colorizer) to hide the menu button (use gestures instead)
* Got [this goated widget](https://github.com/a-chaudhari/plasma-screenrotation) for screen rotation
* Use Polonium and [this script](https://github.com/zeroxoneafour/kwin-swipe-gestures) for better interactivity
* Run `qdbus-qt6 org.kde.plasmashell /PlasmaShell evaluateScript 'lockCorona(!locked)'` to disable/reenable edit mode on panels

## so what?

In the end, I now can pull out around 6 to 7 (heh) hours of battery life somewhat consistently out of a 50whr battery on Alder Lake, which is enough for me.

If that seems low, I think it is too. It's a limitation of this generation of Intel CPUs apparently, and also Surfaces and Linux as well.

I love this Surface. If I went back in time, I would buy it again. However, I would never ever recommend it to the average consumer.
