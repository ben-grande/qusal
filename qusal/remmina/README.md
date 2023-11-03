# remmina

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)

## Description

Remmina Remote Desktop Client in Qubes OS.

Creates a disposable template named "dvm-remmina". From it, you can create
disposables for Remmina usage for SSH, VNC, SPICE, HTTP(S), X2Go and more. If
you prefer to use an app qube, a qube named "remmina" will also be created.

## Installation

- Top:
```sh
qubesctl top.enable remmina
qubesctl --targets=tpl-remmina state.apply
qubesctl top.disable remmina
qubesctl state.apply remmina.appmenus
```

- State:
```sh
qubesctl state.apply remmina.create
qubesctl --skip-dom0 --targets=tpl-remmina state.apply remmina.install
qubesctl state.apply remmina.appmenus
```

## Usage

You will use Remmina to access remote computers, be it though a login shell
(SSH) or through a desktop connection (VNC, SPICE, HTTP, X2Go).

You can base your qubes of `dvm-remmina` for disposables or `remmina` for
persistence of data.
