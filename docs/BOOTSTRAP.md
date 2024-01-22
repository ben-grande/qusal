# Bootstrap

Qusal bootstrap strategy.

## Table of Contents

* [Description](#description)
* [Essential](#essential)
* [Optional](#optional)
  * [Internet communication](#internet-communication)
  * [Files](#files)
  * [Admin](#admin)

## Description

With so many packages, you are wondering, how to bootstrap a new system? Which
order should the packages be applied? Well, the answer depends on your goal.

Bellow you will find a list sorted by task, which have projects that can help
you accomplish your mission.

## Essential

- Base (in order):
  - [dom0](../salt/dom0/README.md)
  - [debian-minimal](../salt/debian-minimal/README.md)
  - [fedora-minimal](../salt/fedora-minimal/README.md)
  - [sys-cacher](../salt/sys-cacher/README.md)
  - [mgmt](../salt/mgmt/README.md)

- Networking:
  - [sys-net](../salt/sys-net/README.md)
  - [sys-firewall](../salt/sys-firewall/README.md)

- Miscellaneous:
  - [vault](../salt/vault/README.md)
  - [sys-gui](../salt/sys-gui/README.md)
  - [sys-audio](../salt/sys-audio/README.md)

## Optional

### Internet communication

- Firewall, DNS Sinkhole and VPN Tunnel:
  - [sys-mirage-firewall](../salt/sys-mirage-firewall/README.md)
  - [sys-pihole](../salt/sys-pihole/README.md)
  - [sys-wireguard](../salt/sys-wireguard/README.md)

- Web browser and file retriever:
  - [browser](../salt/browser/README.md)
  - [fetcher](../salt/fetcher/README.md)

- Instant messaging and E-Mail:
  - [mutt](../salt/mutt/README.md)
  - [signal](../salt/signal/README.md)

### Files

- USB:
  - [usb](../salt/usb/README.md)
  - [sys-usb](../salt/sys-usb/README.md)

- Multimedia:
  - [reader](../salt/reader/README.md)
  - [media](../salt/media/README.md)

- File sharing:
  - [sys-ssh](../salt/sys-ssh/README.md)
  - [sys-syncthing](../salt/sys-syncthing/README.md)
  - [sys-rsync](../salt/sys-rsync/README.md)

### Admin

- Remote administration:
  - [remmina](../salt/remmina/README.md)
  - [ssh](../salt/ssh/README.md)
  - [sys-ssh-agent](../salt/sys-ssh-agent/README.md)

- Remote task execution and configuration management:
  - [ansible](../salt/ansible/README.md)
  - [docker](../salt/docker/README.md)
  - [terraform](../salt/terraform/README.md)

- Coding:
  - [dev](../salt/dev/README.md)
  - [sys-pgp](../salt/sys-pgp/README.md)
  - [sys-git](../salt/sys-git/README.md)
  - [sys-ssh-agent](../salt/sys-ssh-agent/README.md)
