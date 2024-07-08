# Bootstrap

Qusal bootstrap strategy.

## Table of Contents

*   [Description](#description)
*   [Essential](#essential)
*   [Optional](#optional)
    *   [Internet communication](#internet-communication)
    *   [Files](#files)
    *   [Admin](#admin)

## Description

With so many packages, you may be wondering, how to bootstrap a new system?
Well, the answer depends on your goal.

Below you will find a list sorted by task, which have projects that can help
you accomplish your mission. The order of which the formulas are applied can
matter in some circumstances, in those cases, it is noted in this page.

## Essential

*   Base (order matters):
    *   [dom0](../salt/dom0/README.md)
    *   [debian-minimal](../salt/debian-minimal/README.md)
    *   [fedora-minimal](../salt/fedora-minimal/README.md)
    *   [mgmt](../salt/mgmt/README.md)
    *   [sys-cacher](../salt/sys-cacher/README.md)

## Optional

### Internet communication

*   PCI devices holders:
    *   [sys-net](../salt/sys-net/README.md)
    *   [sys-audio](../salt/sys-audio/README.md)
    *   [sys-usb](../salt/sys-usb/README.md)

*   Firewall, DNS Sinkhole and VPN Tunnel:
    *   [sys-firewall](../salt/sys-firewall/README.md)
    *   [sys-mirage-firewall](../salt/sys-mirage-firewall/README.md)
    *   [sys-pihole](../salt/sys-pihole/README.md)
    *   [sys-wireguard](../salt/sys-wireguard/README.md)
    *   [sys-tailscale](../salt/sys-tailscale/README.md)

*   Web browser and file retriever:
    *   [browser](../salt/browser/README.md)
    *   [fetcher](../salt/fetcher/README.md)

*   Instant messaging and E-Mail:
    *   [mail](../salt/mail/README.md)
    *   [signal](../salt/signal/README.md)
    *   [element](../salt/element/README.md)

*   Electronic cash:
    *   [sys-bitcoin](../salt/sys-bitcoin/README.md)
    *   [sys-electrumx](../salt/sys-electrumx/README.md)
    *   [sys-electrs](../salt/sys-electrs/README.md)
    *   [electrum](../salt/electrum/README.md)

### Files

*   Passwords and TOTP:
    *   [vault](../salt/vault/README.md)

*   Multimedia:
    *   [reader](../salt/reader/README.md)
    *   [media](../salt/media/README.md)
    *   [sys-print](../salt/sys-print/README.md)
    *   [video-companion](../salt/video-companion/README.md)

*   File sharing:
    *   [usb](../salt/usb/README.md)
    *   [sys-ssh](../salt/sys-ssh/README.md)
    *   [sys-syncthing](../salt/sys-syncthing/README.md)
    *   [sys-rsync](../salt/sys-rsync/README.md)

### Admin

*   Remote administration:
    *   [remmina](../salt/remmina/README.md)
    *   [ssh](../salt/ssh/README.md)
    *   [sys-ssh-agent](../salt/sys-ssh-agent/README.md)

*   Remote task execution and configuration management:
    *   [ansible](../salt/ansible/README.md)
    *   [docker](../salt/docker/README.md)
    *   [opentofu](../salt/opentofu/README.md)
    *   [terraform](../salt/terraform/README.md)

*   Coding:
    *   [dev](../salt/dev/README.md)
    *   [sys-pgp](../salt/sys-pgp/README.md)
    *   [sys-git](../salt/sys-git/README.md)
    *   [sys-ssh-agent](../salt/sys-ssh-agent/README.md)
