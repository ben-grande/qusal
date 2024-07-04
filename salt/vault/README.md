# vault

Vault environment in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)

## Description

An offline qube will be created and named "vault", it will have a password
manager for high entropy passwords, PGP and SSH client for creating private
keys.

## Installation

*   Top:

```sh
sudo qubesctl top.enable vault
sudo qubesctl --targets=tpl-vault state.apply
sudo qubesctl top.disable vault
sudo qubesctl state.apply vault.appmenus
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply vault.create
sudo qubesctl --skip-dom0 --targets=tpl-vault state.apply vault.install
sudo qubesctl state.apply vault.appmenus
```

<!-- pkg:end:post-install -->

## Usage

The intended usage is to hold passwords and keys. You should copy the keys
generated from the vault to another qube, which can be a split agent
server for SSH, PGP, Pass. A compromise of the client qube can escalate into a
compromise of the qubes it can run RPC services, therefore a separate vault is
appropriate according to your threat model.
