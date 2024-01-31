# electrum

Electrum Bitcoin Wallet in Qubes OS.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)
  * [Wallet cooperation](#wallet-cooperation)
  * [Cold wallet terminology](#cold-wallet-terminology)

## Description

Setup multiple lightweights Electrum Bitcoin Wallets, one offline qube named
"electrum-cold" and one online qube based on Whonix-Workstation named
"electrum-hot".

## Installation

- Top
```sh
qubesctl top.enable electrum
qubesctl --targets=tpl-electrum,electrum-cold,electrum-hot state.apply
qubesctl top.disable electrum
qubesctl state.apply electrum.appmenus
```

- State
<!-- pkg:begin:post-install -->
```sh
qubesctl state.apply electrum.create
qubesctl --skip-dom0 --targets=tpl-electrum state.apply electrum.install
qubesctl --skip-dom0 --targets=electrum-cold,electrum-hot state.apply electrum.configure
qubesctl state.apply electrum.appmenus
```
<!-- pkg:end:post-install -->

## Usage

The qube `electrum-cold` serves as a cold wallet, while the `electrum-hot` is
networked via tor and you can use it as a watching-only (only pub key present)
or hot wallet (private key present).

### Wallet cooperation

If you plan to create private keys on any wallet, it is recommended to pause
or shutdown all qubes to reduce the side-channel attack surface.

As you have both types of wallets, a networked and an offline one, with the
networked wallet you can broadcast transactions while with the offline one,
you sign them. Sharing data between the qubes can be done with `qvm-copy` and
the process of combining a watching-only and a cold wallet is explained in the
[Electrum wiki](https://electrum.readthedocs.io/en/latest/coldstorage.html).

### Cold wallet terminology

I can expect some comments complaining about the term `cold wallet` when
using Qubes OS with an online system. We use this term to refer to an isolated
environment (a qube) that has no internet connection.

You are free to use a non-Qubes physically air-gapped system if you prefer,
you just have to remove the Audio stack (microphone, speakers), Video stack
(camera), USB stack (external ports, Bluetooth), Network stack (network
cards), External reference lights (blinking pattern). If you use a hardware
wallet, you are dependent on a specific hardware vendor and you will need to
choose at least an insecure transfer method, scanning QR code where you can
expose the camera to the data being read, connecting via NFC/USB/SD card
exposes to the USB stack, transfer via radio exposes all devices nearby to the
signal being passed, guard against supply-chain attacks. In the end, your
air-gapped system is not so secure as you thought it to be.

Yes, a Xen exploit that reaches Dom0 or a CPU exploit that can infer
[the memory contents of other running VMs](https://www.qubes-os.org/news/2023/11/14/qsb-096/)
or [the contents of data from a different execution context on the
same CPU core](https://www.qubes-os.org/news/2023/09/27/qsb-094/) can
compromise private private keys, so it is up to you, the user, to choose your
strategy.

Another possibility is a fully offline Qubes OS with this formula installed,
but then again, transferring the data safely to communicate with a networked
device for the transactions to be broadcasted is still a hard thing to fix for
physical air-gapped systems.

There is no consensus on the best solution, choose the option that you can
have more security, not the one you "fell" more secure.
