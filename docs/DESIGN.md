# Design

Qusal design document.

## Table of Contents

*   [Goal](#goal)
*   [Documentation](#documentation)
*   [Format](#format)
    *   [Readme](#readme)
        *   [Access Control](#access-control)
    *   [State file naming](#state-file-naming)
    *   [State ID](#state-id)
    *   [Qube preferences](#qube-preferences)
        *   [Qube naming](#qube-naming)
        *   [Qube label](#qube-label)
        *   [Qube menu](#qube-menu)
    *   [Qube features](#qube-features)
    *   [Qube connections](#qube-connections)
    *   [Qrexec call and policy](#qrexec-call-and-policy)
    *   [Qrexec socket services](#qrexec-socket-services)
*   [Features](#features)
    *   [Browser isolation from the managed service](#browser-isolation-from-the-managed-service)
*   [Release new version](#release-new-version)
    *   [Qubes OS major release upgrade](#qubes-os-major-release-upgrade)
    *   [Template major release upgrade](#template-major-release-upgrade)
    *   [Archive or Build from source major release upgrade](#archive-or-build-from-source-major-release-upgrade)

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
with clear motive. Although some of Google's style guide is optional, we
enforce some for stylistic purpose via documentation lint tools.

Documentation must not duplicate itself, but reference one another.
Reproducing instructions that can be found in upstream documentation is
discouraged unless the benefits of documenting it in-house, such as getting
the documentation from a single source, do outweigh the necessity of having to
modify the documentation constantly to keep up with upstream.

## Format

### Readme

Every project should have a README.md with at least the following sections:

*   Table of Contents;
*   Description;
*   Installation;
*   Access Control (if Qrexec policy changed);
*   Usage; and
*   Credits (if sourced).

#### Access Control

*   It must document default policy and RPC services the user can or should
    edit.
*   It must not document RPC services of other formulas unless the resolution
    of the rule is `deny`.

### State file naming

1.  Every State file `.sls` must have a Top file `.top`. This ensures that
    every state can be applied with top.
2.  Every project must have a `init.top`, it facilitates applying every state
    by enabling a single top file.
3.  State file naming must be common between the projects, it helps understand
    the project as if it was any other.
4.  File name must use `-` as separator, not `_` (unless it is required by the
    language, such as python).

### State ID

1.  State IDs must use `-` as separator, not `_`. The underline is allowed in
    case the features it is changing has underline, such as `default_netvm`.
2.  State IDs must always have the project ID, thus allowing to target
    multiple states to the same minion from different projects without having
    conflicting IDs.

### Qube preferences

#### Qube naming

We differ from upstream especially by placing the `dvm` part as the prefix of
DispVM Templates. This is to easy parsing when the qube type is the first
part of its name and no exceptions.

*   **TemplateVM**: `tpl-NAME`
*   **StandaloneVM**: `NAME`
*   **AppVM**: `NAME`
*   **DispVM**: `disp-NAME`
*   **DispVM Template (AppVM)**: `dvm-NAME`
*   **Service qubes (not a class)**: `sys-NAME`

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

*   **Black**:
    *   **Trust**: Ultimate.
    *   **Description**: You must trust Dom0, Templates, Vaults, Management
        qubes, these qubes control your system and hold valuable information.
    *   **Examples**: dom0, tpl-ssh, vault, dvm-mgmt.
*   **Gray**:
    *   **Trust**: Fully.
    *   **Description**: Trusted storage with extra RPC services that allow
        certain operations to be made by the client and executed on the server
        or may build components for other qubes.
    *   **Examples**: sys-cacher, sys-git, sys-pgp, sys-ssh-agent, qubes-builder.
*   **Purple**:
    *   **Trust**: Very much.
    *   **Description**: Has the ability to manager remote servers via encrypted
        connections and depend on authorization provided by another qube.
        Examples: ansible, dev, ssh, terraform.
*   **Blue**:
    *   **Trust**: Much.
    *   **Description**: TODO
    *   **Examples**: TODO
*   **Green**:
    *   **Trust**: Trusted.
    *   **Description**: TODO
    *   **Examples**: TODO
*   **Yellow**:
    *   **Trust**: Relatively trusted.
    *   **Description**: TODO
    *   **Examples**: TODO
*   **Orange**:
    *   **Trust**: Slight.
    *   **Description**: Controls the network flow of data to the client,
        normally a firewall.
    *   **Examples**: sys-firewall, sys-vpn, sys-pihole.
*   **Red**:
    *   **Trust**: Untrusted.
    *   **Description**: Holds untrusted data (PCI devices, untrusted
        programs, disposables for opening untrusted files or web pages).
    *   **Examples**: sys-net, sys-usb, dvm-browser.

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

### Qube features

Control daemons using Qubes Services. It is much better to control services
this way as we can declare during the creation of qubes instead of having to
add a state to run a script during boot to unmask and start a specific
service. The method below is most of the times combined with `systemd.unit`
`ConditionPathExists=` to enable the service conditionally.

*   Server's service name must match the syntax: `service-server` (example:
    `rsync-server`, `syncthing-server`);
*   Client's service name must match the syntax: `service-client` (example:
    `ssh-client`;
*   Local program's service name must match the syntax: `service` (example:
    `docker`, `podman`.

### Qube connections

There are several ways a qube can connect to another, either directly with
Xen or with Qrexec. If something is not required, we remove it.

*   `template` is always required:
    *   When required, must be set to the custom-made template;
    *   When not possible to use, prefer StandaloneVMs instead.
*   `audiovm` is rarely required on the majority of the projects:
    *   When required, set it to `"*default*"` to honor the global
        preferences.
    *   When not required, must be set to None;
*   `netvm` is required on a lot of projects.
    *   When required, must not be managed to honor the global preferences. If
        it requires a custom networking scheme, the state must make sure that
        the netvm exists;
    *   When not required, must be set to None.
*   `default_dispvm` is nice to have:
    *   When required, must guarantee that the network follows the same chain
        as the calling qube in the default configuration;
    *   When not required, must be set to None.
*   `management_dispvm` is always required:
    *   When required, should not be managed to honor the global preferences,
      but it can make sense to set a custom management qube for debugging.
    *   When not required, such as on qubes that don't work through Salt,
        don't touch it, it doesn't increase attack surface.

### Qrexec call and policy

1.  Must not use `*` for source and destination, use `@anyvm` instead
2.  Target qube for policies must be `@default`. It allows for the real target
    to be set by Dom0 via the `target=` redirection parameter, instead of
    having to modify the client to target a different server via
    `qrexec-client-vm`.
3.  Target qube for client script must default to `@default`, but other
    targets must be allowed via parameters.

### Qrexec socket services

Native Qrexec TCP sockets `/dev/tcp` using `qubes.ConnectTCP` are very handy
to connect to a port of a qube. The downside of using `qubes.ConnectTCP`
directly is the user doesn't want or need to know in which port the client
wants to connect in the server. We will refer to Unix Domains Sockets as
`UDS`.

Using `qusal.Service`, such as `qusal.Rsync`, `qusal.Syncthing`, `qusal.Ssh`
has the following advantages:

*   Usability: User recognizes the call per service name;
*   Extensibility: Allows extending functionality for arguments added in the
    future, no need to migrate user policy from `qubes.ConnectTCP`; is not
    necessary;

Rules for server RPC service:

*   Symlink `qubes.ConnectTCP` to `qusal.Service` if connecting to a local
    port;
*   Use `qubes.ConnectTCP` directly when the user won't manage the policy for
    the wanted call, such as `sys-syncthing-browser`, where it happens that
    only this qube will access the admin interface of `sys-syncthing`;
*   Use `socat` to connect to remote hosts or UDS with path defined by the
    service argument.

Rules for client RPC call:

*   Use `systemd.socket` units, it does not require `socat`, it is not
    restricted to the use of `qubes.ConnectTCP` called by `qvm-connect-tcp`,
    the service can be properly logged and status verified by a service
    manager instead of forking socat to the background with a `rc.local`
    script and finally, can be controlled by Qubes Services to enable or
    disable the unit with `ConditionPathExists=` instead of doing if-else
    statements in `rc.local`;
*   Use of `socat` and `qvm-connect-tcp` is permitted for UDS and for
    instructional use as it is very short.

## Features

### Browser isolation from the managed service

Some projects have daemons and can be managed through a browser. The CLI is
not suitable for everybody and sometimes it can be incomplete on GUI focused
applications. Implement browser separation from the server to avoid browsing
malicious sites and exposing the browser to direct network on the same machine
the server is running. The browser qube is offline and only has access to the
admin interface. In other words, it has control over the server functions, if
the browser is compromised, it can compromise the server.

Some projects that uses this enhancement are `sys-pihole`, `sys-syncthing` and
`sys-cacher`.

## Release new version

The following sections instruct how a contributor or maintainer can deploy qu

### Qubes OS major release upgrade

Qubes OS major releases might come with changes that can impact the project.

1.  Subscribe to the
    [qubes-announce](https://www.qubes-os.org/support/#qubes-announce) mailing
    list to receive notification of new Qubes OS releases.
2.  Keep up changelogs, especially notices of deprecation, new packages being
    added or modifications to those packages that affects our states.
3.  Install the new Qubes OS version.
4.  Install all formulas.
5.  Change the supported or minimum required version of Qubes OS.

### Template major release upgrade

1.  Subscribe to the
    [qubes-announce](https://www.qubes-os.org/support/#qubes-announce) mailing
    list to receive notifications of new templates.
2.  Install the new template version.
3.  Clone template to a new testing name of your choice.
4.  Install all formulas on the testing template and see which states failed.
    Most of the times, the state will fail due to a change in package name
    (occurs when package has version in the name) or a deprecation of a
    package.
5.  Check if there are new packages that are useful to each specified formula.
    The best way is to see the `Recommends` and `Suggests` fields of the main
    package that is installed.
6.  Install all formulas as instructed in each of their documents.
7.  Change the version of the base template.

### Archive or Build from source major release upgrade

Some projects might use archives for lack of a better alternative. Dealing
with them can be troublesome. Prefer packages from repositories when possible.

1.  Subscribe to the vendor release announcement mailing list or RSS to
    receive notifications of new versions.
2.  Read the changelog, breaking changes and new features might be present.
3.  Clone the qube that uses the archive to a new testing name of your choice.
4.  Install the new archive version on the testing qube. Regarding breaking
    changes, most projects implement a migration on the next restart of the
    daemon that rebuilds a database index for example, if they don't, deal
    with it. For new features, check if they should be added to the default
    installation.
5.  Change the version of the archive, git tag or commit.
