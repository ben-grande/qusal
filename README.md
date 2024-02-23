# qusal

Salt Formulas for Qubes OS.

## Warning

**Warning**: Not ready for production, development only. Breaking changes can
and will be introduced in the meantime. You've been warned.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
  * [Prerequisites](#prerequisites)
  * [DomU Installation](#domu-installation)
  * [Dom0 Installation](#dom0-installation)
* [Update](#update)
  * [DomU Update](#domu-update)
  * [Dom0 Update without extra packages](#dom0-update-without-extra-packages)
  * [Dom0 Update with Git](#dom0-update-with-git)
* [Usage](#usage)
* [Contribute](#contribute)
* [Donate](#donate)
* [Support](#support)
  * [Free Support](#free-support)
  * [Paid Support](#paid-support)
* [Contact](#contact)
* [Credits](#credits)
* [Legal](#legal)

## Description

Qusal is a Free and Open Source security-focused project that provides
SaltStack Formulas for Qubes OS users to complete various daily tasks, such
as web browsing, video-calls, remote administration, coding, network tunnels
and much more, which are easy to install and maintains low attack surface.

We not only provide a single solution for each project, but also provides
alternative when they differ, such as for networking, you could use a VPN,
DNS Sink-hole, Mirage Unikernel or the standard Qubes Firewall for managing
the network chain and the connections the clients connected to these NetVMs
are allowed to make.

Here are some of the Global Preferences we can manage:

- **clockvm**: disp-sys-net, sys-net
- **default_dispvm**: dvm-reader
- **default_netvm**: sys-pihole, sys-firewall or disp-sys-firewall
- **management_dispvm**: dvm-mgmt
- **updatevm**: sys-pihole, sys-firewall or disp-sys-firewall
- **default_audiovm**: disp-sys-audio

If you want to learn more about how we make decisions, take a look at our
[design document](docs/DESIGN.md).

## Installation

### Prerequisites

You current setup needs to fulfill the following requisites:

- Qubes OS R4.2
- Internet connection

### DomU Installation

1. Install `git` in the qube, if it is an AppVM, install it it's the
   TemplateVM and restart the AppVM.

2. Clone this repository:
  ```sh
  git clone --recurse-submodules https://github.com/ben-grande/qusal.git
  ```
  If you made a fork, fork the submodule(s) before clone and use your remote
  repository instead, the submodules will also be from your fork.

### Dom0 Installation

Before copying anything to Dom0, read [Qubes OS warning about consequences of
this procedure](https://www.qubes-os.org/doc/how-to-copy-from-dom0/#copying-to-dom0).

1. Copy the repository `$file` from the DomU `$qube` to Dom0:
  ```sh
  qube="CHANGEME" # qube name where you downloaded the repository
  file="CHANGEME" # path to the repository in the qube
  qvm-run --pass-io --localcmd="UPDATES_MAX_FILES=10000
    /usr/libexec/qubes/qfile-dom0-unpacker user
    ~/QubesIncoming/${qube}/qusal" \
    "${qube}" /usr/lib/qubes/qfile-agent "${file}"
  ```

2. Acquire the maintainer signing key by other means and copy it to Dom0.

3. Verify the [commit or tag signature](https://www.qubes-os.org/security/verifying-signatures/#how-to-verify-signatures-on-git-repository-tags-and-commits) and expect a good signature, be surprised otherwise:
  ```sh
  git verify-commit HEAD
  ```

4. Copy the project to the Salt directories:
  ```sh
  ~/QubesIncoming/"${qube}"/qusal/scripts/setup.sh
  ```

## Update

To update, you can copy the repository again to dom0 as instructed in the
[installation](#installation) section above or you can use easier methods
demonstrated below.

### DomU Update

Update the repository state in your trusted DomU:
```sh
git -C ~/src/qusal fetch --recurse-submodules
```

### Dom0 Update without extra packages

This method is similar to the installation method, but shorter.

1. Install the helpers scripts on Dom0 (only has to be run once):
  ```sh
  sudo qubesctl state.apply dom0.install-helpers
  ```

2. Copy the repository `$file` from the DomU `$qube` to Dom0:
  ```sh
  qube="CHANGEME" # qube name where you downloaded the repository
  file="CHANGEME" # path to the repository in the qube
  rm -rfi ~/QubesIncoming/"${qube}"/qusal
  UPDATES_MAX_FILES=10000 qvm-copy-to-dom0 "${qube}" "${file}"
  ```

3. Verify the commit or tag signature and expect a good signature, be
  surprised otherwise:
  ```sh
  git verify-commit HEAD
  ```

4. Copy the project to the Salt directories:
  ```sh
  ~/QubesIncoming/"${qube}"/qusal/scripts/setup.sh
  ```

### Dom0 Update with Git

1. Install git on Dom0, allow the Qrexec protocol to work in submodules and
   clone the repository to `~/src/qusal` (only has to be run once):
  ```sh
  mkdir -p ~/src
  sudo qubesctl state.apply sys-git.install-client
  git clone --recurse-submodules qrexec://@default/qusal.git ~/src/qusal
  ```

2. Fetch from the app qube and place the files in the salt tree (git merge
   and pull will verify the HEAD signature automatically)
  ```sh
  git -C ~/src/qusal fetch --recurse-submodules
  ~/src/qusal/scripts/setup.sh
  ```

## Usage

Qusal is now installed. Please read the README.md of each project in the
[salt](salt/) directory for further information on how to install the desired
package. If you are unsure how to start, get some ideas from our
[bootstrap guide](docs/BOOTSTRAP.md).

The intended behavior is to enforce the state of qubes and their services. If
you modify the qubes and their services and apply the state again,
conflicting configurations will be overwritten. To enforce your state, write
a SaltFile to specify the desired state and call it after the ones provided
by this project.

If you want to edit the access control of any service, you
should always use the Qrexec policy at `/etc/qubes/policy.d/30-user.policy`,
as this file will take precedence over the packaged policies.

Please note that when you allow more Qrexec calls than the default shipped by
Qubes OS, you are increasing the attack surface of the target, normally
to a valuable qube that can hold secrets or pristine data. A compromise of
the client qube can extend to the server, therefore configure the
installation according to your threat model.

## Contribute

There are several ways to contribute to this project. Spread the word, help
on user support, review opened issues, fix typos, implement new features,
donations.

Please take a look at our [contribution guidelines](docs/CONTRIBUTING.md)
before contributing code or to the documentation, it holds important
information on how the project is structured, why some design decisions were
made and what can be improved.

## Donate

This project can only survive through donations. If you like what we have
done, please consider donating. [Contact us](#contact) for donation address.

This project depends on Qubes OS, consider donating to
[upstream](https://qubes-os.org/donate/).

## Support

### Free Support

Free support will be provided on a best effort basis. If you want something,
open an issue and patiently wait for a reply, the project is best developed in
the open so anyone can search for past issues.

### Paid Support

Paid consultation services can be provided.
Request a quote [from us](#contact).

## Contact

You must not contact for [free support](#free-support).

- [E-mail](https://github.com/ben-grande/ben-grande)

## Credits

I stand on the shoulders of giants. This would not be possible without people
contributing to Qubes OS SaltStack formulas. Honorable mention(s):
[unman](https://github.com/unman).

## Legal

This project is [REUSE-compliant](https://reuse.software). It is difficult to
list all licenses and copyrights and keep them up-to-date here.

The easiest way to get the copyright and license of the project with the reuse
tool:
```sh
reuse spdx
```

You can also check these information manually by looking in the file header,
a companion `.license` file or in `.reuse/dep5`.

All licenses are present in the LICENSES directory.

Note that submodules have their own licenses and copyrights statements, please
check each one individually using the same methods described above for a full
statement.
