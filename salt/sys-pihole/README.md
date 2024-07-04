# sys-pihole

Pi-hole DNS Sinkhole in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)
    *   [Web interface](#web-interface)
    *   [Torified Pi-Hole](#torified-pi-hole)
    *   [Local DNS server](#local-dns-server)
    *   [DNS issues after netvm restart](#dns-issues-after-netvm-restart)
*   [Credits](#credits)

## Description

The package will create a standalone qube "sys-pihole". It blocks
advertisements and internet trackers by providing a DNS sinkhole. It is a drop
in replacement for sys-firewall.

The qube will be attached to the "netvm" of the "default_netvm", in other
words, if you are using Qubes OS default setup, it will use "sys-net" as the
"netvm", else it will try to figure out what is your upstream link and attach
to it.

## Installation

Pi-Hole commits and tags are not signed by individuals, but as they are done
through the web interface, they have GitHub Web-Flow signature. This is the
best verification we can get for Pi-Hole. If you don't trust the hosting
provider however, don't install this package.

*   Top:

```sh
sudo qubesctl top.enable sys-pihole browser
sudo qubesctl --targets=tpl-browser,sys-pihole-browser,sys-pihole state.apply
sudo qubesctl top.disable sys-pihole browser
sudo qubesctl state.apply sys-pihole.appmenus
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply sys-pihole.create
sudo qubesctl --skip-dom0 --targets=tpl-browser state.apply browser.install
sudo qubesctl --skip-dom0 --targets=sys-pihole state.apply sys-pihole.install
sudo qubesctl --skip-dom0 --targets=sys-pihole-browser state.apply sys-pihole.configure-browser
sudo qubesctl state.apply sys-pihole.appmenus
```

<!-- pkg:end:post-install -->

If you want to change the global preferences `updatevm` and `default_netvm`
and the per-qube preference `netvm` of all qubes from `sys-firewall` to
`sys-pihole`, run:

```sh
sudo qubesctl state.apply sys-pihole.prefs
```

## Usage

### Web interface

If you want to view statistics or manage the server through a GUI, open
`sys-pihole` or `sys-pihole-browser` desktop file `pihole-browser.desktop`
from the app menu. Addresses starting with `http` or `https` will be
redirected to `sys-pihole-browser`.

Pi-hole will be installed with the following settings:

*   The DNS provider is Quad9 (filtered, DNSSEC)
*   Steven Black's Unified Hosts List is included
*   Query logging is enabled to show everything.

### Torified Pi-Hole

If you want to combine Pi-Hole with Tor, then you should reconfigure your
netvm chaining (will break tor's client stream isolation) as such:

*   qube -> sys-pihole -> Tor-gateway -> sys-firewall -> sys-net

### Local DNS server

If you want sys-pihole to use itself to resolve DNS queries, enable the
service `local-dns-server` from Dom0 to sys-pihole:

```sh
qvm-features sys-pihole service.local-dns-server 1
```

Don't forget to restart sys-pihole after the changes.

Note that if Pi-hole as a problem the host will not not be able to reach the
internet for updates, syncing time etc.

### DNS issues after netvm restart

If you encounter problems with DNS after having upstream netvm route changes,
restart Pi-hole DNS from sys-pihole:

```sh
pihole restartdns
```

## Credits

*   [Patrizio Tufarolo](https://blog.tufarolo.eu/how-to-configure-pihole-in-qubesos-proxyvm/)
*   [Unman](https://github.com/unman/shaker/tree/main/pihole)
