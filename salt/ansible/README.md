# ansible

Ansible environment in Qubes OS.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)

## Description

Install Ansible and use it on the "ansible" app qube.

## Installation

- Top
```sh
qubesctl top.enable ansible
qubesctl --targets=tpl-ansible,ansible,ansible-minion state.apply
qubesctl top.disable ansible
```

- State
<!-- pkg:begin:post-install -->
```sh
qubesctl state.apply ansible.create
qubesctl --skip-dom0 --targets=tpl-ansible state.apply ansible.install
qubesctl --skip-dom0 --targets=ansible state.apply ansible.configure,zsh.touch-zshrc
qubesctl --skip-dom0 --targets=ansible-minion state.apply ansible.configure-minion,zsh.touch-zshrc
```
<!-- pkg:end:post-install -->

## Usage

Configure the control node `ansible`:
```sh
ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ansible
qvm-copy ~/.ssh/id_ansible.pub
```
Select `ansible-minion` as the target qube for the copy operation.

Configure the minion `ansible-minion`:
```sh
mkdir -m 0700 ~/.ssh
cat ~/QubesIncoming/ansible/id_ansible.pub >> ~/.ssh/authorized_keys
```

From the control node `ansible`, test connection to the minion
`ansible-minion`:
```sh
ssh minion
```
