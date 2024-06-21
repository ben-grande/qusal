# Design

Qusal design document.

## Table of Contents

* [Goal](#goal)
* [Documentation](#documentation)
* [Format](#format)
  * [Readme](#readme)
  * [File naming](#file-naming)
  * [State ID](#state-id)
  * [Qube preferences](#qube-preferences)
    * [Qube naming](#qube-naming)
    * [Qube label](#qube-label)
    * [Qube menu](#qube-menu)
  * [Qube connections](#qube-connections)
  * [Qrexec call and policy](#qrexec-call-and-policy)

## Goal

Provide a minimal modular isolated environment for users to complete daily
tasks in a secure manner. We should not focus on a specific Qubes OS user
base as it would narrow our reach. We scope to have a diverse user base, with
different needs and use case that could shape our project for the better.

We must not aim to be a one solution fits all by adding every new project
someone asks for, if the number of projects grows too large, it would be
impossible to keep track of everything, especially with major distribution
updates from templates and Qubes OS releases.

In order to achieve this goal, the formulas must always create qubes based on
minimal templates, with only the strictly necessary packages and features it
needs. If audio is not required, it is never installed and the qube preference
`audiovm` is set to None, the same applies to networking, thus avoiding
unexpected calls to the network or to the audio qube. If the memory
requirements are low, it is capped to a low limit, thus avoiding exacerbated
memory consumption on systems with low specs.

No extraneous features should be included by default besides the basic for
functionality. Extra functionalities that could weaken the system can be
provided via extra states that needs to be installed per the user discretion.

## Documentation

Markdown code must follow
[Google's Markdown style guide](https://google.github.io/styleguide/docguide/style.html).
Any discrepancies with Google's style guide must be fixed or documented here
with clear motive.

Documentation must not duplicate itself, but reference one another.
Reproducing instructions that can be found in upstream documentation is
discouraged unless the benefits of documenting it in-house, such as getting
the documentation from a single source, do outweigh the necessity of having to
modify the documentation constantly to keep up with upstream.

## Format

### Readme

Every project should have a README.md with at least the following sections:

- Table of Contents;
- Description;
- Installation;
- Access Control (if Qrexec policy changed);
- Usage; and
- Credits (if sourced).

### File naming

1.  Every State file `.sls` must have a Top file `.top`. This ensures that
    every state can be applied with top.
2.  Every project must have a `init.top`, it facilitates applying every state
    by enabling a single top file.
3.  State file naming must be common between the projects, it helps understand
    the project as if it was any other.
4.  File name must use `-` as separator, not `_`.

### State ID

1.  State IDs must use `-` as separator, not `_`. The underline is allowed in
    case the features it is changing has underline, such as `default_netvm`.
2.  State IDs must always have the project ID, thus allowing to target multiple
    states to the same minion from different projects without having
    conflicting IDs.

### Qube preferences

#### Qube naming

We differ from upstream especially by placing the `dvm` part as the prefix of
DispVM Templates. This is to easy parsing when the qube type is the first
part of its name and no exceptions.

- **TemplateVM**: `tpl-NAME`
- **StandaloneVM**: `NAME`
- **AppVM**: `NAME`
- **DispVM**: `disp-NAME`
- **DispVM Template (AppVM)**: `dvm-NAME`
- **Service qubes (not a class)**: `sys-NAME`

We recommend that for user created qubes, use the domain in the prefix of the
qube. An AppVM for personal banking will be named `personal-banking`, an
AppVM for personal e-mail will be named `personal-email`.

#### Qube label

We differ from upstream in many senses. We are not labeling qubes based on
them sharing a common security domain, this is very limited if you have many
security domains in use and they do not share the same level of trust. You
don't (or shouldn't) trust your networked browsing qube for personal usage
the same as you trust your vault. The following method tries to fix this
problem, domain name is in the prefix of the qube, the label is solely
related to trustworthiness of the data it is dealing with.

-   **Black**:
    -   **Trust**: Ultimate.
    -   **Description**: You must trust Dom0, Templates, Vaults, Management
        qubes, these qubes control your system and hold valuable information.
    -   **Examples**: dom0, tpl-ssh, vault, dvm-mgmt.
-   **Gray**:
    -   **Trust**: Fully.
    -   **Description**: Trusted storage with extra RPC services that allow
        certain operations to be made by the client and executed on the server
        or may build components for other qubes.
    -   **Examples**: sys-cacher, sys-git, sys-pgp, sys-ssh-agent, qubes-builder.
-   **Purple**:
  -   **Trust**: Very much.
  -   **Description**: Has the ability to manager remote servers via encrypted
      connections and depend on authorization provided by another qube.
      Examples: ansible, dev, ssh, terraform.
-   **Blue**:
  -   **Trust**: Much.
  -   **Description**: TODO
  -   **Examples**: TODO
-   **Green**:
    -   **Trust**: Trusted.
    -   **Description**: TODO
    -   **Examples**: TODO
-   **Yellow**:
    -   **Trust**: Relatively trusted.
    -   **Description**: TODO
    -   **Examples**: TODO
-   **Orange**:
    -   **Trust**: Slight.
    -   **Description**: Controls the network flow of data to the client,
        normally a firewall.
    -   **Examples**: sys-firewall, sys-vpn, sys-pihole.
-   **Red**:
    -   **Trust**: Untrusted.
    -   **Description**: Holds untrusted data (PCI devices, untrusted
        programs, disposables for opening untrusted files or web pages).
    -   **Examples**: sys-net, sys-usb, dvm-browser.

#### Qube menu

The Qubes App Menu is used by GUI users, always add the `.desktop` files to
the qube feature `menu-items`, if it is a template, also add to the feature
`default-menu-items`. Remember to sync the App Menus after the installation of
software in the desired qube.

Explicitly setting menu item avoids the user clicking on a software not
intended to be run in the selected qube or trying to run software that is not
installed. The user opening Tor Browser in a Whonix qube that is intended for
building software is risky, the user trying to open a file manager on a qube
that doesn't have one is less risky but for the user the behavior is
unexpected.

### Qube connections

There are several ways a qube can connect to another, either directly with
Xen or with Qrexec. If something is not required, we remove it.

-   `template` is always required:
    -   When required, must be set to the custom-made template;
    -   When not possible to use, prefer StandaloneVMs instead.
-   `audiovm` is rarely required on the majority of the projects:
  -   When required, set it to `"*default*"` to honor the global preferences.
  -   When not required, must be set to None;
-   `netvm` is required on a lot of projects.
  -   When required, must not be managed to honor the global preferences. If
      it requires a custom networking scheme, the state must make sure that
      the netvm exists;
  -   When not required, must be set to None.
-   `default_dispvm` is nice to have:
  -  When required, must guarantee that the network follows the same chain as
     the calling qube in the default configuration;
  -  When not required, must be set to None.
-   `management_dispvm` is always required:
  -   When required, should not be managed to honor the global preferences,
      but it can make sense to set a custom management qube for debugging.
  -   When not required, such as on qubes that don't work through Salt, don't
      touch it, it doesn't increase attack surface.

### Qrexec call and policy

1.  Must not use `*` for source and destination, use `@anyvm` instead
2.  Target qube for policies must be `@default`. It allows for the real target
    to be set by Dom0 via the `target=` redirection parameter, instead of
    having to modify the client to target a different server via
    `qrexec-client-vm`.
3.  Target qube for client script must default to `@default`, but other targets
    must be allowed via parameters.
