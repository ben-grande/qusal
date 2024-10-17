# video-companion

Stream webcams and share screens in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)
    *   [Basic usage](#basic-usage)
    *   [Remote support usage](#remote-support-usage)

## Description

Installation procedures to stream webcams and share screens across qubes. The
sender/server owns the screen or webcam and the receiver/client wants to
access them without compromising the domains.

## Installation

*   Top:

```sh
sudo qubesctl top.enable video-companion
sudo qubesctl state.apply
sudo qubesctl top.disable video-companion
```

*   State:

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

### Basic usage

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

### Remote support usage

If you need to give or receive remote support, Qubes Video Companion is an
excellent option for an easy to setup, view-only connection.

The
[qubes-remote-support](https://github.com/QubesOS/qubes-remote-support/tree/main)
is an option where the receiver exposes dom0 desktop to the support
provider, it requires running a lot of code in dom0, such as Wormhole, tor
(with Onion Authentication), an SSH server (with public key) and an X2Go
server. It has some major downsides, network latency is capped by onion
routing, shares the whole dom0 screen and has access to the shell, runs too
many servers in the most privileged domain and Wormhole package was orphaned
from Fedora repositories, meaning it doesn't work at this moment and fixes
requires a maintainer upstream.

If you need a simple solution that is view-only, from which you can choose
which monitor to share, which qube to share the windows from, which network
chain to establish for the connection by choosing the `netvm`, which
software to use to share the screen to such as pre-installed applications
(Firefox browser), qubes-video-companion is a great option for that.

Consider the following qube setup on the receiver side:

*   `video-conference`: qube which you will run the conference application
*   `broken`: qube which requires assistance

1.  On the qube `video-conference`, start the companion with
    `qubes-video-companion screenshare` and choose the `broken` qube.
2.  On the qube `video-conference`, start the conference application, can be
    from the web browser or a desktop application. Click to allow camera
    access, it will instead share the `broken` qube windows. The camera can
    appear mirrored/inverted for you, don't worry, the person on the other end
    will see the video correctly.
3.  From the qube where you communicate with your remote support provider,
    share the necessary information for them to connect to the call.

The remote support provider only needs to connect to the call with the same
application used by the client, which can be a web or desktop application. The
intended use case is for visual diagnostics and instructional based support
where the remote support recipient does the actions and the provider guides
them.

There are also downsides to this method. The remote support provider can't do
any tasks that requires write capabilities. The readability of the video might
be low, depending on how many monitors are connected (the few, the better to
set the correct resolution automatically without the user having to configure
it), the font size. In case the receiver disconnects the screenshare or
connects to the call before the starting the screenshare, they might need to
exit and enter the call, reload the web page or disable and enable the camera
permissions for the conference software to detect the camera.
