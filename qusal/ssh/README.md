# ssh

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)

## Description

SSH remote login client on Qubes OS.

Setup SSH client AppVM ssh and a DispVM Template "dvm-ssh".
It's use is plain simple, SSH to servers, no extra configuration is required.
When saving the SSH configuration is necessary, use the ssh qube. If login
in as a one time connection or to an untrusted host use a DispVM based on
"dvm-ssh" for disposability.

## Installation

- Top:
```sh
qubesctl top.enable ssh
qubesctl --targets=tpl-ssh,dvm-ssh,ssh state.apply
qubesctl top.disable ssh
```

- State:
```sh
qubesctl state.apply ssh.create
qubesctl --skip-dom0 --targets=tpl-ssh state.apply ssh.install
qubesctl --skip-dom0 --targets=dvm-ssh,ssh state.apply ssh.configure
```

## Usage

Create DispVMs based on the Template for DispVMs "dvm-ssh" for disposable SSH
sessions or create AppVMs based on "tpl-ssh", such as the "ssh" qube for for
preserving the SSH configuration client side.

The client qube can enhanced by being:

- sys-ssh-agent's client and not storing the SSH keys on the client; or
- sys-git's client and fetching from qubes and push to remote servers.
