# fedora

Fedora Template in Qubes OS.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)

## Description

Creates the Fedora template as well as a Disposable Template based on it.

## Installation

- Top:
```sh
qubesctl top.enable fedora
qubesctl --targets=fedora-39 state.apply
qubesctl top.disable fedora
```

- State:
<!-- pkg:begin:post-install -->
```sh
qubesctl state.apply fedora.create
qubesctl --skip-dom0 --targets=fedora-39 state.apply fedora.install
```
<!-- pkg:end:post-install -->

## Usage

AppVMs and StandaloneVMs can be based on this template.
