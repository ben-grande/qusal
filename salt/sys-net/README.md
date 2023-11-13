# sys-net

PCI handler of Network devices in Qubes OS.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)

## Description

Creates and configure qubes for handling the network devices. Qubes OS
provides the state "qvm.sys-net", but it will create only "sys-net", which can
be a disposable or not. This package takes a different approach, it will
create an AppVM "sys-net" and a DispVM "disp-sys-net".

By default, the chosen one is "sys-net", but you can choose which qube type
becomes the upstream net qube "default_netvm", the "clockvm" and the fallback
target for the "qubes.UpdatesProxy" service in case no rule matched before.

## Installation

Before installation, rename your current `sys-net` to another name such as
`sys-net-old`, the old qube will be used to install packages require for the
template. After successful installation and testing the new net qube
capabilities, you can remove the old one. If you want the default net qube
back, just set `sys-net` template to the full template you are using, such as
Debian or Fedora.

- Top:
```sh
qubesctl top.enable sys-net
qubesctl --targets=tpl-sys-net state.apply
qubesctl top.disable sys-net
qubesctl state.apply sys-net.prefs
```

- State:
<!-- pkg:begin:post-install -->
```sh
qubesctl state.apply sys-net.create
qubesctl --skip-dom0 --targets=tpl-sys-net state.apply sys-net.install
qubesctl state.apply sys-net.prefs
```
<!-- pkg:end:post-install -->

Alternatively, if you prefer to have a disposable net qube:
```sh
qubesctl state.apply sys-net.prefs-disp
```

You might need to install some firmware on the template for your network
drivers. Check files/admin/firmware.txt.

## Usage

A network manager is provided in `sys-net`, from there you can manager Wi-Fi
or Ethernet cable connections. You can also use it for network monitoring. It
should be relied on to hold firewall rules for other qubes, use
`sys-firewall`, `sys-pihole` or `sys-mirage-firewall` for that purpose.
