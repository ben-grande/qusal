# sys-syncthing

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Access Control](#access-control)
* [Debugging](#debugging)
* [Uninstallation](#uninstallation)
* [Credits](#credits)

## Description

Syncthing through Qrexec on Qubes OS.

Creates a Syncthing qube named "sys-syncthing", it will be attached to the
"default_netvm". It makes no sense to run this with "sys-syncthing" attached
to a VPN or Tor proxy.

This package opens up the qubes-firewall, so that the "sys-syncthing" qube is
accessible externally.

## Installation

The Syncthing service is only started if the service is enabled for that qube
in Dom0:
```
qvm-features QUBE service.qubes-syncthing 1
```
The client requires `socat` to be installed.

By default the service will connect to the `sys-syncthing` qube, but you can
change the default via policy.

To use the service, add a Remote Device, and copy the `DeviceID` from the
target qube. On the Advanced tab, under Addresses, change `dynamic` to
`tcp://127.0.0.1:22001`

If the sender qube has no netvm set, under `Settings`, disable
`Enable NAT traversal`, `Local Discovery`, `Global Discovery`, and
`Enable Relaying`

- Top:
```sh
qubesctl top.enable sys-syncthing
qubesctl --targets=tpl-sys-syncthing,sys-syncthing state.apply
qubesctl top.disable sys-syncthing
qubesctl state.apply sys-syncthing.appmenus
/srv/salt/qusal/sys-syncthing/files/firewall/in.sh -a -p add sys-syncthing tcp 22000
/srv/salt/qusal/sys-syncthing/files/firewall/in.sh -a -p add sys-syncthing udp 22000
```

- State:
```sh
qubesctl state.apply sys-syncthing.create
qubesctl --skip-dom0 --targets=tpl-sys-syncthing state.apply sys-syncthing.install
qubesctl --skip-dom0 --targets=sys-syncthing state.apply sys-syncthing.configure
qubesctl state.apply sys-syncthing.appmenus
/srv/salt/qusal/sys-syncthing/files/firewall/in.sh -a -p add sys-syncthing tcp 22000
/srv/salt/qusal/sys-syncthing/files/firewall/in.sh -a -p add sys-syncthing udp 22000
```

## Access Control

A `qusal.Syncthing` service is created to allow use of Syncthing over
Qrexec. The default policy `asks` if you want to sync with the `sys-syncthing`
qube.

If you want to `allow` Syncthing between qubes, insert in you user policy file
`/etc/qubes/policy.d/30-user.policy` to allow the service using the following
format:
```qrexecpolicy
qusal.Syncthing  *  SOURCE  @default allow target=DESTINATION default_target=DEFAULT_DESTINATION
```

## Debugging

If sys-net has more than one network card the first external interface will
be used by default.
If this is incorrect, you must change it manually. In Dom0 run:
```sh
/srv/salt/qusal/sys-syncthing/files/firewall/in.sh delete sys-syncthing tcp 22000 -a -p
/srv/salt/qusal/sys-syncthing/files/firewall/in.sh delete sys-syncthing udp 22000 -a -p
/srv/salt/qusal/sys-syncthing/files/firewall/in.sh add sys-syncthing tcp 22000 -p
/srv/salt/qusal/sys-syncthing/files/firewall/in.sh add sys-syncthing udp 22000 -p
```
This will let you choose the NIC.

## Uninstallation

The `sys-syncthing` qube will not be removed, but the Syncthing service on
that qube will be stopped. The firewall rules will be reverted so the qube
will not be accessible externally. Note: If you have manually set rules you
must manually revert them. The Qrexec policy will be reverted to stop
Syncthing between qubes.

Uninstallation procedure:
```sh
/srv/salt/qusal/sys-syncthing/files/firewall/in.sh -a -p delete sys-syncthing tcp 22000
/srv/salt/qusal/sys-syncthing/files/firewall/in.sh -a -p delete sys-syncthing udp 22000
qubesctl --skip-dom0 --targets=sys-syncthing state.apply sys-syncthing.cancel
qubesctl state.apply sys-syncthing.clean
```

## Credits

- [Unman](https://github.com/unman/shaker/tree/master/syncthing)
