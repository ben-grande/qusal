# docker

Docker installation in Qubes OS.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)

## Description

Setup docker in Qubes OS with the Docker repository.

## Installation

- Top
```sh
sudo qubesctl top.enable docker
sudo qubesctl --targets=tpl-qubes-builder,qubes-builder state.apply
sudo qubesctl top.disable docker
```

- State
<!-- pkg:begin:post-install -->
```sh
sudo qubesctl --skip-dom0 --targets=tpl-qubes-builder state.apply docker.install
sudo qubesctl --skip-dom0 --targets=qubes-builder state.apply docker.configure
```
<!-- pkg:end:post-install -->

## Usage

The only qubes specific configuration to docker is changing its [root
directory](https://docs.docker.com/config/daemon/#daemon-data-directory) to
the private volume or using [qubes
bind-dirs](https://www.qubes-os.org/doc/bind-dirs/) for persistence of the
docker root directory in the root volume.
