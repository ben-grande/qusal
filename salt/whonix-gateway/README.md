# whonix-gateway

Whonix Gateway Template in Qubes OS.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)

## Description

Creates the Whonix Gateway templates as well as a Disposable Template based on
it.

## Installation

- Top:
```sh
qubesctl top.enable whonix-gateway
qubesctl --targets=whonix-gateway-17 state.apply
qubesctl top.disable whonix-gateway
qubesctl state.apply whonix-gateway.appmenus
```

- State:
<!-- pkg:begin:post-install -->
```sh
qubesctl state.apply whonix-gateway.create
qubesctl --skip-dom0 --targets=whonix-gateway-17 state.apply whonix-gateway.install
qubesctl state.apply whonix-gateway.appmenus
```
<!-- pkg:end:post-install -->

## Usage

AppVMs and StandaloneVMs can be based on this template.
