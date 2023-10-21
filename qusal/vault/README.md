# vault

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)

## Description

Vault environment in Qubes OS.

An offline qube will be created and named "vault", it will have a password
manager for high entropy passwords, PGP and SSH client for creating private
keys.

## Installation

- Top:
```sh
qubesctl top.enable vault
qubesctl --targets=tpl-vault state.apply
qubesctl top.disable vault
```

- State:
```sh
qubesctl state.apply vault.create
qubesctl --skip-dom0 --targets=tpl-vault state.apply vault.install
```

## Usage

The intended usage is to hold passwords and keys. You should copy the keys
generated from the vault to the target qube, which can be a split agent
server for SSH, PGP, Pass.

You should use a separate qube for split-ssh, split-gpg2 or any other
split-action operations that allows access to the vault qube, as it increases
the attack surface.
