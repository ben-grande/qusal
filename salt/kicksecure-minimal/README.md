# kicksecure

Kicksecure Template in Qubes OS.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)

## Description

Creates the Kicksecure template as well as a Disposable Template based on it.

## Installation

- Top:
```sh
qubesctl top.enable kicksecure
qubesctl --targets=kicksecure-17 state.apply
qubesctl top.disable kicksecure
qubesctl state.apply kicksecure.prefs
```

- State:
<!-- pkg:begin:post-install -->
```sh
qubesctl state.apply kicksecure.create
qubesctl --skip-dom0 --targets=kicksecure-17 state.apply kicksecure.install
qubesctl state.apply kicksecure.prefs
```
<!-- pkg:end:post-install -->

If you want to help improve Kicksecure on Qubes, install packages that are
known to be broken on Qubes and report bugs upstream (get a terminal with
qvm-console-dispvm):
```sh
qubesctl --skip-dom0 --targets=kicksecure-17 state.apply kicksecure.install-testing
```

## Usage

AppVMs and StandaloneVMs can be based on this template.
