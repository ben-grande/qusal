# docker

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Copyright](#copyright)

## Description

Docker installation on Qubes OS.

Setup docker on Qubes OS with the Docker repository.

## Installation

- Top
```sh
qubesctl top.enable docker
qubesctl --targets=tpl-qubes-builder,qubes-builder state.apply
qubesctl top.disable docker
```

- State
```sh
qubesctl --skip-dom0 --targets=tpl-qubes-builder state.apply docker.install
qubesctl --skip-dom0 --targets=qubes-builder state.apply docker.configure
```

## Copyright

License: GPLv2+
