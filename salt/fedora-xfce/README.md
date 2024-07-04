# fedora-xfce

Fedora Xfce Template in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)

## Description

Creates the Fedora Xfce template as well as a Disposable Template based on it.

## Installation

*   Top:

```sh
sudo qubesctl top.enable fedora-xfce
sudo qubesctl --targets=fedora-40-xfce state.apply
sudo qubesctl top.disable fedora-xfce
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply fedora-xfce.create
sudo qubesctl --skip-dom0 --targets=fedora-40-xfce state.apply fedora-xfce.install
```

<!-- pkg:end:post-install -->

## Usage

AppVMs and StandaloneVMs can be based on this template.
