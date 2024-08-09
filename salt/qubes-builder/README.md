# qubes-builder

Setup Qubes OS Builder V2 in Qubes OS itself.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Access Control](#access-control)
*   [Usage](#usage)
    *   [Pulling new commits](#pulling-new-commits)
    *   [Add PGP public key to qubes-builder GPG home directory](#add-pgp-public-key-to-qubes-builder-gpg-home-directory)
    *   [Builder configuration](#builder-configuration)
    *   [Build Qusal](#build-qusal)

## Description

Setup a Builder qube named "qubes-builder" and a disposable template for Qubes
Executor named "dvm-qubes-builder". It is possible to use any of the available
executors: docker, podman, qubes-executor.

During installation, after cloning the qubes-builderv2 repository, signatures
will be verified and the installation will fail if the signatures couldn't be
verified. Packages necessary for split operations such as split-gpg2, spit-git
and split-ssh-agent will also be installed.

## Installation

The template is based on Fedora Minimal and not Debian Minimal due to the
Qubes Executor lacking some dependencies on Debian such as
[mock](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1025460). Even if the
builder qube was Debian based, the executor qube still needs to be a Fedora
template.

<!-- TODO: remove after 1 month: 2024-08-4 -->
If installation fails on non existent qubes-infrastructure-mirrors directory
during the `qubes-builder.configure` state, please
[manually pull new commits](#Pulling new commits) and then run the state
again. This issue will occur to everyone that ran the same state before
`2024-07-01`, due to [submodule addition](https://github.com/QubesOS/qubes-builderv2/commit/bc6d9a9954d985d2be3ec76ce86d44fea13d345b).
Qusal maintainer decision is not to handle such issue automatically as it
can lead to data loss in case user does manual changes, the installation would
need to `reset` the user changes and to do a clean `pull` that wouldn't fail.
After you've pulled the commit including the `.gitmodules` once, future
installations won't have this issue.

*   Top:

```sh
sudo qubesctl top.enable qubes-builder
sudo qubesctl --targets=tpl-qubes-builder,dvm-qubes-builder,qubes-builder state.apply
sudo qubesctl top.disable qubes-builder
sudo qubesctl state.apply qubes-builder.prefs
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply qubes-builder.create
sudo qubesctl --skip-dom0 --targets=tpl-qubes-builder state.apply qubes-builder.install
sudo qubesctl state.apply qubes-builder.prefs
sudo qubesctl --skip-dom0 --targets=dvm-qubes-builder state.apply qubes-builder.configure-qubes-executor
sudo qubesctl --skip-dom0 --targets=qubes-builder state.apply qubes-builder.configure
```

<!-- pkg:end:post-install -->

If you plan to write for a long time and analyze logs on the builder qube, it
is recommended to install some development goodies:

```sh
sudo qubesctl --skip-dom0 --targets=tpl-qubes-builder state.apply qubes-builder.install-dev
```

If you plan on building Qusal packages (Development only):

```sh
sudo qubesctl --skip-dom0 --targets=qubes-builder state.apply qubes-builder.configure-qusal
```

## Access Control

The policy is based on `qubes-builderv2/rpc/50-qubesbuilder.policy`.
Extra services added are `qubes.Gpg2`, `qusal.GitInit`, `qusal.GitFetch`,
`qusal.GitPush`, `qusal.SshAgent`. Necessary services are allowed to have an
unattended build.

## Usage

### Pulling new commits

The installation will clone the repository but not pull new commits. You will
need to pull new commits from time to time, their signature will be
automatically verified before merging them to your git index.

Pull `qubes-builderv2` commits:

```sh
git pull
```

Initialize and merge submodules:

```sh
git submodule update --init
git submodule update --merge
```

### Add PGP public key to qubes-builder GPG home directory

If you need to pull commits signed by someone with a key not deployed by
default, import their key to the GPG home directory of qubes-builder:

```sh
gpg-qubes-builder --import /path/to/key
```

### Builder configuration

When using the Qubes Executor, configure the `builder.yml` options:

*   For configuration deduplication, include other files;
*   When `executor:type:qubes` use the desired DispVM Template:
    `executor:options:dispvm:`: `"@dispvm"`;
*   Enforce the use of `split-gpg2`: `gpg-client`: `gpg`.

```yaml
include:
  - example-configs/desired-config.yml

executor:
  type: qubes
  options:
    dispvm: "@dispvm"

gpg-client: gpg
```

### Build Qusal

**Warning**: development only.

You can easily build Qusal as a default configuration is provided.

Place only the following in `builder.yml`:

```yaml
include:
  - ../qusal-builder/qusal.yml
```

To run the `sign` state, you will need to change the configuration option
`sign-key:rpm:KEY` to your key fingerprint as well as import the same key to
the default GnuPG home directory `~/.gnupg`.
