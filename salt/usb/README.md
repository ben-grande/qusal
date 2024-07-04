# usb

USB client in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)

## Description

A Template for DispVMs will be created and named "dvm-usb", from this qube,
you can base disposable qubes, geared towards USB client usage.

## Installation

*   Top:

```sh
sudo qubesctl top.enable usb
sudo qubesctl --targets=tpl-usb state.apply
sudo qubesctl top.disable usb
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply usb.create
sudo qubesctl --skip-dom0 --targets=tpl-usb state.apply usb.install
```

<!-- pkg:end:post-install -->

## Usage

You will use the Template for DispVMs "dvm-usb" to create disposable qubes to
connect USB devices to.
