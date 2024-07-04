# mgmt

Management environment in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)

## Description

A Template for DispVMs will be created and named "dvm-mgmt" and become the
global "management_dispvm". It will be used when opening a disposable console
of a qube or for Salt Management on DomUs.

## Installation

*   Top:

```sh
sudo qubesctl top.enable mgmt
sudo qubesctl --targets=tpl-mgmt state.apply
sudo qubesctl top.disable mgmt
sudo qubesctl state.apply mgmt.prefs
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply mgmt.create
sudo qubesctl --skip-dom0 --targets=tpl-mgmt state.apply mgmt.install
sudo qubesctl state.apply mgmt.prefs
```

<!-- pkg:end:post-install -->

## Usage

You will use the Template for DispVMs "dvm-mgmt" indirectly when running salt
states on minions/DomUs or when opening a disposable console of a qube.
