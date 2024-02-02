# kicksecure-minimal

Kicksecure Minimal Template in Qubes OS.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)

## Description

Creates the Kicksecure Minimal template as well as a Disposable Template based
on it.

## Installation

- Top:
```sh
qubesctl top.enable kicksecure-minimal
qubesctl --targets=kicksecure-17-minimal state.apply
qubesctl top.disable kicksecure-minimal
qubesctl state.apply kicksecure-minimal.prefs
```

- State:
<!-- pkg:begin:post-install -->
```sh
qubesctl state.apply kicksecure-minimal.create
qubesctl --skip-dom0 --targets=kicksecure-17-minimal state.apply kicksecure-minimal.install
qubesctl state.apply kicksecure-minimal.prefs
```
<!-- pkg:end:post-install -->

If you want to help improve Kicksecure integration on Qubes, install packages
that are known to be broken on Qubes and can break the boot of the Kicksecure
Qube, to report bugs upstream (get a terminal with `qvm-console-dispvm`):
```sh
qubesctl --skip-dom0 --targets=kicksecure-17-minimal state.apply kicksecure-minimal.install-developers
```

## Usage

AppVMs and StandaloneVMs can be based on this template.

### Kicksecure Developers

This is intended for Kicksecure Developers to test known to be broken
hardening measures. It is not intended for other developers or users.

After you have ran the developers SaltFile, when reporting bugs upstream,
share the following information of the customizations made by this formula:

- `hardened-malloc`:
```
libhardened_malloc.so
```

- `hide-hardware-info`:
```
sysfs_whitelist=0
cpuionfo_whitelist=0
```

- `permission-hardener`:
```
whitelists_disable_all=true
```
