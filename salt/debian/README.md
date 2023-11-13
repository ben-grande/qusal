# debian

Debian Template in Qubes OS.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)

## Description

Creates the Debian template as well as a Disposable Template based on it.

## Installation

- Top:
```sh
qubesctl top.enable debian
qubesctl --targets=debian-12 state.apply
qubesctl top.disable debian
```

- State:
<!-- pkg:begin:post-install -->
```sh
qubesctl state.apply debian.create
qubesctl --skip-dom0 --targets=debian-12 state.apply debian.install
```
<!-- pkg:end:post-install -->

## Usage

AppVMs and StandaloneVMs can be based on this template.
