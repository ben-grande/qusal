# sys-audio

Audio operations in Qubes OS.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)

## Description

Creates the "sys-audio" qube for providing audio operations such as microphone
and speakers to and from qubes. By default, you can use wired USB audio, but
if you want, you can install the necessary packages for bluetooth with the
provided state.

## Installation

- Top
```sh
qubesctl top.enable sys-audio
qubesctl --targets=tpl-sys-audio,dvm-sys-audio state.apply
qubesctl top.disable sys-audio
```

- State
<!-- pkg:begin:post-install -->
```sh
qubesctl state.apply sys-audio.create
qubesctl --skip-dom0 --targets=tpl-sys-audio state.apply sys-audio.install
qubesctl --skip-dom0 --targets=dvm-sys-audio state.apply sys-audio.configure-dvm
```
<!-- pkg:end:post-install -->

If you need Bluetooth support:
```sh
qubesctl --skip-dom0 --targets=tpl-sys-audio state.apply sys-audio.install-bluetooth
```

## Usage

The qube `sys-audio` will be used for audio capabilities for speakers and
microphone, with builtin modules, jack port or Bluetooth. You are be able to
control the volume via the volume icon that appears on the system tray.
