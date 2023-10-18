# sys-git

## Table of Contents

* [Description](#description)
* [Alternatives comparison](#alternatives-comparison)
* [Installation](#installation)
* [Access control](#access-control)
* [Usage](#usage)
  * [Initialize the server repository](#initialize-the-server-repository)
  * [Prepare the client](#prepare-the-client)
* [Copyright](#copyright)

## Description

Git operations through Qrexec on Qubes OS.

Setup a Git server called "sys-git", an offline Git Server that can be
accessed from client qubes via Qrexec. Access control via Qrexec policy can
restrict access to certain repositories, set of git actions for Fetch, Push
and Init.

## Alternatives comparison

The following alternatives will be compared against each other and this
implementation:

- [Rudd-O/git-remote-qubes](https://github.com/Rudd-O/git-remote-qubes)
- [QubesOS-contrib/qubes-app-split-git](https://github.com/QubesOS-contrib/qubes-app-split-git)
- [qubes-os.org/doc/development-workflow/#git-connection-between-vms](https://www.qubes-os.org/doc/development-workflow/#git-connection-between-vms)

| | sys-git | git-remote-qubes | qubes-app-split-git | git-connection-between-vms |
| :--- | :---: | :---: | :---: | :---: |
| Codebase Size | Small | Large | Large | Small |
| Custom Protocol | True | True | True | False |
| Path | Repository | Absolute | Repository | Repository |
| Repository restriction | True | False | True | True |
| No hanging | True | True | True | False |
| Fetch | True | True  | True (only tags) | True |
| Push  | True | True  | False | True |
| Init  | True | False | False | False |
| Validates Git communication | False | False | True | False |
| Verify tag signature | False | False | True | False |

## Installation

- Top
```sh
qubesctl top.enable sys-git
qubesctl --targets=tpl-sys-git,sys-git state.apply
qubesctl top.disable sys-git
```

- State
```sh
qubesctl state.apply sys-git.create
qubesctl --skip-dom0 --targets=tpl-sys-git state.apply sys-git.install
qubesctl --skip-dom0 --targets=sys-git state.apply sys-git.configure
```

Installation on the client template:
```sh
qubesctl --skip-dom0 --targets=tpl-dev state.apply sys-git.install-client
```

## Access control

_Default policy_: `any qube` can `ask` via the `@default` target if you allow
it to `Fetch` from, `Push` to and `Init` on `sys-git`.

__Recommended usage__:
- __Init__: Simply usability, if you don't like this action,
  use the deny rule instead and create the directory manually.
- __Fetch__: Fetch can be allowed by less trusted qubes.
- __Push__: Push should only be made by trusted qubes.

Allow qube `dev` to `Fetch` from `sys-git`, but ask to `Push` and `Init`:
```qrexecpolicy
qusal.GitFetch * dev @default allow target=sys-git
qusal.GitPush  * dev @default ask   target=sys-git default_target=sys-git
qusal.GitInit  * dev @default ask   target=sys-git default_target=sys-git
qusal.GitFetch * dev @anyvm   deny
qusal.GitPush  * dev @anyvm   deny
qusal.GitInit  * dev @anyvm   deny
```

Allow qube `untrusted` to `Fetch` `repo` if using  target name `sys-git` but
deny `Push` and `Init` to any other qube:
```qrexecpolicy
qusal.GitFetch +repo untrusted sys-git ask target=sys-git default_target=sys-git
qusal.GitFetch *     untrusted @anyvm  deny
qusal.GitPush  *     untrusted @anyvm  deny
qusal.GitInit  *     untrusted @anyvm  deny
```

Deny `Fetch`, `Push` and `Init` from any qube to any other qube:
```qrexecpolicy
qusal.GitFetch *     @anyvm @anyvm deny
qusal.GitPush  *     @anyvm @anyvm deny
qusal.GitInit  *     @anyvm @anyvm deny
```

## Usage

### Initialize the server repository

There are a few constraints regarding repositories:

- Must be created under `/home/user/src` in `sys-git`;
- Names  must have only letters, numbers, hyphen, underscore and dot. Must not
  begin with dot, hyphen and underscore.

In `sys-git`, create bare repositories under `/home/user/src`.

From the `server`:
```sh
git init --bare ~/src/X.git
```
You must use the `.git` prefix to indicate a bare repository.

Or from the `client`, if the `qusal.GitInit` policy allows:
```sh
cd ~/path/to/repo
git init-qrexec
```

### Prepare the client

Qrexec protocol is supported with the following URL: `qrexec://<QUBE>/<REPO>`,
where the `<QUBE>` field can be a literal name or token and the `<REPO>` field
is the name of the repository that exists on `sys-git` under `/home/user/src`.

Clone an existing repository:
```sh
git clone qrexec://@default/qubes-doc
```

Or Initialize a new repository:
```sh
git init qubes-doc
cd qubes-doc
```
Add a remote using the Qrexec protocol:
```sh
git remote add sg qrexec://@default/qubes-doc
```

Test fetching:
```sh
git fetch sg
```

You can then use that repository as usual, making commits.

Push to the server and set it as the default upstream:
```sh
git push -u sg master
```

Following pushes will be simpler:
```sh
git push
```

## Copyright

License: GPLv2+
