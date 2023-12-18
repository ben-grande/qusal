# fetcher

Fetch publicly accessible files over the internet in Qubes OS.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)

## Description

A Template for DispVMs will be created and named "dvm-fetcher", from this qube
you will create others that can connect to the internet to download files. You
will be able to download from any protocol as long as the installed tools,
`curl`, `wget`, `git`, `rsync`, accept them.

## Installation

- Top:
```sh
qubesctl top.enable fetcher
qubesctl --targets=tpl-fetcher,dvm-fetcher state.apply
qubesctl top.disable fetcher
```

- State:
<!-- pkg:begin:post-install -->
```sh
qubesctl state.apply fetcher.create
qubesctl --skip-dom0 --targets=tpl-fetcher state.apply fetcher.install
qubesctl --skip-dom0 --targets=dvm-fetcher state.apply fetcher.configure-dvm
```
<!-- pkg:end:post-install -->

## Usage

You will base qubes from the Template for DispVMs `dvm-fetcher` to download
files over the internet using popular command-line tools such as `git`,
`curl`, `wget`, `rsync`.

You can use disposables based from `dvm-fetcher` to clone repositories,
download PGP signatures, Operating System ISOs etc.
