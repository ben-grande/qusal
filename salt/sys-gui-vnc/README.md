# sys-gui-vnc

VNC GUI domain in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Uninstallation](#uninstallation)
*   [Usage](#usage)

## Description

Setup a VNC GUI domain named "sys-gui-vnc". The qube spawns a VNC server and
you can connect from other qubes to it. It is primarily intended for remote
administration.

## Installation

WARNING: [unfinished formula](../../docs/TROUBLESHOOT.md#no-support-for-unfinished-formulas).

*   Top:

```sh
sudo qubesctl top.enable qvm.sys-gui pillar=True
sudo qubesctl top.enable sys-gui-vnc
sudo qubesctl --targets=tpl-sys-gui,sys-gui-vnc state.apply
sudo qubesctl top.disable sys-gui-vnc
sudo qubesctl state.apply sys-gui-vnc.prefs
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl top.enable qvm.sys-gui pillar=True
sudo qubesctl state.apply sys-gui-vnc.create
sudo qubesctl --skip-dom0 --targets=tpl-sys-gui state.apply sys-gui-vnc.install
sudo qubesctl --skip-dom0 --targets=sys-gui-vnc state.apply sys-gui-vnc.configure
sudo qubesctl state.apply sys-gui-vnc.prefs
```

<!-- pkg:end:post-install -->

Shutdown all your running qubes as the global property `default_guivm` has
changed to `sys-gui-vnc`.

## Access control

_Default policy_: `any qube` is `denied` to connected to any other qube.

Allow qube `sys-remote` to connect `sys-gui-vnc` on port `5900`:

```qrexecpolicy
qubes.ConnectTCP +5900 sys-remote @default allow target=sys-gui-vnc
qubes.ConnectTCP *     sys-remote @anyvm   deny
```

## Usage

Qubes that have their `guivm` preference set to `sys-gui-vnc`, will use it as
the GUI domain.

It unnecessary to have a `netvm` set for the VNC client qube for testing, but
it is necessary to make the VNC server accessible from remote computers. If
you plan to expose `sys-gui-vnc` to the network, it must have another
authenticated transport such as a `VPN` or `VNC over SSH`.

From a trusted qube that has a VNC client installed, such as
[remmina](../remmina/README.md), bind the port `6000` to the port `5900`
listening on `sys-gui-vnc`:

```sh
qvm-connnect-tcp 6000::5900
```

On the VNC client application, set connection protocol to `VNC` and host to
`127.0.0.1:6000`.

The login credentials are the same used in `dom0`, the first user in the
`qubes` group and the corresponding password.

## Uninstallation

Set Global preference `default_guivm` to `dom0` and disable `autostart` of
`sys-gui-vnc`:

```sh
sudo qubesctl state.apply sys-gui-vnc.cancel
```

You must also revert exposing the VNC server to other qubes and remote hosts:

*   Delete or deny calls to Qrexec policy rules allowing qubes to connect with
    `qubes.ConnectTCP` to `sys-gui-vnc`; and
*   Close firewall ports and disable services that expose the VNC client qube
    to external hosts.
