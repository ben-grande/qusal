# electrum

Electrum Bitcoin Wallet in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)
    *   [Connect your cold wallet to a trusted server](#connect-your-cold-wallet-to-a-trusted-server)
    *   [Connect your cold wallet to an untrusted server](#connect-your-cold-wallet-to-an-untrusted-server)
    *   [Recommendations for cryptographic operations](#recommendations-for-cryptographic-operations)
    *   [Cold wallet terminology](#cold-wallet-terminology)
*   [Credits](#credits)

## Description

Setup multiple lightweights Electrum Bitcoin Wallets, one offline qube named
"electrum" and one online qube based on Whonix-Workstation named
"electrum-hot".

You can use either wallet or both together depending on your setup. Use the
"electrum" to sign transactions and the "electrum-hot" to broadcast them.

By default, the installation verify and fetch the tarball from upstream
sources, avoiding using outdated distribution package versions that lack
important security fixes. The fetching will occur over Tor and on a disposable
qube "disp-electrum-builder", which will then upload the files to the template
"tpl-electrum". The installation on a disposable helps separate the wallet
usage from ever connecting to the internet.

## Installation

*   Top:

```sh
sudo qubesctl top.enable electrum
sudo qubesctl --targets=sys-bitcoin-gateway,tpl-electrum-builder,tpl-electrum,disp-electrum-builder,electrum,electrum-hot state.apply
sudo qubesctl top.disable electrum
sudo qubesctl state.apply electrum.appmenus
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply electrum.create
sudo qubesctl --skip-dom0 --targets=sys-bitcoin-gateway state.apply sys-bitcoin.configure-gateway
sudo qubesctl --skip-dom0 --targets=tpl-electrum-builder state.apply electrum.install-builder
sudo qubesctl --skip-dom0 --targets=tpl-electrum state.apply electrum.install
sudo qubesctl --skip-dom0 --targets=disp-electrum-builder state.apply electrum.configure-builder
sudo qubesctl --skip-dom0 --targets=electrum state.apply electrum.configure
sudo qubesctl --skip-dom0 --targets=electrum-hot state.apply electrum.configure-hot
sudo qubesctl state.apply electrum.appmenus
```

<!-- pkg:end:post-install -->

## Usage

The qube `electrum` serves as a cold wallet, while the `electrum-hot` is
networked via tor. Both wallets can be watching-only or signing wallet,
depending on how you configure them.

### Connect your cold wallet to a trusted server

If you are running an Electrum Server with our formulas, such as
[sys-electrs](../sys-electrs/README.md),
[sys-electrumx](../sys-electrumx/README.md), the formula documentation
instructs how to make the server available to the client and the rest of this
section doesn't apply to you.

If you server doesn't run with our formulas, you must do some extra steps.

Choose a netvm that can reach your Electrum Server and bind the server port to
the netvm localhost. Prefer the port that supports **SSL**, normally `50002`.
In the following example, our server is running on `192.168.2.10:50002` and
our netvm qube is named `sys-net`.

In the qube `dom0`, allow `electrum` to connect to `sys-net` port
`50002` via Qrexec Policy in the file `/etc/qubes/policy.d/30-user.policy`:

```qrexecpolicy
qubes.ConnectTCP +50002 electrum @default allow target=sys-net
```

In the qube `sys-net`, add the `socat` command to the file
`/rw/config/rc.local`:

```sh
socat TCP4-LISTEN:50002,reuseaddr,fork,bind=127.0.0.1 TCP:192.168.2.10:50002 &
```

In the qube `electrum`, add the `qvm-connect-tcp` command to the file
`/rw/config/rc.local`:

```sh
qvm-connect-tcp ::50002
```

In the qube `electrum`, run as the user `user` the electrum configuration
commands:

```sh
electrum --offline setconfig auto_connect false
electrum --offline setconfig oneserver true
electrum --offline setconfig server 127.0.0.1:50002
```

If you used a plain-text port, no SSL:

```sh
electrum --offline setconfig server 127.0.0.1:50001:t
```

### Connect your cold wallet to an untrusted server

You should not use an untrusted third-party Electrum Server with this method
because it only connects to a single server and it poses a higher security
risk as the SPV method can not work with this design. If you don't have your
own server, you are better off using `electrum-hot` and connecting to multiple
public servers, you loose privacy (over Tor) in favor of security (no loss of
Bitcoins).

As the client can't connect to other services to subscribe to block header
notifications, the wallet is solely trusting the information delivered by the
third-party server, whether its is lagging, splitting or forking the chain.
The SPV method can not be executed because it does not have a minimum number
of servers to verify the information against each other.

Read more about [potention SPV weaknessses](https://developer.bitcoin.org/devguide/operating_modes.html#potential-spv-weaknesses).

### Recommendations for cryptographic operations

If you plan to create private keys or sign transaction, it is recommended to
pause or shutdown all qubes to reduce the side-channel attack surface.

Although there is a possibility that there is not enough entropy source to
create a secure wallet in a virtualized environment, this property is not
taken care by this formula, it trusts the Kernel and Electrum Wallet to
provide enough entropy.

### Cold wallet terminology

I can expect some comments complaining about the term `cold wallet` when
using Qubes OS with an online system. We use this term to refer to an isolated
environment (a qube) that has no internet connection and can optionally reach
an Electrum Server.

As a general rule, private keys should be stored on cold (offline) storage,
because it greatly diminishes the attack surface of internet facing malware.

Should you decide to store the private key on a cold virtualized storage such
as the `electrum` non-networked qube while other qubes have internet
access or on a physically isolated machine normally referred as an `air
gapped` system, every method has drawbacks.

As you have both types of wallets, a networked `electrum-hot` and an offline
one `electrum`, with the networked wallet you can broadcast transactions
while with the offline one, you sign them. Sharing data between the qubes can
be done with `qvm-copy` and the process of combining a watching-only and a
cold wallet is explained in the [Electrum wiki](https://electrum.readthedocs.io/en/latest/coldstorage.html).

Apart from the fact that most people loose Bitcoin by losing their private
keys, being phished, using modified or outdated Bitcoin Node versions, the
difficult part of securing your private key on a separate domain compared to
the domain that can broadcast the transaction, is the trust you must assign to
the less trusted domain to be able to send information to the more trusted
domain. Such things are much worse when using non-Qubes because the transfer
method is often insecure.

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

QubesOS provides secure tools to communicate data between domains, most common
ones are inter-VM File Copy and inter-VM clipboard. When using those programs,
there is no USB, nor camera, nor radio signal used in those qubes, therefore
not dealing with a lot of complicated and code that could expose higher risks
or normal systems, but isolated on Qubes by UsbVMs, that holds the backend of
the USB PCI bus devices.

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

We recommend reading former QubesOS developer, Joanna Rutkowska's paper about
[Software compartmentalization vs physical separation](https://invisiblethingslab.com/resources/2014/Software_compartmentalization_vs_physical_separation.pdf).

There is no consensus on the best solution, choose the option that you can
have more security, not the one you "fell" more secure.

## Credits

*   [qubenix](https://github.com/qubenix/qubes-whonix-bitcoin)
