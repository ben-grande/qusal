# remmina

Remmina Remote Desktop Client in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)

## Description

Creates a disposable template named "dvm-remmina". From it, you can create
disposables for Remmina usage for SSH, VNC, SPICE, HTTP(S), X2Go and more. If
you prefer to use an app qube, a qube named "remmina" will also be created.

## Installation

*   Top:

```sh
sudo qubesctl top.enable remmina
sudo qubesctl --targets=tpl-remmina state.apply
sudo qubesctl top.disable remmina
sudo qubesctl state.apply remmina.appmenus
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply remmina.create
sudo qubesctl --skip-dom0 --targets=tpl-remmina state.apply remmina.install
sudo qubesctl state.apply remmina.appmenus
```

<!-- pkg:end:post-install -->

## Usage

You will use Remmina to access remote computers, be it though a login shell
(SSH) or through a desktop connection (VNC, SPICE, HTTP, X2Go).

You can base your qubes of `dvm-remmina` for disposables or `remmina` for
persistence of data.
