# whonix-workstation

Whonix Workstation Template in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)

## Description

Creates the Whonix Workstation templates as well as a Disposable Template
based on it.

## Installation

*   Top:

```sh
sudo qubesctl top.enable whonix-workstation
sudo qubesctl --targets=whonix-workstation-17 state.apply
sudo qubesctl top.disable whonix-workstation
sudo qubesctl state.apply whonix-workstation.appmenus
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply whonix-workstation.create
sudo qubesctl --skip-dom0 --targets=whonix-workstation-17 state.apply whonix-workstation.install
sudo qubesctl state.apply whonix-workstation.appmenus
```

<!-- pkg:end:post-install -->

## Usage

AppVMs and StandaloneVMs can be based on this template.
