# video-companion

Stream webcams and share screens in Qubes OS.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)

## Description

Installation procedures to stream webcams and share screens across qubes. The
sender/server owns the screen or webcam and the receiver/client wants to
access them without compromising the domains.

## Installation

- Top:
```sh
sudo qubesctl top.enable video-companion
sudo qubesctl state.apply
sudo qubesctl top.disable video-companion
```

- State:
<!-- pkg:begin:post-install -->
```sh
sudo qubesctl state.apply video-companion.create
```
<!-- pkg:end:post-install -->


Installation on the server (sender) template:
```sh
sudo qubesctl --skip-dom0 --targets=QUBE state.apply video-companion.install-sender
```

Installation on the client (receiver) template:
```sh
sudo qubesctl --skip-dom0 --targets=QUBE state.apply video-companion.install-receiver
```

Installation for debugging on the client (receiver) template:
```sh
sudo qubesctl --skip-dom0 --targets=QUBE state.apply video-companion.install-receiver-debug
```

## Usage

The sender has the screen you want to share of the webcam you want to access.

The receiver the is client that requests access to the screen of webcam,
therefore the client is responsible to initiate the call.

On the client, to get the screen of another qube:
```sh
qubes-video-companion screenshare
```

On the client, to get the webcam of another qube:
```sh
qubes-video-companion webcam
```

On the client, if you installed the debug utilities, call cheese to access the
shared screen or webcam:
```sh
cheese
```

Refer to [upstream usage guide](https://github.com/QubesOS/video-companion?tab=readme-ov-file#usage)
for more information.
