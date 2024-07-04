# kicksecure-minimal

Kicksecure Minimal Template in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
    *   [Kicksecure Developers Installation](#kicksecure-developers-installation)
*   [Usage](#usage)
    *   [Kicksecure Developers Usage](#kicksecure-developers-usage)

## Description

Creates the Kicksecure Minimal template as well as a Disposable Template based
on it.

## Installation

*   Top:

```sh
sudo qubesctl top.enable kicksecure-minimal
sudo qubesctl --targets=kicksecure-17-minimal state.apply
sudo qubesctl top.disable kicksecure-minimal
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply kicksecure-minimal.create
sudo qubesctl --skip-dom0 --targets=kicksecure-17-minimal state.apply kicksecure-minimal.install
```

<!-- pkg:end:post-install -->

### Kicksecure Developers Installation

If you want to help improve Kicksecure integration on Qubes, install packages
that are known to be broken on Qubes and can break the boot of the Kicksecure
Qube, to report bugs upstream (get a terminal with `qvm-console-dispvm`):

```sh
sudo qubesctl --skip-dom0 --targets=kicksecure-17-minimal state.apply kicksecure-minimal.install-developers
```

Choose the `kernel` according to the `virt_mode` you want for the template:

*   `hvm`:

```sh
sudo qubesctl state.apply kicksecure-minimal.kernel-hvm
```

*   `pvh`:

```sh
sudo qubesctl state.apply kicksecure-minimal.kernel-pv
```

*   Dom0 provided kernel (resets `virt_mode` to `pvh`):

```sh
sudo qubesctl state.apply kicksecure-minimal.kernel-default
```

## Usage

AppVMs and StandaloneVMs can be based on this template.

### Kicksecure Developers Usage

This is intended for Kicksecure Developers to test known to be broken
hardening measures. It is not intended for other developers or users.

After you have ran the developers SaltFile, when reporting bugs upstream,
share the following information of the customizations made by this formula:

*   `hardened-malloc`:

```txt
libhardened_malloc.so
```

*   `hide-hardware-info`:

```sh
sysfs_whitelist=0
cpuionfo_whitelist=0
```

*   `permission-hardener`:

```sh
whitelists_disable_all=true
```
