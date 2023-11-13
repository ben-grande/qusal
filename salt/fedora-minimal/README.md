# fedora-minimal

Fedora Minimal Template in Qubes OS.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)


## Description

Creates the Fedora Minimal template as well as a Disposable Template based on
it.

## Installation

- Top:
```sh
qubesctl top.enable fedora-minimal
qubesctl --targets=fedora-38-minimal state.apply
qubesctl top.disable fedora-minimal
```

- State:
<!-- pkg:begin:post-install -->
```sh
qubesctl state.apply fedora-minimal.create
qubesctl --skip-dom0 --targets=fedora-38-minimal state.apply fedora-minimal.install
```
<!-- pkg:end:post-install -->

## Usage

AppVMs and StandaloneVMs can be based on this minimal template.
