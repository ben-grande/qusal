# mirage-builder

Mirage Builder environment in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)

## Description

Setup a builder qube for Mirage Unikernel named "mirage-builder". The tool
necessary to build Mirage with docker or directly with Opam will also be
installed.

## Installation

Mirage Firewall commits and tags are not signed by individuals, but as they
are done through the web interface, they have GitHub Web-Flow signature. This
is the best verification we can get for Mirage Firewall. If you don't trust
the hosting provider however, don't install this package.

*   Top:

```sh
sudo qubesctl top.enable mirage-builder
sudo qubesctl --targets=tpl-mirage-builder,mirage-builder state.apply
sudo qubesctl top.disable mirage-builder
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply mirage-builder.create
sudo qubesctl --skip-dom0 --targets=tpl-mirage-builder state.apply mirage-builder.install
sudo qubesctl --skip-dom0 --targets=mirage-builder state.apply mirage-builder.configure
```

<!-- pkg:end:post-install -->

## Usage

The qube `mirage-builder` is intended to build Mirage Unikernel. Consult
upstream documentation on [how to build qubes-mirage-firewall from
source](https://github.com/mirage/qubes-mirage-firewall#build-from-source).

If you plan to build without docker, the hooks and completion scripts are
already being sourced by your shell profile. Because of this, when calling
`opam-init`, use it together with the option `--no-setup`:

```sh
opam init --no-setup
```
