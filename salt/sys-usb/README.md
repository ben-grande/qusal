# sys-usb

PCI handler of USB devices in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
    *   [Keyboard installation](#keyboard-installation)
    *   [AudioVM installation](#audiovm-installation)
    *   [Client installation](#client-installation)
        *   [Client USB proxy installation](#client-usb-proxy-installation)
        *   [Client cryptsetup installation](#client-cryptsetup-installation)
        *   [Client CTAP installation](#client-ctap-installation)
*   [Access control](#access-control)
*   [Usage](#usage)
    *   [How to use audio devices](#how-to-use-audio-devices)
*   [Credits](#credits)

## Description

Setup named disposables for USB qubes. During creation, it tries to separate
the USB controllers to different qubes is possible.

## Installation

*   Top:

```sh
sudo qubesctl top.enable sys-usb
sudo qubesctl --targets=tpl-sys-usb state.apply
sudo qubesctl top.disable sys-usb
sudo qubesctl state.apply sys-usb.appmenus
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply sys-usb.create
sudo qubesctl --skip-dom0 --targets=tpl-sys-usb state.apply sys-usb.install
sudo qubesctl state.apply sys-usb.appmenus
```

<!-- pkg:end:post-install -->

### Keyboard installation

If you use an USB keyboard, also run:

```sh
sudo qubesctl state.apply sys-usb.keyboard
```

### AudioVM installation

If you plan to use `disp-sys-usb` as an AudioVM:

```sh
sudo qubesctl --skip-dom0 --targets=tpl-sys-usb state.apply sys-audio.install
sudo qubesctl --skip-dom0 --targets=dvm-sys-usb state.apply sys-audio.configure-dvm
qvm-tags disp-sys-usb add audiovm
qvm-features disp-sys-usb service.audiovm 1
```

And set the qube preference `audiovm` to `disp-sys-usb`:

```sh
qvm-prefs QUBE audiovm disp-sys-usb
```

### Client installation

#### Client USB proxy installation

Install the proxy on the client template:

```sh
sudo qubesctl --skip-dom0 --targets=TEMPLATE state.apply sys-usb.install-client-proxy
```

#### Client cryptsetup installation

If the client requires decrypting a device, install on the client template:

```sh
sudo qubesctl --skip-dom0 --targets=TEMPLATE state.apply sys-usb.install-client-cryptsetup
```

#### Client CTAP installation

If the client requires a CTAP device, install on the client template:

```sh
sudo qubesctl --skip-dom0 --targets=TEMPLATE state.apply sys-usb.install-client-fido
```

And enable the CTAP Proxy service for the client qubes:

```sh
qvm-features QUBE service.qubes-ctap-proxy 1
```

## Access control

No extra services are implemented, consult upstream to learn how to use the
following services:

*   `qubes.InputMouse`, `qubes.InputKeyboard`, `qubes.InputTablet`;
*   `ctap.GetInfo`, `ctap.ClientPin`, `u2f.Register`, `u2f.Authenticate`,
    `policy.RegisterArgument`.

## Usage

Depending on you system, one or more USB qubes will be created to hold the
different controllers. The qube names are `disp-sys-usb`, `disp-sys-usb-left`,
`disp-sys-usb-dock`.

Start a USB qube an connect a device to it. USB PCI devices will appear on the
system tray icon `qui-devices`. From there, assign it to the intended qube.

### How to use audio devices

Bluetooth and Camera are normally integrated in laptops, but they still are
USB devices internally. They will be held by `(disp-)sys-usb` or
`(disp-)sys-net`, else `dom0`.

To use these devices, evaluate the following options:

1.  Attaching the device (USB passthrough) to the audio client:
    *   Advantages:
        *   Easier setup as it doesn't require an AudioVM.
    *   Disadvantages:
        *   Increased latency;
        *   Only one qube can use the device; and
        *   Less secure as it exposes the Audio stack to the client.

2.  Leaving devices to the AudioVM (`(disp-)sys-usb` as AudioVM):
    *   Advantages:
        *   More secure as the devices are not on the client;
        *   Less latency; and
        *   All audio clients will have the same audio capabilities.
    *   Disadvantages:
        *   Some applications might not work due to not finding the device.

3.  Using [video-companion](../video-companion/README.md) to access webcam:
    *   Advantages:
        *   The most secure for client and server as the physical devices are
          unmanaged;
        *   Least latency.
    *   Disadvantages:
        *   Can't use video-companion to screen share and share webcam at the
          same time; and
        *   Does not cover audio.

## Credits

*   [Unman](https://github.com/unman/shaker/blob/main/sys-usb)
