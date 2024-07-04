# sys-net

PCI handler of network devices in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Access control](#access-control)
*   [Usage](#usage)

## Description

Creates and configure qubes for handling the network devices. Qubes OS
provides the state "qvm.sys-net", but it will create only "sys-net", which can
be a disposable or not. This package takes a different approach, it will
create an AppVM "sys-net" and a DispVM "disp-sys-net".

By default, the chosen one is "disp-sys-net", but you can choose which qube
type becomes the upstream net qube "default_netvm" and the fallback target for
the "qubes.UpdatesProxy" service in case no rule matched before.

## Installation

Before installation, rename your current `sys-net` to another name such as
`sys-net-old`, the old qube will be used to install packages required for the
minimal template. After successful installation and testing the new net qube
capabilities, you can remove the old one. If you want the default net qube
back, just set `sys-net` template to the full template you are using, such as
Debian or Fedora. Before starting, turn on the `default_netvm` and check if
DNS is working, after that, proceed with the installation.

*   Top:

```sh
sudo qubesctl top.enable sys-net
sudo qubesctl --targets=tpl-sys-net state.apply
sudo qubesctl top.disable sys-net
sudo qubesctl state.apply sys-net.prefs-disp
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply sys-net.create
sudo qubesctl --skip-dom0 --targets=tpl-sys-net state.apply sys-net.install
sudo qubesctl state.apply sys-net.prefs-disp
```

<!-- pkg:end:post-install -->

If you need to debug a net qube, install some helper tools:

```sh
sudo qubesctl --skip-dom0 --targets=tpl-sys-net state.apply sys-net.install-debug
```

If you prefer to have an app qube as the net qube:

```sh
sudo qubesctl state.apply sys-net.prefs
```

You might need to install some firmware on the template for your network
drivers. Check files/admin/firmware.txt.

## Access control

_Default policy_: every call is denied.

As every call is denied by default, you need to add rules to you Qrexec policy
for a call to occur. Some examples are represented below.

Qube `dev` can ask to connect to `github.com:22` from `disp-sys-net`:

```qrexecpolicy
qusal.ConnectTCP +github.com+22 dev @default ask target=disp-sys-net
qusal.ConnectTCP *              dev @anyvm   deny
```

## Usage

A network manager is provided in `sys-net`, from there you can manager Wi-Fi
or Ethernet cable connections. You can also use it for network monitoring. It
should be relied on to hold firewall rules for other qubes, use
`sys-firewall`, `sys-pihole` or `sys-mirage-firewall` for that purpose.
