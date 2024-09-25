# sys-gui-gpu

GPU GUI domain in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Uninstallation](#uninstallation)
*   [Usage](#usage)

## Description

Setup a GPU GUI domain named "sys-gui-gpu". The GPU is attached to the qube
and all graphics computation are handled by this qube. Requires a dedicated
graphics card (external GPU) and PCI passthrough support.

## Installation

WARNING: [unfinished formula](../../docs/TROUBLESHOOT.md#no-support-for-unfinished-formulas).

*   Top:

```sh
sudo qubesctl top.enable qvm.sys-gui pillar=True
sudo qubesctl top.enable sys-gui-gpu
sudo qubesctl --targets=tpl-sys-gui,sys-gui-gpu state.apply
sudo qubesctl top.disable sys-gui-gpu
sudo qubesctl state.apply sys-gui-gpu.prefs
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl top.enable qvm.sys-gui pillar=True
sudo qubesctl state.apply sys-gui-gpu.create
sudo qubesctl --skip-dom0 --targets=tpl-sys-gui state.apply sys-gui-gpu.install
sudo qubesctl --skip-dom0 --targets=sys-gui-gpu state.apply sys-gui-gpu.configure
sudo qubesctl state.apply sys-gui-gpu.prefs
```

<!-- pkg:end:post-install -->

The formula assumes Intel graphics card, if you have a card from another
vendor, please use
[qvm-pci](https://www.qubes-os.org/doc/how-to-use-pci-devices/#qvm-pci-usage)
to persistently attach the GPU with the permissive option to `sys-gui-gpu`.

Shutdown all your running qubes as the global property `default_guivm` has
changed to `sys-gui-gpu`.

## Uninstallation

Reboot you computer and prevent Qubes OS autostart of any qube, be it
`sys-gui-gpu` or the qubes connected to it to reach dom0. For that, you need to
boot Qubes OS with
[qubes.skip_autostart GRUB parameter](https://www.qubes-os.org/doc/autostart-troubleshooting/).
Only after you have done these steps manually, you can continue the
uninstallation procedure.

Set Global preference `default_guivm` to `dom0` and disable `autostart` of
`sys-gui-gpu`:

```sh
sudo qubesctl state.apply sys-gui-gpu.cancel
```

## Usage

Qubes that have their `guivm` preference set to `sys-gui-gpu`, will use it as
the GUI domain.

The process to enter `sys-gui-gpu` can be a simple logout, but on most
platforms, a reboot is required and recommended to prevent data loss.

The login credentials are the same used in `dom0`, the first user in the
`qubes` group and the corresponding password.
