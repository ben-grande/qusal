# fetcher

Fetch publicly accessible files over the internet in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)

## Description

A Template for DispVMs will be created and named "dvm-fetcher", from this qube
you will create others that can connect to the internet to download files. You
will be able to download from many protocol as long as the installed tools
accepts them.

Supported protocols: DICT, FILE, FTP, FTPS, GOPHER, GOPHERS, HTTP, HTTPS,
IMAP, IMAPS, LDAP, LDAPS, MQTT, POP3, POP3S, RTMP, RTMPS, RTSP, SCP, SFTP,
SMB, SMBS, SMTP, SMTPS, TELNET, TFTP, WS, WSS, RSYNC, BitTorrent.

## Installation

*   Top:

```sh
sudo qubesctl top.enable fetcher
sudo qubesctl --targets=tpl-fetcher,dvm-fetcher state.apply
sudo qubesctl top.disable fetcher
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply fetcher.create
sudo qubesctl --skip-dom0 --targets=tpl-fetcher state.apply fetcher.install
sudo qubesctl --skip-dom0 --targets=dvm-fetcher state.apply fetcher.configure-dvm
```

<!-- pkg:end:post-install -->

## Usage

You will create disposable qubes based on the Template for DispVMs
`dvm-fetcher` to download files over the internet using popular command-line
tools such as `git`, `curl`, `wget`, `rsync`, `transmission-cli` as well as a
graphical interface for torrenting `transmission-qt`.

You can use disposables based from `dvm-fetcher` to clone repositories,
download PGP signatures, Operating System ISOs etc.
