# sys-firewall

Firewall in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)

## Description

Creates firewall qube, an App qube "sys-firewall" and a Disposable qube
"disp-sys-firewall". By default, "disp-sys-firewall" will be the "updatevm",
the "clockvm" and the "default_netvm".

If you want an easy to configure firewall with ad blocking, checkout
sys-pihole instead.

## Installation

Before installation, rename your current `sys-firewall` to another name such
as `sys-firewall-old`, the old qube will be used to install packages required
for the minimal template. After successful installation and testing the new
net qube capabilities, you can remove the old one. If you want the default net
qube back, just set `sys-firewall` template to the full template you are
using, such as Debian or Fedora. Before starting, turn on `sys-firewall-old`
or yours `default_netvm` and check if DNS is working, after that, proceed with
the installation.

*   Top:

```sh
sudo qubesctl top.enable sys-firewall
sudo qubesctl --targets=tpl-sys-firewall state.apply
sudo qubesctl top.disable sys-firewall
sudo qubesctl state.apply sys-firewall.prefs-disp
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply sys-firewall.create
sudo qubesctl --skip-dom0 --targets=tpl-sys-firewall state.apply sys-firewall.install
sudo qubesctl state.apply sys-firewall.prefs-disp
```

<!-- pkg:end:post-install -->

Alternatively, if you prefer to have an app qube as the firewall:

```sh
sudo qubesctl state.apply sys-firewall.prefs
```

## Usage

You should use this qube for handling updates and firewall downstream/client
qubes, in other words, enforce network policy to qubes that have
`sys-firewall` as its `netvm`. Read [upstream firewall
documentation](https://www.qubes-os.org/doc/firewall/).
