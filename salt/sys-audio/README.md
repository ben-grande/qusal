# sys-audio

Audio operations in Qubes OS.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)
  * [Audio control](#audio-control)
  * [Client started before it's AudioVM](#client-started-before-its-audiovm)
  * [Client turned off with a device attached](#client-turned-off-with-a-device-attached)

## Description

Creates the named disposable "disp-sys-audio" qube for providing audio
operations such as microphone and speakers to and from qubes. By default, you
can use wired USB audio, but if you want, you can install the necessary
packages for bluetooth with the provided state.

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

### Audio control

The qube `disp-sys-audio` will be used for audio capabilities for speakers and
microphone, with builtin modules, Jack port or Bluetooth. You are be able to
control the volume via the volume icon that appears on the system tray.

The basics are very simple to use:

- Left click toggles the volume; and
- Scrolling the mouse from left to right changes the volume;

For more advanced features, right click the icon and click on `Open Mixer` or
`Prefences`. For greater control, use the command `amixer`.

### Client started before it's AudioVM

Audio will not automatically connect if the AudioVM starts after the client.
To connect the client to audio server, restart the client's Pipewire service:
```sh
systemctl --user restart pipewire
```

### Client turned off with a device attached

If you shutdown a client qube with a device attached, such as a microphone or
speaker, normal operation to attach the device to the same or any other qube
will fail. To be able to use the device again:

- Restart the audio server `disp-sys-audio`;
- Restart the audio client; and
- Attach the device to the audio client;
