<!--
SPDX-FileCopyrightText: 2023 Qusal contributors

SPDX-License-Identifier: CC-BY-SA-4.0
-->

# qusal

## Table of Contents

* [Description](#description)
* [Installation](#installation)
  * [Requirements](#requirements)
  * [DomU](#domu)
  * [Dom0](#dom0)
* [Usage](#usage)
* [Legal](#legal)

## Description

Qusal - Salt Formulas for Qubes OS.

Qusal providers a Free and Open Source solution to customizing various tasks
in Qubes OS, from switching PCI handlers to be disposables or app qubes,
installing different pieces of software on dedicated minimal templates for
split agent operations for separating the key store from the client.

Each project is in a separate directory, but they may interact with other
projects.

If you want to edit the access control for any service, such as resolution to
allow, ask, deny or the intended target, you should always use the Qrexec
policy at /etc/qubes/policy.d/30-user.policy, as this file will take
precedence over the packaged policy.

## Installation

### Requirements

- Qubes OS R4.1.
- git

### DomU

Clone this repository in an app qube:
```sh
git clone https://github.com/ben-grande/qusal.git ~/qusal
git clone ssh://git@github.com/ben-grande/qusal.git ~/qusal
```

### Dom0

Before copying anything to Dom0, read [Qubes OS warning about
this procedure](https://www.qubes-os.org/doc/how-to-copy-from-dom0/#copying-to-dom0).

Copy this repository from some qube to Dom0 from Dom0:
```sh
mkdir -p ~/QubesIncoming/QUBE
qvm-run -p <QUBE> tar -cC </PATH/TO> qusal | tar -xvC ~/QubesIncoming/QUBE qusal
```
Example copying repository from the `dev` qube to Dom0 by running in Dom0:
```sh
mkdir -p ~/QubesIncoming/dev
qvm-run -p dev tar -cC /home/user qusal | tar -xvC ~/QubesIncoming/dev qusal
```

Copy the files to the Salt directories:
```sh
cd qusal
./scripts/setup.sh
```

The RPM Spec is not ready, don't try it unless for development.

## Usage

Qusal is now installed. Please read the README.md of each project for further
information on how to install the desired package.

Qubes global settings (qubes-prefs) that will be managed:

- **clockvm**: disp-sys-net, sys-net
- **default_dispvm**: reader
- **default_netvm**: sys-pihole, sys-firewall or disp-sys-firewall
- **management_dispvm**: dvm-mgmt
- **updatevm**: sys-pihole, sys-firewall or disp-sys-firewall

To be implemented:
- **default_audiovm**: sys-audio
- **default_guivm**: sys-gui

## Legal

This project is [REUSE-compliant](https://reuse.software). It is difficult to
list all licenses and copyrights and keep them up-to-date here.

The easiest way to get the copyright and license of the project with the reuse
tool:
```sh
reuse spdx
```

You can also check these information manually by checking in the file header,
a companion `.license` or in `.reuse/dep5`.

Here is a brief summary as of October 2023:

- All original source code is licensed under GPL-3.0-or-later.
- All documentation is licensed under CC-BY-SA-4.0.
- Some configuration and data files are licensed under CC0-1.0.
- Some borrowed code (`qusal/dotfiles/`) is licenses under BSD-2-Clause,
  CC-BY-SA-4.0, GPL-2.0-only, GPL-3.0-only, MIT, Vim.
