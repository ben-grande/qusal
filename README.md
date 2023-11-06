# qusal


## Table of Contents

* [Description](#description)
* [Installation](#installation)
  * [Requirements](#requirements)
  * [DomU](#domu)
  * [Dom0](#dom0)
* [Usage](#usage)
* [Credits](#credits)
* [Legal](#legal)

## Description

Qusal - Salt Formulas for Qubes OS.

**Warning**: This project is in Alpha stage, no ready for production. Try in
development only.

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
git clone --recurse-submodules https://github.com/ben-grande/qusal.git
```

If you made a fork, before cloning it, fork the submodule(s) first:
[dotfiles](https://github.com/ben-grande/dotfiles.git).
```sh
git clone --recurse-submodules https://github.com/USERNAME/qusal.git
```

### Dom0

1. Before copying anything to Dom0, read [Qubes OS warning about
this procedure](https://www.qubes-os.org/doc/how-to-copy-from-dom0/#copying-to-dom0).

2. Copy this repository from some qube to Dom0 from Dom0:
```sh
mkdir -p ~/QubesIncoming/QUBE
qvm-run -p <QUBE> tar -cC </PATH/TO> qusal | tar -xvC ~/QubesIncoming/QUBE qusal
## Example: mkdir -p ~/QubesIncoming/dev
## Example: qvm-run -p dev tar -cC /home/user qusal | tar -xvC ~/QubesIncoming/dev qusal
```

3. Copy the files to the Salt directories:
```sh
cd ~/QubesIncoming/QUBE/qusal
./scripts/setup.sh
```

The RPM Spec is not ready, don't try it unless for development.

## Usage

Qusal is now installed. Please read the README.md of each project for further
information on how to install the desired package.

Every project creates its own template, client and server (when necessary)
with only the required packages and configuration. You don't need to use a
separate template for everything, but if you want to do that, you will have
adjust the target of the qubesctl call or write Salt Top files.

When allowing more Qrexec calls than the default shipped by Qubes OS, you are
increasing the attack surface of the target, normally valuable qube that can
hold secrets or pristine data. A compromise of the client qube can extend to
the server, therefore configure the installation according to your threat
model.

The intended behavior is to enforce the state of qubes and their services. If
you modify the qubes and their services and apply the state again, there is a
good chance your choices will be overwritten. To enforce your state, write a
SaltFile to specify the desired state, do not do it manually, we are past
that.

Qubes global settings (qubes-prefs) that will be managed:

- **clockvm**: disp-sys-net, sys-net
- **default_dispvm**: reader
- **default_netvm**: sys-pihole, sys-firewall or disp-sys-firewall
- **management_dispvm**: dvm-mgmt
- **updatevm**: sys-pihole, sys-firewall or disp-sys-firewall

To be implemented:
- **default_audiovm**: sys-audio
- **default_guivm**: sys-gui

## Credits

I stand on the shoulders of giants. This would not be possible without people
contributing to Qubes OS SaltStack formulas. Honorable mention(s):
[unman](https://github.com/unman).

## Legal

This project is [REUSE-compliant](https://reuse.software). It is difficult to
list all licenses and copyrights and keep them up-to-date here.

The easiest way to get the copyright and license of the project with the reuse
tool:
```sh
reuse spdx
```

You can also check these information manually by looking in the file header,
a companion `.license` file or in `.reuse/dep5`.

All licenses are present in the LICENSES directory.

Note that submodules have their own licenses and copyrights statements, please
check each one individually using the same methods described above for a full
statement.
