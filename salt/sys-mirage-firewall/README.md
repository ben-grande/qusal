# sys-mirage-firewall

Mirage Firewall in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)
*   [Credits](#credits)

## Description

Creates a Mirage Firewall qube named "disp-sys-mirage-firewall". It is an
OCaml program compiled to run as an operating system kernel, in this case, a
MirageOS unikernel replacement for the default firewall (sys-firewall). It
pulls in just the code it needs as libraries.

Contrary to a standard Linux Firewall, Mirage Firewall doesn't need a full
system to run an excessive resources.

You can't use Mirage Firewall to be the updatevm, use another qube instead.

## Installation

We have built the Unikernel locally and verified that the upstream checksum
and local checksum matched when comparing the same release.

*   Top:

```sh
sudo qubesctl top.enable sys-mirage-firewall
sudo qubesctl state.apply
sudo qubesctl top.disable sys-mirage-firewall
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply sys-mirage-firewall.create
```

<!-- pkg:end:post-install -->

## Usage

Set qubes `netvm` to `disp-sys-mirage-firewall`:

```sh
qvm-prefs --set QUBE netvm disp-sys-mirage-firewall
```

To test the firewall, apply rules with `qvm-firewall`.

For monitoring, inspect the Unikernel console:

```sh
sudo xl console disp-sys-mirage-firewall
```

Exit the console with `Ctrl-]`.

## Credits

*   [Unman](https://github.com/unman/shaker/tree/main/mirage)
*   [Thien Tran](https://privsec.dev/posts/qubes/firewalling-with-mirageos-on-qubes-os/)
