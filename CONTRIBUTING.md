# Contributing

## Table of Contents


* [Respect](#respect)
* [Environment](#environment)
  * [Requirements](#requirements)
  * [Lint](#lint)
* [Format](#format)
  * [File naming](#file-naming)
  * [State ID](#state-id)
  * [Readme](#readme)
  * [Qube preferences](#qube-preferences)
  * [Qrexec](#qrexec)

## Respect

Be respectful towards peers.

## Environment

You will need to setup you development environment before you start
contributing. You will need Qubes OS R4 or higher.

### Requirements

The following are the packages you need to install:

General:
- git

For writing:
- editorconfig
- editorconfig plugin for your editor

For linting:
- pre-commit
- gitlint
- salt-lint
- shellcheck
- reuse

For building RPMs:
- dnf
- rpm
- rpmlint

### Lint

Lint before you commit, please... else you will have to fix after the PR has
already been sent.

Install the local hooks:
```sh
pre-commit install
gitlint install-hook
```

To run pre-commit linters:
```sh
pre-commit run
```

## Format

### File naming

1. Every State file `.sls` must have a Top file `.top`. This ensures that
   every state can be applied with top.
2. Every project must have a `init.top`, it facilitates applying every state
   by enabling a single top file.
3. State file naming must be common between the projects, it helps
   understand the project as if it was any other.
4. File name must use `-` as separator, not `_`.

### State ID

1. State IDs must use `-` as separator, not `_`. The underline is allowed in
   case the features it is changing has underline, such as `default_netvm`.
2. State IDs must always have the project ID, thus allowing to target multiple
   states to the same minion from different projects without having
   conflicting IDs.

### Readme

1. Every project should have a README.md with at least the following sections:
   Table of Contents, Description, Installation, Access Control (if changed
   Qrexec policy), Usage.

### Qube preferences

1. Qube name format:

  - TemplateVM: `tpl-NAME`
  - StandaloneVM: `NAME`
  - AppVM: `NAME`
  - DispVM: `disp-NAME`
  - DispVM Template (AppVM): `dvm-NAME`
  - Service qubes (not a class): `sys-NAME`

2. **Label/Color**:

  - **Black** (Ultimately trusted): You must trust Dom0, Templates, Vaults,
    Management qubes, these qubes control your system and hold valuable
    information. Examples: dom0, tpl-ssh, vault, default-mgmt-dvm.
  - **Gray** (Fully trusted): Trusted storage with extra RPC services that allow
    certain operations to be made by the client and executed on the server or
    may build components for other qubes. Examples: sys-cacher, sys-git,
    sys-pgp, sys-ssh-agent, qubes-builder.
  - **Purple** (Much trust): Has the ability to manager remote servers via
    encrypted connections and depend on authorization provided by another
    qube.
    Examples: ansible, dev, ssh, terraform.
  - **Blue** (Very trusted): TODO
  - **Green** (Trusted): TODO
  - **Yellow** (Relatively trusted): TODO
  - **Orange** (Slightly trusted): Controls the network flow of data to the
    client, normally a firewall. Examples: sys-firewall, sys-vpn, sys-pihole.
  - **Red** (Untrusted): Holds untrusted data (PCI devices, untrusted programs,
    disposables for opening untrusted files or web pages). Examples: sys-net,
    sys-usb, dvm-browser.

### Qrexec

1. Don't use `*` for source and destination, use `@anyvm` instead
2. Target qube for policies must be `@default`. It allows for the real target
   to be set by Dom0 via the `target=` redirection parameter, instead of
   having to modify the client to target a different server via
   `qrexec-client-vm`.
3. Target qube for client script must default to `@default`, but other targets
   must be allowed via parameters.
