# terraform

Terraform installation in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)

## Description

Install Terraform and use it on the "terraform" app qube.

## Installation

*   Top:

```sh
sudo qubesctl top.enable terraform
sudo qubesctl --targets=tpl-terraform state.apply
sudo qubesctl top.disable terraform
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply terraform.create
sudo qubesctl --skip-dom0 --targets=tpl-terraform state.apply terraform.install
```

<!-- pkg:end:post-install -->

## Usage

You will be able to run terraform from the "terraform" qube. As simple as
that.

When using SSH keys, being a split-ssh-agent will facilitate key management.
