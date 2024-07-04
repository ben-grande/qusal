# sys-wireguard

Wireguard VPN in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)
*   [Credits](#credits)

## Description

Setup a Wireguard VPN qube named "sys-wireguard" to provide network access to
other qubes through the VPN with fail closed mechanism.

## Installation

*   Top:

```sh
sudo qubesctl top.enable sys-wireguard
sudo qubesctl --targets=tpl-sys-wireguard,sys-wireguard state.apply
sudo qubesctl top.disable sys-wireguard
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply sys-wireguard.create
sudo qubesctl --skip-dom0 --targets=tpl-sys-wireguard state.apply sys-wireguard.install
sudo qubesctl --skip-dom0 --targets=sys-wireguard state.apply sys-wireguard.configure
```

<!-- pkg:end:post-install -->

## Usage

Use the VPN qube `sys-wireguard` to enforce incoming and outgoing connections
from clients connected to the VPN with a fail safe mechanism.

To start using the VPN:

1.  Copy the Wireguard configuration you downloaded to `sys-wireguard` and
    place it in `/home/user/wireguard.conf`.
2.  Run from Dom0 to apply Qubes Firewall rules: `qvm-wireguard`

## Credits

*   [Unman](https://github.com/unman/shaker/tree/main/mullvad)
