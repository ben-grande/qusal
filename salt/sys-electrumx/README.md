# sys-electrumx

ElectrumX in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)
*   [Credits](#credits)

## Description

Setup an offline Electrumx (Electrum Server) qube named "sys-electrumx",
connected to your own full node running on "sys-bitcoin" to index the
blockchain to allow for efficient query of the history of arbitrary addresses.

A disposable qube "disp-electrumx-builder" will be created, based on
Whonix-Workstation, it will server to install and verify ElectrumX. After the
verification succeeds, files are copied to the template "tpl-sys-electrumx".
This method was chosen so the server can be always offline.

At least `200GB` of disk space is required.

## Installation

This formula depends on [sys-bitcoin](../sys-bitcoin/README.md).

*   Top:

```sh
sudo qubesctl top.enable sys-electrumx
sudo qubesctl --targets=sys-bitcoin-gateway,tpl-electrumx-builder,tpl-sys-electrumx,disp-electrumx-builder,sys-electrumx state.apply
sudo qubesctl top.disable sys-electrumx
sudo qubesctl state.apply sys-electrumx.appmenus
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply sys-electrumx.create
sudo qubesctl --skip-dom0 --targets=sys-bitcoin-gateway state.apply sys-bitcoin.configure-gateway
sudo qubesctl --skip-dom0 --targets=tpl-electrumx-builder state.apply sys-electrumx.install-builder
sudo qubesctl --skip-dom0 --targets=tpl-sys-electrumx state.apply sys-electrumx.install
sudo qubesctl --skip-dom0 --targets=disp-electrumx-builder state.apply sys-electrumx.configure-builder
sudo qubesctl --skip-dom0 --targets=sys-electrumx state.apply sys-electrumx.configure
sudo qubesctl state.apply sys-electrumx.appmenus
```

<!-- pkg:end:post-install -->

## Usage

You may customize ElectrumX by writing to the file
`~/.electrumx/conf.d/electrumx.conf.local`.

If you are not using [sys-bitcoin](../sys-bitcoin/README.md), you will need to
add the RPC Authentication cookie to the qube `sys-electrumx` in the file
`~/.bitcoin/.cookie`. Make sure there is no new line at the end of the cookie
file, else ElectrumX will fail to start.

You may want to use the command `electrumx-cli` to send commands to the
ElectrumX server.

## Credits

*   [qubenix](https://github.com/qubenix/qubes-whonix-bitcoin)
