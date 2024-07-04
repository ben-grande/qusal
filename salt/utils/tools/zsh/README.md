# zsh

Zsh environment in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)

## Description

Install Zsh, setup it to be the user shell and touch ~/.zshrc to avoid
warnings.

## Installation

*   Top:

```sh
sudo qubesctl top.enable utils.tools.zsh
sudo qubesctl --targets=TARGET state.apply
sudo qubesctl top.disable utils.tools.zsh
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl --skip-dom0 --targets=TEMPLATEVMS state.apply utils.tools.zsh.change-shell
sudo qubesctl --skip-dom0 --targets=APPVMS state.apply utils.tools.zsh.touch-zshrc
```

<!-- pkg:end:post-install -->

## Usage

Standard Zsh usage. No extra configuration required.
