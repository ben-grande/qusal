# mgmt

## Table of Contents

* [Description](#description)
* [Installation](#installation)

## Description

Management console environment on Qubes OS.

A Template for DispVMs will be created and named "dvm-mgmt" and become the
global "management_dispvm". It will be used when opening a disposable console
of a qube or for Salt Management on DomUs.

## Installation

- State:
```sh
qubesctl state.apply mgmt.create
qubesctl --skip-dom0 --targets=tpl-mgmt state.apply mgmt.install
qubesctl state.apply mgmt.prefs
```
