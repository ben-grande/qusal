# debian

Debian Xfce Template in Qubes OS.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)

## Description

Creates the Debian Xfce Template as well as a Disposable Template based on it.

## Installation

- Top:
```sh
qubesctl top.enable debian-xfce
qubesctl --targets=debian-12-xfce state.apply
qubesctl top.disable debian-xfce
```

- State:
<!-- pkg:begin:post-install -->
```sh
qubesctl state.apply debian-xfce.create
qubesctl --skip-dom0 --targets=debian-12-xfce state.apply debian-xfce.install
```
<!-- pkg:end:post-install -->

## Usage

AppVMs and StandaloneVMs can be based on this template.
