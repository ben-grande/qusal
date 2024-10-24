# sys-electrs

Electrs in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)
*   [Credits](#credits)

## Description

Setup an offline Electrs (Electrum Server) qube named "sys-electrs",
connected to your own full node running on "sys-bitcoin" to index the
blockchain to allow for efficient query of the history of arbitrary addresses.

A disposable qube "disp-electrs-builder" will be created, it will serve to
install and verify Electrs. After the verification succeeds, files are copied
to the template "tpl-sys-electrs". This method was chosen so the server can be
always offline.

At least `200GB` of disk space is required.

## Installation

This formula depends on [sys-bitcoin](../sys-bitcoin/README.md).

*   Top:

```sh
sudo qubesctl top.enable sys-electrs
sudo qubesctl --targets=sys-bitcoin-gateway,tpl-electrs-builder,tpl-sys-electrs,disp-electrs-builder,sys-electrs state.apply
sudo qubesctl top.disable sys-electrs
sudo qubesctl state.apply sys-electrs.appmenus
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply sys-electrs.create
sudo qubesctl --skip-dom0 --targets=sys-bitcoin-gateway state.apply sys-bitcoin.configure-gateway
sudo qubesctl --skip-dom0 --targets=tpl-electrs-builder state.apply sys-electrs.install-builder
sudo qubesctl --skip-dom0 --targets=tpl-sys-electrs state.apply sys-electrs.install
sudo qubesctl --skip-dom0 --targets=disp-electrs-builder state.apply sys-electrs.configure-builder
sudo qubesctl --skip-dom0 --targets=sys-electrs state.apply sys-electrs.configure
sudo qubesctl state.apply sys-electrs.appmenus
```

<!-- pkg:end:post-install -->

## Usage

You may customize Electrs by writing to the file
`~/.electrs/conf.d/electrs.conf.local`.

If you are not using [sys-bitcoin](../sys-bitcoin/README.md), you will need to
add the RPC Authentication cookie to the qube `sys-electrs` in the file
`~/.bitcoin/.cookie`. Make sure there is no new line at the end of the cookie
file, else Electrs will fail to start.

## Credits

*   [qubenix](https://github.com/qubenix/qubes-whonix-bitcoin)
