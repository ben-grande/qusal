# sys-net

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)
  * [Persistent WiFi password in disposable qube](#persistent-wifi-password-in-disposable-qube)

## Description

PCI handler of Network devices on Qubes OS.

Creates and configure qubes for handling the network devices. Qubes OS
provides the state "qvm.sys-net", but it will create only "sys-net", which can
be a disposable or not. This package takes a different approach, it will
create an AppVM "sys-net" and a DispVM "disp-sys-net".

By default, the chosen one is "sys-net", but you can choose which qube type
becomes the upstream net qube, the "clockvm" and the fallback target for the
"qubes.UpdatesProxy" service in case no rule matched before, described in the
installation section below.

## Installation

- Top:
```sh
qubesctl top.enable sys-net
qubesctl --targets=tpl-sys-net state.apply
qubesctl top.disable sys-net
qubesctl state.apply sys-net.prefs
```

- State:
```sh
qubesctl state.apply sys-net.create
qubesctl --skip-dom0 --targets=tpl-sys-net state.apply sys-net.install
qubesctl state.apply sys-net.prefs
```

Alternatively, if you prefer to have a disposable net qube:
```sh
qubesctl state.apply sys-net.prefs-disp
```

You might need to install some firmware on the template for your network
drivers. Check firmware.txt.

## Usage

### Persistent WiFi password in disposable qube

The following change must be done on the AppVM that is a template for
disposables, the `dvm-sys-net`, in the `/rw/config/rc.local` (change the SSID
and PASSWORD for the adequate values):
```sh
conn_net(){
  if nm-online -s -x; then
    nmcli dev wifi connect SSID password "PASSWORD"
  fi
}
while ! systemctl is-active networking.service; do sleep 5; done
case "$(qubesdb-read /type)" in
  DispVM|AppVM)
    if test -e /run/qubes-service/network-manager; then
      conn_net
    fi
    ;;
esac
```
