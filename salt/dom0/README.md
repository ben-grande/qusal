# dom0

Dom0 environment in Qubes OS.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)

## Description

Configure Dom0 window manager, install packages, backup scripts and profile
etc.

## Installation

- Top
```sh
qubesctl top.enable dom0
qubesctl state.apply
qubesctl top.disable dom0
```

- State
<!-- pkg:begin:post-install -->
```sh
qubesctl state.apply dom0
```
<!-- pkg:end:post-install -->

If you need to develop in Dom0, install some goodies (bare bones):
```sh
qubesctl state.apply dom0.install-dev
```

## Usage

You may have noticed the desktop experience in Dom0 has enhanced. You are
using KDE now. You can enforce domains to appear in certain activity with KWin
rules, a tool `qubes-kde-win-rules` is provided to assist you.

Qubes backup has also improved, you may use `qvm-backup --profile qusal`,
the profile provided is an example. Use the tool `qvm-backup-find-last` to
find the last Qubes Backup made locally to a qube or a remote system, this
facilitates verifying the last backup made with `qvm-backup-restore
--verify-only`. An example is provided in /etc/qubes/backup/qusal.conf.
