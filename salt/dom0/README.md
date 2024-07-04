# dom0

Dom0 environment in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
    *   [Choose your Dom0 environment](#choose-your-dom0-environment)
*   [Usage](#usage)

## Description

Configure Dom0 window manager, install packages, backup scripts and profile
etc.

## Installation

*   Top:

```sh
sudo qubesctl top.enable dom0
sudo qubesctl state.apply
sudo qubesctl top.disable dom0
sudo qubesctl --skip-dom0 --templates --standalones state.apply update.qubes-vm
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply dom0
sudo qubesctl --skip-dom0 --templates --standalones state.apply update.qubes-vm
```

<!-- pkg:end:post-install -->

If you need to develop in Dom0, install some goodies (bare bones):

```sh
sudo qubesctl state.apply dom0.install-dev
```

To forward ports from qubes to the external world:

```sh
sudo qubesctl state.apply dom0.port-forward
```

### Choose your Dom0 environment

Instead of running the state `dom0`, you can select which states to apply:

*   Window Manager i3:

```sh
sudo qubesctl state.apply dom0.desktop-i3,dom0.desktop-i3-settings
```

*   Window Manager AwesomeWM:

```sh
sudo qubesctl state.apply dom0.desktop-awesome
```

Follow the same syntax for other `dom0` states you desire.

## Usage

You may have noticed the desktop experience in Dom0 has enhanced. You are
using KDE now. You can enforce domains to appear in certain activity with KWin
rules, a tool `qubes-kde-win-rules` is provided to assist you.

Qubes backup has also improved, you have a profile provided as an example on
how to do backups with native Qubes OS tools. Use the tool
`qvm-backup-find-last` to find the last Qubes Backup made locally to a qube or
a remote system, this facilitates verifying the last backup made with
`qvm-backup-restore --verify-only`. An example is provided in
`/etc/qubes/backup/qusal.conf.example`.
