# sys-pihole

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)
* [Credits](#credits)

## Description

Pi-hole DNS Sinkhole on Qubes OS.

The package will create a standalone qube "sys-pihole". It blocks
advertisements and internet trackers by providing a DNS sinkhole. It is a drop
in replacement for sys-firewall.

The qube will be attached to the "netvm" of the "default_netvm", in other
words, if you are using Qubes OS default setup, it will use "sys-net" as the
"netvm", else it will try to figure out what is your upstream link and attach
to it.

## Installation

- Top:
```sh
qubesctl top.enable sys-pihole
qubesctl --targets=sys-pihole state.apply
qubesctl top.disable sys-pihole
```

- State:
```sh
qubesctl state.apply sys-pihole.create
qubesctl --skip-dom0 --targets=sys-pihole state.apply sys-pihole.install
```

If you want to change the `updatevm` and `default_netvm` and the `netvm` of
all qubes from `sys-firewall` to `sys-pihole`, run:
```sh
qubesctl state.apply sys-pihole.prefs
```

## Usage

You can clone sys-pihole. If you do, you must manually change the IP address
of the clone.

If you want to use Tor, then you should reconfigure your netvm chaining (will
break tor's client stream isolation):

- qube -> sys-pihole -> Tor-gateway -> sys-firewall -> sys-net

Pi-hole will be installed with these default settings:

- The DNS provider is Quad9 (filtered, DNSSEC)
- Steven Black's Unified Hosts List is included
- Query logging is enabled to show everything.

You can change these settings via the admin interface:
- URL: http://localhost/admin
- default password: `UpSNQsy4`

You should change this password on first use by running:
```sh
pihole -a -p
```

## Credits

- [Patrizio Tufarolo](https://blog.tufarolo.eu/how-to-configure-pihole-in-qubesos-proxyvm/)
- [Unman](https://github.com/unman/shaker/tree/master/pihole)
