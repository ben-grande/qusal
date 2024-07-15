# sys-audio

Audio operations in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)
    *   [Audio control](#audio-control)
    *   [Client turned off with a device attached](#client-turned-off-with-a-device-attached)
    *   [How to managed audio input/output devices](#how-to-managed-audio-inputoutput-devices)
    *   [How to use advanced audio processing capabilities](#how-to-use-advanced-audio-processing-capabilities)
    *   [How to use Bluetooth](#how-to-use-bluetooth)
        *   [How to make the Bluetooth icon appear in the system tray](#how-to-make-the-bluetooth-icon-appear-in-the-system-tray)
        *   [How to attach the Bluetooth controller to the AudioVM persistently](#how-to-attach-the-bluetooth-controller-to-the-audiovm-persistently)

## Description

Creates the named disposable "disp-sys-audio" qube for providing audio
operations such as microphone and speakers to and from qubes. By default, you
can use the builtin stereo, JACK and  USB , but if you want, you can install
the necessary packages for bluetooth with the provided state.

## Installation

*   Top:

```sh
sudo qubesctl top.enable sys-audio
sudo qubesctl --targets=tpl-sys-audio,dvm-sys-audio state.apply
sudo qubesctl top.disable sys-audio
sudo qubesctl state.apply sys-audio.appmenus
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply sys-audio.create
sudo qubesctl --skip-dom0 --targets=tpl-sys-audio state.apply sys-audio.install
sudo qubesctl --skip-dom0 --targets=dvm-sys-audio state.apply sys-audio.configure-dvm
sudo qubesctl state.apply sys-audio.appmenus
```

<!-- pkg:end:post-install -->

If you want to autostart the AudioVM on boot, you may run:

```sh
sudo qubesctl state.apply sys-audio.autostart
```

To use advanced sound features such as mixing, echo canceller, noise
reduction:

```sh
sudo qubesctl --skip-dom0 --targets=tpl-sys-audio state.apply sys-audio.install-easyeffects
```

If you need Bluetooth support, install the dependencies:

```sh
sudo qubesctl --skip-dom0 --targets=tpl-sys-audio state.apply sys-audio.install-bluetooth
```

## Usage

### Audio control

The qube `disp-sys-audio` will be used for audio capabilities for speakers
and microphones, with builtin modules, Jack port, USB or Bluetooth. You are be
able to control the volume via the volume icon that appears on the system
tray.

Audio control basics:

*   Left click toggles the volume; and
*   Scrolling the mouse from left to right changes the volume;

For more advanced features, right click the icon and click on `Open Mixer` or
`Preferences`. For greater control, use the command `amixer`.

### Client turned off with a device attached

If you shutdown a client qube with a device attached, such as a microphone or
speaker, normal operation to attach the device to the same or any other qube
will fail. To be able to use the device again:

*   Restart the AudioVM `disp-sys-audio`;
*   Restart the audio client; and
*   Attach the device to the audio client.

### How to managed audio input/output devices

It is possible to connect many types of audio devices to `disp-sys-audio`,
just attach the devices to the AudioVM. Note that attached devices don't take
precedence over built-in audio, happens with USB devices. To choose which
playback and recording device a qube should use, on `disp-sys-audio`, from the
application menu, click on `Volume Control` or from the terminal, run
`pavucontrol`. Select the `Playback` and `Recording` tab, find your client
qube and select the wanted device.

For more information, please refer to the
[usage of sys-usb](../sys-usb/README.md#usage).

### How to use advanced audio processing capabilities

You must run the `install-easyeffects` state as described in the installation
section. Instead of using `Pavucontrol`, use `Easy Effects` for advanced audio
processing capabilities.

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

It may be easier to
[use the USB qube as the AudioVM instead](../sys-usb/README.md#usage).

First, start the qube holding the USB stack:

```sh
qvm-start disp-sys-usb
```

Identify you Bluetooth controller:

```sh
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
