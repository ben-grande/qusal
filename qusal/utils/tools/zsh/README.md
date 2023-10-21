# zsh

## Table of Contents

* [Description](#description)
* [Installation](#installation)

## Description

Zsh installation for Qubes OS.

Install Zsh, setup it to be the user shell and touch ~/.zshrc to avoid
warnings.

## Installation

- Top
```sh
qubesctl top.enable utils.tools.zsh
qubesctl --targets=TARGET state.apply
qubesctl top.disable utils.tools.zsh
```

- State
```sh
qubesctl --skip-dom0 --targets=TEMPLATEVMS state.apply utils.tools.zsh.change-shell
qubesctl --skip-dom0 --targets=APPVMS state.apply utils.tools.zsh.touch-zshrc
```
