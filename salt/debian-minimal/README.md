# debian-minimal

Debian Minimal Template in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)

## Description

Creates the Debian Minimal template as well as a Disposable Template based on
it.

## Installation

*   Top:

```sh
sudo qubesctl top.enable debian-minimal
sudo qubesctl --targets=debian-12-minimal state.apply
sudo qubesctl top.disable debian-minimal
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply debian-minimal.create
sudo qubesctl --skip-dom0 --targets=debian-12-minimal state.apply debian-minimal.install
```

<!-- pkg:end:post-install -->

## Usage

AppVMs and StandaloneVMs can be based on this minimal template.
