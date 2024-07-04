# fedora

Fedora Template in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)

## Description

Creates the Fedora template as well as a Disposable Template based on it.

## Installation

*   Top:

```sh
sudo qubesctl top.enable fedora
sudo qubesctl --targets=fedora-40 state.apply
sudo qubesctl top.disable fedora
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply fedora.create
sudo qubesctl --skip-dom0 --targets=fedora-40 state.apply fedora.install
```

<!-- pkg:end:post-install -->

## Usage

AppVMs and StandaloneVMs can be based on this template.
