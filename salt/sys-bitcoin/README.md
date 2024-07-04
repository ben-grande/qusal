# sys-bitcoin

Bitcoin Core in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)
    *   [Custom daemon parameters](#custom-daemon-parameters)
    *   [Bitcoin Core GUI](#bitcoin-core-gui)
    *   [Connect to a remote Bitcoin RPC](#connect-to-a-remote-bitcoin-rpc)
        *   [Evaluation of remote Bitcoin RPC](#evaluation-of-remote-bitcoin-rpc)
        *   [Configure the remote node](#configure-the-remote-node)
        *   [Connect the qube to the remote node](#connect-the-qube-to-the-remote-node)
    *   [Database on external drive](#database-on-external-drive)
*   [Credits](#credits)

## Description

Setup a Bitcoin Daemon full-node qube named "sys-bitcoin", where you will
index the Bitcoin blockchain. A second non-networked qube named "bitcoin" can
manage a wallet and sign transactions.

By default, installation from upstream binaries will be used, but you can
choose to build from source if you prefer. Compiling from source will not have
the default configuration flags, but will be optimized to our use case.

The download of the Bitcoin source code or binaries as well as the connections
to the Bitcoin P2P network will happen over the Tor network.

If you already have a node on your network that has indexed the blockchain
already and has RPC enabled for remote clients, you can also connect to it,
preferably if it has transport encryption when connecting to the Bitcoin node
with an encrypted tunnel.

A disposable qube "disp-bitcoin-builder" will be created, based on
Whonix-Workstation, it will server to install and verify Bitcoin Core. After
the verification succeeds, files are copied to the template "tpl-sys-bitcoin".
This method was chosen so the client can be always offline and the build
artifacts are built on a machine that is not running the daemon and thus can
be copied to the template with a higher degree of trust.

At least `1TB` of disk space is required. At block `829054` (2024-02-05),
`642G` are used.

## Installation

*   Top:

```sh
sudo qubesctl top.enable sys-bitcoin
sudo qubesctl --targets=sys-bitcoin-gateway,tpl-sys-bitcoin,disp-sys-bitcoin-builder,sys-bitcoin,bitcoin state.apply
sudo qubesctl top.disable sys-bitcoin
sudo qubesctl state.apply sys-bitcoin.appmenus
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply sys-bitcoin.create
sudo qubesctl --skip-dom0 --targets=sys-bitcoin-gateway state.apply sys-bitcoin.configure-gateway
sudo qubesctl --skip-dom0 --targets=tpl-sys-bitcoin state.apply sys-bitcoin.install
sudo qubesctl --skip-dom0 --targets=disp-bitcoin-builder state.apply sys-bitcoin.configure-builder
sudo qubesctl --skip-dom0 --targets=sys-bitcoin state.apply sys-bitcoin.configure
sudo qubesctl --skip-dom0 --targets=bitcoin state.apply sys-bitcoin.configure-client
sudo qubesctl state.apply sys-bitcoin.appmenus
```

<!-- pkg:end:post-install -->

If you prefer to build from source (will take approximately 1 hour to build):

```sh
sudo qubesctl --skip-dom0 --targets=tpl-sys-bitcoin state.apply sys-bitcoin.install-source
sudo qubesctl --skip-dom0 --targets=disp-bitcoin-builder state.apply sys-bitcoin.configure-builder-source
```

If you want to relay blocks (listening node):

```sh
sudo qubesctl --skip-dom0 --targets=sys-bitcoin-gateway state.apply sys-bitcoin.configure-gateway-listen
sudo qubesctl --skip-dom0 --targets=sys-bitcoin state.apply sys-bitcoin.configure-listen
```

Add the tag `bitcoin-client` to the client and install in the client template:

```sh
sudo qubesctl --skip-dom0 --targets=TEMPLATE state.apply sys-bitcoin.install-client
```

## Usage

The qube `sys-bitcoin` can:

*   Index the Bitcoin blockchain connecting to peers over Tor;
*   Connect to a remote Bitcoin RPC reachable over Tor; and
*   Broadcast transactions over Tor.

The qube `bitcoin` can:

*   Create wallet addresses; and
*   Sign transactions.

### Custom daemon parameters

You can set extra parameters for the daemon in
`~/.bitcoin/conf.d/bitcoin.conf.local`, this file will never be changed
externally.

One of these parameters is `prune`, which reduces storage requirements by
deleting old blocks. The downside is that it can't serve old blocks, can't be
used to rescan old wallet and is incompatible to serve any Electrum Server.

You can enable pruning in `/home/user/.bitcoin/conf.d/bitcoin.conf.local` by
specifying how many `MiB` of block files to retain:

```cfg
prune=550
```

A configuration you may want to do after IBD (Initial Block Download) is to
reduce the used memory, as it is not necessary anymore to have a large cache.
As the bitcoind option `dbcache` is dynamic allocated per the qube memory,
you just need to reduce the memory available to the `sys-bitcoin` qube. From
`dom0`, run:

```sh
qvm-prefs sys-bitcoin memory 1000
```

### Bitcoin Core GUI

Do not use the GUI in the `sys-bitcoin` qube to edit configuration, it won't
persist and `bitcoin-qt` cannot be run at the same time as `bitcoind`.

You can use the GUI in the `bitcoin` qube, specially useful for an easy-to-use
interface for the Bitcoin Core Wallet.

### Connect to a remote Bitcoin RPC

#### Evaluation of remote Bitcoin RPC

You may wish to connect to a remote Bitcoin node with RPC available to:

*   Lower disk space usage and to lower resource consumption by not having
    multiple Bitcoin blockchains;
*   Avoid changing  scripts and configurations that expect the connection to
    be working on `127.0.0.1:8332`, such as the Qrexec policy for connecting
    Bitcoind RPC to the Electrum Servers.

But there are huge disadvantages to this method:

*   [Bitcoin Core RPC does not have transport encryption](https://github.com/bitcoin/bitcoin/blob/master/doc/release-notes/release-notes-0.12.0.md#rpc-ssl-support-dropped).
    Therefore, this method is advised against unless you know how to enable
    transport encryption to connect to your Bitcoin RPC. If you run bitcoind
    on `sys-bitcoin`, you do not have to worry about transport encryption as
    communication is done securely via Qrexec.
*   Bitcoin configuration cannot be changed remotely, therefore adding RPC
    Authentication for clients such as Electrum Servers have to be done
    manually.

The remote bitcoind setup is difficult to fit all user needs and requires you
to change a remote node we have no control over the configuration, therefore,
it is intended for advanced users only.

#### Configure the remote node

On the remote node:

*   You must set in the node's `bitcoin.conf`, the following options to bind
    to the external interface: `rpcbind`, `bind` (Electrs),
    `whitelist=download@<ADDR>` (ElectRS), `zmqpubhashblock` (Fulcrum) and
    allow connections of the external IP of your upstream netvm via
    `rpcallowip`.
*   Open the configured ports of the previous settings in the firewall to be
    reachable by the Qubes system.
*   Generate RPC credentials (see `bitcoin/share/rpcauth/rpcauth.py`), add
    `rpcauth=` option to `bitcoin.conf` and save the `user` and `password` for
    later.
*   Restart bitcoind to apply the configuration changes.

#### Connect the qube to the remote node

**Warning**: use of `sys-bitcoin` for the remote node connection is
discouraged as you either need to expose the node RPC port to an onion service
(preferably with Onion Authentication) or punch a hole in the Whonix firewall
so it can reach your LAN.

The following example uses the qube `sys-net` as a netvm that can connect
to your remote node running on the address `192.168.2.10`, RPC port `8332`,
P2P port `8333`, ZMQPUBHASHBLOCK port `8433`.

In `dom0`, create the user Qrexec policy to target the qube `sys-net` in
`/etc/qubes/policy.d/30-user.policy`:

```qrexecpolicy
## Getting Auth doesn't work with remote node.
qusal.BitcoinAuthGet * @anyvm @anyvm   deny

qubes.ConnectTCP +8332 @tag:bitcoin-client @default allow target=sys-net
qubes.ConnectTCP +8333 @tag:bitcoin-client @default allow target=sys-net
qubes.ConnectTCP +8433 @tag:bitcoin-client @default allow target=sys-net
qubes.ConnectTCP *     @tag:bitcoin-client @anyvm   deny
```

In the qube `sys-net`, add the `socat` command (only the ones you need) to the
file `/rw/config/rc.local`:

```sh
## RPC
socat TCP-LISTEN:8332,reuseaddr,fork,bind=127.0.0.1 TCP:192.168.2.10:8332 &
## P2P (ElectRS)
socat TCP-LISTEN:8333,reuseaddr,fork,bind=127.0.0.1 TCP:192.168.2.10:8333 &
## ZMQPubHashBlock (Fulcrum)
socat TCP-LISTEN:8433,reuseaddr,fork,bind=127.0.0.1 TCP:192.168.2.10:8433 &
```

In the Electrum Server qubes or any Bitcoin Client, `sys-electrumx`,
`sys-electrs`, `sys-fulcrum`, add the `qvm-connect-tcp` command to the file
`/rw/config/rc.local`:

```sh
## RPC
qvm-connect-tcp ::8332
## P2P (ElectRS)
qvm-connect-tcp ::8333
## ZMQPubHashBlock (Fulcrum)
qvm-connect-tcp ::8433
```

Still in the Electrum Server qube, you will have to add the RPC authentication
you got from the remote node to `~/.bitcoin/.cookie`.

Restart the qubes you modified the configuration to check if the service is
starting automatically on boot.

### Database on external drive

Your machine might not have enough disk space to store the database and you
don't want to configure a remote client. Unfortunately, this method is
unsupported. It may be possible, but as mounting the drive requires user
intervention, you are on your own to adjust the database path.

If you have done this, please share a guide.

## Credits

*   [qubenix](https://github.com/qubenix/qubes-whonix-bitcoin)
