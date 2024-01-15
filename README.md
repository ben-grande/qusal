# qusal

Salt Formulas for Qubes OS.

## Warning

**Warning**: Not ready for production, development only. Breaking changes can
and will be introduced in the meantime. You've been warned.

## Table of Contents

* [Description](#description)
* [Design](#design)
* [Prerequisites](#prerequisites)
* [Installation](#installation)
  * [DomU](#domu)
  * [Dom0](#dom0)
* [Usage](#usage)
* [Contribute](#contribute)
* [Donate](#donate)
* [Support](#support)
  * [Free Support](#free-support)
  * [Paid Support](#paid-support)
* [Contact](#contact)
* [Credits](#credits)
* [Legal](#legal)

## Description

Qusal providers a Free and Open Source solution to customizing various tasks
in Qubes OS, from switching PCI handlers to be disposables or app qubes,
installing different pieces of software on dedicated minimal templates for
split agent operations for separating the key store from the client.

Each project is in a separate directory, but they may interact with other
projects.

If you want to edit the access control for any service, such as resolution to
allow, ask, deny or the intended target, you should always use the Qrexec
policy at `/etc/qubes/policy.d/30-user.policy`, as this file will take
precedence over the packaged policy.

## Design

Every project creates its own template, client and server (when necessary)
with only the required packages and configuration. You don't need to use a
separate template for everything, but if you want to do that, you will have
adjust the target of the qubesctl call or write Salt Top files.

Qubes global settings (qubes-prefs) that will be managed:

- **clockvm**: disp-sys-net, sys-net
- **default_dispvm**: reader
- **default_netvm**: sys-pihole, sys-firewall or disp-sys-firewall
- **management_dispvm**: dvm-mgmt
- **updatevm**: sys-pihole, sys-firewall or disp-sys-firewall
- **default_audiovm**: disp-sys-audio

To be implemented:
- **default_guivm**: sys-gui

## Prerequisites

You current setup needs to fulfill the following requisites:

- Qubes OS R4.2
- Internet connection

## Installation

### DomU

1. Install `git` in the downloader qube, if it is an AppVM, install it in the
TemplateVM.

2. Clone this repository in an app qube:
```sh
git clone --recurse-submodules https://github.com/ben-grande/qusal.git
```
If you made a fork, before cloning it, fork the submodule(s). Clone your own
project instead of this one, the submodules will be from your fork also.

3. Verify the [commit or tag signature](https://www.qubes-os.org/security/verifying-signatures/#how-to-verify-signatures-on-git-repository-tags-and-commits).

### Dom0

Before copying anything to Dom0, read [Qubes OS warning about consequences of
this procedure](https://www.qubes-os.org/doc/how-to-copy-from-dom0/#copying-to-dom0).

1. Copy this repository from some qube to Dom0 from Dom0:
```sh
mkdir -p ~/QubesIncoming/<QUBE>
qvm-run -p <QUBE> tar -cC </PATH/TO> qusal | tar -xvC ~/QubesIncoming/<QUBE> qusal
## Example: mkdir -p ~/QubesIncoming/dev
## Example: qvm-run -p dev tar -cC /home/user qusal | tar -xvC ~/QubesIncoming/dev qusal
```

2. Copy the project to the Salt directories:
```sh
cd ~/QubesIncoming/<QUBE>/qusal
./scripts/setup.sh
```

## Usage

Qusal is now installed. Please read the README.md of each project for further
information on how to install the desired package.

The intended behavior is to enforce the state of qubes and their services. If
you modify the qubes and their services and apply the state again, there is a
good chance your choices will be overwritten. To enforce your state, write a
SaltFile to specify the desired state, do not do it manually, we are past
that.

The only Qrexec policy file you should change is
`/etc/qubes/policy.d/30-user.policy` as this file will take precedence over
the ones provided by this project. If you modify the policies provided by
Qusal, your changes will be overwritten next time you install/upgrade the
packages.

Please note that when you allow more Qrexec calls than the default shipped by
Qubes OS, you are increasing the attack surface of the target, normally
valuable qube that can hold secrets or pristine data. A compromise of the
client qube can extend to the server, therefore configure the installation
according to your threat model.

If you are unsure how to start, follow the [bootstrap guide](BOOTSTRAP.md) for
some ideas on how to customize your system.

## Contribute

There are several ways to contribute to this project. Spread the word, help on
user support, review opened issues, fix typos, implement new features,
donations.

Please take a look at [contribution guidelines](CONTRIBUTING.md) before
contributing code or to the documentation, it holds important information on
how the project is structured, why some design decisions were made and what
can be improved.

## Donate

This project can only survive through donations. If you like what we have
done, please consider donating. [Contact us](#contact) for donation address.

This project depends on Qubes OS, consider donating to
[upstream](https://qubes-os.org/donate/).

## Support

### Free Support

Free support will be provided on a best effort basis. If you want something,
open an issue and patiently wait for a reply, the project is best developed in
the open so anyone can search for past issues.

### Paid Support

Paid consultation services can be provided.
Request a quote [from us](#contact).

## Contact

You must not contact for [free support](#free-support).

- [E-mail](https://github.com/ben-grande/ben-grande)

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
