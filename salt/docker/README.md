# docker

Docker installation in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)

## Description

Setup docker in Qubes OS with the Docker repository.

## Installation

TODO: remove installation steps or provide a docker qube.

*   Top:

```sh
sudo qubesctl top.enable docker
sudo qubesctl --targets=tpl-qubes-builder state.apply
sudo qubesctl top.disable docker
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl --skip-dom0 --targets=tpl-qubes-builder state.apply docker.install
```

<!-- pkg:end:post-install -->

Enable the Docker and/or Podman service for qubes that will use it:

```sh
qvm-features QUBE service.docker 1
qvm-features QUBE service.podman 1
```

## Usage

The only qubes specific configuration to docker is changing its [root
directory](https://docs.docker.com/config/daemon/#daemon-data-directory) to
the private volume or using [qubes
bind-dirs](https://www.qubes-os.org/doc/bind-dirs/) for persistence of the
docker root directory in the root volume.
