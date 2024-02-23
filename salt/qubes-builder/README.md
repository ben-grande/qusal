# qubes-builder

Setup Qubes OS Builder V2 in Qubes OS itself.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Access Control](#access-control)
* [Usage](#usage)
  * [Builder configuration](#builder-configuration)
  * [Update repository safely](#update-repository-safely)

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

- Top
```sh
sudo qubesctl top.enable qubes-builder
sudo qubesctl --targets=tpl-qubes-builder,dvm-qubes-builder,qubes-builder state.apply
sudo qubesctl top.disable qubes-builder
```

- State
<!-- pkg:begin:post-install -->
```sh
sudo qubesctl state.apply qubes-builder.create
sudo qubesctl --skip-dom0 --targets=tpl-qubes-builder state.apply qubes-builder.install
sudo qubesctl --skip-dom0 --targets=dvm-qubes-builder state.apply qubes-builder.configure-qubes-executor
sudo qubesctl --skip-dom0 --targets=qubes-builder state.apply qubes-builder.configure
```
<!-- pkg:end:post-install -->

## Access Control

The policy is based on `qubes-builderv2/rpc/50-qubesbuilder.policy`.
Extra services added are `qubes.Gpg2`, `qusal.GitInit`, `qusal.GitFetch`,
`qusal.GitPush`, `qusal.SshAgent`. Necessary services are allowed to have an
unattended build.

## Usage

### Builder configuration

When using the Qubes Executor, configure the `builder.yml` `dispvm` option to
either `dom0` or `dvm-qubes-builder`:
```yaml
include:
  - example-configs/desired-config.yml

executor:
  type: qubes
  options:
    dispvm: "dom0"
    #dispvm: "dvm-qubes-builder"
```
Setting the Disposable VM  to Dom0 works because it will use the
`default_dispvm` preference of `qubes-builder`, which is `dvm-qubes-builder`.

### Update repository safely

If you need to pull new commits, set `GNUPGHOME` to
`/home/user/.gnupg/qubes-builder`, the provided gitconfig enforces signature
verification on git merges:
```sh
GNUPGHOME="$HOME/.gnupg/qubes-builder" git pull
Commit 7c37bb7 has a good GPG signature by Frederic Pierret (fepitre)
<frederic.pierret@qubes-os.org>
...
```
