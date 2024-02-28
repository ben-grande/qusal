# sys-audio

Audio operations in Qubes OS.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)
  * [Audio control](#audio-control)
  * [Client switched it's AudioVM](#client-switched-its-audiovm)
  * [Client started before it's AudioVM](#client-started-before-its-audiovm)
  * [Client turned off with a device attached](#client-turned-off-with-a-device-attached)
  * [How to use USB devices](#how-to-use-usb-devices)
  * [How to use Bluetooth](#how-to-use-bluetooth)
    * [How to make the Bluetooth icon appear in the system tray](#how-to-make-the-bluetooth-icon-appear-in-the-system-tray)
    * [How to attach the Bluetooth controller to the AudioVM persistently](#how-to-attach-the-bluetooth-controller-to-the-audiovm-persistently)

## Description

Creates the named disposable "disp-sys-audio" qube for providing audio
operations such as microphone and speakers to and from qubes. By default, you
can use the builtin stereo, JACK and  USB , but if you want, you can install
the necessary packages for bluetooth with the provided state.

## Installation

- Top
```sh
sudo qubesctl top.enable sys-audio
sudo qubesctl --targets=tpl-sys-audio,dvm-sys-audio state.apply
sudo qubesctl top.disable sys-audio
```

- State
<!-- pkg:begin:post-install -->
```sh
sudo qubesctl state.apply sys-audio.create
sudo qubesctl --skip-dom0 --targets=tpl-sys-audio state.apply sys-audio.install
sudo qubesctl --skip-dom0 --targets=dvm-sys-audio state.apply sys-audio.configure-dvm
```
<!-- pkg:end:post-install -->

If you need Bluetooth support, install the dependencies:
```sh
sudo qubesctl --skip-dom0 --targets=tpl-sys-audio state.apply sys-audio.install-bluetooth
```

## Usage

### Audio control

The qube `disp-sys-audio` will be used for audio capabilities for speakers
and microphone, with builtin modules, Jack port or Bluetooth. You are be able
to control the volume via the volume icon that appears on the system tray.

Audio control basics:

- Left click toggles the volume; and
- Scrolling the mouse from left to right changes the volume;

For more advanced features, right click the icon and click on `Open Mixer` or
`Prefences`. For greater control, use the command `amixer`.

### Client switched it's AudioVM

If the client has already started when you decided to switch the AudioVM, you
will need to restart the client qube until [upstream issue is fixed](https://github.com/QubesOS/qubes-issues/issues/8975).

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

- Restart the AudioVM `disp-sys-audio`;
- Restart the audio client; and
- Attach the device to the audio client.

### How to use USB devices

Please refer to the [sys-usb formula instructions](../sys-usb/README.md).

### How to use Bluetooth

#### How to make the Bluetooth icon appear in the system tray

Note that the only way to autostart the Bluetooth icon (blueman-tray) in the
system tray is to attach the Bluetooth controller persistently to the AudioVM.

If you don't do this, you will have to attach the Bluetooth controller
manually to `disp-sys-audio` after it has started and also run `blueman-tray`.

#### How to attach the Bluetooth controller to the AudioVM persistently

If using Bluetooth, you probably want to have it persistently attached to the
AudioVM. Bluetooth devices are held by the USB stack, thus you need to attach
from your `(disp-)sys-usb` to the `disp-sys-audio`.

Note that if you attach the device persistently, the AudioVM will
[not be able to start](https://github.com/QubesOS/qubes-issues/issues/8877)
without first starting the backend holding the USB stack. You can move the
controller from the USB qube to the Audio qube, but this would decrease your
system security.

First, start the qube holding the USB stack:
```sh
qvm-start disp-sys-usb
```

Identify you Bluetooth controller:
```
qvm-usb list disp-sys-usb
```

If you haven't identified the device, run `lsusb` in the USB stack server:
```sh
qvm-run -p disp-sys-usb -- lsusb
```

Permanently attach the Bluetooth controller to the AudioVM (change `DEVID` for
the one you identified above):
```sh
qvm-usb attach --persistent disp-sys-audio disp-sys-usb:DEVID
```
