# sys-usb

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)
* [Credits](#credits)

## Description

PCI handler of USB devices on Qubes OS.

Setup named disposables for USB qubes. During creation, it tries to separate
the USB controllers to different qubes is possible.

## Installation

- Top:
```sh
qubesctl top.enable sys-usb
qubesctl --targets=tpl-sys-usb state.apply
qubesctl top.disable sys-usb
```

- State:
```sh
qubesctl state.apply sys-usb.create
qubesctl --skip-dom0 --targets=tpl-sys-usb state.apply sys-usb.install
```

If you use an USB keyboard, instead of `sys-usb.create`, run:
```sh
qubesctl state.apply sys-usb.keyboard
```

Install the proxy on the client template:
```sh
qubesctl --skip-dom0 --targets=tpl-QUBE state.apply sys-usb.install-client-proxy
```
If the client requires decrypting a device, install on the client template:
```sh
qubesctl --skip-dom0 --targets=tpl-QUBE state.apply sys-usb.install-client-cryptsetup
```
If the client requires a FIDO device, install on the client template:
```sh
qubesctl --skip-dom0 --targets=tpl-QUBE state.apply sys-usb.install-client-fido
```

## Usage

Start a USB qube an connect a device to it.  USB PCI devices will appear on
the system tray icon `qui-devices`. From there, assign it to the intended
qube.

## Credits

- [Unman](https://github.com/unman/shaker/blob/main/sys-usb)
