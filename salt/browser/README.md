# browser

Browser environment in Qubes OS.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
  * [Choose you browser](#choose-you-browser)
* [Usage](#usage)

## Description

Create environment for browsing. By default it creates a disposable template
called "dvm-browser", so when clicking the icon/launcher, it opens a
disposable qube. If you want to save your session, you can also clone the
template and create app qubes.

Default browser to install is Chromium, but you can choose to install Chrome,
Firefox-ESR, W3M or Lynx.

## Installation

- Top
```sh
qubesctl top.enable browser
qubesctl --targets=tpl-browser,dvm-browser state.apply
qubesctl top.disable browser
qubesctl state.apply browser.appmenus
```

- State
<!-- pkg:begin:post-install -->
```sh
qubesctl state.apply browser.create
qubesctl --skip-dom0 --targets=tpl-browser state.apply browser.install
qubesctl --skip-dom0 --targets=dvm-browser state.apply browser.configure
qubesctl state.apply browser.appmenus
```
<!-- pkg:end:post-install -->

### Choose you browser

Instead of running the state `browser.install`, you can select which browser
to install:

- Chromium:
```sh
qubesctl --skip-dom0 --targets=tpl-browser state.apply browser.install-chromium
```
- Chrome:
```sh
qubesctl --skip-dom0 --targets=tpl-browser state.apply browser.install-chrome
```
- Firefox-ESR:
```sh
qubesctl --skip-dom0 --targets=tpl-browser state.apply browser.install-firefox
```
- W3M:
```sh
qubesctl --skip-dom0 --targets=tpl-browser state.apply browser.install-w3m
```
- Lynx:
```sh
qubesctl --skip-dom0 --targets=tpl-browser state.apply browser.install-lynx
```

Do not forget to sync the `appmenus`:
```sh
qubesctl state.apply browser.appmenus
```

## Usage

Open a disposable qube simply by clicking on the desktop application
`dvm-browser (dvm): Browser`.

If you want to use a permanent browser session, create an app qube based on
`tpl-browser`.

If you are forwarding URLs from other qubes via `qvm-open-in-(d)vm`, you might
want to set your preferred browser as the default browser in `tpl-browser`
targeting the desired desktop file:
```sh
xdg-settings set default-web-browser firefox-esr.desktop
```
