# xfce

Xfce environment in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)

## Description

Configure Xfce.

## Installation

*   Top:

```sh
sudo qubesctl top.enable utils.tools.xfce
sudo qubesctl --targets=TARGET state.apply
sudo qubesctl top.disable utils.tools.xfce
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl --skip-dom0 --targets=TEMPLATEVMS,APPVMS state.apply utils.tools.xfce
```

<!-- pkg:end:post-install -->

## Usage

Standard Xfce usage. No extra configuration required.
