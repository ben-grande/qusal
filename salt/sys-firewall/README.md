# sys-firewall

Firewall in Qubes OS.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)

## Description

Creates firewall qube, an App qube "sys-firewall" and a Disposable qube
"disp-sys-firewall". By default, "sys-firewall" will be the "updatevm" and the
"default_netvm", but you can configure "disp-sys-firewall" to take on these
roles if you prefer, later instructed in the installation section below.

If you want an easy to configure firewall with ad blocking, checkout
sys-pihole instead.

## Installation

- Top:
```sh
qubesctl top.enable sys-firewall
qubesctl --targets=tpl-sys-firewall state.apply
qubesctl top.disable sys-firewall
qubesctl state.apply sys-firewall.prefs
```

- State:
<!-- pkg:begin:post-install -->
```sh
qubesctl state.apply sys-firewall.create
qubesctl --skip-dom0 --targets=tpl-sys-firewall state.apply sys-firewall.install
qubesctl state.apply sys-firewall.prefs
```
<!-- pkg:end:post-install -->

Alternatively, if you prefer to have a disposable firewall:
```sh
qubesctl state.apply sys-firewall.prefs-disp
```

## Usage

You should use this qube for handling updates and firewall downstream/client
qubes, in other words, enforce network policy to qubes that have
`sys-firewall` as its `netvm`. Read [upstream firewall
documentation](https://www.qubes-os.org/doc/firewall/).
