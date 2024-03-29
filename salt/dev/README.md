# dev

Development environment in Qubes OS.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)

## Description

Setup a development qube named "dev". Defines the user interactive shell,
installing goodies, applying dotfiles, being client of sys-pgp, sys-git and
sys-ssh-agent.

## Installation

- Top
```sh
sudo qubesctl top.enable dev
sudo qubesctl --targets=tpl-dev,dvm-dev,dev state.apply
sudo qubesctl top.disable dev
```

- State
<!-- pkg:begin:post-install -->
```sh
sudo qubesctl state.apply dev.create
sudo qubesctl --skip-dom0 --targets=tpl-dev state.apply dev.install
sudo qubesctl --skip-dom0 --targets=dvm-dev state.apply dev.configure-dvm
sudo qubesctl --skip-dom0 --targets=dev state.apply dev.configure
```
<!-- pkg:end:post-install -->

## Usage

The development qube `dev` can be used for:

- code development;
- building programs;
- signing commits, tags, pushes and verifying with split-gpg;
- fetching and pushing to and from local qube repository with split-git; and
- fetching and pushing to and from remote repository with split-ssh-agent.
