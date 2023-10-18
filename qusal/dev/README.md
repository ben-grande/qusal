# dev

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Copyright](#copyright)

## Description

Development environment on Qubes OS.

Setup a development qube named "dev". Defines the user interactive shell,
installing goodies, applying dotfiles, being client of sys-pgp, sys-git and
sys-ssh-agent.

## Installation

- Top
```sh
qubesctl top.enable dev
qubesctl --targets=tpl-dev,disp-dev,dev state.apply
qubesctl top.disable dev
```

- State
```sh
qubesctl state.apply dev.create
qubesctl --skip-dom0 --targets=tpl-dev state.apply dev.install
qubesctl --skip-dom0 --targets=dev state.apply dev.configure
```

## Copyright

License: GPLv3+
