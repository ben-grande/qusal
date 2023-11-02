# sys-mirage-firewall

## Table of Contents

* [Description](#description)
* [Installation](#installation)

## Description

Mirage Firewall on Qubes OS.

Creates a Mirage Firewall qube named "sys-mirage-firewall". It is an OCaml
program compiled to run as an operating system kernel, in this case, a
MirageOS unikernel replacement for the default firewall (sys-firewall). It
pulls in just the code it needs as libraries.

Contrary to a standard Linux Firewall, Mirage Firewall doesn't need a full
system to run an excessive resources.

## Installation

- Top
```sh
qubesctl top.enable sys-mirage-firewall
qubesctl state.apply
qubesctl top.disable sys-mirage-firewall
```

- State
```sh
qubesctl state.apply sys-mirage-firewall.create
```

Set qubes `netvm` to `sys-mirage-firewall`:
```sh
qvm-prefs --set QUBE netvm sys-mirage-firewall
```

## Usage

From Dom0, set the firewall rules with `qvm-firewall`.

From Dom0, inspect the Unikernel console:
```sh
sudo xl console sys-mirage-firewall
```
Exit the console with `Ctrl-]`.

## Credits

- [Unman](https://github.com/unman/shaker/tree/master/mirage)
