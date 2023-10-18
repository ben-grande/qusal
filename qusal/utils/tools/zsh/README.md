# Dev

## Table of Contents

* [Description](#description)
* [Installation](#installation)

## Description

Install and configure Zsh.

## Installation

- Top
```sh
qubesctl top.enable zsh
qubesctl --targets=TARGET state.apply
qubesctl top.disable zsh
```

- State
```sh
qubesctl --skip-dom0 --targets=TEMPLATEVMS state.apply zsh.install,zsh.change-shell,zsh.touch-zshrc
qubesctl --skip-dom0 --targets=APPVMS state.apply zsh.touch-zshrc
```
