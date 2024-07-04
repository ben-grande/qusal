# element

Element Matrix client installation in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)

## Description

Install Element and use it on the "element" app qube to connect to your
Matrix account.

## Installation

*   Top:

```sh
sudo qubesctl top.enable element
sudo qubesctl --targets=tpl-element state.apply
sudo qubesctl top.disable element
sudo qubesctl state.apply element.appmenus
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply element.create
sudo qubesctl --skip-dom0 --targets=tpl-element state.apply element.install
sudo qubesctl state.apply element.appmenus
```

<!-- pkg:end:post-install -->

## Usage

You can connect to your Matrix account via the Element client.
