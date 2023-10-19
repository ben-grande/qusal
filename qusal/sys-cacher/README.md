# sys-cacher

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)
    * [Connect to the cacher via IP instead of Qrexec](#connect-to-the-cacher-via-ip-instead-of-qrexec)
    * [Non-TemplateVMs integration](#non-templatevms-integration)
* [Upgrade](#upgrade)
* [Uninstallation](#uninstallation)
* [Copyright](#copyright)

## Description

Caching proxy server for software repositories on Qubes OS.

The caching proxy is "sys-cacher" based on apt-cacher-ng, it stores downloaded
packages, so that you need only download a package once for it to be used when
updating many templates. The proxy is preconfigured to work out of the box
for Debian, Ubuntu, Arch, and Fedora templates.

When you install this package, qubes will be tagged with "sys-cacher-updatevm"
and they will be altered to use the proxy by default. When there is "https://"
in your repository definitions, the entries will be changed in the templates
from to "http://HTTPS///". This is so that the request to the proxy is plain
text, and the proxy will then make the request via https.

This change will be done automatically for every template that exists and is
not Whonix based. No changes are made to Whonix templates, and updates to
those templates will not be cached.

## Installation

Installation may take a long time as it will target all templates unless you
specify otherwise.

- Top
```sh
qubesctl top.enable sys-cacher
qubesctl --targets=tpl-sys-cacher,sys-cacher state.apply
qubesctl top.disable sys-cacher
qubesctl state.apply sys-cacher.tag
qubesctl --skip-dom0 --templates state.apply sys-cacher.install-client
```

- State
```sh
qubesctl state.apply sys-cacher.create
qubesctl --skip-dom0 --targets=tpl-sys-cacher state.apply sys-cacher.install
qubesctl --skip-dom0 --targets=sys-cacher state.apply sys-cacher.configure
qubesctl state.apply sys-cacher.tag
qubesctl --skip-dom0 --templates state.apply sys-cacher.install-client
```

## Usage

### Connect to the cacher via IP instead of Qrexec

Because the sys-cacher qube is listening on port 8082, you can use it from
non-template qubes and qubes that do not have a working Qrexec. Use
the native configuration to set the update proxy using the IP address
of sys-cacher.

### Non-TemplateVMs integration

**Attention**: this method will allow for a client qube to bypass the qubes
firewall and connect to a remote via the updates proxy.

By default, only templates will use the proxy to update, if you want to cache
Non-TemplateVMs updates or simply make them functional again, the qube will
need the `service.updates-proxy-setup` feature set:
```sh
qubesctl --skip-dom0 --targets=QUBE state.apply sys-cacher.install-client
qvm-tags add QUBE sys-cacher-updatevm
qvm-features QUBE service.updates-proxy-setup 1
```
Don't forget to restart the qube.

If you don't want or can't restart the qube, such as DispVMs, where you would
lose you session, run the same commands as above plus the following inside the
qube:
```sh
sudo touch /var/run/qubes-service/updates-proxy-setup
sudo /usr/lib/qubes/update-proxy-configs
sudo systemctl restart qubes-updates-proxy-forwarder.socket
```

## Upgrade

- State
```sh
qubesctl --skip-dom0 --targets=sys-cacher state.apply sys-cacher.configure
```

## Uninstallation

- Top:
```sh
qubesctl top.enable sys-cacher.deinit
qubesctl --templates state.apply
qubesctl top.disable sys-cacher.deinit
```

- State:
```sh
qubesctl state.apply sys-cacher.remove-policy
qubesctl state.apply sys-cacher.untag
qubesctl --skip-dom0 --templates state.apply sys-cacher.uninstall-client
```

If you want to use the standard proxy for a few templates:
```sh
qubesctl --skip-dom0 --targets=TEMPLATE state.apply sys-cacher.uninstall-client
qvm-tags del TEMPLATE sys-cacher-updatevm
```

## Copyright

License: GPLv3+

Credits:
- [Unman](https://github.com/unman/shaker/tree/master/cacher)
