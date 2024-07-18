# qusal

Salt Formulas for Qubes OS.

## Warning

**Warning**: Not ready for production, development only. Breaking changes can
and will be introduced in the meantime. You've been warned.

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
*   [Usage](#usage)
*   [Contribute](#contribute)
*   [Donate](#donate)
*   [Support](#support)
    *   [Free Support](#free-support)
    *   [Paid Support](#paid-support)
*   [Contact](#contact)
*   [Credits](#credits)
*   [Legal](#legal)

## Description

Qusal is a Free and Open Source security-focused project that provides
SaltStack Formulas for [Qubes OS](https://www.qubes-os.org) users to complete
various daily tasks, such as web browsing, video-calls, remote administration,
coding, network tunnels and much more, which are easy to install and maintains
low attack surface.

We not only provide a single solution for each project, but also provides
alternative when they differ, such as for networking, you could use a VPN, DNS
Sink-hole, Mirage Unikernel or the standard Qubes Firewall for managing the
network chain and the connections the clients connected to these NetVMs are
allowed to make.

Here are some of the Global Preferences we can manage:

*   **clockvm**: disp-sys-net, sys-net
*   **default_audiovm**: disp-sys-audio
*   **default_dispvm**: dvm-reader
*   **default_guivm**: sys-gui, sys-gui-vnc, sys-gui-gpu
*   **default_netvm**: sys-pihole, sys-firewall or disp-sys-firewall
*   **management_dispvm**: dvm-mgmt
*   **updatevm**: sys-pihole, sys-firewall or disp-sys-firewall

## Installation

See the [installation instructions](docs/INSTALL.md).

## Usage

After installing Qusal, please read the README.md of each project in the
[salt](salt/) directory you desire install. If you are unsure how to start,
get some ideas from our [bootstrap guide](docs/BOOTSTRAP.md).

The intended behavior is to enforce the state of qubes and their services. If
you modify the qubes and their services and apply the state again, conflicting
configurations will be overwritten. To enforce your state, write a SaltFile to
specify the desired state and call it after the ones provided by this project.

If you want to edit the access control of any service, you
should always use the Qrexec policy at `/etc/qubes/policy.d/30-user.policy`,
as this file will take precedence over the packaged policies.

Please note that when you allow more Qrexec calls than the default shipped by
Qubes OS, you are increasing the attack surface of the target, normally to a
valuable qube that can hold secrets or pristine data. A compromise of the
client qube can extend to the server, therefore configure the installation
according to your threat model.

To troubleshoot issues, read our
[troubleshooting document](docs/TROUBLESHOOT.md).

## Contribute

See the [contribution instructions](docs/CONTRIBUTE.md).

## Donate

This project can only survive through donations. If you like what we have
done, please consider donating. [Contact us](#contact) for donation address.
Please note that donations are gratuitous, there is not obligation from the
maintainers to provide the donor with support, help with bugs, features or
answering questions, if there was, it would not be a donation, but a payment.

This project depends on Qubes OS, consider donating to
[upstream](https://qubes-os.org/donate/).

## Support

### Free Support

Free support will be provided on a best effort basis. If you want something,
open an issue and patiently wait for a reply, the project is best developed in
the open so anyone can search for past issues.

### Paid Support

Paid consultation services can be provided. Request a quote
[from us](#contact).

## Contact

You must not contact for [free support](#free-support).

*   [E-mail](https://github.com/ben-grande/ben-grande)

## Credits

I stand on the shoulders of giants. This would not be possible without people
contributing to Qubes OS SaltStack formulas. Honorable mention(s):
[unman](https://github.com/unman).

## Legal

This project is [REUSE-compliant](https://reuse.software). It is difficult to
list all licenses and copyrights and keep them up-to-date here.

The easiest way to get the copyright and license of the project is with the
reuse tool:

```sh
reuse spdx
```

You can also check these information manually by looking in the file header,
a companion `.license` file or in `.reuse/dep5`.

All licenses are present in the LICENSES directory.

Note that submodules have their own licenses and copyrights statements, please
check each one individually using the same methods described above for a full
statement.
