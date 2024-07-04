# debian-xfce

Debian Xfce Template in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)

## Description

Creates the Debian Xfce Template as well as a Disposable Template based on it.

## Installation

*   Top:

```sh
sudo qubesctl top.enable debian-xfce
sudo qubesctl --targets=debian-12-xfce state.apply
sudo qubesctl top.disable debian-xfce
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply debian-xfce.create
sudo qubesctl --skip-dom0 --targets=debian-12-xfce state.apply debian-xfce.install
```

<!-- pkg:end:post-install -->

## Usage

AppVMs and StandaloneVMs can be based on this template.
