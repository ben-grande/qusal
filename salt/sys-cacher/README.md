# sys-cacher

Caching proxy server for software repositories in Qubes OS.

## Table of Contents

* [Description](#description)
* [Installation](#installation)
* [Usage](#usage)
  * [Report Page and Maintenance Tasks](#report-page-and-maintenance-tasks)
  * [Connect to the cacher via IP instead of Qrexec](#connect-to-the-cacher-via-ip-instead-of-qrexec)
  * [Non-TemplateVMs integration](#non-templatevms-integration)
  * [Rewrite URIs inside the qube](#rewrite-uris-inside-the-qube)
* [Uninstallation](#uninstallation)
* [Credits](#credits)

## Description

The caching proxy is "sys-cacher" based on apt-cacher-ng, it stores downloaded
packages, so that you need only download a package once for it to be used when
updating many  The proxy is preconfigured to work out of the box
for Debian, Ubuntu, Arch, and Fedora

When you install this package, qubes will be tagged with "updatevm-sys-cacher"
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
sudo qubesctl top.enable sys-cacher browser
sudo qubesctl --targets=tpl-browser,sys-cacher-browser,tpl-sys-cacher,sys-cacher state.apply
sudo qubesctl top.disable sys-cacher browser
sudo qubesctl state.apply sys-cacher.appmenus,sys-cacher.tag
sudo qubesctl --skip-dom0 --templates state.apply sys-cacher.install-client
```

- State
<!-- pkg:begin:post-install -->
```sh
sudo qubesctl state.apply sys-cacher.create
sudo qubesctl --skip-dom0 --targets=tpl-browser state.apply browser.install
sudo qubesctl --skip-dom0 --targets=tpl-sys-cacher state.apply sys-cacher.install
sudo qubesctl --skip-dom0 --targets=sys-cacher state.apply sys-cacher.configure
sudo qubesctl --skip-dom0 --targets=sys-cacher-browser state.apply sys-cacher.configure-browser
sudo qubesctl state.apply sys-cacher.appmenus,sys-cacher.tag
sudo qubesctl --skip-dom0 --templates state.apply sys-cacher.install-client
```
<!-- pkg:end:post-install -->

## Usage

### Report Page and Maintenance Tasks

The report page is available from `sys-cacher` and `sys-cacher-browser` at
`http://127.0.0.1:8082/acng-report.html` and any other client qube that has
`sys-cacher` as it's update qube. This is apt-cacher-ng limitation and is bad
security wise, every client has administrative access to the cacher qube.  You
should add the following to the end of `sys-cacher` rc.local:
```sh
echo "AdminAuth: username:password" | tee /etc/qubes-apt-cacher-ng/zzz_security.conf
```
Where username and password are HTTP Auth strings.

If you want to view statistics or manage the server through a GUI, open
`sys-cacher` or `sys-cacher-browser` desktop file `cacher-browser.desktop`
from Dom0. Addresses starting with `http` or `https` will be redirected
to `sys-cacher-browser`.

The browser separation from the server is to avoid browsing malicious sites
and exposing the browser to direct network on the same machine the server is
running. The browser qube is offline and only has access to the admin
interface. In other words, it has control over the server functions, if the
browser is compromised, it can compromise the server.

### Connect to the cacher via IP instead of Qrexec

Because the `sys-cacher` qube is listening on port `8082`, you can use it from
non-template qubes and qubes that do not have a working Qrexec. Use the native
configuration to set the update proxy using the IP address of `sys-cacher` by
setting `sys-cacher` as the netvm of the client qube.

### Non-TemplateVMs integration

**Attention**: this method will allow a client qube to bypass the qubes
firewall and connect to a remote via the updates proxy.

By default, only templates will use the proxy to update, if you want to cache
Non-TemplateVMs updates or simply make them functional again, the qube will
need the `service.updates-proxy-setup` feature set:
```sh
sudo qubesctl --skip-dom0 --targets=QUBE state.apply sys-cacher.install-client
qvm-tags add QUBE updatevm-sys-cacher
qvm-features QUBE service.updates-proxy-setup 1
```
Don't forget to restart the qube.

If you don't want or can't restart the qube, such as DispVMs, where you would
lose the current session, run the above commands plus the following inside the
qube:
```sh
sudo touch /var/run/qubes-service/updates-proxy-setup
sudo /usr/lib/qubes/update-proxy-configs
sudo systemctl restart qubes-updates-proxy-forwarder.socket
```

### Rewrite URIs inside the qube

Sometimes you may want to enable of disable the cacher definition, mostly when
you are using an AppVM based on a TemplateVM that uses `sys-cacher`, but the
AppVM should make a direct connection instead of going through the proxy for
updates.

Use `uninstall` or `install` as argument to the command `apt-cacher-ng-repo`:
```sh
sudo apt-cacher-ng-repo uninstal
```

## Uninstallation

- Top:
```sh
sudo qubesctl top.enable sys-cacher.deinit
sudo qubesctl --templates state.apply
sudo qubesctl top.disable sys-cacher.deinit
```

- State:
```sh
sudo qubesctl state.apply sys-cacher.remove-policy
sudo qubesctl state.apply sys-cacher.untag
sudo qubesctl --skip-dom0 --templates state.apply sys-cacher.uninstall-client
```

If you want to use the standard proxy for a few templates:
```sh
sudo qubesctl --skip-dom0 --targets=TEMPLATE state.apply sys-cacher.uninstall-client
qvm-tags del TEMPLATE updatevm-sys-cacher
```

## Credits

- [Unman](https://github.com/unman/shaker/tree/main/cacher)
