# whonix-gateway

Whonix Gateway Template in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)

## Description

Creates the Whonix Gateway templates as well as a Disposable Template based on
it.

## Installation

*   Top:

```sh
sudo qubesctl top.enable whonix-gateway
sudo qubesctl --targets=whonix-gateway-17 state.apply
sudo qubesctl top.disable whonix-gateway
sudo qubesctl state.apply whonix-gateway.appmenus
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply whonix-gateway.create
sudo qubesctl --skip-dom0 --targets=whonix-gateway-17 state.apply whonix-gateway.install
sudo qubesctl state.apply whonix-gateway.appmenus
```

<!-- pkg:end:post-install -->

## Usage

AppVMs and StandaloneVMs can be based on this template.
