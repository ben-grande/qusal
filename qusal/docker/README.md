# docker

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)

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

## Usage

The only qubes specific configuration to docker is changing its [root
directory](https://docs.docker.com/config/daemon/#daemon-data-directory) to
the private volume or using [qubes
bind-dirs](https://www.qubes-os.org/doc/bind-dirs/) for persistence of the
docker root directory in the root volume.
