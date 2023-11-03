# terraform

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)

## Description

Terraform installation in Qubes OS.

Install Terraform and use it on the "terraform" app qube.

## Installation

- Top:
```sh
qubesctl top.enable terraform
qubesctl --targets=tpl-terraform state.apply
qubesctl top.disable terraform
```

- State:
```sh
qubesctl state.apply terraform.create
qubesctl --skip-dom0 --targets=tpl-terraform state.apply terraform.install
```

## Usage

You will be able to run terraform from the "terraform" qube. As simple as
that.

When using SSH keys, being a split-ssh-agent will facilitate key management.
