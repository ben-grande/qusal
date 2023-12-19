# whonix

Whonix Template in Qubes OS.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)

## Description

Creates the Whonix Gateway and Workstation templates as well as a Disposable
Template based on it.

## Installation

- Top:
```sh
qubesctl top.enable whonix
qubesctl --targets=whonix-workstation-17,whonix-gateway-17 state.apply
qubesctl top.disable whonix
```

- State:
<!-- pkg:begin:post-install -->
```sh
qubesctl state.apply whonix.create
qubesctl --skip-dom0 --targets=whonix-workstation-17,whonix-gateway-17 state.apply whonix.install
```
<!-- pkg:end:post-install -->

## Usage

AppVMs and StandaloneVMs can be based on this template.
