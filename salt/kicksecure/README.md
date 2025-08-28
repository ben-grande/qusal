# kicksecure

Kicksecure Template in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)

## Description

Creates the Kicksecure template as well as a Disposable Template based on
it.

## Installation

*   Top:

```sh
sudo qubesctl top.enable kicksecure
sudo qubesctl --targets=kicksecure-17 state.apply
sudo qubesctl top.disable kicksecure
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply kicksecure.create
sudo qubesctl --skip-dom0 --targets=kicksecure-17 state.apply kicksecure.install
```

<!-- pkg:end:post-install -->

## Usage

AppVMs and StandaloneVMs can be based on this template.
