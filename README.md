# qusal

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Format](#format)
  * [File naming](#file-naming)
  * [Readme](#readme)
  * [Qube naming](#qube-naming)
  * [Qrexec](#qrexec)
* [Copyright](#copyright)

## Description

Qusal - Salt Formulas for Qubes OS R4.1.

Qusal's goal:

- All global preferences customized to use qubes based on minimal templates;
- All service templates with only the necessary programs installed;
- Focus on tasks and usability

Each project is in a separate directory, but they may interact with other
projects.

User policies should always be set on /etc/qubes/policy.d/30-user.policy as
this file will take precedence over the packaged policy.

## Installation

Clone this repository:
```sh
git clone https://github.com/ben-grande/qusal.git ~/qusal
git clone ssh://git@github.com/ben-grande/qusal.git ~/qusal
```

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
./setup.sh
```

Qusal is now installed. Please read the README.md of each project for further
information on how to install the desired package.

Qubes global settings (qubes-prefs) that will be managed:

- **clockvm**: disp-sys-net, sys-net
- **default_audiovmm**: dom0  # TODO
- **default_dispvm**: reader
- **default_netvm**: sys-pihole, sys-firewall or disp-sys-firewall
- **management_dispvm**: dvm-mgmt
- **updatevm**: sys-pihole, sys-firewall or disp-sys-firewall

## Format

### File naming

1. Every State file `.sls` must have a Top file `.top`. This ensures that
   every state can be applied with top.
2. Every project must have a `init.top`, it facilitates applying every state
   by enabling a single top file.
3. State file naming should be common between the projects, it helps
   understand the project as if it was any other.
5. Files names and state IDs should use `-` as separator, not `_`.

### Readme

1. Every project should have a README.md with at least the following sections:
   Table of Contents, Description, Installation, Access Control (if changed
   Qrexec policy), Usage.

### Qube naming

1. Qube name format:

  - TemplateVM: `tpl-NAME`
  - StandaloneVM: `NAME`
  - AppVM: `NAME`
  - DispVM: `disp-NAME`
  - DispVM Template (AppVM): `dvm-NAME`
  - Service qubes (not a class): `sys-NAME`

2. Label:

  - Black (Ultimately trusted): You must trust Dom0, Templates, Vaults,
    Management qubes, these qubes control your system and hold valuable
    information. Examples: dom0, tpl-ssh, vault, default-mgmt-dvm.
  - Gray (Fully trusted): Trusted storage with extra RPC services that allow
    certain operations to be made by the client and executed on the server.
    Examples: sys-cacher, sys-git, sys-pgp, sys-ssh-agent.
  - Purple, Blue, Green, Yellow (Relatively trusted per domain): Can be set
    per user discretion, normally separated per domain (work, clients,
    personal).
  - Orange (Slightly trusted) Controls the flow of data to the client,
    normally a firewall. Examples: sys-firewall, sys-vpn, sys-pihole.
  - Red (Untrusted): Holds untrusted data (PCI devices, untrusted programs,
    disposables for opening untrusted files or web pages). Examples: sys-net,
    sys-usb, disp-sys-usb, disp-browser.

### Qrexec

1. Don't use `*` for source and destination, use `@anyvm` instead
2. Target qube for policies must be `@default`. It allows for the real target
   to be set by Dom0 via the `target=` redirection parameter, instead of
   having to modify the client to target a different server via
   `qrexec-client-vm`.
3. Target qube for client script must default to `@default`, but other targets
   must be allowed via parameters.

## Copyright

Each project has a README.md containing the license name and credits to the
copyright owners.
