# fedora

Fedora Xfce Template in Qubes OS.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)

## Description

Creates the Fedora Xfce template as well as a Disposable Template based on it.

## Installation

- Top:
```sh
qubesctl top.enable fedora-xfce
qubesctl --targets=fedora-39-xfce state.apply
qubesctl top.disable fedora-xfce
```

- State:
<!-- pkg:begin:post-install -->
```sh
qubesctl state.apply fedora-xfce.create
qubesctl --skip-dom0 --targets=fedora-39-xfce state.apply fedora-xfce.install
```
<!-- pkg:end:post-install -->

## Usage

AppVMs and StandaloneVMs can be based on this template.
