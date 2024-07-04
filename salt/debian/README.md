# debian

Debian Template in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)

## Description

Creates the Debian template as well as a Disposable Template based on it.

## Installation

*   Top:

```sh
sudo qubesctl top.enable debian
sudo qubesctl --targets=debian-12 state.apply
sudo qubesctl top.disable debian
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply debian.create
sudo qubesctl --skip-dom0 --targets=debian-12 state.apply debian.install
```

<!-- pkg:end:post-install -->

## Usage

AppVMs and StandaloneVMs can be based on this template.
