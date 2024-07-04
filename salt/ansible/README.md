# ansible

Ansible environment in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)

## Description

Install Ansible and use it on the "ansible" app qube.

## Installation

*   Top:

```sh
sudo qubesctl top.enable ansible
sudo qubesctl --targets=tpl-ansible,ansible,ansible-minion state.apply
sudo qubesctl top.disable ansible
```

*   State

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply ansible.create
sudo qubesctl --skip-dom0 --targets=tpl-ansible state.apply ansible.install
```

<!-- pkg:end:post-install -->

## Usage

From the control node `ansible`, test connection to the managed node
`ansible-minion`:

```sh
ssh -p 1840 user@127.0.0.1
```
