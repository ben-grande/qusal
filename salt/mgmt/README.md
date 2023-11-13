# mgmt

Management console environment in Qubes OS.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)

## Description

A Template for DispVMs will be created and named "dvm-mgmt" and become the
global "management_dispvm". It will be used when opening a disposable console
of a qube or for Salt Management on DomUs.

## Installation

- Top:
```sh
qubesctl top.enable mgmt
qubesctl --skip-dom0 --targets=tpl-mgmt state.apply
qubesctl top.disable mgmt
qubesctl state.apply mgmt.prefs
```

- State:
<!-- pkg:begin:post-install -->
```sh
qubesctl state.apply mgmt.create
qubesctl --skip-dom0 --targets=tpl-mgmt state.apply mgmt.install
qubesctl state.apply mgmt.prefs
```
<!-- pkg:end:post-install -->

## Usage

You will use the Template for DispVMs "dvm-mgmt" indirectly when running salt
states on minions/DomUs or when opening a disposable console of a qube.
