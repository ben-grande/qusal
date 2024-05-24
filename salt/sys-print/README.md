# sys-print

Printer environment in Qubes OS.

## Table of Contents

* [Description](#description)
* [Security](#security)
* [Installation](#installation)
* [Access Control](#access-control)
* [Usage](#usage)
  * [Add a printer](#add-a-printer)
  * [Print](#print)
* [Credits](#credits)

## Description

Creates a print server named "sys-print" and a named disposable
"disp-sys-print" qube for sending files to your configured printer, which can
be done over the network or with IPP-over-USB.

## Security

The client does not have CUPS, does not need internet connection and does not
have USB devices connected.

Using CUPS in a dedicated qube reduces attack surface and has a better
usability as you only need to configure the printer in one qube and other
qubes will have access through Qrexec.

If the devices connected to the server qube can attack the CUPS server, it can
escalate the attack to the client qube. Usage of disposables servers does not
prevent this from happening, it just avoids persistent infection on the
server, where you could attribute different printers to different levels of
trust.

Sending files to the print server with `qvm-copy` is always safer than
allowing a direct connection from the qube that wants to print files to the
qube that has access to the printer.

## Installation

- Top:
```sh
sudo qubesctl top.enable sys-print
sudo qubesctl --targets=tpl-sys-print,sys-print state.apply
sudo qubesctl top.disable sys-print
sudo qubesctl state.apply sys-print.appmenus
```

- State:
<!-- pkg:begin:post-install -->
```sh
sudo qubesctl state.apply sys-print.create
sudo qubesctl --skip-dom0 --targets=tpl-sys-print state.apply sys-print.install
sudo qubesctl --skip-dom0 --targets=dvm-sys-print,sys-print state.apply sys-print.configure
sudo qubesctl state.apply sys-print.appmenus
```
<!-- pkg:end:post-install -->

If you want to install all printer drivers:
```sh
sudo qubesctl --skip-dom0 --targets=tpl-sys-print state.apply sys-print.install-driver-all
```

On the client template:
```sh
sudo qubesctl --skip-dom0 --targets=tpl-QUBE -print state.apply sys-print.install-client
```

The client qube requires the split Print service to be enabled:
```sh
qvm-features QUBE service.print-setup 1
```

## Access Control

_Default policy_: `ask` `all` requests requesting to use the
`qusal.Print` RPC service.

`Asking` can spawn multiple requests depending on the client, usage of `allow`
is recommended for trusted clients.

Allow access to the specified printing agent based on the qube tag:
```qrexecpolicy
qusal.Print * @tag:print-client @default allow target=sys-print
```

Always recommended to end with an explicit deny rule:
```qrexecpolicy
qusal.Print * @anyvm @anyvm deny
```

## Usage

### Add a printer

You will configure your printer from `sys-print` or `disp-sys-print`, it can
connect over the network or USB. If you do not want to save printing
configuration, use `disp-sys-print`.

On `sys-print` or `disp-sys-print`, add your printer:
```sh
system-config-printer
```

### Print

On the client, select the file to print, open it with an editor, viewer or
browser and target the desired printer.

## Credits

- [Unman](https://github.com/unman/shaker/tree/main/sys-print)
