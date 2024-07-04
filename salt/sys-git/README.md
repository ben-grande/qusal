# sys-git

Git operations through Qrexec in Qubes OS.

## Table of Contents

*   [Description](#description)
*   [Alternatives comparison](#alternatives-comparison)
*   [Security](#security)
*   [Installation](#installation)
*   [Access control](#access-control)
*   [Usage](#usage)
    *   [Initialize the server repository](#initialize-the-server-repository)
    *   [Prepare the client](#prepare-the-client)
*   [Credits](#credits)

## Description

Setup a Git server called "sys-git", an offline Git Server that can be
accessed from client qubes via Qrexec. Access control via Qrexec policy can
restrict access to certain repositories, set of git actions for Fetch, Push
and Init. This is an implementation of split-git.

## Alternatives comparison

The following alternatives will be compared against each other and this
implementation:

*   [Rudd-O/git-remote-qubes](https://github.com/Rudd-O/git-remote-qubes)
*   [QubesOS-contrib/qubes-app-split-git](https://github.com/QubesOS-contrib/qubes-app-split-git)
*   [qubes-os.org/doc/development-workflow/#git-connection-between-vms](https://www.qubes-os.org/doc/development-workflow/#git-connection-between-vms)

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
| Validates git communication | False | False | True | False |
| Verifies tag signature | False | False | True | False |

## Security

It is not possible to filter Git's stdout from a Qrexec call as it is used by
the local running git process, we rely on Git's parsing and filtering for
remote operations. A remote can send up to 4 bytes of UTF-8 character to it's
stdout as packet information during the initial server client negotiation, the
client will display the characters on stderr with an error message containing
the character. Git only filters for control characters but other characters
that are valid UTF-8 such as multibyte are not filtered. The same characters
can be present in the git log. In reality, there are many other ways the
remote can make the client display a refname with attacker controlled data
with a much larger byte size, this cannot be solved while the remote helper
does not verify each received reference.

A remote helper that validates the data received can increase the security
by not printing untrusted data, which is the case with
[qubes-app-split-git](https://github.com/QubesOS-contrib/qubes-app-split-git/commits/master/),
but unfortunately it demands signed tags and doesn't work for normal git
operations with signed commits and branches, as the later can't be signed.
A fork of the aforementioned project might be the future of this helper.

Even if the transport is secure, the tool that renders the information of your
recently acquired repository
[can](https://nvd.nist.gov/vuln/detail/CVE-2022-23521)
[contain](https://nvd.nist.gov/vuln/detail/CVE-2022-41902)
[bugs](https://nvd.nist.gov/vuln/detail/CVE-2022-46663)
[that](https://nvd.nist.gov/vuln/detail/CVE-2023-25652)
[result](https://nvd.nist.gov/vuln/detail/CVE-2023-29007)
in local code execution and remote code execution. In the end, if you don't
trust the origin, don't use it.

## Installation

*   Top:

```sh
sudo qubesctl top.enable sys-git
sudo qubesctl --targets=tpl-sys-git,sys-git state.apply
sudo qubesctl top.disable sys-git
```

*   State:

<!-- pkg:begin:post-install -->

```sh
sudo qubesctl state.apply sys-git.create
sudo qubesctl --skip-dom0 --targets=tpl-sys-git state.apply sys-git.install
sudo qubesctl --skip-dom0 --targets=sys-git state.apply sys-git.configure
```

<!-- pkg:end:post-install -->

Installation on the client template:

```sh
sudo qubesctl --skip-dom0 --targets=tpl-dev state.apply sys-git.install-client
```

## Access control

_Default policy_: `any qube` can `ask` via the `@default` target if you allow
it to `Fetch` from, `Push` to and `Init` on `sys-git`.

__Recommended usage__:

*   __Init__: Argument useful when allowing a qube to always create a
*   repository on the server.
*   __Fetch__: Fetch can be allowed by less trusted qubes.
*   __Push__: Push should only be made by trusted qubes.

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

*   Must be created under `/home/user/src` in `sys-git`;
*   Names  must have only letters, numbers, hyphen, underscore and dot. Must
    not begin or end with dot, hyphen and underscore.

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

Qrexec protocol is supported with the following URL format:
`qrexec://<QUBE>/<REPO>`, where the `<QUBE>` field can be a literal name or
token and the `<REPO>` field is the name of the repository that exists on
`sys-git` under `/home/user/src`.

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

Test fetching from the newly added remote:

```sh
git fetch sg
```

Make changes to the git repository as you normally would on any system.

Push to the server and set it as the default upstream:

```sh
git push -u sg main
```

Following pushes will be simpler:

```sh
git push
```

## Credits

*   [Unman](https://github.com/unman/shaker/tree/main/git)
