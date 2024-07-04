# opentofu

OpenTofu installation in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)

## Description

Installs OpenTofu and use it on the "opentofu" app qube. An open-source fork
of Terraform.

## Installation

*   Top:

```sh
sudo qubesctl top.enable opentofu
sudo qubesctl --targets=tpl-opentofu state.apply
sudo qubesctl top.disable opentofu
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply opentofu.create
sudo qubesctl --skip-dom0 --targets=tpl-opentofu state.apply opentofu.install
```

<!-- pkg:end:post-install -->

## Usage

You will be able to run OpenTofu from the "opentofu" qube. As simple as
that.

When using SSH keys, being a split-ssh-agent will facilitate key management.
