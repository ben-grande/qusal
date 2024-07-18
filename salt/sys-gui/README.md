# sys-gui

Hybrid GUI domain in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Uninstallation](#uninstallation)
*   [Usage](#usage)

## Description

Setup a Hybrid GUI domain named "sys-gui". Dom0 remains with the X Server and
graphics drivers but runs only a single GUI application, a full-screen proxy
for the GUI domain's graphical server.

## Installation

WARNING: [unfinished formula](../../docs/TROUBLESHOOT.md#no-support-for-unfinished-formulas).

*   Top:

```sh
sudo qubesctl top.enable qvm.sys-gui pillar=True
sudo qubesctl top.enable sys-gui
sudo qubesctl --targets=tpl-sys-gui,sys-gui state.apply
sudo qubesctl top.disable sys-gui
sudo qubesctl state.apply sys-gui.prefs
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl top.enable qvm.sys-gui pillar=True
sudo qubesctl state.apply sys-gui.create
sudo qubesctl --skip-dom0 --targets=tpl-sys-gui state.apply sys-gui.install
sudo qubesctl --skip-dom0 --targets=sys-gui state.apply sys-gui.configure
sudo qubesctl state.apply sys-gui.prefs
```

<!-- pkg:end:post-install -->

Shutdown all your running qubes as the global property `default_guivm` has
changed to `sys-gui`.

## Usage

Qubes that have their `guivm` preference set to `sys-gui`, will use it as the
GUI domain.

Logout and in the login manager (lightdm, sddm), select session type
`GUI domain (sys-gui)`.

The login credentials are the same used in `dom0`, the first user in the
`qubes` group and the corresponding password.

## Uninstallation

Set Global preference `default_guivm` to `dom0` and disable `autostart` of
`sys-gui`:

```sh
sudo qubesctl state.apply sys-gui.cancel
```

Logout and in the login manager (lightdm, sddm), select session type
`Plasma (X11)` or `Xfce`.
